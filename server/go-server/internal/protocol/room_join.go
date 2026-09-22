package protocol

// Native 9253B0 and 824B80 send 3070/14 for both playing and watching.
// The separate WATCH_GAME enum does not describe this lobby entry path.
type RoomJoinMode byte

const (
	JoinAsPlayer    RoomJoinMode = 0
	JoinAsSpectator RoomJoinMode = 1
)

type RoomJoinRequest struct {
	RoomID   uint16
	Mode     RoomJoinMode
	Password [11]byte
}

func ParseRoomJoinRequest(p []byte) (r RoomJoinRequest, err error) {
	if len(p) != 14 {
		return r, ErrFrame
	}
	r.RoomID, r.Mode = ReadUint16(p, 0), RoomJoinMode(p[2])
	copy(r.Password[:], p[3:14])
	return r, nil
}

// Native waiting-room identity toggle, distinct from the unused WATCH_GAME enum.
const MsgToggleSpectator uint32 = 3091
const MsgSpectatorChanged uint32 = 3092
