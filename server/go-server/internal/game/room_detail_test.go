package game

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestPasswordRoomDetailIsReadOnlyAndLobbyScoped(t *testing.T) {
	h, owner, peer, visitor := waitingRoomFixture()
	r := owner.Room
	for _, tc := range []struct {
		name, stage string
		lobby       uint32
		id          byte
		available   bool
	}{
		{"waiting", "room", 0, byte(r.ID), true},
		{"loading", "loading", 0, byte(r.ID), false},
		{"battle", "battle", 0, byte(r.ID), false},
		{"foreign lobby", "room", 2, byte(r.ID), false},
		{"missing", "room", 0, 250, false},
		{"zero", "room", 0, 0, false},
	} {
		t.Run(tc.name, func(t *testing.T) {
			r.Stage, r.LobbyID = tc.stage, tc.lobby
			roomRequest(t, h, visitor, protocol.MsgRoomDetailRequest, []byte{tc.id})
			p := roomOutputs(t, visitor, protocol.MsgRoomDetail)[0].Payload
			if !bytes.Equal(p, protocol.EncodeRoomDetail(tc.id, tc.available)) {
				t.Fatal("wrong detail response", p)
			}
			if visitor.Room != nil || len(r.Members) != 2 || peer.Room != r || owner.Room != r {
				t.Fatal("query changed membership")
			}
		})
	}
	for _, p := range [][]byte{nil, {1, 0}} {
		if handled, err := h.roomMessage(visitor, visitor.game(), protocol.Message{ID: protocol.MsgRoomDetailRequest, Payload: p}); !handled || err == nil {
			t.Fatal("invalid query accepted")
		}
	}
	roomRequest(t, h, owner, protocol.MsgRoomDetailRequest, []byte{byte(r.ID)})
	roomOutputs(t, owner) // An in-room request must not reopen the lobby dialog.
}
