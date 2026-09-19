package protocol

// TrainingStatus retains the unknown fields of native 21001/21005/21007.
// RewardPerHour and RewardCap describe the XP preview, not an award authority.
type TrainingStatus struct {
	UID           uint64
	Level         uint32
	Unknown12     uint32
	BoxDisplay    uint32
	Minutes       uint32
	Unknown24     uint32
	Active        uint32
	Unknown32     uint32
	RewardPerHour uint32
	RewardCap     uint32
	Tail          [3]uint32
}

func ParseTrainingStatus(p []byte) (TrainingStatus, error) {
	var r TrainingStatus
	if len(p) != 56 {
		return r, ErrFrame
	}
	r.UID = ReadUint64(p, 0)
	r.Level = ReadUint32(p, 8)
	r.Unknown12 = ReadUint32(p, 12)
	r.BoxDisplay = ReadUint32(p, 16)
	r.Minutes = ReadUint32(p, 20)
	r.Unknown24 = ReadUint32(p, 24)
	r.Active = ReadUint32(p, 28)
	r.Unknown32 = ReadUint32(p, 32)
	r.RewardPerHour = ReadUint32(p, 36)
	r.RewardCap = ReadUint32(p, 40)
	for i := range r.Tail {
		r.Tail[i] = ReadUint32(p, 44+i*4)
	}
	return r, nil
}
