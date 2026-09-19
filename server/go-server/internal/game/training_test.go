package game

import (
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestTrainingPreviewBounds(t *testing.T) {
	rules := persistence.TrainingSettings{Rules: persistence.TrainingRules{Enabled: true}}
	for i := uint32(0); i <= 8; i++ {
		rules.Rules.Levels = append(rules.Rules.Levels, persistence.TrainingRule{Level: i, XPPerHour: 1000000, XPCap: 2000000000})
	}
	for _, minutes := range []uint32{0, 59, 60, 119, 120, 120000, 35791394, 0xffffffff} {
		p, err := trainingStatus(0x123456789abcdef0, 8, minutes, true, rules)
		if err != nil {
			t.Fatal(err)
		}
		r, err := protocol.ParseTrainingStatus(p)
		if err != nil || r.UID != 0x123456789abcdef0 || r.Level != 8 || r.Active != 1 {
			t.Fatal(r, err)
		}
		product := uint64(r.Minutes/60) * uint64(r.RewardPerHour)
		if product > 0x7fffffff {
			t.Fatal("native signed overflow", product)
		}
		if product > uint64(r.RewardCap) {
			product = uint64(r.RewardCap)
		}
		if uint32(product) != rules.Rules.Levels[8].Award(minutes) {
			t.Fatal("preview disagrees with award", minutes, product)
		}
	}
	rules.Rules.Enabled = false
	p, err := trainingStatus(1, 0, 120, true, rules)
	r, _ := protocol.ParseTrainingStatus(p)
	if err != nil || r.RewardPerHour != 0 || r.RewardCap != 0 || r.Minutes != 120 {
		t.Fatal(r, err)
	}
	rules.Rules.Enabled = true
	rules.Rules.Levels[0].XPCap = 0x7fffffff
	if _, err := trainingStatus(1, 0, 60, true, rules); err == nil {
		t.Fatal("unrepresentable cap accepted")
	}
}
