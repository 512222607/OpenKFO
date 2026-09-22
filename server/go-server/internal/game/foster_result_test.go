package game

import (
	"bytes"
	"testing"

	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

func TestFosterResultUsesNativeCommonPage(t *testing.T) {
	for _, outcome := range []string{persistence.StageOutcomeClear, persistence.StageOutcomeFailed} {
		_, owner, peer, _ := combatFixture()
		r := owner.Room
		r.Request[46] = byte(protocol.FosterMode)
		awards := []persistence.BattleReward{
			{UID: owner.UID, Outcome: outcome, Experience: 12, Gold: 34, Profile: bytes.Repeat([]byte{1}, protocol.RoleProfileSize)},
			{UID: peer.UID, Outcome: outcome, Experience: 56, Gold: 78, Profile: bytes.Repeat([]byte{2}, protocol.RoleProfileSize)},
		}
		for _, recipient := range []uint64{owner.UID, peer.UID} {
			m, err := stageResultPacket(r, awards, recipient)
			if err != nil || m.ID != 4120 || len(m.Payload) != 1000 {
				t.Fatal("invalid Foster result", err)
			}
			if protocol.ReadUint64(m.Payload, 500) != recipient {
				t.Fatal("recipient profile must be applied last")
			}
			for i := 0; i < 2; i++ {
				row := m.Payload[i*500 : (i+1)*500]
				want := awards[0]
				if protocol.ReadUint64(row, 0) == peer.UID {
					want = awards[1]
				}
				result := byte(1)
				if outcome == persistence.StageOutcomeFailed {
					result = 2
				}
				if row[10] != result || protocol.ReadUint32(row, 34) != want.Experience || protocol.ReadUint32(row, 63) != want.Gold || !bytes.Equal(row[140:], func() []byte {
					if want.UID == recipient {
						return want.Profile
					}
					return make([]byte, protocol.RoleProfileSize)
				}()) {
					t.Fatal("reward/profile mismatch")
				}
				if !bytes.Equal(row[87:104], make([]byte, 17)) {
					t.Fatal("mode21 score/wave/grade fields leaked into mode10")
				}
			}
		}
		if awards[0].Outcome != outcome || awards[1].Outcome != outcome {
			t.Fatal("UI mapping mutated persisted outcome")
		}
		for _, invalid := range []string{"profile", "duplicate", "foreign", "missing", "outcome", "recipient"} {
			rows := append([]persistence.BattleReward(nil), awards...)
			recipient := owner.UID
			switch invalid {
			case "profile":
				rows[0].Profile = nil
			case "duplicate":
				rows[0].UID = rows[1].UID
			case "foreign":
				rows[0].UID = 999
			case "missing":
				rows = rows[:1]
			case "outcome":
				rows[0].Outcome = "win"
			case "recipient":
				recipient = 999
			}
			if _, err := stageResultPacket(r, rows, recipient); err == nil {
				t.Fatal("invalid result accepted", invalid)
			}
		}
	}
}
