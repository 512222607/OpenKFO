package game

import "kungfu.local/server/internal/persistence"

// Caller holds Hub.Mutex. Fetch current policy once per room action, and use
// authenticated account titles rather than any client-provided role fields.
func (h *Hub) stageGate(players ...*Session) (func(uint32) bool, error) {
	access, err := h.stageAccess()
	if err != nil {
		return nil, err
	}
	if !access.RequirementsEnabled {
		return access.Allows, nil
	}
	if len(players) == 0 || access.ClientHash != h.Config.ConfigHash {
		return nil, persistence.ErrDenied
	}
	minimum := byte(255)
	locked := map[uint32]bool{}
	needsUnlocks := false
	for _, rule := range access.Requirements {
		if rule.NeedsUnlock() {
			needsUnlocks = true
		}
	}
	for _, s := range players {
		if s == nil {
			return nil, persistence.ErrDenied
		}
		title, err := h.Store.AccountTitle(s.UID)
		if err != nil {
			return nil, err
		}
		if title < minimum {
			minimum = title
		}
		if needsUnlocks {
			progress, err := h.Store.StagePlayerUnlocks(s.UID, access.ClientHash)
			if err != nil {
				return nil, err
			}
			grants := map[uint32]bool{}
			for _, id := range progress.Maps {
				grants[id] = true
			}
			for _, rule := range access.Requirements {
				if !access.AllowsPlayer(rule.MapID, title, h.Config.ConfigHash, grants) {
					locked[rule.MapID] = true
				}
			}
		}
	}
	return func(id uint32) bool { return !locked[id] && access.AllowsTitle(id, minimum, h.Config.ConfigHash) }, nil
}

func roomPlayers(room *Room) []*Session {
	players := make([]*Session, 0, len(room.Members))
	for _, m := range room.Members {
		players = append(players, m.Session)
	}
	return players
}

func (h *Hub) resolveForPlayers(request []byte, players ...*Session) ([]byte, error) {
	allows, err := h.stageGate(players...)
	if err != nil {
		return nil, err
	}
	return h.resolveWithAllowed(request, allows)
}
