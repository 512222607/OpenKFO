package game

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestPVEBlockLifecycle(t *testing.T) {
	for _, mode := range []protocol.RoomType{protocol.FosterMode, protocol.StageAssault, protocol.TeamSurvival} {
		t.Run(mode.String(), func(t *testing.T) {
			h, owner, peer, outsider := combatFixture()
			r := owner.Room
			r.Request[46] = byte(mode)
			packet := func(create bool, seq uint32) []byte {
				var p []byte
				if create {
					p = make([]byte, 92)
					protocol.WriteUint32(p, 0, protocol.BattleEventPVEBlockCreate)
					protocol.WriteUint32(p, 40, 100)
				} else {
					p = make([]byte, 43)
					protocol.WriteUint32(p, 0, protocol.BattleEventPVEBlockRemove)
					protocol.WriteUint32(p, 39, 100)
				}
				protocol.WriteUint64(p, 4, owner.UID)
				protocol.WriteUint32(p, 19, seq)
				return p
			}
			send := func(s *Session, p []byte) error {
				return h.battleMessage(s, s.game(), protocol.Message{ID: 8071, Payload: p})
			}
			p := packet(true, 1)
			if e := send(peer, p); e != nil {
				t.Fatal(e)
			}
			roomOutputs(t, owner)
			roomOutputs(t, peer)
			if len(r.PVEBlocks) != 0 {
				t.Fatal("peer changed walls")
			}
			if e := send(owner, p); e != nil {
				t.Fatal(e)
			}
			if mode == protocol.TeamSurvival {
				roomOutputs(t, peer)
				if len(r.PVEBlocks) != 0 {
					t.Fatal("competitive wall")
				}
				return
			}
			out := roomOutputs(t, peer, 8071)
			if !bytes.Equal(out[0].Payload, p) || !bytes.Equal(r.PVEBlocks[100].payload, p) {
				t.Fatal("wall payload changed")
			}
			p[39] = 1
			if r.PVEBlocks[100].payload[39] != 0 {
				t.Fatal("state aliases input")
			}
			for _, stale := range [][]byte{packet(true, 1), packet(false, 0)} {
				if e := send(owner, stale); e != nil {
					t.Fatal(e)
				}
			}
			roomOutputs(t, peer)
			if e := send(owner, packet(false, 2)); e != nil {
				t.Fatal(e)
			}
			roomOutputs(t, peer, 8071)
			if r.PVEBlocks[100].payload != nil {
				t.Fatal("removed wall retained")
			}
			if e := send(owner, packet(true, 1)); e != nil {
				t.Fatal(e)
			}
			roomOutputs(t, peer)
			if e := send(owner, packet(true, 3)); e != nil {
				t.Fatal(e)
			}
			roomOutputs(t, peer, 8071)
			forged := packet(false, 4)
			protocol.WriteUint64(forged, 4, peer.UID)
			if e := send(owner, forged); e == nil {
				t.Fatal("forged sender")
			}
			r.Stage = "settlement"
			if e := send(owner, packet(false, 4)); e != nil {
				t.Fatal(e)
			}
			if r.PVEBlocks[100].payload == nil {
				t.Fatal("late packet changed walls")
			}
			roomOutputs(t, peer)
			roomOutputs(t, owner)
			roomOutputs(t, outsider)
		})
	}
}
