package game

import (
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"strings"
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

func TestStageSelectionIncludesPersistedPVEPlans(t *testing.T) {
	h, s, _, _ := waitingRoomFixture()
	hash := strings.Repeat("a", 64)
	h.Config.ConfigHash = hash
	h.Config.Pools = nil
	access := persistence.StageAccess{ClientHash: hash, PVEMaps: []uint32{8110, 9170, 8111}, Requirements: []persistence.StageTitleRequirement{{MapID: 8110, Name: "Foster"}, {MapID: 9170, Name: "Wave"}, {MapID: 8111, Name: "Missing"}},
		FosterPlans: []persistence.FosterConfig{{MapID: 8110, ScriptHash: hash, RuntimeHash: hash, ConfigHash: hash, Templates: []string{"Monster"}, Plan: protocol.FosterPlan{InitialHP: []float32{8}, PlayerLimit: 6, GlobalLimit: 32, Groups: []protocol.FosterGroup{{SubLimit: 2, GroupLimit: 20, Spawns: []protocol.FosterSpawn{{Template: 0, Direction: 2}}}}}}},
		WavePlans:   []persistence.StageWaveConfig{{MapID: 9170, ScriptHash: hash, RuntimeHash: hash, Templates: []string{"Monster"}, Variants: []StageWaveVariant{{MinPlayers: 2, MaxPlayers: 6, Waves: []StageWavePlan{{Monsters: map[uint32]uint32{0: 4}}}}}}}}
	view := persistence.StagePlayerView{Configured: true, Access: access, Catalogue: access.PVEMaps, Maps: access.PVEMaps}
	check := func(want ...uint32) {
		t.Helper()
		if err := h.sendStageSelection(s, view, true); err != nil {
			t.Fatal(err)
		}
		out := roomOutputs(t, s, 21372, 21373)
		actual, err := protocol.ParseStageSelection(out[1].Payload)
		if err != nil || len(actual.MapIDs) != len(want) {
			t.Fatal(actual, err, want)
		}
		for i, id := range want {
			if actual.MapIDs[i] != id {
				t.Fatal(actual, want)
			}
		}
	}
	check(8110, 9170)
	view.Maps = []uint32{9170}
	check(9170) // Player restrictions still apply.
	view.Access.Disabled = []uint32{9170}
	check()
	view.Access.Disabled = nil
	view.Access.ClientHash = strings.Repeat("b", 64)
	check()
}
