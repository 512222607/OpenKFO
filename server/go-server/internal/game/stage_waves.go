package game

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
)

// Counts must come from the matching map's script/template catalogue. No
// default wave count is inferred from another map (such as zombie defence).
type StageWavePlan struct {
	Monsters map[uint32]uint32 `json:"monsters"`
}

type stageWaves struct {
	plans    []StageWavePlan
	index    int
	spawned  map[uint32]uint32
	finished bool
}

func newStageWaves(plans []StageWavePlan) (*stageWaves, error) {
	if len(plans) == 0 {
		return nil, fmt.Errorf("PVE map has no verified wave plan")
	}
	w := &stageWaves{spawned: map[uint32]uint32{}}
	for _, plan := range plans {
		if len(plan.Monsters) == 0 {
			return nil, fmt.Errorf("PVE wave has no monsters")
		}
		copyPlan := StageWavePlan{Monsters: map[uint32]uint32{}}
		for template, count := range plan.Monsters {
			if count == 0 {
				return nil, fmt.Errorf("PVE monster count must be positive")
			}
			copyPlan.Monsters[template] = count
		}
		w.plans = append(w.plans, copyPlan)
	}
	return w, nil
}

func (w *stageWaves) canSpawn(template uint32) bool {
	return !w.finished && w.spawned[template] < w.plans[w.index].Monsters[template]
}

func (h *Hub) stageWaveReport(s *Session, ch *Channel, payload []byte) error {
	r := s.Room
	if r == nil || r.Type() != protocol.StageAssault || r.Stage != "battle" || ch.Phase != "battle" || r.Owner != s.UID {
		return nil
	}
	member := r.Members[s.UID]
	if member == nil || member.Session != s {
		return protocol.ErrFrame
	}
	report, err := protocol.ParseStageWaveReport(payload)
	if err != nil {
		return err
	}
	w := r.StageWaves
	if w == nil || w.finished || report.Wave != int32(w.index+1) || report.ReportValue != 1 ||
		report.ContextValue != uint64(r.ID)|(uint64(r.Serial)<<32) {
		return nil
	}
	for _, actor := range r.PVEActors {
		if actor.active {
			return nil
		}
	}
	for template, count := range w.plans[w.index].Monsters {
		if w.spawned[template] != count {
			return nil
		}
	}
	// First wave starts locally (93B6B0). Only the next wave is announced;
	// repeated old reports must not resend a command that respawns monsters.
	w.index++
	next := uint32(w.index + 1)
	if w.index == len(w.plans) {
		w.finished = true
		next = ^uint32(0) // Native 82A820's -1 end-scene branch; not a reward receipt.
	}
	w.spawned = map[uint32]uint32{}
	p := make([]byte, 40)
	protocol.WriteUint32(p, 8, next)
	h.broadcast(r, protocol.Message{ID: protocol.MsgStageWaveControl, Payload: p}, 0)
	return nil
}
