package main

import (
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestRoomMemberDiagnostics(t *testing.T) {
	p := make([]byte, 149)
	p[0] = 42
	p[8] = 8
	p[76] = 1
	for _, id := range []uint32{3090, 3105} {
		s := describe(protocol.Message{ID: id, Payload: p})
		if !strings.Contains(s, "UID=42 观战 槽位=8 装备=0") {
			t.Fatal(s)
		}
	}
	if s := describe(protocol.Message{ID: 3090, Payload: append(p, p...)}); !strings.Contains(s, "长度错误") {
		t.Fatal(s)
	}
	if s := describe(protocol.Message{ID: 3130, Payload: protocol.Uint64Bytes(42)}); !strings.Contains(s, "UID=42") {
		t.Fatal(s)
	}
	if s := describe(protocol.Message{ID: 3130, Payload: make([]byte, 7)}); !strings.Contains(s, "长度错误") {
		t.Fatal(s)
	}
}
