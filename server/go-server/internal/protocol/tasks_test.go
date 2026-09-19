package protocol

import "testing"

func TestTaskNotifications(t *testing.T) {
	for _, id := range []uint32{6030, 6040, 6060, 6090} {
		offset := 12
		if id == 6040 {
			offset = 4
		}
		for n := 0; n < offset+2; n++ {
			if _, err := ParseTaskNotification(id, make([]byte, n)); err == nil {
				t.Fatalf("accepted truncated %d/%d", id, n)
			}
		}
		p := make([]byte, offset+5)
		p[offset], p[offset+1], p[len(p)-1] = 0x34, 0x12, 0xab
		r, err := ParseTaskNotification(id, p)
		if err != nil || r.Key != 0x1234 || len(r.Raw) != len(p) || r.Raw[len(p)-1] != 0xab {
			t.Fatal(id, r, err)
		}
		p[offset] = 0
		if r.Raw[offset] != 0x34 {
			t.Fatal("notification aliases input")
		}
		// Unknown keys remain visible for diagnostics, never authorized for sending.
		if r, err = ParseTaskNotification(id, make([]byte, offset+2)); err != nil || r.Key != 0 {
			t.Fatal(r, err)
		}
	}
	if _, err := ParseTaskNotification(6050, make([]byte, 14)); err == nil {
		t.Fatal("request treated as notification")
	}
}

func TestTaskProgressEncoding(t *testing.T) {
	r := TaskProgress{Unknown0: 7, Key: 1001, State: 2}
	r.ProfileBaseline[0], r.ProfileBaseline[28] = 50, 99
	p, err := EncodeTaskProgress([]TaskProgress{r})
	if err != nil || len(p) != 123 || p[4] != 0xe9 || p[5] != 3 || p[6] != 2 || p[7] != 50 || p[119] != 99 {
		t.Fatal(p, err)
	}
	decoded, err := ParseTaskProgress(p)
	if err != nil || decoded != r {
		t.Fatal(decoded, err)
	}
	p, err = EncodeTaskProgress(nil)
	if err != nil || len(p) != 7 {
		t.Fatal(p, err)
	}
	for _, rows := range [][]TaskProgress{{r, r}, {{Key: 0, State: 1}}, {{Key: 1, State: 4}}, make([]TaskProgress, 513)} {
		if _, err := EncodeTaskProgress(rows); err == nil {
			t.Fatal("invalid list accepted")
		}
	}
}
