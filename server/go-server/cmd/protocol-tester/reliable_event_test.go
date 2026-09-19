package main

import (
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestReliableEventNativeLayouts(t *testing.T) {
	for _, kind := range []uint32{9000, 9001, 9002, 9500, 9501, 9502} {
		size := 55
		if kind < 9500 {
			size = 63
		}
		p := make([]byte, size)
		protocol.WriteUint32(p, 0, kind)
		protocol.WriteUint64(p, 4, 0x100000001)
		protocol.WriteUint64(p, 39, 0x200000002)
		protocol.WriteUint32(p, 47, 123)
		protocol.WriteUint32(p, 51, 456)
		if size == 63 {
			protocol.WriteUint32(p, 55, 7)
			protocol.WriteUint32(p, 59, 9)
		}
		r, err := protocol.ParseReliableEvent(p)
		if err != nil || r.Sender != 0x100000001 || r.Actor != 0x200000002 || r.ObjectKey != 123 || r.Flag51 != 456 || r.HasContext != (size == 63) {
			t.Fatal(r, err)
		}
		if size == 63 && r.Context != [2]uint32{7, 9} {
			t.Fatal(r)
		}
		text := describe(protocol.Message{ID: 8071, Payload: p})
		if !strings.Contains(text, "4294967297") || !strings.Contains(text, "8589934594") {
			t.Fatal(text)
		}
		if !strings.Contains(text, "对象键=123") || !strings.Contains(text, "状态值超出") {
			t.Fatal(text)
		}
		for _, flag := range []uint32{0, 1} {
			protocol.WriteUint32(p, 51, flag)
			if strings.Contains(describeReliableEvent(p), "状态值超出") {
				t.Fatal("valid native flag warned")
			}
		}
		for _, bad := range [][]byte{p[:size-1], append(append([]byte{}, p...), 0)} {
			if _, err := protocol.ParseReliableEvent(bad); err == nil {
				t.Fatal("wrong length accepted")
			}
			if !strings.Contains(describeReliableEvent(bad), "格式错误") {
				t.Fatal("missing diagnostic")
			}
		}
	}
	for n := 0; n < 4; n++ {
		if _, err := protocol.ParseReliableEvent(make([]byte, n)); err == nil {
			t.Fatal("short accepted")
		}
	}
	if _, err := protocol.ParseReliableEvent(make([]byte, 63)); err == nil {
		t.Fatal("unknown accepted")
	}
}
