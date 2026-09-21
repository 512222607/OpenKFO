package tunnel

import (
	"bytes"
	"testing"
)

func TestDatagramAuthenticationReplayAndReordering(t *testing.T) {
	g, e := NewDatagramGrant(19091)
	if e != nil {
		t.Fatal(e)
	}
	a, _ := NewDatagramCodec(g, false)
	b, _ := NewDatagramCodec(g, true)
	first, _ := a.Seal(123, []byte("first"))
	second, _ := a.Seal(123, []byte("second"))
	bad := bytes.Clone(second)
	bad[len(bad)-1] ^= 1
	if _, _, e = b.Open(bad); e == nil {
		t.Fatal("tampering accepted")
	}
	for _, p := range [][]byte{second, first} {
		port, _, e := b.Open(p)
		if e != nil || port != 123 {
			t.Fatal("reorder rejected", e)
		}
	}
	if _, _, e = b.Open(first); e == nil {
		t.Fatal("replay accepted")
	}
	if _, _, e = a.Open(second); e == nil {
		t.Fatal("reflection accepted")
	}
	reply, _ := b.Seal(321, []byte("reply"))
	port, data, e := a.Open(reply)
	if e != nil || port != 321 || string(data) != "reply" {
		t.Fatal(e)
	}
	old, _ := a.Seal(123, nil)
	var latest []byte
	for i := 0; i < 65; i++ {
		latest, _ = a.Seal(123, nil)
	}
	b.Open(latest)
	if _, _, e = b.Open(old); e == nil {
		t.Fatal("old packet accepted")
	}
	if _, e = a.Seal(123, make([]byte, DatagramLimit)); e == nil {
		t.Fatal("oversize accepted")
	}
	other, _ := NewDatagramGrant(19091)
	c, _ := NewDatagramCodec(other, true)
	if _, _, e = c.Open(second); e == nil {
		t.Fatal("wrong session accepted")
	}
}
