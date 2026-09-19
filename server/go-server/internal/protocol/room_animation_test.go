package protocol

import "testing"

func TestBattlePoseNativeLayout(t *testing.T) {
	for pose := 0; pose < 256; pose++ {
		p := []byte{0x78, 0x56, 0x34, 0x12, 0xef, 0xcd, 0xab, 0x90, byte(pose)}
		r, err := ParseBattlePose(p)
		if pose > 3 {
			if err == nil {
				t.Fatal("native ignores invalid pose", pose)
			}
			continue
		}
		if err != nil || r.UID != 0x90abcdef12345678 || r.Pose != byte(pose) {
			t.Fatal(r, err)
		}
	}
	for _, n := range []int{0, 1, 8, 10, 17} {
		if _, err := ParseBattlePose(make([]byte, n)); err == nil {
			t.Fatal("invalid size", n)
		}
	}
}

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
