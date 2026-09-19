package persistence

import (
	"bytes"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestRoleManagerProgression(t *testing.T) {
	rules := RewardRules{GrowthEnabled: true}.Normalized()
	for i := range rules.Levels {
		rules.Levels[i].NextExperience = 100
	}
	role := RoleManager{}
	p := make([]byte, protocol.RoleProfileSize)
	if err := role.SetLevel(p, 1, 90); err != nil {
		t.Fatal(err)
	}
	change, err := role.AddExp(p, 220, rules)
	if err != nil || change.Before != 1 || change.After != 4 || protocol.ReadUint32(p, ExperienceOffset) != 10 {
		t.Fatalf("multi-level reward: %+v, %v", change, err)
	}
	if err := role.SetLevel(p, MaxRoleLevel-1, 90); err != nil {
		t.Fatal(err)
	}
	change, err = role.AddExp(p, 220, rules)
	if err != nil || change.After != MaxRoleLevel || protocol.ReadUint32(p, ExperienceOffset) != 210 {
		t.Fatalf("level cap: %+v, %v", change, err)
	}
	before := bytes.Clone(p)
	if err := role.SetLevel(p, MaxRoleLevel+1, 0); err == nil || !bytes.Equal(p, before) {
		t.Fatal("invalid level must fail without mutation")
	}
	change, err = role.AddExp(p, 10, RewardRules{})
	if err != nil || change.Before != change.After || protocol.ReadUint32(p, ExperienceOffset) != 220 {
		t.Fatalf("disabled growth: %+v, %v", change, err)
	}
}
