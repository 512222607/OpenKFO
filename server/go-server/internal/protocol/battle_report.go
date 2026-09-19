package protocol

const BattleReportRecordSize = 87
const BattleReportSize = 8 * BattleReportRecordSize

type BattleReportRecord struct {
	UID                uint64
	Health, FinishCode uint16
	RoomID, Serial     uint32
	Raw                [BattleReportRecordSize]byte
}

// Native 987E40 sends eight fixed slot records. FinishCode copies its WORD
// argument; meanings depend on the mode and are not authority to grant rewards.
func ParseBattleReport(p []byte) (rows [8]BattleReportRecord, err error) {
	if len(p) != BattleReportSize {
		return rows, ErrFrame
	}
	for i := range rows {
		r := p[i*BattleReportRecordSize : (i+1)*BattleReportRecordSize]
		copy(rows[i].Raw[:], r)
		rows[i].UID = ReadUint64(r, 29)
		rows[i].Health, rows[i].FinishCode = ReadUint16(r, 2), ReadUint16(r, 65)
		rows[i].RoomID, rows[i].Serial = ReadUint32(r, 67), ReadUint32(r, 71)
	}
	return rows, nil
}
