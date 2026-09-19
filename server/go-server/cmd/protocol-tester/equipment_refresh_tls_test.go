package main

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func checkEquipmentRefreshTLS(t *testing.T, host, peer *client, uid uint64, send func(*client, uint32, []byte), drain func(*client) []protocol.Message) {
	t.Helper()
	for _, instance := range []uint32{1, 2, 0} {
		opcode, ack := uint32(protocol.MsgEquipItem), uint32(protocol.MsgEquipmentChanged)
		p := make([]byte, 16)
		protocol.WriteUint32(p, 0, instance)
		if instance == 0 {
			opcode, ack = protocol.MsgUnequipItem, 2310
			p = protocol.Uint32Bytes(2)
		}
		send(host, opcode, p)
		own := drain(host)
		found := false
		var equipped []byte
		for _, m := range own {
			if m.ID == ack {
				found = true
			}
			if m.ID == protocol.MsgInventoryList {
				if len(m.Payload)%protocol.InventoryRecordSize != 0 {
					t.Fatal("invalid own inventory stride")
				}
				for off := 0; off < len(m.Payload); off += protocol.InventoryRecordSize {
					item := m.Payload[off : off+protocol.InventoryRecordSize]
					if protocol.ReadUint16(item, 17) != 0 {
						equipped = append(equipped, item...)
					}
				}
			}
		}
		if !found {
			t.Fatal("equipment request not acknowledged", own)
		}
		remote := drain(peer)
		if len(remote) != 1 || remote[0].ID != 3090 {
			t.Fatal("missing peer equipment refresh", remote)
		}
		r := remote[0].Payload
		count := len(equipped) / protocol.InventoryRecordSize
		if len(r) != 149+len(equipped) || protocol.ReadUint64(r, 0) != uid || r[8] >= 8 || r[76] != 0 || int(r[64]) != count || !bytes.Equal(r[149:], equipped) {
			t.Fatal("refresh changed player identity or native equipment stride", remote)
		}
		weapons := 0
		for off := 149; off < len(r); off += protocol.InventoryRecordSize {
			item := r[off : off+protocol.InventoryRecordSize]
			if item[4] != protocol.ItemWeapon {
				continue
			}
			weapons++
			if instance == 0 || protocol.ReadUint32(item, 0) != instance || protocol.ReadUint16(item, 17) != 8 || protocol.ReadUint32(item, 5) != 253000+instance {
				t.Fatal("wrong replacement weapon")
			}
		}
		if (instance == 0 && weapons != 0) || (instance != 0 && weapons != 1) {
			t.Fatal("weapon refresh count", weapons)
		}
	}
}
