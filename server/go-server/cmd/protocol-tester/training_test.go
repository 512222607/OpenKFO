package main

import (
	"encoding/hex"
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestTrainingNativeLayout(t *testing.T) {
	p, err := hex.DecodeString("88776655443322110200000003000000040000007800000006000000010000000800000064000000e80300000b0000000c0000000d000000")
	if err != nil {
		t.Fatal(err)
	}
	r, err := protocol.ParseTrainingStatus(p)
	if err != nil || r.UID != 0x1122334455667788 || r.Level != 2 || r.Minutes != 120 || r.Active != 1 || r.RewardPerHour != 100 || r.RewardCap != 1000 || r.BoxDisplay != 4 || r.Unknown12 != 3 || r.Unknown24 != 6 || r.Unknown32 != 8 || r.Tail != [3]uint32{11, 12, 13} {
		t.Fatalf("decoded=%+v error=%v", r, err)
	}
	for _, id := range []uint32{21001, 21005, 21007} {
		if got := describe(protocol.Message{ID: id, Payload: p}); !strings.Contains(got, "每小时经验=100") || !strings.Contains(got, "经验上限=1000") {
			t.Fatal(got)
		}
	}
	for _, n := range []int{0, 32, 55, 57} {
		if _, err := protocol.ParseTrainingStatus(make([]byte, n)); err == nil {
			t.Fatalf("accepted length %d", n)
		}
	}
}
