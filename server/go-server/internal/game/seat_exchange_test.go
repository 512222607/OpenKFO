package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
	"time"
)

func TestSeatExchangeConsentAndStaleRequests(t *testing.T) {
	h, a, b, outside := waitingRoomFixture()
	r := a.Room
	r.Request[37] = 4
	p := make([]byte, 24)
	protocol.WriteUint64(p, 0, a.UID)
	protocol.WriteUint64(p, 8, b.UID)
	protocol.WriteUint32(p, 16, uint32(r.Members[a.UID].Slot))
	protocol.WriteUint32(p, 20, uint32(r.Members[b.UID].Slot))
	send := func(s *Session, id uint32) {
		if e := h.exchangeSeat(s, protocol.Message{ID: id, Payload: p}); e != nil {
			t.Fatal(e)
		}
	}
	send(a, 3260)
	roomOutputs(t, b, 3261)
	roomOutputs(t, a)
	roomOutputs(t, outside)
	send(a, 3262)
	roomOutputs(t, a, 3264)
	if r.Members[a.UID].Slot != 0 {
		t.Fatal("self approved another player")
	}
	send(b, 3263)
	roomOutputs(t, a, 3264)
	send(a, 3260)
	roomOutputs(t, b, 3261)
	send(b, 3262)
	roomOutputs(t, a, 3265)
	roomOutputs(t, b, 3265)
	if r.Members[a.UID].Slot != 1 || r.Members[b.UID].Slot != 0 || r.Members[a.UID].Team != 1 {
		t.Fatal("swap failed")
	}
	send(b, 3262)
	roomOutputs(t, b, 3264) // stale original positions cannot swap again.
	protocol.WriteUint32(p, 16, 1)
	protocol.WriteUint32(p, 20, 0)
	send(a, 3260)
	roomOutputs(t, b, 3261)
	r.Exchange.expires = time.Now().Add(-time.Second)
	send(b, 3262)
	roomOutputs(t, b, 3264)
	protocol.WriteUint64(p, 8, 0)
	protocol.WriteUint32(p, 20, 3)
	send(a, 3260)
	roomOutputs(t, a, 3265)
	roomOutputs(t, b, 3265)
	if r.Members[a.UID].Slot != 3 || r.Members[a.UID].Team != 1 {
		t.Fatal("empty slot altered team")
	}
}

func TestSeatExchangeInvalidatedByRoomChange(t *testing.T) {
	h, a, b, _ := waitingRoomFixture()
	r := a.Room
	p := make([]byte, 24)
	protocol.WriteUint64(p, 0, a.UID)
	protocol.WriteUint64(p, 8, b.UID)
	protocol.WriteUint32(p, 20, 1)
	if err := h.exchangeSeat(a, protocol.Message{ID: 3260, Payload: p}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b, 3261)
	h.clearRoomReady(r)
	roomOutputs(t, a, 3264)
	roomOutputs(t, b, 3264)
	if r.Exchange != nil {
		t.Fatal("pending exchange survived room change")
	}
	if err := h.exchangeSeat(b, protocol.Message{ID: 3262, Payload: p}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b, 3264)
	if r.Members[a.UID].Slot != 0 || r.Members[b.UID].Slot != 1 {
		t.Fatal("late acceptance changed seats")
	}
	if err := h.exchangeSeat(a, protocol.Message{ID: 3260, Payload: p}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b, 3261)
	roomOutputs(t, a) // New requests must not remain blocked by stale busy state.
}
