package game

import "kungfu.local/server/internal/persistence"

// 910621 writes the selected lobby ID into 2010+8. Older local test
// clients sent zero; allow that alias only for the default single lobby.
func (hub *Hub) admitLobby(id uint32) (uint32, error) {
	if len(hub.Config.LobbyIDs) == 0 {
		if id == 0 || id == 1 {
			return 1, nil
		}
		return 0, persistence.ErrDenied
	}
	if id != 0 {
		for _, allowed := range hub.Config.LobbyIDs {
			if allowed == id {
				return id, nil
			}
		}
	}
	return 0, persistence.ErrDenied
}
