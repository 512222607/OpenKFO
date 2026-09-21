package game

import (
	"errors"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestDiscardPhaseAndFrameGuards(t *testing.T) {
	for _, phase := range []string{"loading", "battle", "settlement"} {
		h, s, _, _ := combatFixture()
		h.Store = nil // Any attempted persistence access must fail this test.
		s.game().Phase = phase
		if err := h.route(s, s.game(), protocol.Message{ID: 2130, Payload: protocol.Uint32Bytes(1)}); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, s)
	}
	h, s, _, _ := combatFixture()
	h.Store = nil
	s.game().Phase = "room"
	s.Room.Stage = "room"
	s.Room.Members[s.UID].Ready = true
	if err := h.route(s, s.game(), protocol.Message{ID: 2130, Payload: protocol.Uint32Bytes(1)}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s)
	for _, n := range []int{0, 3, 5, 8} {
		if err := h.route(s, s.game(), protocol.Message{ID: 2130, Payload: make([]byte, n)}); !errors.Is(err, protocol.ErrFrame) {
			t.Fatalf("accepted %d-byte frame: %v", n, err)
		}
	}
}
