package game

import (
	"testing"

	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
)

func TestSoloPracticeNPCDoesNotTerminateSession(t *testing.T) {
	session := &Session{UID: 1003, GameChannel: 1, Channels: map[uint32]*Channel{1: {ID: 1, Kind: "game", Phase: "battle"}}, Output: make(chan tunnel.Frame, 8), Done: make(chan struct{})}
	request := make([]byte, 81)
	request[46] = 5
	room := &Room{ID: 1, Serial: 7, Stage: "battle", Request: request, Members: map[uint64]*Member{1003: {Session: session}}}
	session.Room = room
	hub := NewHub(nil, Config{})
	hub.SecurityLogDirectory = t.TempDir()
	hub.Sessions[1003] = session
	hub.Rooms[1] = room
	attack := make([]byte, 103)
	protocol.WriteUint32(attack, 0, 0x1fcc)
	protocol.WriteUint64(attack, 4, 1003)
	protocol.WriteUint64(attack, 39, 0xffff)
	protocol.WriteUint32(attack, 95, 1)
	protocol.WriteUint32(attack, 99, 7)
	encoded, _ := protocol.Encode(protocol.Message{ID: 8071, Payload: attack})
	frame := tunnel.Frame{Op: "data", Channel: 1, Data: encoded}
	if err := hub.Handle(session, frame); err != nil {
		t.Fatal("practice NPC event terminated session", err)
	}
	if len(session.Output) != 0 {
		t.Fatal("NPC event forwarded")
	}
	room.Request[46] = 0
	if err := hub.battleMessage(session, session.game(), protocol.Message{ID: protocol.MsgBattleEvent, Payload: attack}); err == nil {
		t.Fatal("competitive actor spoof admitted")
	}
	if err := hub.Handle(session, frame); err != nil || len(session.Output) != 0 {
		t.Fatal("rejected competitive event must be dropped without disconnect", err)
	}
}
