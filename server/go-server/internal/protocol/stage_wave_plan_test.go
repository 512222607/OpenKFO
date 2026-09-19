package protocol

import "testing"

func TestStageWaveConfigurationBounds(t *testing.T) {
	valid := func() []StageWaveVariant {
		return []StageWaveVariant{{MinPlayers: 1, MaxPlayers: 8, Waves: []StageWavePlan{{Monsters: map[uint32]uint32{0: 4}}}}}
	}
	if e := ValidateStageWaveVariants(valid(), 1); e != nil {
		t.Fatal(e)
	}
	for _, name := range []string{"party", "overlap", "empty", "template", "count", "size"} {
		v := valid()
		switch name {
		case "party":
			v[0].MinPlayers = 0
		case "overlap":
			v = append(v, v[0])
		case "empty":
			v[0].Waves = nil
		case "template":
			v[0].Waves[0].Monsters = map[uint32]uint32{1: 1}
		case "count":
			v[0].Waves[0].Monsters[0] = 0
		case "size":
			v[0].Waves[0].Monsters[0] = 10001
		}
		if ValidateStageWaveVariants(v, 1) == nil {
			t.Fatal("accepted", name)
		}
	}
}
