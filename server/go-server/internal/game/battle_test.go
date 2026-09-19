package game

import (
	"bytes"
	"math"
	"testing"

	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
)

func combatFixture() (*Hub, *Session, *Session, *Session) {
	hub := NewHub(nil, Config{})
	room := &Room{ID: 1, Serial: 7, Stage: "battle", Request: make([]byte, 81), Members: map[uint64]*Member{}}
	hub.Rooms[1] = room
	players := make([]*Session, 3)
	for index := range players {
		player := &Session{UID: uint64(1003 + index), Nickname: []string{"甲", "乙", "丙"}[index], GameChannel: 1, Channels: map[uint32]*Channel{1: {ID: 1, Kind: "game", Phase: "battle"}}, Output: make(chan tunnel.Frame, 64), Done: make(chan struct{})}
		hub.Sessions[player.UID] = player
		players[index] = player
		if index < 2 {
			player.Room = room
			room.Members[player.UID] = &Member{Session: player, Slot: byte(index)}
		}
	}
	room.Owner = players[0].UID
	return hub, players[0], players[1], players[2]
}

func combatPacket(id uint32, size int, sender, actor uint64, context int) protocol.Message {
	payload := make([]byte, size)
	protocol.WriteUint32(payload, 0, id)
	protocol.WriteUint64(payload, 4, sender)
	protocol.WriteUint32(payload, 19, 1)
	protocol.WriteUint64(payload, 39, actor)
	if context != 0 {
		protocol.WriteUint32(payload, context, 1)
		protocol.WriteUint32(payload, context+4, 7)
	}
	return protocol.Message{ID: 8071, Payload: payload}
}

func TestDamageRelayBothDirectionsAndReplay(t *testing.T) {
	for _, victimReports := range []bool{false, true} {
		hub, attacker, victim, outsider := combatFixture()
		sender, receiver := attacker, victim
		if victimReports {
			sender, receiver = victim, attacker
		}
		movement := combatPacket(8120, 108, sender.UID, sender.UID, 0)
		if err := hub.battleMessage(sender, sender.game(), movement); err != nil {
			t.Fatal(err)
		}
		<-receiver.Output
		damage := combatPacket(8121, 94, sender.UID, victim.UID, 86)
		protocol.WriteUint64(damage.Payload, 47, attacker.UID)
		protocol.WriteUint32(damage.Payload, 67, math.Float32bits(300))
		if err := hub.battleMessage(sender, sender.game(), damage); err != nil {
			t.Fatal(err)
		}
		if len(receiver.Output) != 1 || len(sender.Output) != 0 || len(outsider.Output) != 0 {
			t.Fatal("damage recipients incorrect")
		}
		encoded, _ := protocol.Encode(damage)
		if !bytes.Equal((<-receiver.Output).Data, encoded) {
			t.Fatal("damage payload changed")
		}
		if err := hub.battleMessage(sender, sender.game(), damage); err != nil || len(receiver.Output) != 0 {
			t.Fatal("duplicate damage replayed", err)
		}
	}
}

func TestDamageRejectsSpoofStaleContextAndInvalidFloat(t *testing.T) {
	for _, mutate := range []func([]byte){
		func(p []byte) { protocol.WriteUint64(p, 4, 1004) },
		func(p []byte) { protocol.WriteUint64(p, 39, 1005) },
		func(p []byte) { protocol.WriteUint64(p, 47, 1005) },
		func(p []byte) { protocol.WriteUint32(p, 90, 6) },
		func(p []byte) { protocol.WriteUint32(p, 67, math.Float32bits(float32(math.NaN()))) },
	} {
		hub, attacker, victim, _ := combatFixture()
		message := combatPacket(8121, 94, attacker.UID, victim.UID, 86)
		protocol.WriteUint64(message.Payload, 47, attacker.UID)
		mutate(message.Payload)
		if err := hub.battleMessage(attacker, attacker.game(), message); err == nil {
			t.Fatal("invalid damage accepted")
		}
		if len(victim.Output) != 0 {
			t.Fatal("invalid damage forwarded")
		}
	}
}

func TestNativeStateBuffAndHealingRelay(t *testing.T) {
	for _, layout := range [][3]int{{8122, 51, 0}, {8440, 71, 0}, {8441, 47, 0}, {8450, 59, 51}, {8451, 47, 0}, {8121, 94, 86}} {
		hub, sender, peer, _ := combatFixture()
		message := combatPacket(uint32(layout[0]), layout[1], sender.UID, sender.UID, layout[2])
		if layout[0] == 8121 {
			protocol.WriteUint32(message.Payload, 67, math.Float32bits(-30))
		}
		if err := hub.battleMessage(sender, sender.game(), message); err != nil {
			t.Fatalf("id=%d: %v", layout[0], err)
		}
		if len(peer.Output) != 1 || len(sender.Output) != 0 {
			t.Fatalf("id=%d not relayed", layout[0])
		}
	}
}

func TestBuffCanTargetOpponentWithoutImpersonatingThem(t *testing.T) {
	for _, id := range []uint32{8126, 8150} {
		hub, sender, peer, outsider := combatFixture()
		size, context, targetOffset := 87, 79, 39
		if id == 8126 {
			size, context, targetOffset = 71, 0, 55
		}
		message := combatPacket(id, size, sender.UID, peer.UID, context)
		protocol.WriteUint64(message.Payload, targetOffset, peer.UID)
		protocol.WriteUint64(message.Payload, 47, sender.UID)
		if err := hub.battleMessage(sender, sender.game(), message); err != nil {
			t.Fatal(id, err)
		}
		if len(peer.Output) != 1 || len(sender.Output) != 0 {
			t.Fatal("opponent effect missing", id)
		}
		<-peer.Output
		protocol.WriteUint64(message.Payload, 47, outsider.UID)
		if err := hub.battleMessage(sender, sender.game(), message); err == nil {
			t.Fatal("unrelated effect admitted", id)
		}
	}
}

func TestMultiplayerPracticeNPCDoesNotKickOrBypassEnvelope(t *testing.T) {
	hub, sender, peer, _ := combatFixture()
	sender.Room.Request[46] = 5
	message := combatPacket(8150, 87, sender.UID, 100, 79)
	if err := hub.battleMessage(sender, sender.game(), message); err != nil {
		t.Fatal(err)
	}
	if len(peer.Output) != 0 || peer.Room == nil {
		t.Fatal("NPC event affected peer")
	}
	protocol.WriteUint64(message.Payload, 4, peer.UID)
	if err := hub.battleMessage(sender, sender.game(), message); err == nil {
		t.Fatal("practice bypassed sender authentication")
	}
}

func TestExitCleansLoadingAndBattleAndTransfersWaitingOwner(t *testing.T) {
	for _, stage := range []string{"room", "loading", "wait_ready", "battle"} {
		hub, owner, peer, _ := combatFixture()
		hub.Store = recoveryStore(t)
		room := owner.Room
		room.Stage = stage
		peer.game().Phase = stage
		room.Members[peer.UID].Ready = true
		peer.ConsumeIntents = map[uint32]bool{1: true}
		hub.Detach(owner)
		if stage == "room" {
			if peer.Room != room || room.Owner != peer.UID || room.Members[peer.UID].Ready {
				t.Fatal("waiting room owner transfer failed")
			}
		} else if peer.Room != room || peer.game().Phase != "room" || len(hub.Rooms) != 1 || len(room.Members) != 1 || peer.ConsumeIntents != nil || room.Owner != peer.UID {
			t.Fatal("stale battle after exit", stage)
		}
		if hub.Sessions[peer.UID] != peer {
			t.Fatal("peer login was terminated")
		}
	}
}
