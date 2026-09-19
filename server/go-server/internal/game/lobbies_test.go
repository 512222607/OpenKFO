package game

import (
	"testing"
	"time"

	"kungfu.local/server/internal/protocol"
)

func TestLobbyAdmissionBeforeConsumingHandoff(t *testing.T) {
	hub, _, _, s := waitingRoomFixture()
	hub.Config.LobbyIDs = []uint32{1, 2}
	s.GameChannel = 0
	s.HandoffUntil = time.Now().Add(time.Minute)
	ch := s.Channels[1]
	ch.Phase = "connected"
	p := make([]byte, 96)
	protocol.WriteUint64(p, 0, s.UID)
	protocol.WriteUint32(p, 49, 594)
	for _, invalid := range []uint32{0, 3, ^uint32(0)} {
		protocol.WriteUint32(p, 8, invalid)
		if hub.route(s, ch, protocol.Message{ID: 2010, Payload: p}) == nil {
			t.Fatal("unlisted lobby admitted")
		}
		if s.GameChannel != 0 || ch.Phase != "connected" || s.HandoffUntil.IsZero() {
			t.Fatal("failed admission mutated handoff")
		}
		roomOutputs(t, s)
	}
	protocol.WriteUint32(p, 8, 2)
	if err := hub.route(s, ch, protocol.Message{ID: 2010, Payload: p}); err != nil {
		t.Fatal(err)
	}
	reply := roomOutputs(t, s, 2030)[0]
	if s.LobbyID != 2 || protocol.ReadUint32(reply.Payload, 0) != 2 || protocol.ReadUint32(reply.Payload, 26) != 2 {
		t.Fatal("selected lobby not installed")
	}
	if err := hub.route(s, ch, protocol.Message{ID: 2060}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 2070)
	if s.LobbyID != 0 {
		t.Fatal("leave retained lobby membership")
	}
}

func TestLobbyRoomAndPlayerIsolation(t *testing.T) {
	hub, host, peer, visitor := waitingRoomFixture()
	room := host.Room
	room.LobbyID, host.LobbyID, peer.LobbyID, visitor.LobbyID = 1, 1, 1, 2
	roomRequest(t, hub, visitor, 2260, []byte{1, 0, 0x88})
	if p := roomOutputs(t, visitor, 2280)[0].Payload; len(p) != 8 || protocol.ReadUint32(p, 4) != 0 {
		t.Fatal("foreign room listed")
	}
	join := make([]byte, 14)
	protocol.WriteUint16(join, 0, room.ID)
	roomRequest(t, hub, visitor, 3070, join)
	if protocol.ReadUint32(roomOutputs(t, visitor, 3080)[0].Payload, 14) != 29 {
		t.Fatal("foreign room existence leaked")
	}
	if hub.install(room, visitor) == nil {
		t.Fatal("internal join bypassed lobby isolation")
	}
	roomRequest(t, hub, visitor, 3075, []byte{0})
	roomOutputs(t, visitor, notice("").ID)
	if visitor.Room != nil || len(room.Members) != 2 {
		t.Fatal("quick join crossed lobby")
	}
	page := append(protocol.Uint32Bytes(1), protocol.Uint32Bytes(10)...)
	ids, _, err := hub.playerPage(2, page)
	if err != nil || len(ids) != 1 || ids[0] != visitor.UID {
		t.Fatal("player directory crossed lobby", ids, err)
	}
	visitor.LobbyID = 1
	roomRequest(t, hub, visitor, 2260, []byte{1, 0, 0x88})
	if p := roomOutputs(t, visitor, 2280)[0].Payload; len(p) != 267 || protocol.ReadUint32(p, 4) != 1 {
		t.Fatal("own lobby room missing")
	}
	visitor.LobbyID = 2
	visitor.Bound = true
	visitor.P2PUntil = time.Now().Add(time.Minute)
	hub.Store = recoveryStore(t)
	roomRequest(t, hub, visitor, 3010, room.Request)
	roomOutputs(t, visitor, 3100, 3160)
	if visitor.Room == nil || visitor.Room.LobbyID != 2 || visitor.Room == room {
		t.Fatal("new room lost creator lobby")
	}
}

func TestLobbyChatIsolation(t *testing.T) {
	hub, a, b, c := combatFixture()
	for _, s := range []*Session{a, b, c} {
		s.Room = nil
		s.game().Phase = "lobby"
		s.LobbyID = 1
	}
	c.LobbyID = 2
	p := make([]byte, 215)
	p[12] = 3
	copy(p[13:], "hi")
	if err := hub.chat(a, protocol.Message{ID: 5002, Payload: p}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, a, 5003)
	roomOutputs(t, b, 5003)
	roomOutputs(t, c)
}
