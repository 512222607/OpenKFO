package game

import "kungfu.local/server/internal/protocol"

// These packets update native death UI. They never create a death, respawn,
// reward, or modify authoritative inventory. Caller validated battle membership.
func (h *Hub) deathNotice(s *Session, m protocol.Message) error {
	p, r := m.Payload, s.Room
	const packetSize = 55
	if len(p) != packetSize || protocol.ReadUint64(p, 4) != s.UID {
		return rejectBattle("death notice length or sender")
	}
	if p[12] != 1 || p[13] != 1 {
		return nil
	}
	id := protocol.ReadUint32(p, 0)
	target := protocol.ReadUint64(p, 39)
	if id == protocol.BattleEventDeathTerminal {
		target = protocol.ReadUint64(p, 47)
		if protocol.ReadUint64(p, 39) != s.UID || (target != s.UID && s.UID != r.Owner) {
			return rejectBattle("death terminal requires actor or controller")
		}
	} else {
		if s.UID != r.Owner || target == s.UID {
			return rejectBattle("countdown requires remote controller")
		}
		if protocol.ReadUint32(p, 47) != 1 || protocol.ReadUint32(p, 51) > 0x7fffffff {
			return nil
		}
	}
	member := r.Members[target]
	if member == nil || member.Spectator {
		return rejectBattle("death target outside fighters")
	}
	origin := r.Members[s.UID]
	key := battleEventKey{Kind: id, Actor: target}
	sequence := protocol.ReadUint32(p, 19)
	if previous, ok := origin.BattleEvents[key]; ok && int32(sequence-previous.Sequence) <= 0 {
		return nil
	}
	if origin.BattleEvents == nil {
		origin.BattleEvents = map[battleEventKey]battleSequence{}
	}
	origin.BattleEvents[key] = battleSequence{Sequence: sequence, Payload: string(p)}
	if id == protocol.BattleEventDeathCountdown {
		member.Session.sendGame(m)
	} else {
		h.broadcast(r, m, s.UID)
	}
	return nil
}
