package protocol

const (
	MsgChangeRoomOwner       uint32 = 4051
	MsgChangeRoomOwnerResult uint32 = 4052
)

// Native 805D70 widens a room WORD to DWORD, followed by the selected UID.
type RoomOwnerRequest struct {
	RoomID    uint32
	TargetUID uint64
}

func ParseRoomOwnerRequest(p []byte) (r RoomOwnerRequest, err error) {
	if len(p) != 12 {
		return r, ErrFrame
	}
	r.RoomID = ReadUint32(p, 0)
	r.TargetUID = ReadUint64(p, 4)
	if r.RoomID == 0 || r.RoomID > 65535 || r.TargetUID == 0 {
		return RoomOwnerRequest{}, ErrFrame
	}
	return r, nil
}
