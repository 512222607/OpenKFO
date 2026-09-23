package game

import (
	"bytes"
	"testing"

	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

func TestWingReequipRefreshesEffectsForSelfAndPeer(t *testing.T) {
	hub, self, peer, _ := waitingRoomFixture()
	wing := make([]byte, protocol.InventoryRecordSize)
	protocol.WriteUint32(wing, 0, 1048598)
	wing[protocol.InventoryKindOffset] = protocol.ItemTalisman
	protocol.WriteUint32(wing, protocol.InventoryItemIDOffset, 303148)
	protocol.WriteUint16(wing, 23, 10000)
	account := persistence.Account{UID: self.UID, Profile: make([]byte, 360), Inventory: [][]byte{wing}}
	account.Profile[122], account.Profile[124] = 1, 2
	peer.Room.Members[peer.UID].Ready = true
	for _, slot := range []uint16{protocol.SlotPrimaryTalisman, protocol.SlotUnequipped, protocol.SlotPrimaryTalisman} {
		protocol.WriteUint16(wing, protocol.InventorySlotOffset, slot)
		hub.broadcastEquipment(self, account)
		own := roomOutputs(t, self, protocol.MsgRoomRoster, protocol.MsgRoomEquipmentEffects)
		remote := roomOutputs(t, peer, protocol.MsgRoomRoster, protocol.MsgRoomEquipmentEffects)
		p := own[1].Payload
		if !bytes.Equal(p, remote[1].Payload) || protocol.ReadUint64(p, 0) != self.UID || p[8] != 1 || p[9] != 2 || len(p) != 21+protocol.InventoryRecordSize {
			t.Fatal("incorrect self/peer equipment effect packet")
		}
		if slot == protocol.SlotUnequipped {
			if p[11] != 0 || !bytes.Equal(p[21:], make([]byte, protocol.InventoryRecordSize)) {
				t.Fatal("unequipped wing retained in effects update")
			}
		} else if p[11] != 1 || !bytes.Equal(p[21:], wing) {
			t.Fatal("wing instance, slot or quota changed")
		}
		if !peer.Room.Members[peer.UID].Ready {
			t.Fatal("equipment update cancelled peer readiness")
		}
	}
}
