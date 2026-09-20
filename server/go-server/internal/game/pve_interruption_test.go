package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
	"time"
)

func TestPVELeaveAbortsWithoutControllerMigration(t *testing.T) {
	for _, mode := range []protocol.RoomType{protocol.StageAssault, protocol.FosterMode} {
		t.Run(mode.String(), func(t *testing.T) { testPVELeaveAbortsWithoutControllerMigration(t, mode) })
	}
}

func testPVELeaveAbortsWithoutControllerMigration(t *testing.T, mode protocol.RoomType) {
	for _, phase := range []string{"loading", "wait_ready", "battle", "finishing"} {
		for _, ownerLeaves := range []bool{true, false} {
			h, owner, peer, outsider := combatFixture()
			r := owner.Room
			r.Stage = phase
			r.Request[46] = byte(mode)
			r.StageWaves, _ = newStageWaves([]StageWavePlan{{Monsters: map[uint32]uint32{7: 1}}})
			r.PVEActors = map[uint64]pveActor{42: {active: true}}
			r.PVEBlocks = map[uint32]pveBlock{100: {sequence: 1, payload: []byte{1}}}
			r.FosterPlan = &protocol.FosterPlan{}
			r.FosterSpawned = []int{1}
			r.FosterRetired = []int{1}
			r.FosterFinishReported = true
			r.Reports = map[uint64][]byte{owner.UID: settlementReport(r)}
			r.LoadTimer = time.NewTimer(time.Hour)
			leaver, remaining := owner, peer
			if !ownerLeaves {
				leaver, remaining = peer, owner
			}
			h.leave(leaver, false) // No Store: abort must not depend on a DB snapshot.
			roomOutputs(t, leaver)
			roomOutputs(t, remaining, protocol.MsgRoomLeft, 20150)
			roomOutputs(t, outsider)
			if len(h.Rooms) != 0 || len(r.Members) != 0 || r.PVEActors != nil || r.PVEBlocks != nil || r.StageWaves != nil || r.FosterPlan != nil || r.FosterSpawned != nil || r.FosterRetired != nil || r.FosterFinishReported || r.Reports != nil || r.LoadTimer != nil {
				t.Fatal("stage state survived departure", phase, ownerLeaves)
			}
			if remaining.Room != nil || remaining.game().Phase != "lobby" {
				t.Fatal("remaining client stranded")
			}
		}
	}
}

func TestPVEReportCannotUseCompetitiveRewards(t *testing.T) {
	for _, mode := range []protocol.RoomType{protocol.StageAssault, protocol.FosterMode} {
		h, owner, peer, _ := combatFixture()
		r := owner.Room
		r.Request[46] = byte(mode)
		p := settlementReport(r)
		for _, s := range []*Session{owner, peer} {
			if err := h.settleReport(s, p); err != nil {
				t.Fatal(err)
			}
		}
		roomOutputs(t, owner)
		roomOutputs(t, peer)
		if len(r.Reports) != 0 || r.Stage != "battle" {
			t.Fatal("PVE entered PvP settlement")
		}
	}
}

func TestPVELeaveAfterSettlementKeepsRemainingResult(t *testing.T) {
	for _, mode := range []protocol.RoomType{protocol.StageAssault, protocol.FosterMode} {
		t.Run(mode.String(), func(t *testing.T) { testPVELeaveAfterSettlementKeepsRemainingResult(t, mode) })
	}
}

func testPVELeaveAfterSettlementKeepsRemainingResult(t *testing.T, mode protocol.RoomType) {
	for _, ownerLeaves := range []bool{true, false} {
		h, owner, peer, outsider := combatFixture()
		r := owner.Room
		r.Request[46] = byte(mode)
		r.Stage = "settlement"
		for _, m := range r.Members {
			m.Ready = false
			m.Session.game().Phase = "settlement"
		}
		leaver, remaining := owner, peer
		if !ownerLeaves {
			leaver, remaining = peer, owner
		}
		h.leave(leaver, false)
		want := []uint32{protocol.MsgPlayerLeftRoom}
		if ownerLeaves {
			want = append(want, protocol.MsgRoomOwner)
		}
		roomOutputs(t, remaining, want...)
		roomOutputs(t, leaver)
		roomOutputs(t, outsider)
		if h.Rooms[r.ID] != r || len(r.Members) != 1 || r.Stage != "settlement" || remaining.Room != r || remaining.game().Phase != "settlement" || r.Owner != remaining.UID {
			t.Fatal("settled stage aborted on departure", ownerLeaves)
		}
		// The last departure still removes the room without database access.
		h.leave(remaining, false)
		if len(h.Rooms) != 0 {
			t.Fatal("empty result room retained")
		}
	}
}
