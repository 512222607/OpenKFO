package protocol

import "testing"

func TestRoomAnimationNativeLayout(t *testing.T) {
	p := []byte{0x78, 0x56, 0x34, 0x12, 0xef, 0xcd, 0xab, 0x90, 0xff}
	r, err := ParseRoomAnimation(p)
	if err != nil || r.SubjectValue != 0x12345678 || r.UnknownValue != 0x90abcdef || r.Animation != 255 {
		t.Fatal(r, err)
	}
	p[0] = 0
	if r.SubjectValue != 0x12345678 {
		t.Fatal("input alias retained")
	}
	for _, n := range []int{0, 1, 4, 8, 10, 17} {
		if _, err := ParseRoomAnimation(make([]byte, n)); err == nil {
			t.Fatal("invalid size", n)
		}
	}
}
