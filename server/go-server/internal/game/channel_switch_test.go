package game

import (
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"testing"
	"time"
)

func TestChannelSwitchPreservesAuthenticationAndRejectsOldTraffic(t *testing.T) {
	hub, s, peer, _ := waitingRoomFixture()
	s.P2P = 1010
	s.TablesReady = true
	old := s.game()
	if err := hub.route(s, old, protocol.Message{ID: 2060}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 2070)
	if s.LoggedOut || hub.Sessions[s.UID] != s || s.P2P != 1010 || !s.TablesReady || s.Room != nil || s.Bound {
		t.Fatal("wrong switch state")
	}
	if peer.Room == nil {
		t.Fatal("other player lost room")
	}
	s.Channels[9] = &Channel{ID: 9, Kind: "game", Phase: "connected"}
	hello := make([]byte, 96)
	protocol.WriteUint64(hello, 0, s.UID)
	protocol.WriteUint32(hello, 49, 594)
	if err := hub.route(s, s.Channels[9], protocol.Message{ID: 2010, Payload: hello}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 2030)
	if err := hub.Handle(s, tunnel.Frame{Op: "data", Channel: old.ID, Data: []byte{1, 2, 3}}); err != nil {
		t.Fatal("old bytes broke switch", err)
	}
	if err := hub.Handle(s, tunnel.Frame{Op: "close", Channel: old.ID}); err != nil {
		t.Fatal(err)
	}
	if s.GameChannel != 9 || hub.Sessions[s.UID] != s {
		t.Fatal("old close removed new channel")
	}
	bind := append(protocol.Uint64Bytes(s.UID), protocol.Uint32Bytes(1010)...)
	if err := hub.route(s, s.game(), protocol.Message{ID: 1156, Payload: bind}); err != nil {
		t.Fatal(err)
	}
	s.Channels[10] = &Channel{ID: 10, Kind: "game", Phase: "connected"}
	if err := hub.route(s, s.Channels[10], protocol.Message{ID: 2010, Payload: hello}); err == nil {
		t.Fatal("reused handoff grant")
	}
	if err := hub.route(s, s.game(), protocol.Message{ID: 2060}); err != nil {
		t.Fatal(err)
	}
	s.HandoffUntil = time.Now().Add(-time.Second)
	if err := hub.route(s, s.Channels[10], protocol.Message{ID: 2010, Payload: hello}); err == nil {
		t.Fatal("expired grant accepted")
	}
}
