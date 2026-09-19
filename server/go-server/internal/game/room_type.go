package game

import "kungfu.local/server/internal/protocol"

// Type reads the single authoritative wire request, so room edits cannot leave
// a duplicate cached mode stale. All gameplay mode decisions use this accessor.
func (r *Room) Type() protocol.RoomType {
	if r == nil {
		return protocol.UnknownRoomType
	}
	return protocol.RoomTypeFromRequest(r.Request)
}
