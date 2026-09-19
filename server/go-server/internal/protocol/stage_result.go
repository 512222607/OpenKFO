package protocol

// Mode 21 uses the shared 140B header + 360B profile record in 4120,
// but its result21.sui consumer reads additional fields at +92/+96/+100.
// Values are decoded, not accepted as authorization to grant a reward.
type StageResult struct {
	UID                               uint64
	ResultValue                       byte
	Experience, Gold, ItemID          uint32
	Waves, ElapsedSeconds, GradeValue uint32
	Raw                               [500]byte
}

func ParseStageResults(p []byte) ([]StageResult, error) {
	if len(p) == 0 || len(p)%500 != 0 || len(p)/500 > 8 {
		return nil, ErrFrame
	}
	rows := make([]StageResult, len(p)/500)
	seen := map[uint64]bool{}
	for i := range rows {
		r := &rows[i]
		block := p[i*500 : (i+1)*500]
		copy(r.Raw[:], block)
		r.UID, r.ResultValue = ReadUint64(block, 0), block[10]
		if r.UID == 0 || seen[r.UID] {
			return nil, ErrFrame
		}
		seen[r.UID] = true
		r.Experience, r.ItemID, r.Gold = ReadUint32(block, 34), ReadUint32(block, 54), ReadUint32(block, 63)
		r.Waves, r.ElapsedSeconds, r.GradeValue = ReadUint32(block, 92), ReadUint32(block, 96), ReadUint32(block, 100)
	}
	return rows, nil
}
