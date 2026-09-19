package protocol

// BattleStart exposes only fields confirmed by native 81E1A0 and GetNetDelay.
// Raw retains unresolved header bytes and the battle context without renaming them.
type BattleStart struct {
	RoomID         uint32
	ControllerSlot uint16
	NetworkDelay   [8]uint32
	Raw            [53]byte
}

func ParseBattleStart(p []byte) (BattleStart, error) {
	var r BattleStart
	if len(p) != len(r.Raw) {
		return r, ErrFrame
	}
	copy(r.Raw[:], p)
	r.RoomID = ReadUint32(p, 0)
	r.ControllerSlot = ReadUint16(p, 11)
	for i := range r.NetworkDelay {
		r.NetworkDelay[i] = ReadUint32(p, 13+i*4)
	}
	return r, nil
}
