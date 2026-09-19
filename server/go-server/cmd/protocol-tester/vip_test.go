package main

import (
	"encoding/hex"
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestVIPNativeLayout(t *testing.T) {
	p, _ := hex.DecodeString("04000000010000000200000003000000040000005000000006000000")
	r, e := protocol.ParseVIPStatus(p)
	if e != nil || r.Kind != 4 || r.Unknown != ([4]uint32{1, 2, 3, 4}) || r.ShopPercent != 80 || r.Tail != 6 {
		t.Fatal(r, e)
	}
	for _, bad := range [][]byte{nil, p[:27], append(append([]byte{}, p...), 0)} {
		if _, e := protocol.ParseVIPStatus(bad); e == nil {
			t.Fatal("bad length accepted")
		}
	}
	if text := describeVIP(protocol.Message{ID: 1038, Payload: p}); !strings.Contains(text, "铂金VIP") || !strings.Contains(text, "原值=80") {
		t.Fatal(text)
	}
}

func TestVIPLoginOffset(t *testing.T) {
	p := make([]byte, 37)
	p[32] = 99 // Adjacent byte is a separate login field.
	protocol.WriteUint32(p, 33, 3)
	if text := describe(protocol.Message{ID: 1020, Payload: p}); !strings.Contains(text, "VIP类型=3") {
		t.Fatal(text)
	}
	if text := describe(protocol.Message{ID: 1020, Payload: p[:36]}); !strings.Contains(text, "过短") {
		t.Fatal(text)
	}
}
