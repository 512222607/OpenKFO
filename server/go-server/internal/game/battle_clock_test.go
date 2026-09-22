package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
	"time"
)

func TestBattleClockPeersAndLifecycle(t *testing.T) {
	h, owner, peer, _ := waitingRoomFixture()
	r := owner.Room
	r.Stage = "battle"
	r.Serial = 7
	r.BattleClock = 1
	r.BattleStartedAt = time.Now()
	started := r.BattleStartedAt
	for _, seconds := range []int{1, 2, 5} {
		if !h.tickBattleClock(r, 7, started, started.Add(time.Duration(seconds)*time.Second)) {
			t.Fatal("clock stopped")
		}
		for _, s := range []*Session{owner, peer} {
			messages := roomOutputs(t, s, protocol.MsgBattleClock)
			if protocol.ReadUint32(messages[0].Payload, 0) != uint32(seconds+1) {
				t.Fatal("incorrect shared counter")
			}
		}
	}
	h.tickBattleClock(r, 7, started, started.Add(5*time.Second))
	roomOutputs(t, owner)
	roomOutputs(t, peer)
	r.Stage = "settlement"
	if h.tickBattleClock(r, 7, started, started.Add(6*time.Second)) {
		t.Fatal("settlement clock running")
	}
	r.Stage = "battle"
	r.Serial++
	if h.tickBattleClock(r, 7, started, started.Add(6*time.Second)) {
		t.Fatal("old round sent")
	}
	r.Serial = 7
	r.BattleStartedAt = started.Add(time.Second)
	if h.tickBattleClock(r, 7, started, started.Add(6*time.Second)) {
		t.Fatal("old start sent")
	}
	r.BattleStartedAt = started
	delete(h.Rooms, r.ID)
	if h.tickBattleClock(r, 7, started, started.Add(6*time.Second)) {
		t.Fatal("deleted room sent")
	}
	roomOutputs(t, owner)
	roomOutputs(t, peer)
}
