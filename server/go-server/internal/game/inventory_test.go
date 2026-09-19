package game

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestInventoryExpiryNotificationOnce(t *testing.T) {
	_, s, _, _ := waitingRoomFixture()
	p := make([]byte, 68)
	protocol.WriteUint32(p, 0, 42)
	p[4] = 25
	protocol.WriteUint16(p, 17, 8)
	s.rememberInventory([][]byte{p})
	protocol.WriteUint32(p, 19, 2)
	protocol.WriteUint16(p, 17, 0)
	s.syncInventory([][]byte{p})
	replies := roomOutputs(t, s, 2161, 2121)
	if !bytes.Equal(replies[0].Payload, p) || !bytes.Equal(replies[1].Payload, []byte{1, 0, 0, 0, 42, 0, 0, 0}) {
		t.Fatal("incorrect expiry layout")
	}
	s.syncInventory([][]byte{p})
	roomOutputs(t, s)
}

func TestInventoryDeletionIsIncrementalAndIdempotent(t *testing.T) {
	_, s, peer, _ := waitingRoomFixture()
	item := func(id uint32) []byte { p := make([]byte, 68); protocol.WriteUint32(p, 0, id); p[4] = 25; return p }
	keep, removeA, removeB, added := item(7), item(3), item(9), item(12)
	s.rememberInventory([][]byte{keep, removeB, removeA})
	peer.rememberInventory([][]byte{removeA})
	protocol.WriteUint16(keep, 23, 2)
	s.syncInventory([][]byte{keep, added})
	messages := roomOutputs(t, s, 2161, 2160, 2162, 2162)
	if !bytes.Equal(messages[0].Payload, keep) || !bytes.Equal(messages[1].Payload, added) {
		t.Fatal("changed new/update record")
	}
	for i, id := range []uint32{3, 9} {
		p := messages[i+2].Payload
		if len(p) != 4 || protocol.ReadUint32(p, 0) != id {
			t.Fatal("delete must be one instance without count prefix")
		}
	}
	s.syncInventory([][]byte{keep, added})
	roomOutputs(t, s)
	roomOutputs(t, peer)
	if len(peer.Inventory) != 1 || peer.Inventory[3] == nil {
		t.Fatal("another player's inventory changed")
	}
	s.syncInventory(nil)
	deleted := roomOutputs(t, s, 2162, 2162)
	if protocol.ReadUint32(deleted[0].Payload, 0) != 7 || protocol.ReadUint32(deleted[1].Payload, 0) != 12 || len(s.Inventory) != 0 {
		t.Fatal("delete last items")
	}
	s.syncInventory(nil)
	roomOutputs(t, s)
}
