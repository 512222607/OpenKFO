package desktop

import "testing"

func TestStageWavePreviewRejectsUnknownRevision(t *testing.T) {
	if _, err := zombieWavePreview([]byte("unverified"), []byte("unverified")); err == nil {
		t.Fatal("unverified script interpreted as supported waves")
	}
	a := &archive{}
	preview, err := a.stageWavePreview("script/pve/act_zombiedefend_normal.lua", []byte("changed"))
	if err != nil || preview != nil {
		t.Fatal("changed script should retain binding without inferred waves", preview, err)
	}
}
