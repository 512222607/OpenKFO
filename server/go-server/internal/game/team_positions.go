package game

// The native team-room layout uses Spawn 0..3 on one side and 4..7 on
// the other (0x816940 indexes the room coordinate table at Spawn+8).
const teamSideSize byte = 4

func (r *Room) freeTeamPosition(team byte, except uint64) (byte, bool) {
	for position := team * teamSideSize; position < (team+1)*teamSideSize; position++ {
		occupied := false
		for uid, member := range r.Members {
			if uid != except && member.Spawn == position {
				occupied = true
				break
			}
		}
		if !occupied {
			return position, true
		}
	}
	return 0, false
}
