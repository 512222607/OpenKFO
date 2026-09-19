package main

import (
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestBattleStartDiagnostic(t *testing.T) {
	p := make([]byte, 53)
	protocol.WriteUint32(p, 0, 9)
	protocol.WriteUint16(p, 11, 3)
	protocol.WriteUint32(p, 41, 350)
	text := describe(protocol.Message{ID: 4080, Payload: p})
	for _, want := range []string{"房间=9", "主控槽位=3", "[0 0 0 0 0 0 0 350]", "0表示未测量"} {
		if !strings.Contains(text, want) {
			t.Fatal(text)
		}
	}
	for _, id := range []uint32{4140, 4150} {
		if !strings.Contains(describe(protocol.Message{ID: id, Payload: []byte{1}}), "长度错误") {
			t.Fatal(id)
		}
	}
	if !strings.Contains(describe(protocol.Message{ID: 4080, Payload: p[:52]}), "长度错误") {
		t.Fatal("short packet accepted")
	}
}
