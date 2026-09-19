package protocol

import "testing"

func TestStageResultNativeOffsets(t *testing.T) {
	p := make([]byte, 1000)
	for i := 0; i < 2; i++ {
		b := p[i*500 : (i+1)*500]
		WriteUint64(b, 0, uint64(1<<40)+uint64(i)+1)
		b[10], b[139], b[499] = 10, 0xa5, 0x5a
		for offset, value := range map[int]uint32{34: 123, 54: 250001, 63: 456, 92: 25, 96: 125, 100: 7} {
			WriteUint32(b, offset, value)
		}
	}
	rows, err := ParseStageResults(p)
	if err != nil || len(rows) != 2 {
		t.Fatal(err)
	}
	for i, r := range rows {
		if r.UID != uint64(1<<40)+uint64(i)+1 || r.ResultValue != 10 || r.Experience != 123 || r.Gold != 456 || r.ItemID != 250001 || r.Waves != 25 || r.ElapsedSeconds != 125 || r.GradeValue != 7 || r.Raw[139] != 0xa5 || r.Raw[499] != 0x5a {
			t.Fatal("native field or raw data lost", i)
		}
	}
	p[139] = 0
	if rows[0].Raw[139] != 0xa5 {
		t.Fatal("parser aliases input")
	}
	for _, bad := range [][]byte{nil, p[:499], p[:999], append(p, 0), make([]byte, 4500), make([]byte, 500)} {
		if _, err := ParseStageResults(bad); err == nil {
			t.Fatal("bad result accepted", len(bad))
		}
	}
	WriteUint64(p, 500, ReadUint64(p, 0))
	if _, err := ParseStageResults(p); err == nil {
		t.Fatal("duplicate player accepted")
	}
}
