package desktop

import (
	"bytes"
	"compress/zlib"
	"encoding/binary"
	"fmt"
	"hash/crc32"
	"image/png"
	"io"
	"os"
	"path/filepath"
	"strings"
)

// Some installed textures retain all PNG chunks after an obscured 32-byte header.
// Reconstruct only a unique 8-bit non-interlaced header consistent with the
// surviving CRC byte and every scanline filter. Ambiguous files are rejected.
func decodeTexture(b []byte) ([]byte, error) {
	if len(b) < 45 || len(b) > 8<<20 {
		return nil, fmt.Errorf("图片大小无效")
	}
	if bytes.HasPrefix(b, []byte("\x89PNG\r\n\x1a\n")) {
		config, err := png.DecodeConfig(bytes.NewReader(b))
		if err != nil || config.Width > 4096 || config.Height > 4096 {
			return nil, fmt.Errorf("PNG 尺寸无效")
		}
		if _, err := png.Decode(bytes.NewReader(b)); err != nil {
			return nil, err
		}
		return b, nil
	}
	var compressed []byte
	palette := false
	for p := 33; p < len(b); {
		if p+12 > len(b) {
			return nil, fmt.Errorf("PNG 块不完整")
		}
		n := int(binary.BigEndian.Uint32(b[p:]))
		if n > len(b)-p-12 {
			return nil, fmt.Errorf("PNG 块越界")
		}
		typ := string(b[p+4 : p+8])
		chunk := b[p+4 : p+8+n]
		if crc32.ChecksumIEEE(chunk) != binary.BigEndian.Uint32(b[p+8+n:]) {
			return nil, fmt.Errorf("PNG 块校验失败")
		}
		if typ == "IDAT" {
			compressed = append(compressed, b[p+8:p+8+n]...)
		}
		if typ == "PLTE" {
			palette = true
		}
		p += 12 + n
	}
	r, err := zlib.NewReader(bytes.NewReader(compressed))
	if err != nil {
		return nil, err
	}
	defer r.Close()
	raw, err := io.ReadAll(io.LimitReader(r, (64<<20)+1))
	if err != nil || len(raw) > 64<<20 {
		return nil, fmt.Errorf("图片解压失败或过大")
	}
	colors := [][2]int{{6, 4}, {2, 3}, {0, 1}, {4, 2}}
	if palette {
		colors = append(colors, [2]int{3, 1})
	}
	var found []byte
	for _, c := range colors {
		for w := 1; w <= 4096; w++ {
			stride := w*c[1] + 1
			if len(raw) == 0 || len(raw)%stride != 0 {
				continue
			}
			h := len(raw) / stride
			if h > 4096 || w*h > 16<<20 {
				continue
			}
			hdr := make([]byte, 13)
			binary.BigEndian.PutUint32(hdr, uint32(w))
			binary.BigEndian.PutUint32(hdr[4:], uint32(h))
			hdr[8] = 8
			hdr[9] = byte(c[0])
			crc := crc32.ChecksumIEEE(append([]byte("IHDR"), hdr...))
			if byte(crc) != b[32] {
				continue
			}
			valid := true
			for y := 0; y < len(raw); y += stride {
				if raw[y] > 4 {
					valid = false
					break
				}
			}
			if !valid {
				continue
			}
			out := make([]byte, len(b))
			copy(out, b)
			copy(out, []byte("\x89PNG\r\n\x1a\n"))
			binary.BigEndian.PutUint32(out[8:], 13)
			copy(out[12:], "IHDR")
			copy(out[16:], hdr)
			binary.BigEndian.PutUint32(out[29:], crc)
			if _, err := png.Decode(bytes.NewReader(out)); err != nil {
				continue
			}
			if found != nil {
				return nil, fmt.Errorf("图片头存在多个候选，未猜测尺寸")
			}
			found = out
		}
	}
	if found == nil {
		return nil, fmt.Errorf("暂不支持此图片格式")
	}
	return found, nil
}

func shopImages(client string, items []Item, keys []string) (map[string][]byte, error) {
	if len(keys) < 1 || len(keys) > 24 {
		return nil, fmt.Errorf("每次读取 1–24 个图标")
	}
	wanted := map[string]bool{}
	for _, k := range keys {
		wanted[k] = true
	}
	root, err := filepath.EvalSymlinks(filepath.Join(client, "Data", "UI"))
	if err != nil {
		return nil, err
	}
	result := map[string][]byte{}
	for _, item := range items {
		if !wanted[item.Key] || len(item.Fields) < 10 {
			continue
		}
		relative := strings.ReplaceAll(item.Fields[9], "\\", "/")
		if strings.Contains(relative, ":") || strings.HasPrefix(relative, "/") {
			continue
		}
		path, err := filepath.EvalSymlinks(filepath.Join(root, filepath.FromSlash(relative)))
		if err != nil {
			continue
		}
		rel, err := filepath.Rel(root, path)
		if err != nil || rel == ".." || strings.HasPrefix(rel, ".."+string(filepath.Separator)) {
			continue
		}
		stat, err := os.Stat(path)
		if err != nil || stat.Size() > 8<<20 || stat.IsDir() {
			continue
		}
		data, err := os.ReadFile(path)
		if err != nil {
			continue
		}
		image, err := decodeTexture(data)
		if err == nil {
			result[item.Key] = image
		}
	}
	return result, nil
}
