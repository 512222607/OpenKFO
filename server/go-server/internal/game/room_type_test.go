package game

import (
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestRoomTypeReflectsRoomEdits(t *testing.T) {
	room := &Room{Request: make([]byte, protocol.RoomRequestSize)}
	room.Request[protocol.RoomTypeOffset] = 1 // Native team-survival mode.
	if room.Type() != protocol.TeamSurvival || !room.Type().IsTeam() {
		t.Fatal("native mode mapping changed")
	}
	room.Request[protocol.RoomTypeOffset] = 5 // Native free-practice mode.
	if room.Type() != protocol.FreePractice || room.Type().IsCompetitive() || room.Type().IsTeam() {
		t.Fatal("room edit left stale mode")
	}
	room.Request = nil
	if room.Type() != protocol.UnknownRoomType || room.Type().IsCompetitive() {
		t.Fatal("missing request must not become a competitive room")
	}
}
