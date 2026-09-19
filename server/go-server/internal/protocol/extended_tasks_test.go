package protocol

import "testing"

func TestExtendedTaskListEncoding(t *testing.T) {
	for _, c := range []struct {
		id  uint32
		key uint16
	}{{6041, 2001}, {6042, 3002}} {
		r := ExtendedTaskProgress{Key: c.key, State: 2}
		r.Conditions[0] = ExtendedTaskCondition{Key: 0, Current: 1}
		r.Conditions[1] = ExtendedTaskCondition{Key: 3, Current: 2}
		p, e := EncodeExtendedTaskProgress(c.id, []ExtendedTaskProgress{r})
		if e != nil || len(p) != 141 || ReadUint16(p, 12) != c.key || p[16] != 2 || ReadUint32(p, 53) != 0 || ReadUint32(p, 57) != 1 || ReadUint32(p, 65) != 3 || ReadUint32(p, 69) != 2 {
			t.Fatal(p, e)
		}
		for _, offset := range []int{0, 11, 17, 52, 61, 137, 140} {
			if p[offset] != 0 {
				t.Fatal("unknown field set", offset)
			}
		}
		if _, e = EncodeExtendedTaskProgress(c.id, []ExtendedTaskProgress{r, r}); e == nil {
			t.Fatal("duplicate accepted")
		}
		r.Conditions[0].Current = 0x80000000
		if _, e = EncodeExtendedTaskProgress(c.id, []ExtendedTaskProgress{r}); e == nil {
			t.Fatal("overflow accepted")
		}
		if p, e = EncodeExtendedTaskProgress(c.id, nil); e != nil || len(p) != 0 {
			t.Fatal("empty list", e)
		}
	}
	if _, e := EncodeExtendedTaskProgress(6041, []ExtendedTaskProgress{{Key: 3002, State: 1}}); e == nil {
		t.Fatal("wrong category")
	}
	if _, e := EncodeExtendedTaskProgress(6041, []ExtendedTaskProgress{{Key: 2001, State: 0}}); e == nil {
		t.Fatal("invalid state")
	}
}

func TestExtendedTaskAuxRecords(t *testing.T) {
	p := make([]byte, 44)
	p[12], p[13], p[34], p[35] = 0xd1, 7, 0xb9, 11
	p[21], p[43] = 81, 92
	r, e := ParseExtendedTaskAuxRecords(p)
	if e != nil || len(r) != 2 || r[0].Key != 2001 || r[1].Key != 3001 || r[0].Raw[21] != 81 || r[1].Raw[21] != 92 {
		t.Fatal(r, e)
	}
	r[0].Raw[21] = 0
	if p[21] != 81 {
		t.Fatal("aliases wire")
	}
	for _, n := range []int{1, 12, 21, 23, 43} {
		if _, e := ParseExtendedTaskAuxRecords(p[:n]); e == nil {
			t.Fatal("short tail accepted", n)
		}
	}
	if r, e := ParseExtendedTaskAuxRecords(nil); e != nil || len(r) != 0 {
		t.Fatal(r, e)
	}
}

func TestExtendedTaskActions(t *testing.T) {
	for id, state := range map[uint32]byte{6051: 2, 6052: 2, 6081: 1, 6082: 1, 6311: 3, 6312: 3} {
		p := []byte{0xd1, 7, state, 0x78, 0x56, 0x34, 0x12, 255, 238, 221, 204, 187, 170, 153, 136, 119, 102, 85, 68}
		r, e := ParseExtendedTaskAction(id, p)
		if e != nil || r.Key != 2001 || r.State != state || r.Context != 0x12345678 || r.Tail[0] != 255 || r.Tail[11] != 68 {
			t.Fatal(id, r, e)
		}
		for _, n := range []int{0, 2, 3, 7, 14, 18, 20} {
			if _, e := ParseExtendedTaskAction(id, make([]byte, n)); e == nil {
				t.Fatal("wrong length accepted", n)
			}
		}
		p[2] = 4
		if _, e := ParseExtendedTaskAction(id, p); e == nil {
			t.Fatal("client completion claim accepted")
		}
		p[2], p[0], p[1] = state, 0, 0
		if _, e := ParseExtendedTaskAction(id, p); e == nil {
			t.Fatal("zero key accepted")
		}
	}
	if _, e := ParseExtendedTaskAction(6050, make([]byte, 19)); e == nil {
		t.Fatal("base task accepted")
	}
}

func TestExtendedTaskStateConsumers(t *testing.T) {
	p := make([]byte, 141)
	p[12], p[13], p[16] = 0xb9, 0x0b, 4
	p[14] = 2
	// Distinct first and last slots, plus sentinels outside the slot array.
	p[52], p[53], p[57], p[61] = 99, 17, 5, 91
	p[125], p[129], p[133], p[137] = 23, 7, 92, 88
	r, e := ParseExtendedTaskProgress(p)
	if e != nil || r.Key != 3001 || r.State != 4 {
		t.Fatal(r, e)
	}
	if r.DisplayMode != 2 || r.Conditions[0] != (ExtendedTaskCondition{17, 5, 91}) || r.Conditions[6] != (ExtendedTaskCondition{23, 7, 92}) || r.Conditions[1] != (ExtendedTaskCondition{}) || r.Raw[137] != 88 {
		t.Fatal("condition slot offsets", r)
	}
	r.Raw[16] = 0
	if p[16] != 4 {
		t.Fatal("aliases wire")
	}
	if _, e = ParseExtendedTaskProgress(p[:140]); e == nil {
		t.Fatal("short record accepted")
	}
	for _, id := range []uint32{6031, 6032, 6061, 6062, 6091, 6092, 6301, 6302} {
		p := []byte{0xb9, 0x0b, 3, 0xff}
		r, e := ParseExtendedTaskNotification(id, p)
		if e != nil || r.Key != 3001 || r.State != 3 || len(r.Raw) != 4 {
			t.Fatal(id, r, e)
		}
		r.Raw[3] = 0
		if p[3] != 255 {
			t.Fatal("aliases notification")
		}
		if _, e := ParseExtendedTaskNotification(id, p[:2]); e == nil {
			t.Fatal("short notification accepted")
		}
	}
	if _, e := ParseExtendedTaskNotification(6311, []byte{1, 2, 3}); e == nil {
		t.Fatal("request accepted as notification")
	}
}
