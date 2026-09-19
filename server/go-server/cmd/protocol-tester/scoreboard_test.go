package main

import (
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestScoreboardDiagnostic(t *testing.T) {
	p := make([]byte, 334)
	copy(p, []byte{0xdb, 0x1f, 0, 0}) // 8155, independent wire fixture.
	copy(p[39:46], []byte{1, 2, 3, 4, 5, 6, 7})
	copy(p[46:54], []byte{0xff, 0xff, 0xff, 0xff, 0, 0, 0, 0})
	p[54] = 17
	p[82] = 42
	p[298] = 99 // last slot starts at 46+7*36, not at the envelope end.
	p[330] = 7
	got := describe(protocol.Message{ID: 8071, Payload: p})
	for _, want := range []string{"汇总原始值=01020304050607", "槽0 UID=4294967295 DWORD[8,12]=[17,0]", "槽1 UID=42", "槽7 UID=99", "WORD[32]=7"} {
		if !strings.Contains(got, want) {
			t.Fatalf("missing %q: %s", want, got)
		}
	}
	for _, n := range []int{0, 39, 333, 335} {
		if !strings.Contains(describeScoreboard(make([]byte, n)), "长度错误") {
			t.Fatalf("accepted length %d", n)
		}
	}
}
