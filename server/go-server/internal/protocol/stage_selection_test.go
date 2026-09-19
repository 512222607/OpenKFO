package protocol

import (
	"bytes"
	"testing"
)

func TestStageSelectionClearsNativeCandidates(t *testing.T) {
	p, e := EncodeStageSelection(nil)
	if e != nil || len(p) != 404 || !bytes.Equal(p[4:7], []byte{'0', ',', 0}) {
		t.Fatal("missing clear sentinel", e)
	}
	decoded, e := ParseStageSelection(p)
	if e != nil || len(decoded.MapIDs) != 0 {
		t.Fatal(decoded, e)
	}
	p, e = EncodeStageSelection([]uint32{8110, 8111})
	if e != nil {
		t.Fatal(e)
	}
	decoded, e = ParseStageSelection(p)
	if e != nil || len(decoded.MapIDs) != 2 {
		t.Fatal(decoded, e)
	}
	for _, text := range []string{"0,8110,", "8110,0,", "0,0,"} {
		p = make([]byte, 404)
		copy(p[4:], text)
		if _, e = ParseStageSelection(p); e == nil {
			t.Fatal("sentinel mixed with real maps", text)
		}
	}
	if _, e = EncodeStageSelection([]uint32{0}); e == nil {
		t.Fatal("zero admitted as a map")
	}
}
