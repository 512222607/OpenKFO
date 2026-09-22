package game

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"time"
)

type seatExchange struct {
	payload        []byte
	source, target *Member
	expires        time.Time
}

func (h *Hub) cancelSeatExchange(r *Room) {
	if r.Exchange == nil {
		return
	}
	pending := r.Exchange
	r.Exchange = nil
	for _, member := range []*Member{pending.source, pending.target} {
		if member.Session.Room == r && r.Members[member.Session.UID] == member {
			member.Session.sendGame(protocol.Message{ID: 3264})
		}
	}
}

func (h *Hub) exchangeSeat(s *Session, m protocol.Message) error {
	p := m.Payload
	if len(p) != 24 {
		return protocol.ErrFrame
	}
	r := s.Room
	if r == nil || r.Stage != "room" || s.game() == nil || s.game().Phase != "room" {
		return nil
	}
	reject := func() { s.sendGame(protocol.Message{ID: 3264}) }
	if !r.canConfigure(s) {
		reject()
		return nil
	}
	sourceID, targetID := protocol.ReadUint64(p, 0), protocol.ReadUint64(p, 8)
	source, target := r.Members[sourceID], r.Members[targetID]
	from, to := protocol.ReadUint32(p, 16), protocol.ReadUint32(p, 20)
	positionLimit := uint32(8)
	if len(r.Request) == 81 && !r.Type().IsTeam() {
		positionLimit = uint32(r.Request[37])
	}
	if source == nil || source.Spectator || source.Session.Room != r || sourceID == targetID || len(r.Request) != 81 || from >= 8 || to >= positionLimit || from == to || uint32(source.Spawn) != from || source.Ready {
		reject()
		return nil
	}
	// Native empty-seat movement preserves Team; crossing sides uses 3230.
	if targetID == 0 && r.Type().IsTeam() && byte(to)/teamSideSize != source.Team {
		reject()
		return nil
	}
	if targetID != 0 && (target == nil || target.Session.Room != r || uint32(target.Spawn) != to || target.Ready) {
		reject()
		return nil
	}
	for uid, member := range r.Members {
		if uint32(member.Spawn) == to && uid != targetID {
			reject()
			return nil
		}
	}
	if r.Exchange != nil && time.Now().After(r.Exchange.expires) {
		r.Exchange = nil
	}
	if m.ID == 3260 {
		if sourceID != s.UID || source.Session != s {
			reject()
			return nil
		}
		if r.Exchange != nil {
			s.sendGame(protocol.Message{ID: 3267})
			return nil
		}
		if target != nil {
			r.Exchange = &seatExchange{bytes.Clone(p), source, target, time.Now().Add(30 * time.Second)}
			target.Session.sendGame(protocol.Message{ID: 3261, Payload: bytes.Clone(p)})
			return nil
		}
	} else {
		pending := r.Exchange
		if pending == nil || targetID != s.UID || target == nil || target.Session != s || pending.source != source || pending.target != target || !bytes.Equal(p, pending.payload) {
			reject()
			return nil
		}
		r.Exchange = nil
		if m.ID == 3263 {
			source.Session.sendGame(protocol.Message{ID: 3264})
			return nil
		}
	}
	// Native 0x45C4C0 / 0x453950 read/write entity+0x1B04 (Spawn).
	// 3265 changes that position and team, never the entity roster Slot.
	if target != nil {
		source.Spawn, target.Spawn = target.Spawn, source.Spawn
		source.Team, target.Team = target.Team, source.Team
	} else {
		source.Spawn = byte(to)
	}
	h.clearRoomReady(r)
	h.broadcast(r, protocol.Message{ID: 3265, Payload: bytes.Clone(p)}, 0)
	return nil
}
