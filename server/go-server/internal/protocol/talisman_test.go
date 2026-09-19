package protocol

import "testing"

func TestTalismanEventIdentityAndSlots(t *testing.T) {
	const uid = uint64(0xfedcba9876543210)
	p := make([]byte, 75)
	WriteUint64(p, 4, uid)
	WriteUint64(p, 59, uid)
	WriteUint32(p, 19, 123)
	WriteUint32(p, 67, 7)
	WriteUint32(p, 71, 9)
	for _, kind := range []uint32{8291, 8292} {
		for _, slot := range []uint32{37, 38} {
			WriteUint32(p, 0, kind)
			WriteUint32(p, 39, slot)
			e, err := ParseTalismanEvent(p)
			if err != nil || !e.Match(uid, 7, 9) || e.Kind != kind || e.Slot != uint16(slot) || e.Sequence != 123 {
				t.Fatal(e, err)
			}
			if e.Match(uid+1, 7, 9) || e.Match(uid, 8, 9) || e.Match(uid, 7, 10) {
				t.Fatal("foreign context accepted")
			}
			for i := 43; i < 59; i++ {
				p[i] = byte(i * 3)
			}
			other, err := ParseTalismanEvent(p)
			if err != nil || other != e {
				t.Fatal("uninitialized bytes changed semantics")
			}
		}
	}
	for _, slot := range []uint32{0, 27, 36, 39, 65573} {
		WriteUint32(p, 39, slot)
		if _, err := ParseTalismanEvent(p); err == nil {
			t.Fatal("invalid slot", slot)
		}
	}
	WriteUint32(p, 39, 37)
	WriteUint32(p, 0, 8289)
	if _, err := ParseTalismanEvent(p); err == nil {
		t.Fatal("wrong event")
	}
	WriteUint32(p, 0, 8292)
	for _, q := range [][]byte{nil, p[:74], append(append([]byte{}, p...), 0)} {
		if _, err := ParseTalismanEvent(q); err == nil {
			t.Fatal("invalid length")
		}
	}
	WriteUint64(p, 59, uid+1)
	e, err := ParseTalismanEvent(p)
	if err != nil || e.Match(uid, 7, 9) {
		t.Fatal("foreign actor")
	}
}
