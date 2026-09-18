package game

import (
	"bytes"
	"testing"
	"time"

	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
)

func TestChineseChatRoomIsolationAndPrivateDelivery(t *testing.T) {
	hub, sender, peer, outsider := combatFixture()
	payload := make([]byte, 215)
	text := persistence.GBK("测试中毒和扣血")
	payload[12] = byte(len(text) + 1)
	copy(payload[13:], text)
	if err := hub.chat(sender, protocol.Message{ID: 5002, Payload: payload}); err != nil {
		t.Fatal(err)
	}
	if len(sender.Output) != 1 || len(peer.Output) != 1 || len(outsider.Output) != 0 {
		t.Fatal("room chat leaked or failed")
	}
	if !bytes.Equal((<-sender.Output).Data, (<-peer.Output).Data) {
		t.Fatal("different chat on each player")
	}
	sender.LastChat = time.Time{}
	private := make([]byte, 256)
	copy(private[29:50], persistence.GBK(outsider.Nickname))
	private[50] = byte(len(text) + 1)
	copy(private[55:], text)
	if err := hub.chat(sender, protocol.Message{ID: 5000, Payload: private}); err != nil {
		t.Fatal(err)
	}
	if len(sender.Output) != 1 || len(outsider.Output) != 1 || len(peer.Output) != 0 {
		t.Fatal("private chat recipient mismatch")
	}
}

func TestMalformedChatDoesNotDisconnectBattle(t *testing.T) {
	hub, sender, peer, _ := combatFixture()
	for _, payload := range [][]byte{nil, make([]byte, 215)} {
		encoded, _ := protocol.Encode(protocol.Message{ID: 5002, Payload: payload})
		if err := hub.Handle(sender, tunnel.Frame{Op: "data", Channel: 1, Data: encoded}); err != nil {
			t.Fatal("chat terminated session", err)
		}
		if sender.Room == nil || sender.game().Phase != "battle" || len(peer.Output) != 0 {
			t.Fatal("bad chat changed battle")
		}
	}
	if len(sender.Output) != 2 {
		t.Fatal("missing user notices")
	}
}
