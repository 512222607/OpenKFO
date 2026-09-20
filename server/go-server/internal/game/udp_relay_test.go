package game

import (
	"bytes"
	"encoding/hex"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"testing"
	"time"
)

func TestSDPRelayIsBoundToAuthenticatedRoom(t *testing.T) {
	hub := NewHub(nil, Config{})
	room := &Room{ID: 1, Stage: "battle", Members: map[uint64]*Member{}}
	players := []*Session{}
	for index := 0; index < 3; index++ {
		player := &Session{UID: uint64(1003 + index), P2P: uint32(2001 + index), UDPPort: uint16(40001 + index), Bound: true, P2PUntil: time.Now().Add(time.Minute), GameChannel: 1, Channels: map[uint32]*Channel{1: {ID: 1, Kind: "game", Phase: "battle"}}, Output: make(chan tunnel.Frame, 8), Done: make(chan struct{})}
		hub.Sessions[player.UID] = player
		if index < 2 {
			room.Members[player.UID] = &Member{Session: player}
			player.Room = room
		}
		players = append(players, player)
	}
	sender, peer, outsider := players[0], players[1], players[2]
	packet := make([]byte, 24+12)
	protocol.WriteUint16(packet, 0, 1)
	protocol.WriteUint16(packet, 2, 1008)
	protocol.WriteUint32(packet, 4, sender.P2P)
	protocol.WriteUint32(packet, 12, sender.P2P)
	packet[22] = 1
	packet[23] = 12
	protocol.WriteUint32(packet, 24, peer.P2P)
	protocol.WriteUint32(packet, 28, peer.P2P)
	protocol.WriteUint32(packet, 32, outsider.P2P)
	body := []byte{0x31, 0, 0xff, 1, 2, 3, 4}
	packet = append(packet, body...)
	frame := tunnel.Frame{Op: "udp", Port: sender.UDPPort, Data: packet}
	if err := hub.Handle(sender, frame); err != nil {
		t.Fatal(err)
	}
	if len(peer.Output) != 1 || len(sender.Output) != 0 || len(outsider.Output) != 0 {
		t.Fatal("relay recipient isolation or deduplication failed")
	}
	received := <-peer.Output
	if received.Port != peer.UDPPort || received.Op != "udp" || protocol.ReadUint16(received.Data, 2) != 1009 || protocol.ReadUint32(received.Data, 4) != peer.P2P || protocol.ReadUint32(received.Data, 12) != sender.P2P || protocol.ReadUint32(received.Data, 16) != peer.P2P || received.Data[23] != 0 || received.Data[22] != 1 || !bytes.Equal(received.Data[24:], body) {
		t.Fatal("native relay envelope mismatch")
	}
	for _, change := range []func(*tunnel.Frame){
		func(f *tunnel.Frame) { protocol.WriteUint32(f.Data, 12, peer.P2P) },
		func(f *tunnel.Frame) { protocol.WriteUint32(f.Data, 4, peer.P2P) },
		func(f *tunnel.Frame) { f.Port++ },
		func(f *tunnel.Frame) { f.Data[23] = 3 },
		func(f *tunnel.Frame) { f.Data[23] = 128 },
	} {
		invalid := frame
		invalid.Data = bytes.Clone(packet)
		change(&invalid)
		if err := hub.Handle(sender, invalid); err == nil {
			t.Fatal("invalid sender/envelope accepted")
		}
		if len(peer.Output) != 0 {
			t.Fatal("invalid packet forwarded")
		}
	}
	sender.P2PUntil = time.Now().Add(-time.Second)
	if err := hub.Handle(sender, frame); err == nil {
		t.Fatal("expired lease admitted")
	}
}

// Captured during an equipment change, immediately before the old server
// disconnected UID 10013. Recipient byte 23 is zero; the body remains present.
func TestEquipmentRefreshEmptyRelayKeepsSession(t *testing.T) {
	packet, err := hex.DecodeString("0100f003f003000000000000f00300000000000000000000eeaaa08828000000b0084f612e31a664323056c5546ae50d627a54c5546ae50d627a54025d6ae50d607a4c617e316664")
	if err != nil {
		t.Fatal(err)
	}
	hub := NewHub(nil, Config{})
	sender := &Session{UID: 10013, P2P: 1008, UDPPort: 18001, Bound: true, P2PUntil: time.Now().Add(time.Minute), Output: make(chan tunnel.Frame, 8), Done: make(chan struct{})}
	hub.Sessions[sender.UID] = sender
	frame := tunnel.Frame{Op: "udp", Port: sender.UDPPort, Data: packet}
	if err := hub.Handle(sender, frame); err != nil {
		t.Fatalf("empty recipient packet disconnects player: %v", err)
	}
	if len(sender.Output) != 0 {
		t.Fatal("no-recipient packet must not generate a reply")
	}
	heartbeat := make([]byte, 28)
	protocol.WriteUint16(heartbeat, 0, 1)
	protocol.WriteUint16(heartbeat, 2, 1013)
	protocol.WriteUint32(heartbeat, 4, sender.P2P)
	protocol.WriteUint32(heartbeat, 12, sender.P2P)
	if err := hub.Handle(sender, tunnel.Frame{Op: "udp", Port: sender.UDPPort, Data: heartbeat}); err != nil {
		t.Fatal(err)
	}
	if len(sender.Output) != 1 {
		t.Fatal("heartbeat did not continue after empty relay")
	}
	<-sender.Output
	for _, mutate := range []func(*tunnel.Frame){
		func(f *tunnel.Frame) { protocol.WriteUint32(f.Data, 12, 999) },
		func(f *tunnel.Frame) { f.Port++ },
		func(f *tunnel.Frame) { f.Data = f.Data[:24] },
	} {
		invalid := frame
		invalid.Data = bytes.Clone(packet)
		mutate(&invalid)
		if err := hub.Handle(sender, invalid); err == nil {
			t.Fatal("invalid empty relay accepted")
		}
	}
	sender.P2PUntil = time.Now().Add(-time.Second)
	if err := hub.Handle(sender, frame); err == nil {
		t.Fatal("expired empty relay accepted")
	}
}
