package desktop

import (
	"os"
	"testing"
)

func TestStageRequirementsArchive(t *testing.T) {
	path := os.Getenv("OPENKFO_CLIENT_ARCHIVE")
	if path == "" {
		t.Skip("client archive required")
	}
	before, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	rows, hash, err := ReadStageRequirements(path)
	if err != nil || len(rows) != 96 || hash != digest(before) {
		t.Fatal(len(rows), err)
	}
	joined, pve, joinedHash, err := ReadStageCatalogue(path)
	if err != nil || len(joined) != 96 || len(pve) != 50 || joinedHash != hash {
		t.Fatal("combined catalogue", len(joined), len(pve), err)
	}
	after, err := os.ReadFile(path)
	if err != nil || digest(after) != hash {
		t.Fatal("archive changed", err)
	}
}

func TestStageRequirementValidation(t *testing.T) {
	for _, s := range []string{
		`<MapInfo/>`, `<Wrong/>`,
		`<MapInfo><MapConfig MapId="1" MapType="9" Name="A" NeedTitleLevel="256"/></MapInfo>`,
		`<MapInfo><MapConfig MapId="1" MapType="9" Name="A"/></MapInfo>`,
		`<MapInfo><MapConfig MapId="1" MapType="9" Name="A" NeedTitleLevel="0"/><MapConfig MapId="1" MapType="9" Name="B" NeedTitleLevel="1"/></MapInfo>`,
	} {
		r, e := parseXML(s)
		if e != nil {
			t.Fatal(e)
		}
		if _, e = stageRequirements(r); e == nil {
			t.Fatal("bad requirements accepted")
		}
	}
	r, _ := parseXML(`<MapInfo><MapConfig MapId="8110" MapType="9" Name="A" NeedTitleLevel="3"/><MapConfig MapId="0" MapType="110" Name="Random" NeedTitleLevel="0"/><RandomMap/></MapInfo>`)
	rows, e := stageRequirements(r)
	if e != nil || len(rows) != 2 || rows[0].MapID != 8110 || rows[0].TitleLevel != 3 || rows[1].MapID != 0 {
		t.Fatal(rows, e)
	}
}
