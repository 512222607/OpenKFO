package protocol

import (
	"math"
	"testing"
)

func TestPVEActorNativeLayouts(t *testing.T) {
	p := make([]byte, 67)
	WriteUint32(p, 0, BattleEventPVEActorCreate)
	WriteUint64(p, 4, 0x1020304050607080)
	WriteUint64(p, 39, 0x8877665544332211)
	WriteUint32(p, 47, 7)
	for i, v := range []float32{-12.5, 20, 0.25} {
		WriteUint32(p, 51+i*4, math.Float32bits(v))
	}
	WriteUint32(p, 63, 4)
	r, err := ParsePVEActorCreate(p)
	if err != nil || r.Sender != 0x1020304050607080 || r.Actor != 0x8877665544332211 || r.TemplateValue != 7 || r.Position != [3]float32{-12.5, 20, 0.25} || r.DirectionValue != 4 {
		t.Fatal(r, err)
	}
	p[47] = 0
	if r.Raw[47] != 7 {
		t.Fatal("raw aliases input")
	}
	for _, bad := range [][]byte{nil, p[:66], append(p, 0), make([]byte, 67)} {
		if _, err := ParsePVEActorCreate(bad); err == nil {
			t.Fatal("bad creation accepted")
		}
	}
	for axis := 0; axis < 3; axis++ {
		for _, bits := range []uint32{0x7f800000, 0xff800000, 0x7fc00000} {
			bad := append([]byte(nil), p...)
			WriteUint32(bad, 51+axis*4, bits)
			if _, err := ParsePVEActorCreate(bad); err == nil {
				t.Fatal("nonfinite coordinate accepted")
			}
		}
	}
	d := make([]byte, 47)
	WriteUint32(d, 0, BattleEventPVEActorRemove)
	WriteUint64(d, 4, r.Sender)
	WriteUint64(d, 39, r.Actor)
	removed, err := ParsePVEActorRemove(d)
	if err != nil || removed.Sender != r.Sender || removed.Actor != r.Actor {
		t.Fatal(removed, err)
	}
	for _, bad := range [][]byte{nil, d[:46], append(d, 0), make([]byte, 47)} {
		if _, err := ParsePVEActorRemove(bad); err == nil {
			t.Fatal("bad removal accepted")
		}
	}
}
