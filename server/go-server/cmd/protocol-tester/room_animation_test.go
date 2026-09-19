package main

import (
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestBattlePoseDiagnostic(t *testing.T) {
	p := []byte{42, 0, 0, 0, 1, 0, 0, 0, 3}
	text := describe(protocol.Message{ID: protocol.MsgBattlePose, Payload: p})
	if !strings.Contains(text, "UID=4294967338") || !strings.Contains(text, "姿态原值=3") {
		t.Fatal(text)
	}
	for _, bad := range [][]byte{p[:8], append(p, 0), {42, 0, 0, 0, 1, 0, 0, 0, 4}} {
		if !strings.Contains(describe(protocol.Message{ID: protocol.MsgBattlePose, Payload: bad}), "无效") {
			t.Fatal("invalid pose accepted")
		}
	}
	if !strings.Contains(describe(protocol.Message{ID: protocol.MsgBattlePoseRequest, Payload: p}), "结构未确认") {
		t.Fatal("invented request layout")
	}
}

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
