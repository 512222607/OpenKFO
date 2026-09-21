package game

import (
	"bytes"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestControllerObjectInteractionWithPeer(t *testing.T) {
	for _, operation := range []uint32{3, 4} {
		h, owner, peer, outsider := combatFixture()
		m := combatPacket(protocol.BattleEventAction, 103, owner.UID, peer.UID, 95)
		protocol.WriteUint32(m.Payload, 47, 10)
		protocol.WriteUint32(m.Payload, 51, operation)
		protocol.WriteUint32(m.Payload, 55, 4002)
		if err := h.battleMessage(owner, owner.game(), m); err != nil {
			t.Fatal(err)
		}
		got := roomOutputs(t, peer, 8071)[0]
		if !bytes.Equal(got.Payload, m.Payload) {
			t.Fatal("interaction changed")
		}
		roomOutputs(t, owner)
		roomOutputs(t, outsider)
		if err := h.battleMessage(owner, owner.game(), m); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, peer)
		// A peer cannot impersonate the controller, even with a valid actor.
		protocol.WriteUint64(m.Payload, 4, peer.UID)
		protocol.WriteUint64(m.Payload, 39, owner.UID)
		if err := h.battleMessage(peer, peer.game(), m); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, owner)
		// Envelope identity, room context and unrelated actions stay protected.
		protocol.WriteUint64(m.Payload, 4, owner.UID)
		if h.battleMessage(peer, peer.game(), m) == nil {
			t.Fatal("spoofed sender accepted")
		}
		protocol.WriteUint64(m.Payload, 39, outsider.UID)
		if h.battleMessage(owner, owner.game(), m) == nil {
			t.Fatal("outsider accepted")
		}
		protocol.WriteUint64(m.Payload, 39, peer.UID)
		protocol.WriteUint32(m.Payload, 99, 8)
		if h.battleMessage(owner, owner.game(), m) == nil {
			t.Fatal("stale battle accepted")
		}
		protocol.WriteUint32(m.Payload, 99, 7)
		protocol.WriteUint32(m.Payload, 51, 0)
		if h.battleMessage(owner, owner.game(), m) == nil {
			t.Fatal("unrelated cross-player action accepted")
		}
		roomOutputs(t, peer)
	}
}
