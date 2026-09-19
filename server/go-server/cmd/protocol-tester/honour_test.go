package main

import (
	"encoding/hex"
	"strings"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestHonourDiagnostics(t *testing.T) {
	// Explicit wire offsets: valid flag, 12 unknown bytes, rank, honour,
	// level, challenge count, wins, then a NUL-terminated description.
	p, err := hex.DecodeString("0100000000000000000000000000000007000000e8030000030000000a000000060000007465737400")
	if err != nil {
		t.Fatal(err)
	}
	text := describe(protocol.Message{ID: 20370, Payload: p})
	for _, want := range []string{"排名=7", "荣誉值=1000", "等级=3", "场次=10", "胜场=6", "60.0%", "test"} {
		if !strings.Contains(text, want) {
			t.Fatal(text)
		}
	}
	if got := describeHonour(p[:len(p)-1]); !strings.Contains(got, "NUL") {
		t.Fatal(got)
	}
	protocol.WriteUint32(p, 24, 11)
	if got := describeHonour(p); !strings.Contains(got, "图标范围") {
		t.Fatal(got)
	}
	protocol.WriteUint32(p, 24, 10)
	if got := describeHonour(p); strings.Contains(got, "风险") {
		t.Fatal(got)
	}
	protocol.WriteUint32(p, 20, 0x80000000)
	if got := describeHonour(p); !strings.Contains(got, "有符号范围") {
		t.Fatal(got)
	}
	protocol.WriteUint32(p, 20, 1000)
	protocol.WriteUint32(p, 32, 11)
	if got := describeHonour(p); !strings.Contains(got, "风险") {
		t.Fatal(got)
	}
	protocol.WriteUint32(p, 28, 0)
	protocol.WriteUint32(p, 32, 0)
	if got := describeHonour(p); !strings.Contains(got, "0.0%") {
		t.Fatal(got)
	}
	protocol.WriteUint32(p, 0, 0)
	if got := describeHonour(p); !strings.Contains(got, "清空该页") {
		t.Fatal(got)
	}
	for _, n := range []int{0, 1, 3} {
		if got := describeHonour(make([]byte, n)); !strings.Contains(got, "过短") {
			t.Fatal(got)
		}
	}
}
