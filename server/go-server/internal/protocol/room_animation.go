package protocol

const (
	MsgRoomAnimationRequest = 3410 // Lua name only; request layout is unconfirmed.
	MsgRoomAnimation        = 3420
)

// Native 81DE60 requires nine bytes, passes DWORD +0 and BYTE +8 to
// its virtual consumer, and does not read DWORD +4. Neither a full UID
// nor an allowlist of animation values has been established by this handler.
type RoomAnimation struct {
	SubjectValue uint32
	UnknownValue uint32
	Animation    byte
}

func ParseRoomAnimation(p []byte) (RoomAnimation, error) {
	if len(p) != 9 {
		return RoomAnimation{}, ErrFrame
	}
	return RoomAnimation{ReadUint32(p, 0), ReadUint32(p, 4), p[8]}, nil
}
