package desktop

import (
	"crypto/sha256"
	"encoding/hex"
	"os"
	"testing"
)

func TestTitleCatalogueClientArchive(t *testing.T) {
	path := os.Getenv("OPENKFO_CLIENT_ARCHIVE")
	if path == "" {
		t.Skip("client archive required")
	}
	before, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	rows, err := ReadRoleTitles(path)
	if err != nil || len(rows) != 17 || rows[0].Level != 0 || rows[0].Name != "平凡少年Ⅰ" {
		t.Fatal(rows, err)
	}
	_, hash, err := readRoleTitleCatalogue(path)
	wantHash := sha256.Sum256(before)
	if err != nil || hash != hex.EncodeToString(wantHash[:]) {
		t.Fatal("catalogue hash does not bind parsed archive", err)
	}
	after, err := os.ReadFile(path)
	if err != nil || sha256.Sum256(before) != sha256.Sum256(after) {
		t.Fatal("archive changed", err)
	}
	t.Logf("Read %d title entries; archive unchanged", len(rows))
}

func TestTitleCatalogueValidation(t *testing.T) {
	for _, body := range []string{
		`<TitleSetting/>`, `<TitleMission/>`,
		`<TitleSetting><TitleLevel Level="256" Title="name" Icon="icon"/></TitleSetting>`,
		`<TitleSetting><TitleLevel Level="-1" Title="name" Icon="icon"/></TitleSetting>`,
		`<TitleSetting><TitleLevel Level="0" Title="name"/></TitleSetting>`,
		`<TitleSetting><TitleLevel Level="0" Title="a" Icon="x"/><TitleLevel Level="0" Title="b" Icon="y"/></TitleSetting>`,
	} {
		root, err := parseXML(body)
		if err != nil {
			t.Fatal(err)
		}
		if _, err = roleTitles(root); err == nil {
			t.Fatal("invalid catalogue accepted", body)
		}
	}
	root, _ := parseXML(`<TitleSetting><TitleLevel Level="0" Title="name" Icon="icon"/></TitleSetting>`)
	if rows, err := roleTitles(root); err != nil || len(rows) != 1 || rows[0].Level != 0 {
		t.Fatal(rows, err)
	}
}
