package protocol

import (
	"bytes"
	"testing"
)

func TestStageFinishReport(t *testing.T) {
	for _, reason := range []StageFinishReason{StageFinishWaves, StageFinishActorFlags, StageFinishCounterZero} {
		p := make([]byte, BattleReportSize)
		for _, slot := range []int{0, 7} {
			r := p[slot*BattleReportRecordSize:]
			WriteUint64(r, 29, uint64(slot)+1<<40)
			WriteUint16(r, 65, uint16(reason))
			WriteUint32(r, 67, 15)
			WriteUint32(r, 71, 91)
		}
		rows, got, err := ParseStageFinishReport(p)
		if err != nil || got != reason || rows[7].UID == rows[0].UID || got.String() == "未知关卡结束原因" {
			t.Fatal("native report rejected", got, err)
		}
		for _, failure := range []string{"mixed reason", "unknown reason", "room", "serial", "duplicate", "empty slot", "empty", "short"} {
			t.Run(reason.String()+"/"+failure, func(t *testing.T) {
				bad := bytes.Clone(p)
				r := bad[7*BattleReportRecordSize:]
				switch failure {
				case "mixed reason":
					WriteUint16(r, 65, uint16(reason)%3+1)
				case "unknown reason":
					WriteUint16(r, 65, 4)
				case "room":
					WriteUint32(r, 67, 16)
				case "serial":
					WriteUint32(r, 71, 92)
				case "duplicate":
					WriteUint64(r, 29, rows[0].UID)
				case "empty slot":
					bad[BattleReportRecordSize] = 1
				case "empty":
					clear(bad)
				case "short":
					bad = bad[:len(bad)-1]
				}
				if _, _, err := ParseStageFinishReport(bad); err == nil {
					t.Fatal("invalid report accepted")
				}
			})
		}
	}
}
