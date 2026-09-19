package protocol

const MsgStageWaveControl uint32 = 20572
const BattleEventStageWaveEnd uint32 = 20407

type StageWaveControl struct {
	Wave int32
	Raw  [40]byte
}

// Native 82A820 accepts exactly 40 bytes and only reads DWORD +8.
// Wave -1 calls 93BC60; it is not a server-verified completion result.
func ParseStageWaveControl(p []byte) (r StageWaveControl, err error) {
	if len(p) != len(r.Raw) {
		return r, ErrFrame
	}
	copy(r.Raw[:], p)
	r.Wave = int32(ReadUint32(p, 8))
	return r, nil
}

type StageWaveEnd struct {
	Sender, ContextValue uint64
	Raw                  [47]byte
}

// 93BC60 -> A3FBB0 produces an embedded battle event, not top-level 20407.
// ContextValue is copied from the room object; it is not a claimed reward.
func ParseStageWaveEnd(p []byte) (r StageWaveEnd, err error) {
	if len(p) != len(r.Raw) || ReadUint32(p, 0) != BattleEventStageWaveEnd {
		return r, ErrFrame
	}
	copy(r.Raw[:], p)
	r.Sender, r.ContextValue = ReadUint64(p, 4), ReadUint64(p, 39)
	return r, nil
}
