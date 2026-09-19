package protocol

// Native 985660 sends 8040/14: room WORD, local identity QWORD, then
// the raw DWORD from 17BA718. Its final field is not a readiness permission.
type BattleInputReady struct {
	RoomID      uint16
	UID         uint64
	ClientValue uint32
}

func ParseBattleInputReady(p []byte) (r BattleInputReady, err error) {
	if len(p) != 14 {
		return r, ErrFrame
	}
	r.RoomID, r.UID, r.ClientValue = ReadUint16(p, 0), ReadUint64(p, 2), ReadUint32(p, 10)
	return r, nil
}
