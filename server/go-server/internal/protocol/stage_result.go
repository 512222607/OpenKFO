package protocol

const StageResultRecordSize = 140 + RoleProfileSize

// Native 937830 switches +100 through 937980 to RankC..RankSSS.png.
// Other raw values use RankD.png. This is display mapping, not a scoring rule.
type StageGrade uint32

const (
	StageGradeC   StageGrade = 2
	StageGradeB   StageGrade = 3
	StageGradeA   StageGrade = 4
	StageGradeS   StageGrade = 5
	StageGradeSS  StageGrade = 6
	StageGradeSSS StageGrade = 7
)

func (g StageGrade) String() string {
	switch g {
	case StageGradeC:
		return "C"
	case StageGradeB:
		return "B"
	case StageGradeA:
		return "A"
	case StageGradeS:
		return "S"
	case StageGradeSS:
		return "SS"
	case StageGradeSSS:
		return "SSS"
	default:
		return "D"
	}
}

// Mode 21 uses the shared 140B header + 360B profile record in 4120,
// but its result21.sui consumer reads additional fields at +92/+96/+100.
// Values are decoded, not accepted as authorization to grant a reward.
type StageResult struct {
	UID                               uint64
	ResultValue                       byte
	Experience, Gold, ItemID          uint32
	Waves, ElapsedSeconds, GradeValue uint32
	Raw                               [StageResultRecordSize]byte
}

// EncodeStageResults overlays confirmed fields on the retained native record.
// The caller supplies the persisted profile in Raw[140:] and controls ordering
// (recipient last). Unknown header fields are not synthesized as reward data.
func EncodeStageResults(rows []StageResult) ([]byte, error) {
	if len(rows) == 0 || len(rows) > 8 {
		return nil, ErrFrame
	}
	p := make([]byte, len(rows)*StageResultRecordSize)
	seen := map[uint64]bool{}
	for i, row := range rows {
		if row.UID == 0 || seen[row.UID] {
			return nil, ErrFrame
		}
		seen[row.UID] = true
		block := p[i*StageResultRecordSize : (i+1)*StageResultRecordSize]
		copy(block, row.Raw[:])
		WriteUint64(block, 0, row.UID)
		block[10] = row.ResultValue
		WriteUint32(block, 34, row.Experience)
		WriteUint32(block, 54, row.ItemID)
		WriteUint32(block, 63, row.Gold)
		WriteUint32(block, 92, row.Waves)
		WriteUint32(block, 96, row.ElapsedSeconds)
		WriteUint32(block, 100, row.GradeValue)
	}
	return p, nil
}

func ParseStageResults(p []byte) ([]StageResult, error) {
	if len(p) == 0 || len(p)%StageResultRecordSize != 0 || len(p)/StageResultRecordSize > 8 {
		return nil, ErrFrame
	}
	rows := make([]StageResult, len(p)/StageResultRecordSize)
	seen := map[uint64]bool{}
	for i := range rows {
		r := &rows[i]
		block := p[i*StageResultRecordSize : (i+1)*StageResultRecordSize]
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
