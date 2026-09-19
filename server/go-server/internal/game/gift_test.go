package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestInvalidGiftDoesNotAccessStore(t *testing.T) {
	h, s, peer, _ := waitingRoomFixture()
	h.Store = nil // Any accidental debit/inventory write would panic.
	p := make([]byte, 426)
	p[0] = 111
	copy(p[83:], []byte("recipient"))
	for _, phase := range []string{"lobby", "room"} {
		s.game().Phase = phase
		for n := 0; n < 2; n++ {
			if err := h.route(s, s.game(), protocol.Message{ID: 9090, Payload: p}); err != nil {
				t.Fatal(err)
			}
			roomOutputs(t, s, 9110)
			roomOutputs(t, peer)
		}
	}
	p[0] = 111
	if err := h.route(s, s.game(), protocol.Message{ID: 9090, Payload: p}); err != nil {
		t.Fatal(err)
	}
	r := roomOutputs(t, s, 9110)[0]
	if len(r.Payload) != 2 || protocol.ReadUint16(r.Payload, 0) != 56 {
		t.Fatal("wrong native error")
	}
	if err := h.route(s, s.game(), protocol.Message{ID: 9090, Payload: p[:169]}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 20150)
	s.game().Phase = "battle"
	if err := h.route(s, s.game(), protocol.Message{ID: 9090, Payload: p}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s)
	roomOutputs(t, peer)
}
