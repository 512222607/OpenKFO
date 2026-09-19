package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestVIPIdentityFollowsInventory(t *testing.T) {
	_, s, peer, _ := waitingRoomFixture()
	card := make([]byte, 68)
	card[4] = 73
	protocol.WriteUint32(card, 0, 1234)
	protocol.WriteUint32(card, 5, 730003)
	protocol.WriteUint32(card, 13, 60)
	protocol.WriteUint32(card, 19, 1)
	s.syncInventory([][]byte{card})
	msgs := roomOutputs(t, s, 2160, 1038)
	if len(msgs) != 2 {
		t.Fatalf("VIP promotion messages %d", len(msgs))
	}
	v, err := protocol.ParseVIPStatus(msgs[1].Payload)
	if err != nil || v.Kind != 4 || v.ShopPercent != 0 || v.Unknown != ([4]uint32{}) || v.Tail != 0 {
		t.Fatal(v, err)
	}
	if len(roomOutputs(t, peer)) != 0 {
		t.Fatal("private VIP state leaked to peer")
	}
	s.syncInventory([][]byte{card})
	if len(roomOutputs(t, s)) != 0 {
		t.Fatal("unchanged VIP repeated")
	}
	protocol.WriteUint32(card, 19, 2)
	s.syncInventory([][]byte{card})
	msgs = roomOutputs(t, s, 2161, 2121, 1038)
	if len(msgs) != 3 || protocol.ReadUint32(msgs[2].Payload, 0) != 1 {
		t.Fatal("expired VIP not reset", msgs)
	}
	s.syncInventory(nil)
	if len(roomOutputs(t, s, 2162)) != 1 {
		t.Fatal("ordinary membership repeated")
	}
}

func TestVIPShopPacketAndExpiry(t *testing.T) {
	m := vipIdentityPacket(3, 80)
	v, err := protocol.ParseVIPStatus(m.Payload)
	if err != nil || v.Kind != 3 || v.ShopPercent != 80 || v.Unknown != ([4]uint32{}) || v.Tail != 0 {
		t.Fatal(v, err)
	}
	_, s, _, _ := waitingRoomFixture()
	s.VIPKind, s.VIPShopPercent = 3, 80
	s.syncVIPIdentity(nil)
	ms := roomOutputs(t, s, 1038)
	if s.VIPShopPercent != 0 || protocol.ReadUint32(ms[0].Payload, 20) != 0 {
		t.Fatal("expired discount retained")
	}
}
