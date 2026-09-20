package game

import (
	"math"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestHealthSequenceFirstReceiptWins(t *testing.T) {
	h, sender, peer, _ := combatFixture()
	for _, step := range []struct {
		sequence uint32
		amount   float32
		forward  bool
	}{
		{math.MaxUint32, 2, true},
		{math.MaxUint32, 3, false},   // Same identity, different damage.
		{math.MaxUint32, -10, false}, // Cannot turn an accepted hit into healing.
		{0, 2, true},                 // Native counter wraps.
		{math.MaxUint32, 8, false},
		{1, 2, true}, // Equal amount with a new identity remains a new hit.
	} {
		m := combatPacket(protocol.BattleEventHealth, 94, sender.UID, peer.UID, 86)
		protocol.WriteUint64(m.Payload, 47, sender.UID)
		protocol.WriteUint32(m.Payload, 19, step.sequence)
		protocol.WriteUint32(m.Payload, 67, math.Float32bits(step.amount))
		if err := h.battleMessage(sender, sender.game(), m); err != nil {
			t.Fatal(err)
		}
		if step.forward {
			roomOutputs(t, peer, 8071)
		} else {
			roomOutputs(t, peer)
		}
	}
	// The accepted identity belongs to this sender and target. Independent
	// actors/senders must not suppress one another's legitimate health events.
	for _, s := range []*Session{sender, peer} {
		m := combatPacket(protocol.BattleEventHealth, 94, s.UID, sender.UID, 86)
		protocol.WriteUint64(m.Payload, 47, s.UID)
		protocol.WriteUint32(m.Payload, 67, math.Float32bits(2))
		if err := h.battleMessage(s, s.game(), m); err != nil {
			t.Fatal(err)
		}
		if s == sender {
			roomOutputs(t, peer, 8071)
		} else {
			roomOutputs(t, sender, 8071)
		}
	}
}
