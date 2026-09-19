package protocol

const (
	MsgRoomAnimationRequest = 3410 // Lua name only; request layout is unconfirmed.
	MsgRoomAnimation        = 3420
	MsgBattlePoseRequest    = 3430 // Lua name only; do not infer the request from the reply.
	MsgBattlePose           = 3440
)

// Native 81F6C0 requires 9B, looks up the full UID via 818C70, then calls
// 9E3FF0. That setter accepts only 0..3 and writes actor+1B88.
type BattlePose struct {
	UID  uint64
	Pose byte
}

func ParseBattlePose(p []byte) (BattlePose, error) {
	if len(p) != 9 || p[8] > 3 {
		return BattlePose{}, ErrFrame
	}
	return BattlePose{ReadUint64(p, 0), p[8]}, nil
}

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
