package main

import (
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestRoomAnimationDiagnostic(t *testing.T) {
	p := []byte{42, 0, 0, 0, 7, 0, 0, 0, 255}
	text := describe(protocol.Message{ID: 3420, Payload: p})
	for _, want := range []string{"对象字段=42", "中间DWORD=7", "动作值=255", "未确认"} {
		if !strings.Contains(text, want) {
			t.Fatal(text)
		}
	}
	if !strings.Contains(describe(protocol.Message{ID: 3420, Payload: p[:8]}), "长度错误") {
		t.Fatal("truncation hidden")
	}
	if !strings.Contains(describe(protocol.Message{ID: 3410, Payload: p}), "请求结构未确认") {
		t.Fatal("invented request layout")
	}
}
