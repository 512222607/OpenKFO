package protocol

import (
	"bytes"
	"strings"
	"testing"
)

func TestMailRecordAndDetailNativeLayout(t *testing.T) {
	r := MailRecord{ID: 7, Title: "礼物", Sender: "sender", Body: "body", RemainingRaw: 30, Read: true, AttachmentKey: 19}
	p, err := r.Encode()
	if err != nil {
		t.Fatal(err)
	}
	want := make([]byte, 339)
	want[0] = 7
	copy(want[4:], []byte{0xc0, 0xf1, 0xce, 0xef})
	copy(want[83:], "sender")
	want[125] = 30
	copy(want[126:], "body")
	want[327] = 1
	want[331] = 19
	if !bytes.Equal(p, want) {
		t.Fatalf("wrong mail record %x", p)
	}
	catalog := make([]byte, 108)
	catalog[4] = 25
	catalog[5] = 42
	catalog[107] = 0xa5
	d := MailDetail{MailKey: 7, State: 1, AttachmentKey: 19, Gold: 3, Tickets: 4, Experience: 5, Reputation: 6, Catalog: catalog}
	q, err := d.Encode()
	if err != nil {
		t.Fatal(err)
	}
	header := []byte{7, 0, 0, 0, 1, 0, 0, 0, 19, 0, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0, 5, 0, 0, 0, 6, 0, 0, 0}
	if len(q) != 136 || !bytes.Equal(q[:28], header) || !bytes.Equal(q[28:], catalog) {
		t.Fatal("detail layout")
	}
	catalog[5] = 99
	if q[33] != 42 {
		t.Fatal("encoded packet aliases catalog")
	}
	for _, mutate := range []func(*MailRecord){func(r *MailRecord) { r.ID = 0 }, func(r *MailRecord) { r.Title = strings.Repeat("a", 21) }, func(r *MailRecord) { r.Sender = "a\x00b" }, func(r *MailRecord) { r.Body = strings.Repeat("a", 201) }, func(r *MailRecord) { r.Body = "😀" }} {
		x := r
		mutate(&x)
		if _, err := x.Encode(); err == nil {
			t.Fatal("unsafe text accepted")
		}
	}
	r.Body = strings.Repeat("a", 200)
	if _, err := r.Encode(); err != nil {
		t.Fatal(err)
	}
	for _, n := range []int{1, 107, 109} {
		d.Catalog = make([]byte, n)
		if _, err := d.Encode(); err == nil {
			t.Fatal("bad catalog length")
		}
	}
}

func TestMailActionOwnership(t *testing.T) {
	p := []byte{1, 0, 0, 0, 1, 0, 0, 0, 19, 0, 0, 0}
	if key, err := ParseMailAction(p, 4294967297); err != nil || key != 19 {
		t.Fatal(key, err)
	}
	for _, uid := range []uint64{0, 1, 4294967298} {
		if _, err := ParseMailAction(p, uid); err == nil {
			t.Fatal("wrong owner accepted")
		}
	}
	if _, err := ParseMailAction(p[:11], 4294967297); err == nil {
		t.Fatal("short request")
	}
	p[8] = 0
	if _, err := ParseMailAction(p, 4294967297); err == nil {
		t.Fatal("zero key")
	}
}
