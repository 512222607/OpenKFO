package main

import (
	"encoding/hex"
	"strings"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestWeaponUpgradeResultDiagnostics(t *testing.T) {
	// Only success and instance have confirmed native meanings. Fill all
	// other bytes to show diagnostics do not mislabel them as balances/levels.
	p := make([]byte, 22)
	for i := range p {
		p[i] = 0xcc
	}
	protocol.WriteUint32(p, 9, 0xf1234567)
	for _, flag := range []byte{0, 1, 255} {
		p[0] = flag
		got := describe(protocol.Message{ID: 21413, Payload: p})
		want := "结果=成功"
		if flag == 0 {
			want = "结果=失败"
		}
		if !strings.Contains(got, want) || !strings.Contains(got, "实例=4045620583") {
			t.Fatalf("flag=%d: %s", flag, got)
		}
	}
	if got := describeWeaponUpgradeResult(append(p, p...)); !strings.Contains(got, "只处理首条") {
		t.Fatal(got)
	}
	for _, n := range []int{0, 1, 21, 23, 43} {
		if got := describeWeaponUpgradeResult(make([]byte, n)); !strings.Contains(got, "长度错误") {
			t.Fatal(n, got)
		}
	}
}

func TestWeaponLevelDiagnostics(t *testing.T) {
	// Deliberately unaligned DWORD at 17, nonzero unknown byte at 16.
	// Synthetic fixture, not captured official upgrade values.
	p, err := hex.DecodeString("00000000e8030000f40100004b000000a564000000")
	if err != nil {
		t.Fatal(err)
	}
	s := describe(protocol.Message{ID: 21411, Payload: p})
	for _, want := range []string{"配置 1 条", "等级=0", "阈值=1000", "金币=500", "成功率=75%", "0xA5", "原值=100"} {
		if !strings.Contains(s, want) {
			t.Fatalf("missing %q in %s", want, s)
		}
	}
	if strings.Contains(s, "风险") {
		t.Fatal(s)
	}
	for _, size := range []int{0, 1, 20, 22, 41} {
		if !strings.Contains(describeWeaponLevels(make([]byte, size)), "长度错误") {
			t.Fatalf("accepted length %d", size)
		}
	}
	s = describeWeaponLevels(make([]byte, 42))
	for _, want := range []string{"分母为0", "重复等级", "索引不一致"} {
		if !strings.Contains(s, want) {
			t.Fatal(s)
		}
	}
}
