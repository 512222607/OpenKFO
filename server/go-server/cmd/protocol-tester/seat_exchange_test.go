package main

import (
	"encoding/hex"
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestDescribeSeatExchange(t *testing.T) {
	p, _ := hex.DecodeString("ffffffffffffffff01000000010000000200000007000000")
	s := describe(protocol.Message{ID: 3261, Payload: p})
	for _, want := range []string{"18446744073709551615", "4294967297", "原座位=2", "目标座位=7"} {
		if !strings.Contains(s, want) {
			t.Fatalf("missing %s: %s", want, s)
		}
	}
	for _, size := range []int{0, 23, 25} {
		if !strings.Contains(describe(protocol.Message{ID: 3265, Payload: make([]byte, size)}), "长度错误") {
			t.Fatal("accepted malformed swap")
		}
	}
	if !strings.Contains(describe(protocol.Message{ID: 3264}), "撤销") {
		t.Fatal("missing cancellation")
	}
}
