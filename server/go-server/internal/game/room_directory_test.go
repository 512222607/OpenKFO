package game

import (
	"errors"
	"fmt"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"testing"
)

func TestRoomDirectoryPageCounters(t *testing.T) {
	for _, total := range []int{0, 1, 9, 10, 18, 19} {
		for _, page := range []byte{0, 1, 2, 3} {
			t.Run(fmt.Sprintf("rooms_%d_page_%d", total, page), func(t *testing.T) {
				h := NewHub(nil, Config{})
				for i := 1; i <= total+20; i++ {
					r := &Room{ID: uint16(i), LobbyID: 1, Request: make([]byte, 81), Stage: "room", Members: map[uint64]*Member{}}
					if i > total {
						if i%2 == 0 {
							r.LobbyID = 2
						} else {
							r.Request[46] = 5
						}
					}
					h.Rooms[r.ID] = r
				}
				s := &Session{UID: 1004, LobbyID: 1, Output: make(chan tunnel.Frame, 1), Done: make(chan struct{})}
				ch := &Channel{ID: 1, Kind: "game", Phase: "lobby"}
				if _, err := h.roomMessage(s, ch, protocol.Message{ID: 2260, Payload: []byte{page, 1, 0}}); err != nil {
					t.Fatal(err)
				}
				d := protocol.Decoder{}
				messages, err := d.Feed((<-s.Output).Data)
				if err != nil || len(messages) != 1 {
					t.Fatal(messages, err)
				}
				p := messages[0].Payload
				wantPage := int(page)
				if wantPage == 0 {
					wantPage = 1
				}
				wantPages := (total + 8) / 9
				if wantPages == 0 {
					wantPages = 1
				}
				count := total - (wantPage-1)*9
				if count < 0 {
					count = 0
				}
				if count > 9 {
					count = 9
				}
				if protocol.ReadUint32(p, 0) != uint32(wantPage) || protocol.ReadUint32(p, 4) != uint32(wantPages) || len(p) != 8+259*count {
					t.Fatalf("page counters=%d/%d bytes=%d; want=%d/%d rooms=%d", protocol.ReadUint32(p, 0), protocol.ReadUint32(p, 4), len(p), wantPage, wantPages, count)
				}
			})
		}
	}
}

func TestRoomDirectoryRefreshPendingDuringJoin(t *testing.T) {
	hub, host, peer, newcomer := waitingRoomFixture()
	room := host.Room
	member := &Member{Session: newcomer, Slot: 2, Spawn: 2, Team: 1}
	// The native client sends 2260 before receiving 3100, but the server
	// finishes the join before it processes that queued refresh.
	hub.completeRoomJoin(room, member, make([]byte, 149), nil)
	roomOutputs(t, newcomer, 3100, 3160)
	room.Members[peer.UID].Ready = true
	roomRequest(t, hub, newcomer, 2260, []byte{1, 1, 0x88})
	reply := roomOutputs(t, newcomer, 2280)[0]
	if len(reply.Payload) != 8+259 || protocol.ReadUint16(reply.Payload, 8) != room.ID {
		t.Fatal("pending refresh did not return the room directory")
	}
	if newcomer.Room != room || newcomer.game().Phase != "room" || room.Members[newcomer.UID] != member || len(room.Members) != 3 || !room.Members[peer.UID].Ready {
		t.Fatal("directory refresh changed room membership or readiness")
	}
	for _, phase := range []string{"lobby", "room", "connected"} {
		for _, payload := range [][]byte{nil, {1, 1}, {1, 1, 0x88}, {1, 1, 0x88, 0}} {
			if phase != "connected" && len(payload) == 3 {
				continue
			}
			newcomer.game().Phase = phase
			handled, err := hub.roomMessage(newcomer, newcomer.game(), protocol.Message{ID: 2260, Payload: payload})
			if !handled || !errors.Is(err, protocol.ErrFrame) {
				t.Fatalf("phase=%s length=%d: invalid request accepted: %v", phase, len(payload), err)
			}
			roomOutputs(t, newcomer)
		}
	}
}

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
