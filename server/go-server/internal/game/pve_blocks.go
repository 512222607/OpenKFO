package game

import (
	"kungfu.local/server/internal/protocol"
	"sort"
)

// Keep removal tombstones to reject stale creates. The bound is server policy,
// not a recovered native limit. State is scoped to one battle, like PVEActors.
const maxPVEBlocks = 1024

type pveBlock struct {
	sequence uint32
	payload  []byte
}

func (h *Hub) pveBlockMessage(s *Session, ch *Channel, message protocol.Message) error {
	r, p := s.Room, message.Payload
	if r == nil || (r.Type() != protocol.FosterMode && r.Type() != protocol.StageAssault) || r.Owner != s.UID {
		return nil
	}
	loading := r.Stage == "loading" && ch.Phase == "loading"
	if !loading && (r.Stage != "battle" || ch.Phase != "battle") {
		return nil
	}
	member := r.Members[s.UID]
	if member == nil || member.Session != s {
		return protocol.ErrFrame
	}
	if loading && member.Loaded {
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
	if !loading {
		h.broadcast(r, message, s.UID)
	}
	return nil
}

// Lua EVENT_GROUP constructors create walls in main(), before 4160. Peers
// cannot consume them until their mode objects exist. Replay only the final
// active walls after the loading barrier; the owner already applied locally.
func (h *Hub) sendInitialPVEBlocks(r *Room) {
	ids := make([]uint32, 0, len(r.PVEBlocks))
	for id, block := range r.PVEBlocks {
		if block.payload != nil {
			ids = append(ids, id)
		}
	}
	sort.Slice(ids, func(i, j int) bool { return ids[i] < ids[j] })
	for _, id := range ids {
		h.broadcast(r, protocol.Message{ID: protocol.MsgBattleEvent, Payload: r.PVEBlocks[id].payload}, r.Owner)
	}
}
