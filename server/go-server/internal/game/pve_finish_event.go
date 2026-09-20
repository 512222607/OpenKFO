package game

import "kungfu.local/server/internal/protocol"

// Native 941910 emits the Foster script's completion transition; 827EF0
// accepts only the current controller and room context. This synchronizes a
// client mode flag, not a verified victory or permission to grant rewards.
func (h *Hub) pveFinishEvent(s *Session, message protocol.Message) error {
	r := s.Room
	if r.Type() != protocol.FosterMode || r.Owner != s.UID {
		return nil
	}
	event, err := protocol.ParseStageWaveEnd(message.Payload)
	if err != nil {
		return err
	}
	if event.Sender != s.UID {
		return protocol.ErrFrame
	}
	if event.ContextValue != uint64(r.ID)|(uint64(r.Serial)<<32) {
		return nil // Delayed notification from an earlier battle.
	}
	// The controller set its flag before sending; peers need the same event.
	// Replays are safe: the native consumer assigns true, it does not toggle.
	h.broadcast(r, message, s.UID)
	return nil
}
