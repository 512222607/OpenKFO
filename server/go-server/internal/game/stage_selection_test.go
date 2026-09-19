package game

import (
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestStageSelectionRefreshAndRevocation(t *testing.T) {
	h, s, peer, _ := waitingRoomFixture()
	h.Config.Pools = map[string][]uint32{"0:2": {8110}}
	view := persistence.StagePlayerView{Configured: true, Catalogue: []uint32{8110, 8111}, Maps: []uint32{8110, 8111}}
	check := func(want []uint32) {
		t.Helper()
		out := roomOutputs(t, s, 21372, 21373)
		records, e := protocol.ParseStageRecords(out[0].Payload)
		if e != nil || len(records) != 2 {
			t.Fatal(records, e)
		}
		selection, e := protocol.ParseStageSelection(out[1].Payload)
		if e != nil {
			t.Fatal(e)
		}
		if len(selection.MapIDs) != len(want) {
			t.Fatal(selection, want)
		}
		for i := range want {
			if selection.MapIDs[i] != want[i] {
				t.Fatal(selection, want)
			}
		}
	}
	if err := h.sendStageSelection(s, view, true); err != nil {
		t.Fatal(err)
	}
	check([]uint32{8110})
	if err := h.sendStageSelection(s, view, false); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s)
	view.ForcedMaps = []uint32{8111}
	if err := h.sendStageSelection(s, view, false); err != nil {
		t.Fatal(err)
	}
	check([]uint32{8110, 8111})
	view.Maps = nil
	view.ForcedMaps = nil
	if err := h.sendStageSelection(s, view, false); err != nil {
		t.Fatal(err)
	}
	check(nil)
	if err := h.sendStageSelection(s, view, false); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s)
	roomOutputs(t, peer)
}
