package desktop

import (
	"os"
	"path/filepath"
	"strconv"
	"testing"
)

func TestWeaponMetadataTypes(t *testing.T) {
	for index, name := range []string{"刀类", "剑类", "长柄", "拳套", "拳脚", "重型", "奇门"} {
		if got := weaponType(Item{Fields: []string{"25", "1", strconv.Itoa(index + 1)}}); got != name {
			t.Fatal(got, name)
		}
	}
	if weaponType(Item{}) != "未分类" || weaponType(Item{Fields: []string{"25", "1", "42"}}) != "类型 42" {
		t.Fatal("unknown type lost")
	}
}

func TestInstalledWeaponMetadata(t *testing.T) {
	client := os.Getenv("OPENKFO_WEAPON_TEST_CLIENT")
	if client == "" {
		t.Skip("client fixture required")
	}
	items, err := Catalog(client)
	if err != nil {
		t.Fatal(err)
	}
	a, err := loadArchive(filepath.Join(client, "Data/config.spf2"))
	if err != nil {
		t.Fatal(err)
	}
	info, err := inspect(a, items)
	if err != nil {
		t.Fatal(err)
	}
	byID := map[int]Item{}
	for _, item := range items {
		if item.Kind == 25 {
			byID[int(item.ID)] = item
		}
	}
	icons := 0
	for _, w := range info.weapons {
		item := byID[w.ID]
		if w.Name != item.Name || w.Icon != item.Icon || w.Description != item.Description || w.Type != weaponType(item) {
			t.Fatalf("metadata mismatch %d", w.ID)
		}
		if w.Icon != "" {
			if _, err := os.Stat(w.Icon); err != nil {
				t.Fatal(err)
			}
			icons++
		}
	}
	if len(info.weapons) == 0 || icons == 0 {
		t.Fatal("missing weapons/icons")
	}
	t.Logf("weapons=%d valid_icons=%d", len(info.weapons), icons)
}
