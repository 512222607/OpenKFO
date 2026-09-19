package protocol

import "testing"

func TestRoomKickPayloadPreservesIdentityFlag(t *testing.T) {
	p := []byte{8, 7, 6, 5, 4, 3, 2, 1, 255}
	r, err := ParseRoomKickRequest(p)
	if err != nil || r.TargetUID != 0x0102030405060708 || r.ClientFlag != 255 {
		t.Fatal(r, err)
	}
	p[0], p[8] = 0, 0
	if r.TargetUID != 0x0102030405060708 || r.ClientFlag != 255 {
		t.Fatal("request aliases bytes")
	}
	for _, n := range []int{0, 8, 10} {
		if _, err = ParseRoomKickRequest(make([]byte, n)); err == nil {
			t.Fatal("wrong length", n)
		}
	}
}
