package game

import (
	"encoding/json"
	"testing"
)

func TestStageWavePlayerVariants(t *testing.T) {
	var c Config
	err := json.Unmarshal([]byte(`{"stage_waves":{"77":[{"monsters":{"3":99}}]},"stage_wave_variants":{"77":[{"min_players":1,"max_players":2,"waves":[{"monsters":{"3":4}}]},{"min_players":3,"max_players":4,"waves":[{"monsters":{"3":6}}]},{"min_players":5,"max_players":6,"waves":[{"monsters":{"3":8}}]}]}}`), &c)
	if err != nil {
		t.Fatal(err)
	}
	for players, want := range map[int]uint32{1: 4, 2: 4, 3: 6, 4: 6, 5: 8, 6: 8} {
		plan, err := c.stagePlan(77, players)
		if err != nil || plan.plans[0].Monsters[3] != want {
			t.Fatal("wrong range selected", players, err)
		}
		plan.plans[0].Monsters[3] = 1000
		again, err := c.stagePlan(77, players)
		if err != nil || again.plans[0].Monsters[3] != want {
			t.Fatal("battle mutated shared config")
		}
	}
	for _, players := range []int{0, 7, 8, 9} {
		if _, err := c.stagePlan(77, players); err == nil {
			t.Fatal("unsupported party fell back to flat plan", players)
		}
	}
	delete(c.StageWaveVariants, 77)
	if p, err := c.stagePlan(77, 1); err != nil || p.plans[0].Monsters[3] != 99 {
		t.Fatal("legacy flat plan lost", err)
	}
	c.StageWaveVariants[77] = nil
	if _, err := c.stagePlan(77, 1); err == nil {
		t.Fatal("explicit empty variants fell back")
	}
}

func TestStageWaveRejectsAmbiguousOrInvalidVariants(t *testing.T) {
	valid := []StageWavePlan{{Monsters: map[uint32]uint32{7: 1}}}
	for _, variants := range [][]StageWaveVariant{
		{{MinPlayers: 0, MaxPlayers: 2, Waves: valid}},
		{{MinPlayers: 2, MaxPlayers: 1, Waves: valid}},
		{{MinPlayers: 1, MaxPlayers: 9, Waves: valid}},
		{{MinPlayers: 1, MaxPlayers: 2, Waves: valid}, {MinPlayers: 2, MaxPlayers: 4, Waves: valid}},
		{{MinPlayers: 1, MaxPlayers: 2, Waves: valid}, {MinPlayers: 3, MaxPlayers: 4}},
	} {
		c := Config{StageWaveVariants: map[uint32][]StageWaveVariant{77: variants}}
		if _, err := c.stagePlan(77, 1); err == nil {
			t.Fatal("invalid variant accepted")
		}
	}
}
