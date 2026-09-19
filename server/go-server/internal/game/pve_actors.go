package game

import "kungfu.local/server/internal/protocol"

// Native 93B0C8 seeds 100 identities and 93C1C0 returns removed identities
// to the pool. Keep tombstones for this battle so old events cannot resurrect
// an actor, while newer creates can reuse an identity.
const stageAssaultActorPoolSize = 100

type pveActor struct {
	sequence uint32
	active   bool
}

func (r *Room) hasPVEActor(uid uint64) bool {
	return r.Type() == protocol.StageAssault && r.PVEActors[uid].active
}

func (r *Room) controlsBattleActor(s *Session, uid uint64) bool {
	return uid == s.UID || (s.UID == r.Owner && r.hasPVEActor(uid))
}

func (r *Room) stalePVEEvent(s *Session, uid uint64, sequence uint32) bool {
	a, known := r.PVEActors[uid]
	return r.Type() == protocol.StageAssault && known &&
		(!a.active || (s.UID == r.Owner && int32(sequence-a.sequence) <= 0))
}

// Called after battleMessage validates the authenticated room membership and
// phase. Owner-only control is server policy, not a claim about native trust.
// This does not enable PVE room admission or turn removals into rewards.
func (h *Hub) pveActorMessage(s *Session, message protocol.Message) error {
	r, p := s.Room, message.Payload
	if r.Type() != protocol.StageAssault || r.Owner != s.UID {
		return nil
	}
	var sender, actor uint64
	var template uint32
	create := protocol.ReadUint32(p, 0) == protocol.BattleEventPVEActorCreate
	if create {
		event, err := protocol.ParsePVEActorCreate(p)
		if err != nil {
			return err
		}
		sender, actor = event.Sender, event.Actor
		template = event.TemplateValue
	} else {
		event, err := protocol.ParsePVEActorRemove(p)
		if err != nil {
			return err
		}
		sender, actor = event.Sender, event.Actor
	}
	if sender != s.UID || r.Members[actor] != nil {
		return protocol.ErrFrame
	}
	sequence := protocol.ReadUint32(p, 19)
	previous, seen := r.PVEActors[actor]
	// 7D1730 writes +19 using 7D0E20's incrementing event counter.
	if seen && int32(sequence-previous.sequence) <= 0 {
		return nil
	}
	if create {
		// A live identity cannot change template/location via another create.
		if seen && previous.active {
			return nil
		}
		if !seen && len(r.PVEActors) >= stageAssaultActorPoolSize {
			return protocol.ErrFrame
		}
		if r.StageWaves != nil && !r.StageWaves.canSpawn(template) {
			return nil
		}
	} else if !seen || !previous.active {
		return nil
	}
	if r.PVEActors == nil {
		r.PVEActors = make(map[uint64]pveActor)
	}
	r.PVEActors[actor] = pveActor{sequence: sequence, active: create}
	if create && r.StageWaves != nil {
		r.StageWaves.spawned[template]++
	}
	for _, member := range r.Members {
		for key := range member.BattleEvents {
			if key.Actor == actor {
				delete(member.BattleEvents, key)
			}
		}
	}
	delete(r.Reliable, reliableActor{actor, 9000})
	delete(r.Reliable, reliableActor{actor, 9500})
	h.broadcast(r, message, s.UID)
	return nil
}
