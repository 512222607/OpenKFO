package main

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestRoomSettingsNativeBoundaries(t *testing.T) {
	for _, tc := range []struct {
		id   uint32
		n    int
		want string
	}{
		{21370, 0, "初始化"}, {21370, 1, "长度错误"},
		{21371, 7, "长度错误"}, {21371, 8, "两个DWORD"}, {21371, 9, "长度错误"},
		{21372, 23, "长度错误"}, {21372, 48, "记录数=2"},
		{21373, 0, "过短"}, {21373, 403, "过短"}, {21373, 404, "至少404"},
		{21374, 403, "过短"}, {21374, 404, "至少404"},
	} {
		got := describe(protocol.Message{ID: tc.id, Payload: make([]byte, tc.n)})
		if !strings.Contains(got, tc.want) {
			t.Fatalf("%d/%d: %s", tc.id, tc.n, got)
		}
	}
}

func TestExchangeReplyNotStageAcknowledgement(t *testing.T) {
	p := make([]byte, 8)
	protocol.WriteUint32(p, 4, 12345)
	got := describe(protocol.Message{ID: 21371, Payload: p})
	if !strings.Contains(got, "物品兑换面板") || !strings.Contains(got, "整数除100=123") {
		t.Fatal(got)
	}
	if got := describe(protocol.Message{ID: 21370}); strings.Contains(got, "响应族21371") {
		t.Fatal("unproven request/reply pairing", got)
	}
}

func TestRoomSettingsTextTermination(t *testing.T) {
	for _, id := range []uint32{21373, 21374} {
		p := bytes.Repeat([]byte{'1'}, 405)
		p[404] = 0
		if got := describe(protocol.Message{ID: id, Payload: p}); !strings.Contains(got, "缺少结束符") {
			t.Fatal("terminator outside copied record admitted", got)
		}
		p = make([]byte, 404)
		copy(p[4:], "1,2,3,")
		if got := describe(protocol.Message{ID: id, Payload: p}); !strings.Contains(got, "原生分割项=3") {
			t.Fatal(got)
		}
		p[9] = 0
		if got := describe(protocol.Message{ID: id, Payload: p}); !strings.Contains(got, "末项无逗号") {
			t.Fatal(got)
		}
	}
}

func TestStageProgressNativeSideEffects(t *testing.T) {
	p := make([]byte, 404)
	got := describe(protocol.Message{ID: 21373, Payload: p})
	if !strings.Contains(got, "不能据此认定旧解锁已撤销") {
		t.Fatal(got)
	}
	copy(p[4:], "8110,")
	got = describe(protocol.Message{ID: 21373, Payload: p})
	if strings.Contains(got, "空分割列表") {
		t.Fatal(got)
	}
	got = describe(protocol.Message{ID: 21374, Payload: p})
	if !strings.Contains(got, "关卡开启提示") {
		t.Fatal(got)
	}
}
