package protocol

import (
	"bytes"
	"testing"
)

func TestNativeGiftLayout(t *testing.T) {
	p := make([]byte, 426)
	p[0] = 109
	copy(p[54:62], []byte{1, 0, 0, 0, 1, 0, 0, 0})
	copy(p[83:104], []byte{0xb2, 0xe2, 0xca, 0xd4, 0}) // 测试 in GBK.
	p[145] = 77
	p[157] = 23
	p[165] = 4
	p[169] = 2
	copy(p[170:], []byte("hello"))
	r, err := ParseGiftRequest(p)
	if err != nil || r.Currency != 109 || r.RecipientUID != 4294967297 || r.RecipientName != "测试" || r.CatalogKey != 77 || r.TicketPrice != 23 || r.CatalogField77 != 4 || r.Flag169 != 2 || r.Text != "hello" {
		t.Fatalf("%+v %v", r, err)
	}
	for _, mutate := range []func([]byte) []byte{
		func(p []byte) []byte { return p[:425] },
		func(p []byte) []byte { return append(p, 0) },
		func(p []byte) []byte { copy(p[83:104], bytes.Repeat([]byte{'a'}, 21)); return p },
		func(p []byte) []byte { p[83] = 0; return p },
		func(p []byte) []byte { p[83] = 0x81; p[84] = 0; return p },
		func(p []byte) []byte { copy(p[170:], bytes.Repeat([]byte{'a'}, 256)); return p },
	} {
		if _, err := ParseGiftRequest(mutate(bytes.Clone(p))); err == nil {
			t.Fatal("invalid native gift accepted")
		}
	}
	// Directory misses leave the target UID zero; name resolution belongs to the server.
	clear(p[54:62])
	if _, err := ParseGiftRequest(p); err != nil {
		t.Fatal(err)
	}
}
