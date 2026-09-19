package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestMailActionRejectsForeignUIDBeforeDatabase(t *testing.T) {
	h, s, peer, _ := waitingRoomFixture()
	h.Store = nil
	for _, op := range []uint32{1320, 1340} {
		p := make([]byte, 12)
		protocol.WriteUint64(p, 0, peer.UID)
		protocol.WriteUint32(p, 8, 19)
		if err := h.route(s, s.game(), protocol.Message{ID: op, Payload: p}); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, s, 20150)
		roomOutputs(t, peer)
	}
	s.game().Phase = "battle"
	if err := h.route(s, s.game(), protocol.Message{ID: 1300}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s)
}
