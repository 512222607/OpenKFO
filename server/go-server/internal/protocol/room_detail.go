package protocol

const (
	MsgRoomDetailRequest = 2490
	MsgRoomDetail        = 2500
	RoomDetailSize       = 259
)

// 92571C sends one byte. The password dialog later zero-extends it into
// the WORD room ID of 3070; this request cannot represent IDs above 255.
func ParseRoomDetailRequest(p []byte) (byte, error) {
	if len(p) != 1 {
		return 0, ErrFrame
	}
	return p[0], nil
}

// Native 825250 requires exactly 259 bytes, reads +4 == 1, and retains
// BYTE +0 for the password dialog. Unresolved bytes stay zero.
func EncodeRoomDetail(roomID byte, available bool) []byte {
	p := make([]byte, RoomDetailSize)
	p[0] = roomID
	if available {
		p[4] = 1
	}
	return p
}
