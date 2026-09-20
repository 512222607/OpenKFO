package desktop

import (
	"bytes"
	"compress/zlib"
	"crypto/sha256"
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
// Reconstruct only a unique non-interlaced header consistent with the
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
	profileColor := ""
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
		if typ == "iCCP" {
			profile := b[p+8 : p+8+n]
			separator := bytes.IndexByte(profile, 0)
			if separator > 0 && separator+2 < len(profile) && profile[separator+1] == 0 {
				reader, profileErr := zlib.NewReader(bytes.NewReader(profile[separator+2:]))
				if profileErr == nil {
					header := make([]byte, 128)
					_, profileErr = io.ReadFull(reader, header)
					reader.Close()
					if profileErr == nil && string(header[36:40]) == "acsp" {
						profileColor = string(header[16:20])
					}
				}
			}
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
	// PNG legal color / channel / bit-depth combinations.
	colors := [][3]int{{6, 4, 8}, {6, 4, 16}, {2, 3, 8}, {2, 3, 16}, {0, 1, 1}, {0, 1, 2}, {0, 1, 4}, {0, 1, 8}, {0, 1, 16}, {4, 2, 8}, {4, 2, 16}}
	if palette {
		colors = append(colors, [3]int{3, 1, 1}, [3]int{3, 1, 2}, [3]int{3, 1, 4}, [3]int{3, 1, 8})
	}
	var found []byte
	for _, c := range colors {
		// ICC color-space metadata survives header obfuscation. An RGB profile
		// cannot describe grayscale PNG samples (and vice versa).
		if profileColor == "RGB " && (c[0] == 0 || c[0] == 4) {
			continue
		}
		if profileColor == "GRAY" && c[0] != 0 && c[0] != 4 {
			continue
		}

		for w := 1; w <= 4096; w++ {
			stride := (w*c[1]*c[2]+7)/8 + 1
			if len(raw) == 0 || len(raw)%stride != 0 {
				continue
			}
			h := len(raw) / stride
			// Installed 80x80 icons share these three obscured header blocks.
			// Established from independently decoded 253030.png; use the
			// complete 24-byte signature, never filename or a guessed aspect ratio.
			if bytes.Equal(b[:24], []byte{0x81, 0x22, 0xa3, 0xb7, 0x88, 0x0d, 0x0e, 0x9b, 0x35, 0xcb, 0x95, 0x47, 0x4d, 0x55, 0x56, 0x96, 0x97, 0x02, 0xf9, 0x67, 0x87, 0x3b, 0xbf, 0x15}) && (w != 80 || h != 80) {
				continue
			}
			if h > 4096 || w*h > 16<<20 {
				continue
			}
			hdr := make([]byte, 13)
			binary.BigEndian.PutUint32(hdr, uint32(w))
			binary.BigEndian.PutUint32(hdr[4:], uint32(h))
			hdr[8] = byte(c[2])
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

// Catalog consumers (inventory cards and detail preview) use Image.file, unlike
// the shop's byte API. Return a decoded cache file, never the encrypted source.
// Source-content hashing also invalidates the cache after a client update.
func cachedTexture(path string) (string, error) {
	info, err := os.Stat(path)
	if err != nil {
		return "", err
	}
	if info.IsDir() || info.Size() > 8<<20 {
		return "", fmt.Errorf("图片大小无效")
	}
	b, err := os.ReadFile(path)
	if err != nil {
		return "", err
	}
	cache, err := os.UserCacheDir()
	if err != nil {
		return "", err
	}
	cache = filepath.Join(cache, "OpenKFO", "gm-icons", "v1")
	target := filepath.Join(cache, fmt.Sprintf("%x.png", sha256.Sum256(b)))
	if info, err := os.Stat(target); err == nil && !info.IsDir() && info.Size() > 0 {
		return target, nil
	}
	decoded, err := decodeTexture(b)
	if err != nil {
		return "", err
	}
	if err = os.MkdirAll(cache, 0700); err != nil {
		return "", err
	}
	file, err := os.CreateTemp(cache, ".icon-*.png")
	if err != nil {
		return "", err
	}
	temporary := file.Name()
	defer os.Remove(temporary)
	_, err = file.Write(decoded)
	closeErr := file.Close()
	if err != nil {
		return "", err
	}
	if closeErr != nil {
		return "", closeErr
	}
	if err = os.Rename(temporary, target); err != nil {
		// Another GM/helper process may have populated the same content-addressed file.
		if info, statErr := os.Stat(target); statErr != nil || info.IsDir() || info.Size() != int64(len(decoded)) {
			return "", err
		}
	}
	return target, nil
}
