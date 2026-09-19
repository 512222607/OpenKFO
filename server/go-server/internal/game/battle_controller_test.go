package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestBattleStartUsesOneController(t *testing.T) {
	h, owner, peer, _ := combatFixture()
	r := h.Rooms[1]
	r.Members[owner.UID].Slot = 3
	r.Members[peer.UID].Slot = 6
	owner.P2P, peer.P2P = 1234, 5678
	for _, uid := range []uint64{owner.UID, peer.UID} {
		r.Owner = uid
		p := battleStartPayload(r)
		if len(p) != 53 || protocol.ReadUint16(p, 11) != uint16(r.Members[uid].Slot) {
			t.Fatal("controller is not the selected owner")
		}
		for slot := 0; slot < 8; slot++ {
			if protocol.ReadUint32(p, 13+slot*4) != 0 {
				t.Fatal("unmeasured network delay contains a peer ID", slot)
			}
		}
		if protocol.ReadUint32(p, 0) != 1 || protocol.ReadUint32(p, 5) != 7 || protocol.ReadUint32(p, 45) != 1 || protocol.ReadUint32(p, 49) != 7 {
			t.Fatal("battle context changed")
		}
	}
}
