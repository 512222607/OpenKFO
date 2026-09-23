package game

import (
	"bytes"
	"database/sql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestExpiredEquipmentSynchronizesAtEachPlayersReturn(t *testing.T) {
	for _, legacy := range []bool{false, true} {
		t.Run(map[bool]string{false: "3550", true: "3110"}[legacy], func(t *testing.T) {
			hub, host, peer, _ := combatFixture()
			db, err := sql.Open("recovery-snapshot", "expired")
			if err != nil {
				t.Fatal(err)
			}
			defer db.Close()
			hub.Store = &persistence.Store{DB: db}
			room := host.Room
			room.Stage = "settlement"
			for _, s := range []*Session{host, peer} {
				s.game().Phase = "settlement"
				room.Members[s.UID].Ready = false
				r := make([]byte, 68)
				protocol.WriteUint32(r, 0, 7)
				r[4] = 25
				protocol.WriteUint32(r, 5, 253002)
				protocol.WriteUint16(r, 17, 8)
				s.rememberInventory([][]byte{r})
			}
			for _, s := range []*Session{host, peer} {
				other := peer
				if s == peer {
					other = host
				}
				if legacy {
					roomRequest(t, hub, s, 3110, nil)
					roomOutputs(t, s, 3115, 3100, 3160, 3105, 2310, 2161, 2121)
					assertPlayerRefresh(t, roomOutputs(t, other, 3090)[0], s.UID)
				} else {
					roomRequest(t, hub, s, 3550, append(protocol.Uint64Bytes(s.UID), make([]byte, 4)...))
					roomOutputs(t, s, 3550, 2310, 2161, 2121, protocol.MsgRoomRoster)
					assertPlayerRefresh(t, roomOutputs(t, other, 3550, protocol.MsgRoomRoster)[1], s.UID)
				}
				if s.game().Phase != "room" || protocol.ReadUint16(s.Inventory[7], 17) != 0 || protocol.ReadUint32(s.Inventory[7], 19) != 2 {
					t.Fatal("returned player retained expired equipment")
				}
				if s == host && (peer.game().Phase != "settlement" || protocol.ReadUint16(peer.Inventory[7], 17) != 8) {
					t.Fatal("peer inventory changed before their return")
				}
				roomRequest(t, hub, s, 3550, append(protocol.Uint64Bytes(s.UID), make([]byte, 4)...))
				roomOutputs(t, s, 3550)
				roomOutputs(t, other, 3550)
			}
		})
	}
}

func assertPlayerRefresh(t *testing.T, message protocol.Message, uid uint64) {
	t.Helper()
	p := message.Payload
	if (message.ID != 3090 && message.ID != protocol.MsgRoomRoster) || len(p) < 149 || protocol.ReadUint64(p, 0) != uid || p[8] >= 8 || p[76] != 0 {
		t.Fatal("player equipment refresh entered native spectator branch", message)
	}
}

func TestEquipmentChangeRemainsPlayerRecord(t *testing.T) {
	hub, host, peer, _ := waitingRoomFixture()
	hub.Store = recoveryStore(t)
	host.Room.Members[peer.UID].Ready = true
	hub.equipmentChanged(host)
	if !host.Room.Members[peer.UID].Ready {
		t.Fatal("equipment refresh cancelled peer readiness")
	}
	remote := roomOutputs(t, peer, protocol.MsgRoomRoster)[0]
	own := roomOutputs(t, host, protocol.MsgRoomRoster)[0]
	assertPlayerRefresh(t, remote, host.UID)
	if !bytes.Equal(own.Payload, remote.Payload) {
		t.Fatal("self and peer room appearances differ")
	}
}

func TestRoomWeaponReplacementAndRemoval(t *testing.T) {
	hub, host, peer, _ := waitingRoomFixture()
	item := func(id uint32, slot uint16) []byte {
		r := make([]byte, protocol.InventoryRecordSize)
		protocol.WriteUint32(r, 0, id)
		r[4] = protocol.ItemWeapon
		protocol.WriteUint32(r, 5, 253000+id)
		protocol.WriteUint16(r, 17, slot)
		return r
	}
	host.rememberInventory([][]byte{item(1, protocol.SlotPrimaryWeapon), item(2, 0)})
	for _, equip := range []bool{true, false, true} {
		slot, id := uint16(protocol.SlotUnequipped), uint32(protocol.MsgUnequipItem)
		payload := protocol.Uint32Bytes(2)
		if equip {
			slot, id = protocol.SlotPrimaryWeapon, protocol.MsgEquipItem
			payload = append(payload, make([]byte, 12)...)
		}
		records := [][]byte{item(1, 0), item(2, slot)}
		oldEquipped := protocol.ReadUint16(host.Inventory[1], 17) != 0
		host.syncEquipmentChange(protocol.Message{ID: id, Payload: payload}, records[1], records)
		account := persistence.Account{UID: host.UID, Profile: make([]byte, 836), Inventory: records}
		hub.broadcastEquipment(host, account)
		var expected []uint32
		if oldEquipped {
			expected = append(expected, protocol.MsgItemUnequipped)
		}
		expected = append(expected, id+10)
		if oldEquipped {
			expected = append(expected, protocol.MsgItemUpdated)
		}
		expected = append(expected, protocol.MsgItemUpdated)
		expected = append(expected, protocol.MsgRoomRoster)
		own := roomOutputs(t, host, expected...)
		if oldEquipped && (protocol.ReadUint32(own[0].Payload, 0) != 1 || protocol.ReadUint16(own[0].Payload, 21) != 0) {
			t.Fatal("displaced weapon was not explicitly unequipped first")
		}
		remote := roomOutputs(t, peer, protocol.MsgRoomRoster)[0]
		if !bytes.Equal(own[len(own)-1].Payload, remote.Payload) {
			t.Fatal("self and peer received different room equipment")
		}
		assertPlayerRefresh(t, remote, host.UID)
		wantCount := 0
		if equip {
			wantCount = 1
		}
		if int(remote.Payload[64]) != wantCount || len(remote.Payload) != 149+wantCount*protocol.InventoryRecordSize {
			t.Fatal("room retained old weapon")
		}
		if equip && !bytes.Equal(remote.Payload[149:], records[1]) {
			t.Fatal("wrong room weapon")
		}
	}
}

func TestExpiryRefreshSkipsUnsafeSessionPhases(t *testing.T) {
	hub, s, _, _ := waitingRoomFixture()
	hub.Store = recoveryStore(t) // driver rejects queries other than normal snapshots
	for _, phase := range []string{"loading", "battle", "settlement", "connected", "closed"} {
		s.game().Phase = phase
		if err := hub.RefreshExpiredInventory(s); err != nil {
			t.Fatalf("phase %s unexpectedly queried DB: %v", phase, err)
		}
		roomOutputs(t, s)
	}
	s.game().Phase = "room"
	for _, stage := range []string{"loading", "battle", "settlement"} {
		s.Room.Stage = stage
		if err := hub.RefreshExpiredInventory(s); err != nil {
			t.Fatal(err)
		}
	}
	s.Room.Stage = "room"
	s.LoggedOut = true
	if err := hub.RefreshExpiredInventory(s); err != nil {
		t.Fatal(err)
	}
}

func TestTwoWeaponRoomRefreshUpdatesSelfAndPeers(t *testing.T) {
	hub, self, peer, _ := waitingRoomFixture()
	records := [][]byte{}
	for i, slot := range []uint16{protocol.SlotPrimaryWeapon, protocol.SlotSecondaryWeapon} {
		item := make([]byte, protocol.InventoryRecordSize)
		protocol.WriteUint32(item, 0, uint32(i+1))
		item[4] = protocol.ItemWeapon
		protocol.WriteUint16(item, 17, slot)
		records = append(records, item)
	}
	hub.broadcastEquipment(self, persistence.Account{UID: self.UID, Profile: make([]byte, 360), Inventory: records})
	own := roomOutputs(t, self, protocol.MsgRoomRoster)[0]
	messages := roomOutputs(t, peer, protocol.MsgRoomRoster)
	if !bytes.Equal(own.Payload, messages[0].Payload) {
		t.Fatal("self did not receive both weapon slots")
	}
	if messages[0].Payload[64] != 2 || !bytes.Equal(messages[0].Payload[149:], append(bytes.Clone(records[0]), records[1]...)) {
		t.Fatal("peer lost primary or secondary weapon")
	}
}

func TestPetRefreshAndExpiryPreservePeerReadiness(t *testing.T) {
	hub, self, peer, _ := waitingRoomFixture()
	pet := make([]byte, protocol.InventoryRecordSize)
	protocol.WriteUint32(pet, 0, 123)
	pet[protocol.InventoryKindOffset] = protocol.ItemTalisman
	protocol.WriteUint32(pet, protocol.InventoryItemIDOffset, 303131)
	protocol.WriteUint16(pet, protocol.InventorySlotOffset, protocol.SlotPrimaryTalisman)
	protocol.WriteUint16(pet, 23, 10000)
	original := bytes.Clone(pet)
	account := persistence.Account{UID: self.UID, Profile: make([]byte, 360), Inventory: [][]byte{pet}}
	peer.Room.Members[peer.UID].Ready = true
	hub.broadcastEquipment(self, account)
	own := roomOutputs(t, self, protocol.MsgRoomRoster, protocol.MsgRoomEquipmentEffects)[0]
	remote := roomOutputs(t, peer, protocol.MsgRoomRoster, protocol.MsgRoomEquipmentEffects)[0]
	if !bytes.Equal(own.Payload, remote.Payload) || own.Payload[64] != 1 || !bytes.Equal(own.Payload[149:], original) {
		t.Fatal("pet instance, slot or durability lost in self/peer refresh")
	}
	protocol.WriteUint16(pet, protocol.InventorySlotOffset, protocol.SlotUnequipped)
	self.Room.Members[self.UID].Ready = true
	hub.refreshExpiredEquipment(self, account)
	for _, player := range []*Session{self, peer} {
		out := roomOutputs(t, player, protocol.MsgPlayerNotReady, protocol.MsgRoomRoster, protocol.MsgRoomEquipmentEffects)
		if protocol.ReadUint64(out[0].Payload, 0) != self.UID || out[1].Payload[64] != 0 {
			t.Fatal("expiry cancelled another player or retained the pet")
		}
	}
	if !peer.Room.Members[peer.UID].Ready || self.Room.Members[self.UID].Ready {
		t.Fatal("expiry readiness scope incorrect")
	}
}
