package protocol

import "testing"

func TestNativeBattleInputReady(t *testing.T) {
	p := []byte{0x34, 0x12, 1, 2, 3, 4, 5, 6, 7, 8, 0xff, 0xff, 0xff, 0xff}
	r, err := ParseBattleInputReady(p)
	if err != nil || r.RoomID != 0x1234 || r.UID != 0x0807060504030201 || r.ClientValue != 0xffffffff {
		t.Fatal(r, err)
	}
	for _, p := range [][]byte{nil, p[:13], append(p, 0)} {
		if _, err := ParseBattleInputReady(p); err == nil {
			t.Fatal("invalid input-ready length")
		}
	}
}
