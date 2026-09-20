package game

import (
	"math"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestFosterHealthReceipts(t *testing.T) {
	h, owner, peer, _ := combatFixture()
	r := owner.Room
	r.Request[46] = byte(protocol.FosterMode)
	spawn := protocol.FosterSpawn{Template: 0}
	r.FosterPlan = &protocol.FosterPlan{InitialHP: []float32{8}, GlobalLimit: 2, Groups: []protocol.FosterGroup{{SubLimit: 2, GroupLimit: 2, Spawns: []protocol.FosterSpawn{spawn, spawn}}}}
	r.FosterSpawned = []int{0}
	r.FosterTriggered = []bool{true}
	r.FosterRetired = []int{0}
	create := fosterSpawnPacket(owner.UID, 42, 1, spawn)
	if err := h.battleMessage(owner, owner.game(), create); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, peer, 8071)
	if r.PVEActors[42].reportedHP != 8 || r.PVEActors[42].maximumHP != 8 {
		t.Fatal("initial HP did not follow spawn template")
	}
	for _, step := range []struct {
		sequence     uint32
		amount, want float32
		forward      bool
	}{{2, 2, 6, true}, {2, 2, 6, false}, {2, 5, 6, false}, {2, -50, 6, false}, {1, 5, 6, false}, {3, -50, 8, true}, {4, 10, 0, true}, {5, 2, 0, true}, {6, -1, 1, true}} {
		m := combatPacket(protocol.BattleEventHealth, 94, peer.UID, 42, 86)
		protocol.WriteUint64(m.Payload, 47, peer.UID)
		protocol.WriteUint32(m.Payload, 19, step.sequence)
		protocol.WriteUint32(m.Payload, 67, math.Float32bits(step.amount))
		if err := h.battleMessage(peer, peer.game(), m); err != nil {
			t.Fatal(err)
		}
		if r.PVEActors[42].reportedHP != step.want || r.Stage != "battle" || !r.PVEActors[42].active {
			t.Fatal("health receipt changed progress or applied twice", step, r.PVEActors[42])
		}
		if step.forward {
			roomOutputs(t, owner, 8071)
		} else {
			roomOutputs(t, owner)
		}
	}
	for _, invalid := range []string{"sender", "context", "nan"} {
		m := combatPacket(protocol.BattleEventHealth, 94, peer.UID, 42, 86)
		protocol.WriteUint64(m.Payload, 47, peer.UID)
		protocol.WriteUint32(m.Payload, 19, 7)
		protocol.WriteUint32(m.Payload, 67, math.Float32bits(1))
		switch invalid {
		case "sender":
			protocol.WriteUint64(m.Payload, 4, owner.UID)
		case "context":
			protocol.WriteUint32(m.Payload, 90, r.Serial+1)
		case "nan":
			protocol.WriteUint32(m.Payload, 67, math.Float32bits(float32(math.NaN())))
		}
		if err := h.battleMessage(peer, peer.game(), m); err == nil || r.PVEActors[42].reportedHP != 1 {
			t.Fatal("unvalidated health event changed projection", invalid, err)
		}
		roomOutputs(t, owner)
	}
	remove := combatPacket(protocol.BattleEventPVEActorRemove, 47, owner.UID, 42, 0)
	protocol.WriteUint32(remove.Payload, 19, 8)
	if err := h.battleMessage(owner, owner.game(), remove); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, peer, 8071)
	if r.PVEActors[42].maximumHP != 0 {
		t.Fatal("removed actor kept health projection")
	}
	if r.FosterRetired[0] != 0 {
		t.Fatal("removing a living actor became a death receipt")
	}
	protocol.WriteUint32(create.Payload, 19, 9)
	if err := h.battleMessage(owner, owner.game(), create); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, peer, 8071)
	if r.PVEActors[42].reportedHP != 8 {
		t.Fatal("reused identity inherited previous life HP")
	}
}
