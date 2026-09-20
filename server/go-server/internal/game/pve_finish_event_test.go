package game

import (
	"bytes"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestFosterFinishEvent(t *testing.T) {
	for _, scenario := range []string{"valid", "repeat", "peer", "sender", "previous-battle", "short", "long", "loading", "settled", "competitive", "wave-mode", "replaced-session"} {
		t.Run(scenario, func(t *testing.T) {
			h, owner, peer, outsider := combatFixture()
			r := owner.Room
			r.Request[46] = byte(protocol.FosterMode)
			p := make([]byte, 47)
			protocol.WriteUint32(p, 0, protocol.BattleEventStageWaveEnd)
			protocol.WriteUint64(p, 4, owner.UID)
			protocol.WriteUint64(p, 39, uint64(r.ID)|(uint64(r.Serial)<<32))
			sender := owner
			wantError := false
			switch scenario {
			case "peer":
				sender = peer
				protocol.WriteUint64(p, 4, peer.UID)
			case "sender":
				protocol.WriteUint64(p, 4, peer.UID)
				wantError = true
			case "previous-battle":
				protocol.WriteUint32(p, 43, uint32(r.Serial)+1)
			case "short":
				p, wantError = p[:46], true
			case "long":
				p, wantError = append(p, 0), true
			case "loading":
				r.Stage = "loading"
			case "settled":
				r.Stage = "result"
			case "competitive":
				r.Request[46] = 0
			case "wave-mode":
				r.Request[46] = byte(protocol.StageAssault)
			case "replaced-session":
				r.Members[owner.UID].Session = peer
				wantError = true
			}
			beforeStage, beforeReports := r.Stage, len(r.Reports)
			count := 1
			if scenario == "repeat" {
				count = 2
			}
			for i := 0; i < count; i++ {
				err := h.battleMessage(sender, sender.game(), protocol.Message{ID: protocol.MsgBattleEvent, Payload: p})
				if (err != nil) != wantError {
					t.Fatal("unexpected validation result", err)
				}
				if scenario == "valid" || scenario == "repeat" {
					if !r.FosterFinishReported {
						t.Fatal("controller finish receipt missing")
					}
					out := roomOutputs(t, peer, protocol.MsgBattleEvent)
					if !bytes.Equal(out[0].Payload, p) {
						t.Fatal("native event changed")
					}
				} else {
					if r.FosterFinishReported {
						t.Fatal("invalid finish changed receipt")
					}
					roomOutputs(t, peer)
				}
				roomOutputs(t, owner)
				roomOutputs(t, outsider)
				if r.Stage != beforeStage || len(r.Reports) != beforeReports {
					t.Fatal("script notification changed settlement state")
				}
			}
		})
	}
}
