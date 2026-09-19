package main

import (
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestProfileDescriptionValidatesWireLength(t *testing.T) {
	if !strings.Contains(describe(protocol.Message{ID: 2421}), "过短") {
		t.Fatal("short response accepted")
	}
	p := make([]byte, 445)
	p[16] = 1
	p[139] = 1
	protocol.WriteUint64(p, 8, 10001)
	if !strings.Contains(describe(protocol.Message{ID: 2421, Payload: p}), "UID=10001") {
		t.Fatal("missing target")
	}
	p[16] = 2
	if !strings.Contains(describe(protocol.Message{ID: 2421, Payload: p}), "不一致") {
		t.Fatal("wrong count accepted")
	}
}
