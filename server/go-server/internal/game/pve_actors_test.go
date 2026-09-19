package game

import (
	"bytes"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestPVEActorLifecycle(t *testing.T) {
	h, owner, peer, outsider := combatFixture()
	r := owner.Room
	r.Request[46] = byte(protocol.StageAssault)
	create := combatPacket(protocol.BattleEventPVEActorCreate, 67, owner.UID, 42, 0)
	remove := combatPacket(protocol.BattleEventPVEActorRemove, 47, owner.UID, 42, 0)
	protocol.WriteUint32(remove.Payload, 19, 2)
	send := func(s *Session, m protocol.Message) {
		t.Helper()
		if err := h.battleMessage(s, s.game(), m); err != nil {
			t.Fatal(err)
		}
	}
	// Only the current owner controls spawning, and packets remain room-local.
	send(peer, create)
	roomOutputs(t, owner)
	if len(r.PVEActors) != 0 {
		t.Fatal("peer registered an actor")
	}
	send(owner, create)
	if !r.PVEActors[42].active {
		t.Fatal("actor not registered")
	}
	if got := roomOutputs(t, peer, 8071)[0]; !bytes.Equal(got.Payload, create.Payload) {
		t.Fatal("rewritten create")
	}
	roomOutputs(t, outsider)
	send(owner, create)
	roomOutputs(t, peer)
	send(owner, remove)
	roomOutputs(t, peer, 8071)
	if r.PVEActors[42].active {
		t.Fatal("actor not removed")
	}
	// Delayed create/remove retries cannot resurrect or remove another lifetime.
	send(owner, create)
	send(owner, remove)
	roomOutputs(t, peer)
	protocol.WriteUint32(create.Payload, 19, 3)
	send(owner, create)
	roomOutputs(t, peer, 8071)
	send(owner, remove)
	roomOutputs(t, peer)
	if !r.PVEActors[42].active || len(r.PVEActors) != 1 {
		t.Fatal("identity reuse corrupted")
	}
	for _, actor := range []uint64{owner.UID, peer.UID} {
		bad := combatPacket(protocol.BattleEventPVEActorCreate, 67, owner.UID, actor, 0)
		if h.battleMessage(owner, owner.game(), bad) == nil {
			t.Fatal("player identity accepted")
		}
	}
	spoof := combatPacket(protocol.BattleEventPVEActorCreate, 67, peer.UID, 43, 0)
	if h.battleMessage(owner, owner.game(), spoof) == nil {
		t.Fatal("forged sender accepted")
	}
	roomOutputs(t, peer)
	if len(r.Reports) != 0 {
		t.Fatal("removal created settlement")
	}
}

func TestPVEActorPoolAndModeIsolation(t *testing.T) {
	h, owner, peer, _ := combatFixture()
	r := owner.Room
	packet := combatPacket(protocol.BattleEventPVEActorCreate, 67, owner.UID, 0, 0)
	if err := h.battleMessage(owner, owner.game(), packet); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, peer)
	if r.PVEActors != nil {
		t.Fatal("PvP accepted monster")
	}
	r.Request[46] = byte(protocol.StageAssault)
	for actor := uint64(0); actor < stageAssaultActorPoolSize; actor++ {
		protocol.WriteUint64(packet.Payload, 39, actor)
		if err := h.battleMessage(owner, owner.game(), packet); err != nil {
			t.Fatal(actor, err)
		}
		roomOutputs(t, peer, 8071)
	}
	protocol.WriteUint64(packet.Payload, 39, stageAssaultActorPoolSize)
	if h.battleMessage(owner, owner.game(), packet) == nil {
		t.Fatal("unbounded pool")
	}
	roomOutputs(t, peer)
}

func TestPVECombatOwnershipAndEntityOrdering(t *testing.T) {
	h, owner, peer, outsider := combatFixture()
	r := owner.Room
	r.Request[46] = byte(protocol.StageAssault)
	r.PVEActors = map[uint64]pveActor{42: {active: true, sequence: 1}, 43: {active: true, sequence: 1}}
	state := func(actor uint64, sequence uint32) protocol.Message {
		m := combatPacket(protocol.BattleEventState, 51, owner.UID, actor, 0)
		protocol.WriteUint32(m.Payload, 19, sequence)
		return m
	}
	// Different entities can arrive out of order without suppressing updates.
	for _, m := range []protocol.Message{state(42, 10), state(43, 9)} {
		if err := h.battleMessage(owner, owner.game(), m); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, peer, 8071)
	}
	if err := h.battleMessage(owner, owner.game(), state(42, 10)); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, peer)
	forged := state(43, 11)
	protocol.WriteUint64(forged.Payload, 4, peer.UID)
	if h.battleMessage(peer, peer.game(), forged) == nil {
		t.Fatal("non-controller changed monster state")
	}
	roomOutputs(t, owner)
	// A player may attack a registered monster using their own identity.
	hit := combatPacket(protocol.BattleEventHealth, 94, peer.UID, 42, 86)
	protocol.WriteUint64(hit.Payload, 47, peer.UID)
	if err := h.battleMessage(peer, peer.game(), hit); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, owner, 8071)
	// The controller may report a monster attacking another room player.
	hit = combatPacket(protocol.BattleEventHealth, 94, owner.UID, peer.UID, 86)
	protocol.WriteUint32(hit.Payload, 19, 12)
	protocol.WriteUint64(hit.Payload, 47, 42)
	if err := h.battleMessage(owner, owner.game(), hit); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, peer, 8071)
	protocol.WriteUint64(hit.Payload, 47, outsider.UID)
	if h.battleMessage(owner, owner.game(), hit) == nil {
		t.Fatal("foreign damage source accepted")
	}
	roomOutputs(t, outsider)
	// Cleanup and identity reuse must not leak old controller updates.
	r.PVEActors[42] = pveActor{active: false, sequence: 20}
	if err := h.battleMessage(owner, owner.game(), state(42, 21)); err != nil {
		t.Fatal(err)
	}
	r.PVEActors[42] = pveActor{active: true, sequence: 30}
	if err := h.battleMessage(owner, owner.game(), state(42, 22)); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, peer)
	if err := h.battleMessage(owner, owner.game(), state(42, 31)); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, peer, 8071)
}

func TestPVEReliableControllerLifecycle(t *testing.T) {
	h, owner, peer, _ := combatFixture()
	r := owner.Room
	r.Request[46] = byte(protocol.StageAssault)
	r.PVEActors = map[uint64]pveActor{42: {active: true, sequence: 1}}
	complete := combatPacket(9502, 55, owner.UID, 42, 0)
	protocol.WriteUint32(complete.Payload, 19, 2)
	protocol.WriteUint32(complete.Payload, 47, 7)
	protocol.WriteUint32(complete.Payload, 51, 1)
	if err := h.battleMessage(owner, owner.game(), complete); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, peer, 8071)
	protocol.WriteUint64(complete.Payload, 4, peer.UID)
	if err := h.battleMessage(peer, peer.game(), complete); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, owner)
	remove := combatPacket(protocol.BattleEventPVEActorRemove, 47, owner.UID, 42, 0)
	protocol.WriteUint32(remove.Payload, 19, 3)
	if err := h.battleMessage(owner, owner.game(), remove); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, peer, 8071)
	if len(r.Reliable) != 0 {
		t.Fatal("retired actor retained reliable state")
	}
	protocol.WriteUint64(complete.Payload, 4, owner.UID)
	if err := h.battleMessage(owner, owner.game(), complete); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, peer)
}
