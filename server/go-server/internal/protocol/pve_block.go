package protocol

import "math"

const (
	BattleEventPVEBlockCreate uint32 = 20403
	BattleEventPVEBlockRemove uint32 = 20404
)

// 941D30/827910: create_block's boolean is preserved without assigning an
// unverified collision meaning. Corners retain the script's four XYZ vectors.
type PVEBlockCreate struct {
	Sender  uint64
	ID      uint32
	Flag    bool
	Corners [4][3]float32
	Raw     [92]byte
}

func ParsePVEBlockCreate(p []byte) (r PVEBlockCreate, err error) {
	if len(p) != len(r.Raw) || ReadUint32(p, 0) != BattleEventPVEBlockCreate || p[39] > 1 {
		return r, ErrFrame
	}
	copy(r.Raw[:], p)
	r.Sender, r.ID, r.Flag = ReadUint64(p, 4), ReadUint32(p, 40), p[39] != 0
	for i := range r.Corners {
		for j := range r.Corners[i] {
			v := math.Float32frombits(ReadUint32(p, 44+12*i+4*j))
			if math.IsNaN(float64(v)) || math.IsInf(float64(v), 0) {
				return PVEBlockCreate{}, ErrFrame
			}
			r.Corners[i][j] = v
		}
	}
	return r, nil
}

type PVEBlockRemove struct {
	Sender uint64
	ID     uint32
	Raw    [43]byte
}

// 941C70/8278A0: no room-context trailer; identity and current room must be
// authenticated by the server. Removing a wall is not completion proof.
func ParsePVEBlockRemove(p []byte) (r PVEBlockRemove, err error) {
	if len(p) != len(r.Raw) || ReadUint32(p, 0) != BattleEventPVEBlockRemove {
		return r, ErrFrame
	}
	copy(r.Raw[:], p)
	r.Sender, r.ID = ReadUint64(p, 4), ReadUint32(p, 39)
	return r, nil
}
