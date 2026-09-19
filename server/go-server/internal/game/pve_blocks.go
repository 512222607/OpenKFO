package game

import "kungfu.local/server/internal/protocol"

// Keep removal tombstones to reject stale creates. The bound is server policy,
// not a recovered native limit. State is scoped to one battle, like PVEActors.
const maxPVEBlocks = 1024

type pveBlock struct {
	sequence uint32
	payload  []byte
}

func (h *Hub) pveBlockMessage(s *Session, message protocol.Message) error {
	r, p := s.Room, message.Payload
	if (r.Type() != protocol.FosterMode && r.Type() != protocol.StageAssault) || r.Owner != s.UID {
		return nil
	}
	var sender uint64
	var id uint32
	create := protocol.ReadUint32(p, 0) == protocol.BattleEventPVEBlockCreate
	if create {
		event, err := protocol.ParsePVEBlockCreate(p)
		if err != nil {
			return err
		}
		sender, id = event.Sender, event.ID
	} else {
		event, err := protocol.ParsePVEBlockRemove(p)
		if err != nil {
			return err
		}
		sender, id = event.Sender, event.ID
	}
	if sender != s.UID {
		return protocol.ErrFrame
	}
	sequence := protocol.ReadUint32(p, 19)
	previous, seen := r.PVEBlocks[id]
	if seen && int32(sequence-previous.sequence) <= 0 {
		return nil
	}
	if !seen && len(r.PVEBlocks) >= maxPVEBlocks {
		return protocol.ErrFrame
	}
	if r.PVEBlocks == nil {
		r.PVEBlocks = make(map[uint32]pveBlock)
	}
	next := pveBlock{sequence: sequence}
	if create {
		next.payload = append([]byte(nil), p...)
	}
	r.PVEBlocks[id] = next
	h.broadcast(r, message, s.UID)
	return nil
}
