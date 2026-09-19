package main

import (
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestStageWaveDiagnostic(t *testing.T) {
	p := make([]byte, 40)
	protocol.WriteUint32(p, 8, 0xffffffff)
	protocol.WriteUint32(p, 12, 1)
	if text := describe(protocol.Message{ID: 20571, Payload: p}); !strings.Contains(text, "波次=-1") || !strings.Contains(text, "报告字段=1") {
		t.Fatal(text)
	}
	if text := describe(protocol.Message{ID: 20572, Payload: p}); !strings.Contains(text, "波次=-1") {
		t.Fatal(text)
	}
	event := make([]byte, 47)
	protocol.WriteUint32(event, 0, 20407)
	protocol.WriteUint64(event, 4, 123)
	protocol.WriteUint64(event, 39, 456)
	if text := describe(protocol.Message{ID: 8071, Payload: event}); !strings.Contains(text, "申报UID=123") || !strings.Contains(text, "上下文原值=456") {
		t.Fatal(text)
	}
	for _, m := range []protocol.Message{{ID: 20571, Payload: p[:39]}, {ID: 20572, Payload: p[:39]}, {ID: 8071, Payload: event[:46]}} {
		if !strings.Contains(describe(m), "长度错误") {
			t.Fatal("malformed packet described as valid")
		}
	}
}

func TestPVEActorDiagnostic(t *testing.T) {
	for _, tc := range []struct {
		id   uint32
		size int
	}{{20400, 67}, {20401, 47}} {
		p := make([]byte, tc.size)
		protocol.WriteUint32(p, 0, tc.id)
		protocol.WriteUint64(p, 4, 123)
		protocol.WriteUint64(p, 39, 456)
		text := describe(protocol.Message{ID: 8071, Payload: p})
		if !strings.Contains(text, "申报UID=123") || !strings.Contains(text, "实体=456") {
			t.Fatal(text)
		}
		bad := describe(protocol.Message{ID: 8071, Payload: p[:len(p)-1]})
		if !strings.Contains(bad, "错误") && !strings.Contains(bad, "无效") {
			t.Fatal(bad)
		}
	}
}
