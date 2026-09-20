package game

import (
	"math"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestFosterCompletionReceiptGate(t *testing.T) {
	for _, scenario := range []string{"corpse-pending", "retired", "missing-flag", "unfinished-group", "live", "unknown-hp", "lost-removal", "extra-actor", "wrong-group", "wrong-mode"} {
		t.Run(scenario, func(t *testing.T) {
			_, owner, _, _ := combatFixture()
			r := owner.Room
			r.Request[46] = byte(protocol.FosterMode)
			r.FosterPlan = &protocol.FosterPlan{Groups: []protocol.FosterGroup{{SubLimit: 2, GroupLimit: 2, Spawns: []protocol.FosterSpawn{{}, {}}}, {Spawns: []protocol.FosterSpawn{{}}}}}
			r.FosterSpawned, r.FosterRetired = []int{2, 1}, []int{1, 1}
			r.FosterFinishReported = true
			r.PVEActors = map[uint64]pveActor{42: {active: true, maximumHP: 8, fosterGroup: 0}}
			switch scenario {
			case "retired":
				r.PVEActors = nil
				r.FosterRetired[0] = 2
			case "missing-flag":
				r.FosterFinishReported = false
			case "unfinished-group":
				r.FosterSpawned[1] = 0
			case "live":
				a := r.PVEActors[42]
				a.reportedHP = 1
				r.PVEActors[42] = a
			case "unknown-hp":
				a := r.PVEActors[42]
				a.maximumHP = 0
				r.PVEActors[42] = a
			case "lost-removal":
				r.PVEActors = nil
			case "extra-actor":
				r.PVEActors[43] = r.PVEActors[42]
			case "wrong-group":
				a := r.PVEActors[42]
				a.fosterGroup = 1
				r.PVEActors[42] = a
			case "wrong-mode":
				r.Request[46] = byte(protocol.StageAssault)
			}
			want := scenario == "corpse-pending" || scenario == "retired"
			if r.fosterReceiptsComplete() != want {
				t.Fatal("unexpected completion receipt result")
			}
			if r.Stage != "battle" || len(r.Reports) != 0 {
				t.Fatal("receipt check authorized settlement")
			}
		})
	}
}

func TestFosterRetiredReceiptsSurviveIdentityReuse(t *testing.T) {
	h, owner, peer, _ := combatFixture()
	r := owner.Room
	r.Request[46] = byte(protocol.FosterMode)
	spawn := protocol.FosterSpawn{}
	r.FosterPlan = &protocol.FosterPlan{InitialHP: []float32{8}, GlobalLimit: 2, Groups: []protocol.FosterGroup{{SubLimit: 2, GroupLimit: 2, Spawns: []protocol.FosterSpawn{spawn, spawn}}}}
	r.FosterSpawned, r.FosterRetired = []int{0}, []int{0}
	r.FosterTriggered = []bool{true}
	for life := uint32(0); life < 2; life++ {
		create := fosterSpawnPacket(owner.UID, 42, life*3+1, spawn)
		damage := combatPacket(protocol.BattleEventHealth, 94, owner.UID, 42, 86)
		protocol.WriteUint32(damage.Payload, 19, life*3+2)
		protocol.WriteUint32(damage.Payload, 67, math.Float32bits(8))
		for _, m := range []protocol.Message{create, damage} {
			if err := h.battleMessage(owner, owner.game(), m); err != nil {
				t.Fatal(err)
			}
			roomOutputs(t, peer, 8071)
		}
		if life == 1 {
			r.FosterFinishReported = true
			if !r.fosterReceiptsComplete() {
				t.Fatal("last corpse timer blocked completed receipts")
			}
		}
		remove := combatPacket(protocol.BattleEventPVEActorRemove, 47, owner.UID, 42, 0)
		protocol.WriteUint32(remove.Payload, 19, life*3+3)
		if err := h.battleMessage(owner, owner.game(), remove); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, peer, 8071)
		if err := h.battleMessage(owner, owner.game(), remove); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, peer)
		if r.FosterRetired[0] != int(life+1) {
			t.Fatal("removal replay or reused identity lost completion count")
		}
	}
	if !r.fosterReceiptsComplete() {
		t.Fatal("retired receipts lost final progress")
	}
}
