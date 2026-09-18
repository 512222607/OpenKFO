package desktop

import (
	"bytes"
	"compress/zlib"
	"encoding/binary"
	"fmt"
	"hash/crc32"
	"io"
	"os"
	"sort"
	"strings"

	"golang.org/x/text/encoding/simplifiedchinese"
)

const configKey = "F48A715746514613BD70EF276119128F"

var little = binary.LittleEndian

type archive struct {
	data                          []byte
	tree, table, checksums, count int
	entries                       map[string]int
}

func loadArchive(path string) (*archive, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	return parseArchive(data)
}
func parseArchive(data []byte) (*archive, error) {
	if len(data) < 64 || len(data) > 128<<20 || !bytes.HasPrefix(data, []byte("SGDP Package File.\x00")) || little.Uint32(data[36:]) != 2 {
		return nil, fmt.Errorf("配置包格式错误")
	}
	a := &archive{data: data, tree: int(little.Uint32(data[40:])), table: int(little.Uint32(data[44:])), checksums: int(little.Uint32(data[48:])), count: int(little.Uint32(data[52:])), entries: map[string]int{}}
	if a.tree < 64 || a.tree > a.table || a.count < 1 || a.count > 10000 || a.table+a.count*8 != a.checksums || a.checksums+a.count*8 != len(data) {
		return nil, fmt.Errorf("配置包边界错误")
	}
	type node struct {
		offset int
		prefix string
	}
	pending := []node{{0, ""}}
	seen := map[int]bool{}
	indices := map[int]bool{}
	intervals := [][2]int{}
	tree := data[a.tree:a.table]
	for len(pending) > 0 {
		current := pending[len(pending)-1]
		pending = pending[:len(pending)-1]
		offset := current.offset
		if offset < 0 || offset+4 > len(tree) || seen[offset] {
			return nil, fmt.Errorf("配置索引指针错误")
		}
		seen[offset] = true
		size := int(little.Uint32(tree[offset:]))
		end := offset + 4 + size*12
		if size < 1 || size > a.count || end > len(tree) {
			return nil, fmt.Errorf("配置索引节点错误")
		}
		intervals = append(intervals, [2]int{offset, end})
		for pos := offset + 4; pos < end; pos += 12 {
			label := tree[pos : pos+8]
			if zero := bytes.IndexByte(label, 0); zero >= 0 {
				label = label[:zero]
			}
			path := current.prefix + string(label)
			target := little.Uint32(tree[pos+8:])
			if len(path) == 0 || len(path) > 1024 {
				return nil, fmt.Errorf("配置路径长度错误")
			}
			if target>>24 == 255 {
				index := int(target & 0xffffff)
				if index >= a.count || indices[index] {
					return nil, fmt.Errorf("配置条目编号错误")
				}
				indices[index] = true
				decoded, err := decodeText([]byte(path))
				if err != nil {
					return nil, err
				}
				key := strings.ToLower(strings.TrimLeft(strings.ReplaceAll(decoded, "\\", "/"), "/"))
				if _, exists := a.entries[key]; exists {
					return nil, fmt.Errorf("配置路径重复")
				}
				a.entries[key] = index
			} else {
				pending = append(pending, node{int(target), path})
			}
		}
		if len(seen)+len(pending) > len(tree)/16 {
			return nil, fmt.Errorf("配置索引过大")
		}
	}
	sort.Slice(intervals, func(i, j int) bool { return intervals[i][0] < intervals[j][0] })
	for i := 1; i < len(intervals); i++ {
		if intervals[i-1][1] > intervals[i][0] {
			return nil, fmt.Errorf("配置索引重叠")
		}
	}
	if len(indices) != a.count {
		return nil, fmt.Errorf("配置索引不完整")
	}
	return a, nil
}
func decodeText(data []byte) (string, error) {
	decoded, err := simplifiedchinese.GB18030.NewDecoder().Bytes(data)
	return string(decoded), err
}
func encodeText(text string) ([]byte, error) {
	return simplifiedchinese.GB18030.NewEncoder().Bytes([]byte(text))
}
func (a *archive) bounds(index int) (int, int, error) {
	offset := int(little.Uint32(a.data[a.table+index*8:]))
	size := int(little.Uint32(a.data[a.table+index*8+4:]))
	if offset < 64 || size < 4 || offset+size+4 > a.tree {
		return 0, 0, fmt.Errorf("配置条目边界错误")
	}
	return offset, size, nil
}
func (a *archive) raw(name string) ([]byte, error) {
	index, ok := a.entries[name]
	if !ok {
		return nil, fmt.Errorf("缺少配置 %s", name)
	}
	offset, size, err := a.bounds(index)
	if err != nil {
		return nil, err
	}
	if little.Uint32(a.data[offset:]) != 0x2200 {
		return nil, fmt.Errorf("配置条目标志错误")
	}
	compressed := append([]byte(nil), a.data[offset+4:offset+size+4]...)
	for i := range compressed {
		compressed[i] ^= 255 ^ configKey[i%len(configKey)]
	}
	input := bytes.NewReader(compressed)
	reader, err := zlib.NewReader(input)
	if err != nil {
		return nil, err
	}
	defer reader.Close()
	raw, err := io.ReadAll(io.LimitReader(reader, (8<<20)+1))
	if err != nil {
		return nil, err
	}
	if len(raw) > 8<<20 || input.Len() != 0 {
		return nil, fmt.Errorf("配置解压长度错误")
	}
	return raw, nil
}
func (a *archive) text(name string) (string, error) {
	raw, err := a.raw(name)
	if err != nil {
		return "", err
	}
	return decodeText(raw)
}
func (a *archive) verify() error {
	summary := make([]byte, 0, a.count*4)
	for index := 0; index < a.count; index++ {
		offset, size, err := a.bounds(index)
		if err != nil {
			return err
		}
		record := a.data[a.checksums+index*8 : a.checksums+index*8+4]
		if little.Uint32(record) != crc32.ChecksumIEEE(a.data[offset:offset+size+4]) {
			return fmt.Errorf("配置包条目 CRC 校验失败")
		}
		summary = append(summary, record...)
	}
	if crc32.ChecksumIEEE(summary) != little.Uint32(a.data[56:]) {
		return fmt.Errorf("配置包汇总 CRC 校验失败")
	}
	return nil
}
func (a *archive) replace(replacements map[string][]byte) ([]byte, error) {
	names := make([]string, 0, len(replacements))
	for name := range replacements {
		names = append(names, name)
	}
	sort.Strings(names)
	addition := []byte{}
	records := map[int][2]int{}
	for _, name := range names {
		index, ok := a.entries[name]
		if !ok {
			return nil, fmt.Errorf("缺少待修改条目")
		}
		var compressed bytes.Buffer
		writer := zlib.NewWriter(&compressed)
		if _, err := writer.Write(replacements[name]); err != nil {
			return nil, err
		}
		if err := writer.Close(); err != nil {
			return nil, err
		}
		encoded := compressed.Bytes()
		for i := range encoded {
			encoded[i] ^= 255 ^ configKey[i%len(configKey)]
		}
		records[index] = [2]int{a.tree + len(addition), len(encoded)}
		addition = append(addition, 0, 0x22, 0, 0)
		addition = append(addition, encoded...)
	}
	delta := len(addition)
	result := append([]byte(nil), a.data[:a.tree]...)
	result = append(result, addition...)
	result = append(result, a.data[a.tree:]...)
	little.PutUint32(result[40:], uint32(a.tree+delta))
	little.PutUint32(result[44:], uint32(a.table+delta))
	little.PutUint32(result[48:], uint32(a.checksums+delta))
	for index, record := range records {
		little.PutUint32(result[a.table+delta+index*8:], uint32(record[0]))
		little.PutUint32(result[a.table+delta+index*8+4:], uint32(record[1]))
		little.PutUint32(result[a.checksums+delta+index*8:], crc32.ChecksumIEEE(result[record[0]:record[0]+record[1]+4]))
	}
	summary := []byte{}
	for index := 0; index < a.count; index++ {
		summary = append(summary, result[a.checksums+delta+index*8:a.checksums+delta+index*8+4]...)
	}
	little.PutUint32(result[56:], crc32.ChecksumIEEE(summary))
	return result, nil
}
