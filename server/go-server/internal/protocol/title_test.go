package protocol

import "testing"

func TestEncodeTitleAward(t *testing.T) {
	for _, choices := range [][]uint32{nil, {0}, {7, 7}, {1, 2, 3, 4, 5, 6, 7, 8}} {
		if _, err := EncodeTitleAward(1, choices); err == nil {
			t.Fatal("invalid choices", choices)
		}
	}
	if _, err := EncodeTitleAward(0, []uint32{7}); err == nil {
		t.Fatal("zero title")
	}
	p, err := EncodeTitleAward(3, []uint32{0x12345678})
	if err != nil || len(p) != 64 || p[0] != 3 || p[8] != 0x78 || p[11] != 0x12 {
		t.Fatal(p, err)
	}
	for i, v := range p {
		if i != 0 && (i < 8 || i > 11) && v != 0 {
			t.Fatal("nonzero reserved/empty slot", i)
		}
	}
	p, err = EncodeTitleAward(3, []uint32{1, 2, 3, 4, 5, 6, 7})
	if err != nil || ReadUint32(p, 56) != 7 || ReadUint32(p, 60) != 0 {
		t.Fatal("last candidate", err)
	}
}

func TestTitleRewardOptionsAndClaim(t *testing.T) {
	p := make([]byte, 64)
	p[0] = 3
	for i := 0; i < 7; i++ {
		WriteUint32(p, 8+i*8, uint32(100+i))
		WriteUint32(p, 12+i*8, uint32(200+i))
	}
	r, err := ParseTitleRewardOptions(p)
	if err != nil || r[0].CatalogKey != 100 || r[6].CatalogKey != 106 || r[6].Unknown != 206 {
		t.Fatal(r, err)
	}
	if _, err = ParseTitleRewardOptions(p[:63]); err == nil {
		t.Fatal("short options")
	}
	claim := make([]byte, 149)
	claim[145], claim[146], claim[147], claim[148] = 0x78, 0x56, 0x34, 0x12
	if key, err := ParseTitleRewardClaim(claim); err != nil || key != 0x12345678 {
		t.Fatal(key, err)
	}
	for _, n := range []int{0, 13, 148, 150, 169} {
		if _, err := ParseTitleRewardClaim(make([]byte, n)); err == nil {
			t.Fatal("bad claim length", n)
		}
	}
}

func TestTitleAwardReadBoundary(t *testing.T) {
	for n := 0; n < 64; n++ {
		if _, _, err := ParseTitleAward(make([]byte, n)); err == nil {
			t.Fatal("short title award", n)
		}
	}
	p := make([]byte, 68)
	p[0], p[63], p[67] = 16, 7, 8
	level, raw, err := ParseTitleAward(p)
	if err != nil || level != 16 || len(raw) != 68 || raw[63] != 7 || raw[67] != 8 {
		t.Fatal(level, raw, err)
	}
	p[0] = 0
	if raw[0] != 16 {
		t.Fatal("input alias")
	}
}
