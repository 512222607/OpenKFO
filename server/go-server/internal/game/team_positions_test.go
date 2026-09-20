package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestTeamChangeAllocatesOppositeSideAndPreservesSlot(t *testing.T) {
	h, a, b, _ := waitingRoomFixture()
	r := a.Room
	r.Members[b.UID].Spawn = 4
	for _, want := range []struct{ team, spawn byte }{{1, 5}, {0, 0}, {1, 5}} {
		roomRequest(t, h, a, 3230, []byte{want.team})
		for _, s := range []*Session{a, b} {
			p := roomOutputs(t, s, 3250)[0].Payload
			if len(p) != 10 || p[8] != want.team || p[9] != want.spawn {
				t.Fatalf("wrong native team position: %x", p)
			}
		}
		if r.Members[a.UID].Slot != 0 || r.Members[b.UID].Spawn != 4 {
			t.Fatal("changed roster identity or occupied position")
		}
	}
	// Four-player rooms still use 4..7 for the second side.
	p := make([]byte, 24)
	protocol.WriteUint64(p, 0, a.UID)
	protocol.WriteUint32(p, 16, 5)
	protocol.WriteUint32(p, 20, 6)
	roomRequest(t, h, a, 3260, p)
	roomOutputs(t, a, 3265)
	roomOutputs(t, b, 3265)
	if r.Members[a.UID].Spawn != 6 || r.Members[a.UID].Team != 1 {
		t.Fatal("right-side movement rejected or changed team")
	}
}

func TestFullTeamRejectsWithoutChangingMember(t *testing.T) {
	h, a, b, _ := waitingRoomFixture()
	r := a.Room
	r.Members[b.UID].Spawn = 4
	for n := byte(5); n < 8; n++ {
		uid := uint64(20000 + int(n))
		s := &Session{UID: uid, Room: r, Channels: map[uint32]*Channel{}}
		// Reuse a valid channel phase; no output is sent to these members.
		s.Channels = b.Channels
		r.Members[uid] = &Member{Session: s, Spawn: n, Team: 1}
	}
	roomRequest(t, h, a, 3230, []byte{1})
	roomOutputs(t, a, 20150)
	roomOutputs(t, b)
	if r.Members[a.UID].Team != 0 || r.Members[a.UID].Spawn != 0 {
		t.Fatal("full destination changed player")
	}
}
