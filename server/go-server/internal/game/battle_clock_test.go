package game

import (
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestBattleClockStartsAfterAllPlayersReadyOnce(t *testing.T) {
	hub, owner, peer, outsider := combatFixture()
	room := owner.Room
	room.Stage = "wait_ready"
	for _, player := range []*Session{owner, peer} {
		player.game().Phase = "wait_ready"
	}
	ready := func(player *Session) {
		payload := make([]byte, 14)
		protocol.WriteUint16(payload, 0, room.ID)
		protocol.WriteUint64(payload, 2, player.UID)
		roomRequest(t, hub, player, 8040, payload)
	}
	ready(owner)
	ready(owner)
	if len(owner.Output) != 0 || len(peer.Output) != 0 || room.Stage != "wait_ready" {
		t.Fatal("clock started before all players were ready")
	}
	ready(peer)
	for _, player := range []*Session{owner, peer} {
		packets := roomOutputs(t, player, 8070, 8090)
		if len(packets[0].Payload) != 12 || len(packets[1].Payload) != 4 || protocol.ReadUint32(packets[1].Payload, 0) != 1 {
			t.Fatal("missing battle context or native clock enable flag")
		}
	}
	ready(owner)
	ready(peer)
	if room.Stage != "battle" || len(owner.Output) != 0 || len(peer.Output) != 0 || len(outsider.Output) != 0 {
		t.Fatal("duplicate start or notification outside the room")
	}
}
