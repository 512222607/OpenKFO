package protocol

import "testing"

func TestRoomJoinNativeLayout(t *testing.T) {
	p := []byte{0x34, 0x12, 1, 'p', 'a', 's', 's', 0, 0, 0, 0, 0, 0, 0}
	r, err := ParseRoomJoinRequest(p)
	if err != nil || r.RoomID != 0x1234 || r.Mode != JoinAsSpectator || string(r.Password[:4]) != "pass" {
		t.Fatal(r, err)
	}
	p[3] = 'X'
	if r.Password[0] != 'p' {
		t.Fatal("request aliases input")
	}
	p[2] = 0
	r, err = ParseRoomJoinRequest(p)
	if err != nil || r.Mode != JoinAsPlayer {
		t.Fatal(r, err)
	}
	p[2] = 255
	r, err = ParseRoomJoinRequest(p)
	if err != nil || byte(r.Mode) != 255 {
		t.Fatal("unknown mode must remain distinguishable", r, err)
	}
	for _, p := range [][]byte{nil, make([]byte, 13), make([]byte, 15)} {
		if _, err := ParseRoomJoinRequest(p); err == nil {
			t.Fatal("accepted bad length")
		}
	}
}
