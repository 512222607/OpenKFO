package protocol

import "testing"

func TestBattleReportSlotsAndFinishCode(t *testing.T) {
	p := make([]byte, BattleReportSize)
	for i := 0; i < 8; i++ {
		r := p[i*87 : (i+1)*87]
		WriteUint64(r, 29, uint64(100+i))
		WriteUint16(r, 2, uint16(800+i))
		WriteUint16(r, 65, uint16(i))
		WriteUint32(r, 67, 17)
		WriteUint32(r, 71, 99)
		r[64], r[86] = 0xa1, 0xb2
	}
	rows, err := ParseBattleReport(p)
	if err != nil {
		t.Fatal(err)
	}
	for i, r := range rows {
		if r.UID != uint64(100+i) || r.Health != uint16(800+i) || r.FinishCode != uint16(i) || r.RoomID != 17 || r.Serial != 99 || r.Raw[64] != 0xa1 || r.Raw[86] != 0xb2 {
			t.Fatal("record offsets crossed", i, r)
		}
	}
	p[64] = 0
	if rows[0].Raw[64] != 0xa1 {
		t.Fatal("raw data aliases caller")
	}
	for _, size := range []int{0, 87, BattleReportSize - 1, BattleReportSize + 1} {
		if _, err := ParseBattleReport(make([]byte, size)); err == nil {
			t.Fatal("invalid size accepted", size)
		}
	}
}
