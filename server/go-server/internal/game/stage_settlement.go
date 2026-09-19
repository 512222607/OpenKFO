package game

import (
	"bytes"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

// A native report is not proof of clearance. Match its identities/context to
// this room and require the server's complete wave progression for reason 1.
func validateStageFinish(r *Room, payload []byte) (string, error) {
	if r == nil || r.Type() != protocol.StageAssault || r.StageWaves == nil {
		return "", nil
	}
	_, reason, err := protocol.ParseStageFinishReport(payload)
	if err != nil {
		return "", err
	}
	health, err := validateBattleReport(r, payload)
	if err != nil {
		return "", err
	}
	w := r.StageWaves
	switch reason {
	case protocol.StageFinishWaves:
		if !w.finished || w.index != len(w.plans) || len(w.plans) == 0 {
			return "", nil
		}
		for _, actor := range r.PVEActors {
			if actor.active {
				return "", nil
			}
		}
		return persistence.StageOutcomeClear, nil
	case protocol.StageFinishActorFlags:
		// The native flag itself has unresolved semantics. Only the subset
		// where the controller also reports every player dead is actionable.
		if w.finished {
			return "", nil
		}
		for _, hp := range health {
			if hp != 0 {
				return "", nil
			}
		}
		return persistence.StageOutcomeFailed, nil
	default:
		// Counter-zero reason 3 is not silently relabelled as failure/timeout.
		return "", nil
	}
}

// 93C890 calls 987E40 only for the controller. Do not send 4100 to solicit
// peers: its report producer does not preserve this mode's natural reason.
// This collects a validated finish for the separate PVE payout/result flow.
func (h *Hub) stageFinishReport(s *Session, payload []byte) error {
	r := s.Room
	if r == nil || r.StageWaves == nil || r.Owner != s.UID || (r.Stage != "battle" && r.Stage != "finishing") {
		return nil
	}
	m := r.Members[s.UID]
	if m == nil || m.Session != s {
		return protocol.ErrFrame
	}
	outcome, err := validateStageFinish(r, payload)
	if err != nil {
		return err
	}
	if outcome == "" {
		return nil
	}
	if previous := r.Reports[s.UID]; previous != nil {
		// First accepted report is immutable; retries cannot rewrite outcome.
		return nil
	}
	r.Reports = map[uint64][]byte{s.UID: bytes.Clone(payload)}
	r.Stage = "finishing"
	return nil
}
