package game

import "kungfu.local/server/internal/protocol"

// Native 8A0F00/921430 creates this private introduction room before P2P
// registration. It is not mode 5 practice or the titlemission skill exercises.
func tutorialRequest(p []byte) bool {
	return len(p) == 81 && p[46] == 4 && p[37] == 1 &&
		protocol.ReadUint32(p, 38) == 1201 && protocol.ReadUint32(p, 42) == 1201
}

func tutorialRoom(r *Room) bool { return r != nil && tutorialRequest(r.Request) }

func (h *Hub) acknowledgeTutorialJoin(s *Session, r *Room) error {
	a, err := h.Store.Snapshot(s.UID)
	if err != nil {
		return err
	}
	m := r.Members[s.UID]
	s.sendGame(protocol.Message{ID: 3100, Payload: roomEntryForMember(r, m, fighter(a, m, false))})
	s.sendGame(protocol.Message{ID: 3160, Payload: protocol.Uint64Bytes(r.Owner)})
	r.TutorialPending = false
	return nil
}

// 4124/0 is emitted by the native guide at completion (96A2B0), not 6220.
func (h *Hub) completeTutorial(s *Session, ch *Channel, payload []byte) error {
	if len(payload) != 0 {
		return protocol.ErrFrame
	}
	r := s.Room
	if !tutorialRoom(r) || r.Stage != "battle" || ch.Phase != "battle" ||
		r.Owner != s.UID || len(r.Members) != 1 || r.Members[s.UID] == nil ||
		r.Members[s.UID].Session != s || !r.Members[s.UID].Input {
		return nil
	}
	level, err := h.Store.CompleteTutorial(s.UID)
	if err != nil {
		return err
	}
	// 829B50 updates the live title; 957670 copies 64 bytes and hides slots
	// without catalogue entries. This notification grants no selectable items.
	if level == 2 {
		p := make([]byte, 64)
		p[0] = level
		s.sendGame(protocol.Message{ID: 4125, Payload: p})
	}
	h.leave(s, true)
	return nil
}
