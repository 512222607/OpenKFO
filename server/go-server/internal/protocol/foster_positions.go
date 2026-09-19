package protocol

import "math"

const BattleEventFosterPositions uint32 = 20405

type FosterPosition struct {
	UID       uint64
	Position  [3]float32
	Direction uint32
}

// 941A90 sends six compact records; 827780 copies all six to virtual +11C.
// Record order is not a room slot number. Empty records are zero-filled.
func ParseFosterPositions(p []byte) (sender uint64, rows [6]FosterPosition, err error) {
	if len(p) != 183 || ReadUint32(p, 0) != BattleEventFosterPositions {
		return 0, rows, ErrFrame
	}
	seen := map[uint64]bool{}
	for i := range rows {
		base := 39 + 24*i
		r := &rows[i]
		r.UID = ReadUint64(p, base)
		r.Direction = ReadUint32(p, base+20)
		if r.UID == 0 {
			for _, b := range p[base : base+24] {
				if b != 0 {
					return 0, rows, ErrFrame
				}
			}
			continue
		}
		if seen[r.UID] {
			return 0, rows, ErrFrame
		}
		seen[r.UID] = true
		for j := range r.Position {
			v := math.Float32frombits(ReadUint32(p, base+8+4*j))
			if math.IsNaN(float64(v)) || math.IsInf(float64(v), 0) {
				return 0, rows, ErrFrame
			}
			r.Position[j] = v
		}
	}
	if len(seen) == 0 {
		return 0, rows, ErrFrame
	}
	return ReadUint64(p, 4), rows, nil
}
