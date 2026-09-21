package desktop

import (
	"os"
	"testing"
)

func TestStagePublishRejectsChangedRulesAndScripts(t *testing.T) {
	maps := []StageRequirement{{MapID: 1201, Name: "training", TitleLevel: 1}}
	pve := []StageMap{{MapID: 1201, ScriptHash: "old-script"}}
	if err := compareStageCatalogues(maps, pve, maps, pve); err != nil {
		t.Fatal(err)
	}
	changed := append([]StageRequirement(nil), maps...)
	changed[0].TitleLevel = 2
	if compareStageCatalogues(maps, pve, changed, pve) == nil {
		t.Fatal("changed title accepted")
	}
	changedPVE := append([]StageMap(nil), pve...)
	changedPVE[0].ScriptHash = "new-script"
	if compareStageCatalogues(maps, pve, maps, changedPVE) == nil {
		t.Fatal("changed script accepted")
	}
}

func TestStagePublishActualArchives(t *testing.T) {
	oldPath, newPath := os.Getenv("OPENKFO_OLD_STAGE_ARCHIVE"), os.Getenv("OPENKFO_CLIENT_ARCHIVE")
	if oldPath == "" || newPath == "" {
		t.Skip("native archives not configured")
	}
	if err := VerifyStageCompatibility(oldPath, newPath); err != nil {
		t.Fatal(err)
	}
	if err := VerifyStageCompatibility(oldPath, "missing-stage-archive.spf2"); err == nil {
		t.Fatal("unreadable catalogue accepted")
	}
}
