package persistence

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestRewardProgressFailureDoesNotMutate(t *testing.T) {
	for _, gold := range []bool{false, true} {
		p := bytes.Repeat([]byte{0}, 360)
		protocol.WriteUint32(p, ExperienceOffset, 0x7fffffff)
		before := bytes.Clone(p)
		balance := uint64(0)
		xp, g := uint32(1), uint32(0)
		if gold {
			balance = 0xffffffff
			xp = 0
			g = 1
		}
		if _, e := creditRewardProgress(p, balance, xp, g, RewardRules{}); e == nil {
			t.Fatal("overflow accepted")
		}
		if !bytes.Equal(p, before) {
			t.Fatal("failed reward mutated profile")
		}
	}
}
func TestRewardProgressPreservesUnrelatedFields(t *testing.T) {
	p := bytes.Repeat([]byte{0x55}, 360)
	protocol.WriteUint32(p, ExperienceOffset, 10)
	protocol.WriteUint32(p, ExperienceOffset+4, 0x7ffffffe)
	before := bytes.Clone(p)
	balance, e := creditRewardProgress(p, 50, 5, 7, RewardRules{})
	if e != nil || balance != 57 || protocol.ReadUint32(p, ExperienceOffset) != 15 || protocol.ReadUint32(p, ExperienceOffset+4) != 0x7fffffff {
		t.Fatal(balance, e)
	}
	copy(before[ExperienceOffset:ExperienceOffset+8], p[ExperienceOffset:ExperienceOffset+8])
	if !bytes.Equal(p, before) {
		t.Fatal("reward changed unrelated profile fields")
	}
}
