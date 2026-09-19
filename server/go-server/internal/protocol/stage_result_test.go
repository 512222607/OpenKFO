package protocol

import (
	"bytes"
	"testing"
)

func TestStageResultEncodingPreservesProfileAndUnknownFields(t *testing.T) {
	rows := make([]StageResult, 2)
	for i := range rows {
		r := &rows[i]
		for j := range r.Raw {
			r.Raw[j] = byte(j + i)
		}
		r.UID = uint64(1<<40) + uint64(i) + 1
		r.ResultValue, r.Experience, r.Gold, r.ItemID = 10, 123, 456, 253001
		r.Waves, r.ElapsedSeconds, r.GradeValue = 25, 125, uint32(StageGradeSSS)
	}
	p, err := EncodeStageResults(rows)
	if err != nil {
		t.Fatal(err)
	}
	decoded, err := ParseStageResults(p)
	if err != nil {
		t.Fatal(err)
	}
	for i, r := range decoded {
		want := rows[i]
		if r.UID != want.UID || r.ResultValue != want.ResultValue || r.Experience != want.Experience || r.Gold != want.Gold || r.ItemID != want.ItemID || r.Waves != want.Waves || r.ElapsedSeconds != want.ElapsedSeconds || r.GradeValue != want.GradeValue {
			t.Fatal("typed field not encoded", i)
		}
		if !bytes.Equal(r.Raw[140:], want.Raw[140:]) || !bytes.Equal(r.Raw[104:140], want.Raw[104:140]) || r.Raw[87] != want.Raw[87] {
			t.Fatal("opaque profile/header changed")
		}
	}
	roundtrip, err := EncodeStageResults(decoded)
	if err != nil || !bytes.Equal(roundtrip, p) {
		t.Fatal("native roundtrip changed bytes", err)
	}
	for _, bad := range [][]StageResult{nil, make([]StageResult, 9), {{UID: 0}}, {rows[0], rows[0]}} {
		if _, err := EncodeStageResults(bad); err == nil {
			t.Fatal("invalid identities accepted")
		}
	}
}

func TestStageGradeNativeImages(t *testing.T) {
	for value, want := range map[StageGrade]string{0: "D", 1: "D", 2: "C", 3: "B", 4: "A", 5: "S", 6: "SS", 7: "SSS", 8: "D", 0xffffffff: "D"} {
		if value.String() != want {
			t.Fatal(value, want)
		}
	}
}

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
