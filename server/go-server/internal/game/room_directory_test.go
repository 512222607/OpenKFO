package game

import (
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"testing"
)

func TestNativeRoomDirectoryPageAndMode(t *testing.T) {
	hub := NewHub(nil, Config{})
	for id := uint16(1); id <= 12; id++ {
		request := make([]byte, 81)
		request[37] = 2
		if id == 12 {
			request[46] = 5
		}
		hub.Rooms[id] = &Room{ID: id, Owner: 1003, Request: request, Stage: "room", Members: map[uint64]*Member{1003: {}}}
	}
	for _, example := range []struct {
		name    string
		request []byte
		count   int
		first   uint16
	}{
		{"native first page all", []byte{1, 0, 0x88}, 9, 1},
		{"native second page all", []byte{2, 0, 0x88}, 3, 10},
		{"normal combat", []byte{1, 0, 0}, 9, 1},
		{"practice", []byte{1, 0, 5}, 1, 12},
		{"refresh option is not page", []byte{1, 1, 0x88}, 9, 1},
		{"empty mode", []byte{1, 0, 3}, 0, 0},
	} {
		t.Run(example.name, func(t *testing.T) {
			channel := &Channel{ID: 1, Kind: "game", Phase: "lobby"}
			session := &Session{UID: 1004, Output: make(chan tunnel.Frame, 1), Done: make(chan struct{})}
			handled, err := hub.roomMessage(session, channel, protocol.Message{ID: 2260, Payload: example.request})
			if !handled || err != nil {
				t.Fatal(handled, err)
			}
			decoder := protocol.Decoder{}
			messages, err := decoder.Feed((<-session.Output).Data)
			if err != nil || len(messages) != 1 {
				t.Fatal(messages, err)
			}
			message := messages[0]
			if message.ID != 2280 || len(message.Payload) != 8+259*example.count {
				t.Fatalf("unexpected room directory: id=%d bytes=%d", message.ID, len(message.Payload))
			}
			if example.count > 0 && protocol.ReadUint16(message.Payload, 8) != example.first {
				t.Fatal("wrong first room")
			}
		})
	}
}
