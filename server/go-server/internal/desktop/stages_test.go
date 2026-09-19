package desktop

import (
	"crypto/sha256"
	"os"
	"testing"
)

func TestStageCatalogueClientArchive(t *testing.T) {
	path := os.Getenv("OPENKFO_CLIENT_ARCHIVE")
	if path == "" {
		t.Skip("OPENKFO_CLIENT_ARCHIVE is not configured")
	}
	before, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	maps, err := ReadStageMaps(path)
	if err != nil {
		t.Fatal(err)
	}
	after, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	if sha256.Sum256(before) != sha256.Sum256(after) {
		t.Fatal("client archive changed")
	}
	// This fixture belongs to the current native client, not a generated XML.
	for difficulty := uint32(1); difficulty <= 4; difficulty++ {
		found := false
		for _, m := range maps {
			if m.Logic == 1 && m.Group == 1 && m.Difficulty == difficulty && m.MapID == 8109+difficulty && m.MapType == 10 {
				found = true
			}
		}
		if !found {
			t.Fatalf("missing native group 1 difficulty %d", difficulty)
		}
	}
	t.Logf("read %d native map selections; archive unchanged", len(maps))
	for _, row := range maps {
		if row.MapID == 9170 && (row.Script != "script/pve/act_zombiedefend_normal.lua" || len(row.ScriptHash) != 64) {
			t.Fatalf("native script binding lost: %+v", row)
		}
		if row.MapID == 9170 {
			p := row.WavePreview
			if p == nil || len(p.Templates) != 5 || len(p.Variants) != 3 {
				t.Fatal("missing verified native wave preview", p)
			}
			for i, variant := range p.Variants {
				if len(variant.Waves) != 25 {
					t.Fatal("wrong wave count")
				}
				for _, check := range []struct{ wave, total int }{{1, 2}, {3, 4}, {4, 4}, {11, 3}, {14, 4}, {21, 2}, {25, 4}} {
					total := uint32(0)
					for id, count := range variant.Waves[check.wave-1].Monsters {
						if id >= uint32(len(p.Templates)) {
							t.Fatal("unknown template")
						}
						total += count
					}
					if total != uint32(check.total*(i+2)) {
						t.Fatalf("variant %d wave %d: %d", i, check.wave, total)
					}
				}
			}
		}
	}
	requirements, _, err := ReadStageRequirements(path)
	if err != nil {
		t.Fatal(err)
	}
	byID := map[uint32]StageRequirement{}
	for _, row := range requirements {
		byID[row.MapID] = row
	}
	for _, row := range maps {
		match, ok := byID[row.MapID]
		if !ok {
			t.Errorf("PVE map %d absent from MapInfo", row.MapID)
		}
		// Same attribute spelling, different native consumers: do not equate
		// these enums or silently normalize MapInfo 110 to a room mode.
		if match.MapType != 110 || (row.MapType != 10 && row.MapType != 21) {
			t.Errorf("current native type mapping changed: %+v / %+v", row, match)
		}
	}
}

func TestStageCatalogueSelection(t *testing.T) {
	record := `<Map LogicType="1" Group="1" SelectDifficulty="1" MapID="8110" MapType="10"/>`
	root, err := parseXML(`<PVEEntryUI>` + record + `</PVEEntryUI>`)
	if err != nil {
		t.Fatal(err)
	}
	maps, err := stageMaps(root)
	if err != nil || len(maps) != 1 || maps[0] != (StageMap{Logic: 1, Group: 1, Difficulty: 1, MapID: 8110, MapType: 10}) {
		t.Fatal(maps, err)
	}
	for _, text := range []string{`<PVEEntryUI/>`, `<Wrong/>`, `<PVEEntryUI>` + record + record + `</PVEEntryUI>`, `<PVEEntryUI><Map MapID="8110"/></PVEEntryUI>`} {
		root, err = parseXML(text)
		if err != nil {
			t.Fatal(err)
		}
		if _, err = stageMaps(root); err == nil {
			t.Fatal("invalid catalogue accepted")
		}
	}
}

func TestStageDisplayRewards(t *testing.T) {
	root, err := parseXML(`<PVEEntryUI><Map LogicType="1" Group="1" SelectDifficulty="1" MapID="8110" MapType="10" DisplayDifficulty="2" RewardItem1="95002500" RewardItem2="60333601" RewardItem3=""/></PVEEntryUI>`)
	if err != nil {
		t.Fatal(err)
	}
	r, err := stageMaps(root)
	if err != nil || r[0].DisplayDifficulty != 2 || r[0].RewardItems != [3]uint32{95002500, 60333601, 0} {
		t.Fatal(r, err)
	}
	for _, value := range []string{"-1", "4294967296", "item"} {
		root.children[0].set("RewardItem1", value)
		if _, err := stageMaps(root); err == nil {
			t.Fatal("invalid reward ID accepted")
		}
	}
}
