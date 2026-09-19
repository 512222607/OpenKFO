package protocol

import (
	"math"
	"testing"
)

func TestPVEBlockPackets(t *testing.T) {
	p := make([]byte, 92)
	WriteUint32(p, 0, BattleEventPVEBlockCreate)
	WriteUint64(p, 4, 1<<40)
	p[39] = 1
	WriteUint32(p, 40, 100)
	for i := 0; i < 12; i++ {
		WriteUint32(p, 44+4*i, math.Float32bits(float32(i)-8))
	}
	r, err := ParsePVEBlockCreate(p)
	if err != nil || r.Sender != 1<<40 || r.ID != 100 || !r.Flag || r.Corners[3][2] != 3 {
		t.Fatal(r, err)
	}
	for _, n := range []int{0, 39, 43, 91, 93} {
		if _, e := ParsePVEBlockCreate(make([]byte, n)); e == nil {
			t.Fatal("bad length", n)
		}
	}
	p[39] = 2
	if _, e := ParsePVEBlockCreate(p); e == nil {
		t.Fatal("invalid boolean")
	}
	p[39] = 0
	for i := 0; i < 12; i++ {
		offset := 44 + 4*i
		old := ReadUint32(p, offset)
		for _, v := range []float32{float32(math.NaN()), float32(math.Inf(1)), float32(math.Inf(-1))} {
			WriteUint32(p, offset, math.Float32bits(v))
			if _, e := ParsePVEBlockCreate(p); e == nil {
				t.Fatal("nonfinite corner", i)
			}
		}
		WriteUint32(p, offset, old)
	}
	d := make([]byte, 43)
	WriteUint32(d, 0, BattleEventPVEBlockRemove)
	WriteUint64(d, 4, 1<<40)
	WriteUint32(d, 39, 100)
	removed, e := ParsePVEBlockRemove(d)
	if e != nil || removed.Sender != r.Sender || removed.ID != r.ID {
		t.Fatal(removed, e)
	}
	for _, bad := range [][]byte{d[:42], append(d, 0), p} {
		if _, e := ParsePVEBlockRemove(bad); e == nil {
			t.Fatal("invalid removal")
		}
	}
}
