package protocol

// StageFinishReason is specific to mode 21's 93C890, not a PvP outcome.
type StageFinishReason uint16

const (
	StageFinishWaves       StageFinishReason = 1 // 93BC60 set mode+1C after 20572/-1.
	StageFinishActorFlags  StageFinishReason = 2 // All occupied actors' +1B78 flags persist >9000 ticks.
	StageFinishCounterZero StageFinishReason = 3 // 94BC50 returns zero; counter semantics unresolved.
)

func (r StageFinishReason) String() string {
	switch r {
	case StageFinishWaves:
		return "波次结束标记"
	case StageFinishActorFlags:
		return "全员状态标记持续超时"
	case StageFinishCounterZero:
		return "原生计数归零"
	default:
		return "未知关卡结束原因"
	}
}

// ParseStageFinishReport checks the native report's internal consistency.
// It does not authenticate the sender, validate room membership, prove wave
// completion, or authorize rewards. Those require the server's battle state.
func ParseStageFinishReport(p []byte) ([8]BattleReportRecord, StageFinishReason, error) {
	rows, err := ParseBattleReport(p)
	if err != nil {
		return rows, 0, err
	}
	var reason StageFinishReason
	var room, serial uint32
	seen := map[uint64]bool{}
	for _, row := range rows {
		if row.UID == 0 {
			if row.Raw != ([BattleReportRecordSize]byte{}) {
				return rows, 0, ErrFrame
			}
			continue
		}
		code := StageFinishReason(row.FinishCode)
		if code < StageFinishWaves || code > StageFinishCounterZero || seen[row.UID] {
			return rows, 0, ErrFrame
		}
		if reason == 0 {
			reason, room, serial = code, row.RoomID, row.Serial
		} else if code != reason || row.RoomID != room || row.Serial != serial {
			return rows, 0, ErrFrame
		}
		seen[row.UID] = true
	}
	if reason == 0 {
		return rows, 0, ErrFrame
	}
	return rows, reason, nil
}
