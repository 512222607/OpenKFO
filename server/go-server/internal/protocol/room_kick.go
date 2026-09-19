package protocol

// RoomKickRequest is the native 8062F0 payload. ClientFlag comes from the
// sender's object+107C via 481080; it is not an operation or permission grant.
type RoomKickRequest struct {
	TargetUID  uint64
	ClientFlag byte
}

func ParseRoomKickRequest(payload []byte) (RoomKickRequest, error) {
	if len(payload) != 9 {
		return RoomKickRequest{}, ErrFrame
	}
	return RoomKickRequest{TargetUID: ReadUint64(payload, 0), ClientFlag: payload[8]}, nil
}
