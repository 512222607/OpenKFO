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
