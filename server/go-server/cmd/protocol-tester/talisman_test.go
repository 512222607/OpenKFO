package main

import (
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestTalismanDiagnostics(t *testing.T) {
	p := make([]byte, 75)
	protocol.WriteUint32(p, 0, 8292)
	protocol.WriteUint32(p, 39, 38)
	protocol.WriteUint64(p, 59, 0x100000001)
	protocol.WriteUint32(p, 67, 12)
	protocol.WriteUint32(p, 71, 345)
	s := describe(protocol.Message{ID: 8071, Payload: p})
	for _, want := range []string{"8292", "槽位=38", "4294967297", "12/345", "不表示已扣除"} {
		if !strings.Contains(s, want) {
			t.Fatal(s)
		}
	}
	for id, size := range map[uint32]int{4201: 8, 4202: 4, 4204: 12} {
		for _, n := range []int{size - 1, size + 1} {
			if !strings.Contains(describe(protocol.Message{ID: id, Payload: make([]byte, n)}), "长度错误") {
				t.Fatal(id, n)
			}
		}
	}
	if !strings.Contains(describe(protocol.Message{ID: 4201, Payload: make([]byte, 8)}), "不可据此直接扣费") {
		t.Fatal("unsafe cost interpretation")
	}
}

func TestTalismanReplyBoundaries(t *testing.T) {
	for id, size := range map[uint32]int{4203: 32, 4205: 8, 4206: 12, 4207: 8} {
		s := describe(protocol.Message{ID: id, Payload: make([]byte, size-1)})
		if !strings.Contains(s, "过短") && !strings.Contains(s, "长度错误") {
			t.Fatal(id, s)
		}
	}
	p := make([]byte, 32)
	protocol.WriteUint32(p, 8, 603001)
	protocol.WriteUint32(p, 16, 5)
	protocol.WriteUint32(p, 20, 1234)
	protocol.WriteUint32(p, 24, 10000)
	s := describe(protocol.Message{ID: 4203, Payload: p})
	for _, want := range []string{"材料配置=603001", "材料数量原值=5", "当前额度原值=1234", "最大额度原值=10000"} {
		if !strings.Contains(s, want) {
			t.Fatal(s)
		}
	}
}
