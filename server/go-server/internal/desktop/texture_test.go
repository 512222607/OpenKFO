package desktop

import (
	"bytes"
	"image/png"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestInstalledShopImages(t *testing.T) {
	client := os.Getenv("OPENKFO_TEST_CLIENT")
	if client == "" {
		t.Skip("set OPENKFO_TEST_CLIENT for installed texture verification")
	}
	for _, fixture := range []struct {
		path          string
		width, height int
	}{
		{"Picture/ItemIcon/253030.png", 80, 80},
		{"Picture/Shop_Panel1_New.png", 800, 560},
	} {
		b, err := os.ReadFile(filepath.Join(client, "Data/UI", fixture.path))
		if err != nil {
			t.Fatal(err)
		}
		decoded, err := decodeTexture(b)
		if err != nil {
			t.Fatal(err)
		}
		c, err := png.DecodeConfig(bytes.NewReader(decoded))
		if err != nil || c.Width != fixture.width || c.Height != fixture.height {
			t.Fatalf("%s: %v %v", fixture.path, c, err)
		}
		if dir := os.Getenv("OPENKFO_TEST_IMAGE_OUTPUT"); dir != "" {
			if err := os.MkdirAll(dir, 0755); err != nil {
				t.Fatal(err)
			}
			if err := os.WriteFile(filepath.Join(dir, filepath.Base(fixture.path)), decoded, 0644); err != nil {
				t.Fatal(err)
			}
		}
		b[len(b)-1] ^= 1
		if _, err := decodeTexture(b); err == nil {
			t.Fatal("corrupt CRC accepted")
		}
	}
	items := []Item{{Key: "25:253030", Fields: []string{"", "", "", "", "", "", "", "", "", "Picture/ItemIcon/253030.png"}},
		{Key: "escape", Fields: []string{"", "", "", "", "", "", "", "", "", "../../outside.png"}}}
	result, err := shopImages(client, items, []string{"25:253030", "escape"})
	if err != nil || len(result) != 1 || len(result["25:253030"]) == 0 {
		t.Fatalf("images=%d error=%v", len(result), err)
	}
	if _, err := shopImages(client, items, make([]string, 25)); err == nil {
		t.Fatal("unbounded batch accepted")
	}
	all, err := catalog(client, false)
	if err != nil {
		t.Fatal(err)
	}
	keys := []string{}
	for _, item := range all {
		if item.Supported {
			keys = append(keys, item.Key)
		}
	}
	count := 0
	for start := 0; start < len(keys); start += 24 {
		end := start + 24
		if end > len(keys) {
			end = len(keys)
		}
		batch, err := shopImages(client, all, keys[start:end])
		if err != nil {
			t.Fatal(err)
		}
		count += len(batch)
	}
	t.Logf("Installed shop icons decoded: %d/%d", count, len(keys))
	reasons := map[string]int{}
	for _, item := range all {
		if !item.Supported {
			continue
		}
		b, err := os.ReadFile(filepath.Join(client, "Data/UI", filepath.FromSlash(strings.ReplaceAll(item.Fields[9], "\\", "/"))))
		if err != nil {
			reasons["missing"]++
			continue
		}
		if _, err = decodeTexture(b); err != nil {
			reasons[err.Error()]++
		}
	}
	t.Logf("Unavailable icons: %v", reasons)
}
