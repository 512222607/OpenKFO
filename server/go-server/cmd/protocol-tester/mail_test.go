package main

import (
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestMailDiagnostics(t *testing.T) {
	renewal := make([]byte, 124)
	protocol.WriteUint32(renewal, 8, 42)
	protocol.WriteUint32(renewal, 21, 253001)
	if s := describe(protocol.Message{ID: 1410, Payload: renewal}); !strings.Contains(s, "续费候选") || !strings.Contains(s, "库存实例=42") || !strings.Contains(s, "物品ID=253001") {
		t.Fatal(s)
	}
	for _, entry := range []struct {
		id   uint32
		size int
	}{{1310, 339}, {1410, 124}} {
		p := make([]byte, entry.size*2)
		p[0] = 7
		copy(p[entry.size:], []byte{255, 255, 255, 255})
		s := describe(protocol.Message{ID: entry.id, Payload: p})
		if !strings.Contains(s, "2条") || !strings.Contains(s, "4294967295") {
			t.Fatal(s)
		}
		if !strings.Contains(describe(protocol.Message{ID: entry.id, Payload: p[:len(p)-1]}), "长度错误") {
			t.Fatal("truncation accepted")
		}
		if !strings.Contains(describe(protocol.Message{ID: entry.id}), "0条") {
			t.Fatal("empty list rejected")
		}
	}
	for _, entry := range []struct {
		id   uint32
		size int
	}{{1330, 136}, {1350, 5}} {
		if !strings.Contains(describe(protocol.Message{ID: entry.id, Payload: make([]byte, entry.size-1)}), "过短") {
			t.Fatal("short unsafe consumer packet")
		}
	}
	if s := describe(protocol.Message{ID: 1350, Payload: []byte{1, 0x78, 0x56, 0x34, 0x12}}); !strings.Contains(s, "305419896") {
		t.Fatal(s)
	}
}
