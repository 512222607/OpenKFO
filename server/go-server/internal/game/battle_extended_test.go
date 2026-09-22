package game

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"math"
	"testing"
	"time"
)

func extendedPacket(id uint32, size int, sender, actor uint64, context int) protocol.Message {
	m := combatPacket(id, size, sender, actor, context)
	m.Payload[12], m.Payload[13] = 1, 1
	return m
}
func TestExtendedOwnedEvents(t *testing.T) {
	for _, tc := range []struct {
		id                         uint32
		size, context, actorOffset int
	}{{8125, 53, 0, 39}, {8143, 59, 0, 39}, {8280, 55, 0, 39}, {8284, 75, 67, 59}, {8293, 51, 0, 39}} {
		h, a, b, _ := combatFixture()
		m := extendedPacket(tc.id, tc.size, a.UID, a.UID, tc.context)
		if tc.id == 8284 {
			clear(m.Payload[39:67])
			protocol.WriteUint32(m.Payload, 39, 1)
			protocol.WriteUint64(m.Payload, 59, a.UID)
		}
		if err := h.battleMessage(a, a.game(), m); err != nil {
			t.Fatal(tc.id, err)
		}
		roomOutputs(t, b, 8071)
		if err := h.battleMessage(a, a.game(), m); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, b)
		bad := protocol.Message{ID: 8071, Payload: bytes.Clone(m.Payload)}
		protocol.WriteUint64(bad.Payload, tc.actorOffset, b.UID)
		if err := h.battleMessage(a, a.game(), bad); err == nil {
			t.Fatal("foreign actor accepted", tc.id)
		}
		roomOutputs(t, b)
	}
}
func TestPairTransformRequiresSelectionLease(t *testing.T) {
	h, a, b, _ := combatFixture()
	r := a.Room
	transform := extendedPacket(8144, 115, b.UID, a.UID, 0)
	protocol.WriteUint64(transform.Payload, 47, b.UID)
	if err := h.battleMessage(b, b.game(), transform); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, a)
	selectTarget := extendedPacket(8143, 59, a.UID, a.UID, 0)
	protocol.WriteUint64(selectTarget.Payload, 47, b.UID)
	protocol.WriteUint32(selectTarget.Payload, 55, 15000)
	if err := h.battleMessage(a, a.game(), selectTarget); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b, 8071)
	if err := h.battleMessage(b, b.game(), transform); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, a, 8071)
	r.PairSelections[a.UID] = pairSelection{b.UID, time.Now().Add(-time.Second)}
	protocol.WriteUint32(transform.Payload, 19, 2)
	if err := h.battleMessage(b, b.game(), transform); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, a)
}
func TestProjectileOwnershipWitnessAndTombstone(t *testing.T) {
	h, a, b, _ := combatFixture()
	create := extendedPacket(8400, 131, a.UID, a.UID, 123)
	protocol.WriteUint32(create.Payload, 47, 17)
	if err := h.battleMessage(a, a.game(), create); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b, 8071)
	removal := extendedPacket(8404, 51, b.UID, 0, 43)
	protocol.WriteUint32(removal.Payload, 39, 17)
	if err := h.battleMessage(b, b.game(), removal); err == nil {
		t.Fatal("peer removed projectile")
	}
	roomOutputs(t, a)
	hit := extendedPacket(8402, 123, b.UID, 0, 115)
	protocol.WriteUint32(hit.Payload, 39, 17)
	protocol.WriteUint64(hit.Payload, 43, b.UID)
	if err := h.battleMessage(b, b.game(), hit); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, a, 8071)
	result := extendedPacket(8401, 123, b.UID, 0, 115)
	protocol.WriteUint32(result.Payload, 39, 17)
	protocol.WriteUint32(result.Payload, 43, 2)
	if err := h.battleMessage(b, b.game(), result); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, a, 8071)
	if err := h.battleMessage(b, b.game(), result); err != nil {
		t.Fatal("duplicate consumed witness", err)
	}
	roomOutputs(t, a)
	protocol.WriteUint32(result.Payload, 19, 2)
	if err := h.battleMessage(b, b.game(), result); err == nil {
		t.Fatal("witness reused")
	}
	protocol.WriteUint64(removal.Payload, 4, a.UID)
	if err := h.battleMessage(a, a.game(), removal); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b, 8071)
	protocol.WriteUint32(create.Payload, 19, 2)
	if err := h.battleMessage(a, a.game(), create); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b)
	if a.Room.Projectiles[17].alive {
		t.Fatal("projectile resurrected")
	}
}
func TestSlipAndCollectibleGuards(t *testing.T) {
	h, a, b, _ := combatFixture()
	slip := extendedPacket(8270, 87, a.UID, a.UID, 0)
	if err := h.battleMessage(a, a.game(), slip); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b, 8071)
	protocol.WriteUint32(slip.Payload, 19, 2)
	protocol.WriteUint32(slip.Payload, 67, math.Float32bits(1))
	if err := h.battleMessage(a, a.game(), slip); err == nil {
		t.Fatal("absent actor with movement")
	}
	spawn := extendedPacket(8287, 63, b.UID, 0, 0)
	protocol.WriteUint32(spawn.Payload, 39, 1)
	protocol.WriteUint32(spawn.Payload, 43, 9)
	if err := h.battleMessage(b, b.game(), spawn); err == nil {
		t.Fatal("nonhost spawned object")
	}
	protocol.WriteUint64(spawn.Payload, 4, a.UID)
	if err := h.battleMessage(a, a.game(), spawn); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b, 8071)
	protocol.WriteUint32(spawn.Payload, 19, 2)
	if err := h.battleMessage(a, a.game(), spawn); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b)
}

func TestPairUDPSelectionOnlyForDeliveredTarget(t *testing.T) {
	_, a, b, outsider := combatFixture()
	r := a.Room
	m := extendedPacket(8143, 59, a.UID, a.UID, 0)
	protocol.WriteUint64(m.Payload, 47, b.UID)
	protocol.WriteUint32(m.Payload, 55, 15000)
	raw, err := protocol.Encode(m)
	if err != nil {
		t.Fatal(err)
	}
	r.observeRelayedPairSelection(a, outsider, raw)
	if len(r.PairSelections) != 0 {
		t.Fatal("undelivered selection created lease")
	}
	r.observeRelayedPairSelection(a, b, raw)
	first := r.PairSelections[a.UID]
	if first.target != b.UID {
		t.Fatal("delivered selection not recorded")
	}
	r.observeRelayedPairSelection(a, b, raw)
	if r.PairSelections[a.UID] != first {
		t.Fatal("duplicate refreshed lease")
	}
	r.retireBattleObjects(b.UID)
	if len(r.PairSelections) != 0 {
		t.Fatal("departed target retained")
	}
}
