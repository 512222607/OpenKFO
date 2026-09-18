package game

import (
	"fmt"
	"log"
	"math"
	"time"

	"kungfu.local/server/internal/protocol"
)

type battleSequence struct {
	Sequence uint32
	Payload  string
}

// Layouts verified against gfld.dat's native dispatch handlers. In particular,
// 8121 carries damage/healing (82A9D0); 8122 carries an integer state 0..7
// consumed by 82A8B0 -> 9F2DC0, not an absolute HP float.
// Do not infer that an unknown packet is safe to broadcast from its size alone.
func (hub *Hub) battleMessage(session *Session, channel *Channel, message protocol.Message) error {
	room, payload := session.Room, message.Payload
	if room == nil || room.Stage != "battle" || channel.Phase != "battle" {
		return nil
	}
	member := room.Members[session.UID]
	if member == nil || member.Session != session || len(payload) < 39 {
		return protocol.ErrFrame
	}
	id := protocol.ReadUint32(payload, 0)
	length, contextOffset := 0, 0
	actorOffset := 39
	var floats []int
	switch id {
	case 8120:
		length, floats = 108, []int{51, 55, 59, 63, 67, 71, 87, 91}
	case 8121:
		length, contextOffset, floats = 94, 86, []int{67, 72, 76, 80}
	case 8122:
		length = 51
	case 8126:
		// 82B8D0 resolves source at 47 and target at 55 before applying
		// the skill's effect list. There is no room trailer in this packet.
		length, actorOffset = 71, 55
	case 8140:
		length, contextOffset, floats = 103, 95, []int{63, 67, 71}
	case 8150:
		length, contextOffset, floats = 87, 79, []int{67}
	case 8440:
		length = 71
	case 8441, 8451:
		length = 47
	case 8450:
		length, contextOffset = 59, 51
	default:
		if time.Since(session.LastBattleNotice) > time.Second {
			log.Printf("battle_unhandled uid=%d room=%d id=%d bytes=%d", session.UID, room.ID, id, len(payload))
			session.LastBattleNotice = time.Now()
		}
		return nil
	}
	if len(payload) != length || protocol.ReadUint64(payload, 4) != session.UID {
		return fmt.Errorf("battle envelope id=%d uid=%d bytes=%d", id, session.UID, len(payload))
	}
	if contextOffset != 0 && (protocol.ReadUint32(payload, contextOffset) != uint32(room.ID) || protocol.ReadUint32(payload, contextOffset+4) != room.Serial) {
		return fmt.Errorf("battle context id=%d uid=%d", id, session.UID)
	}
	for _, offset := range floats {
		value := float64(math.Float32frombits(protocol.ReadUint32(payload, offset)))
		if math.IsNaN(value) || math.IsInf(value, 0) {
			return protocol.ErrFrame
		}
	}
	if id == 8122 && protocol.ReadUint32(payload, 47) > 7 {
		return protocol.ErrFrame
	}
	if id != 8120 {
		actor := protocol.ReadUint64(payload, actorOffset)
		// Practice NPCs are local objects, not authenticated players. Ignore
		// their events without disconnecting an otherwise valid player session.
		if room.Members[actor] == nil && len(room.Request) > 46 && room.Request[46] == 5 {
			return nil
		}
		if room.Members[actor] == nil {
			return fmt.Errorf("battle unknown actor id=%d actor=%d", id, actor)
		}
		if id == 8121 || id == 8126 || id == 8150 {
			attacker := protocol.ReadUint64(payload, 47)
			if attacker != 0 && room.Members[attacker] == nil && len(room.Request) > 46 && room.Request[46] == 5 {
				return nil
			}
			if (attacker != 0 && room.Members[attacker] == nil) || (actor != session.UID && attacker != session.UID) {
				return fmt.Errorf("battle effect ownership id=%d uid=%d target=%d source=%d", id, session.UID, actor, attacker)
			}
		} else if actor != session.UID {
			return fmt.Errorf("battle actor id=%d actor=%d expected=%d", id, actor, session.UID)
		}
	}
	// A movement packet must not suppress a damage/HP packet with the same
	// sequence. Track each native message kind separately, and compare the
	// complete payload so distinct state changes are not mistaken for retries.
	sequence := protocol.ReadUint32(payload, 19)
	if member.BattleEvents == nil {
		member.BattleEvents = make(map[uint32]battleSequence)
	}
	previous, seen := member.BattleEvents[id]
	if seen && ((sequence == previous.Sequence && string(payload) == previous.Payload) || int32(sequence-previous.Sequence) < 0) {
		return nil
	}
	member.BattleEvents[id] = battleSequence{sequence, string(payload)}
	hub.broadcast(room, message, session.UID)
	if id == 8121 || id == 8122 {
		if time.Since(session.LastBattleNotice) > time.Second {
			log.Printf("battle_health_relay uid=%d room=%d id=%d actor=%d recipients=%d", session.UID, room.ID, id, protocol.ReadUint64(payload, 39), len(room.Members)-1)
			session.LastBattleNotice = time.Now()
		}
	}
	return nil
}
