package protocol

import "fmt"

// StageWavePlan uses the native sorted name-vector index, not a model ID.
type StageWavePlan struct {
	Monsters map[uint32]uint32 `json:"monsters"`
}
type StageWaveVariant struct {
	MinPlayers int             `json:"min_players"`
	MaxPlayers int             `json:"max_players"`
	Waves      []StageWavePlan `json:"waves"`
}

// ValidateStageWaveVariants bounds imported configuration before storing it.
// Missing party sizes are allowed, but never overlap or silently fall back.
func ValidateStageWaveVariants(variants []StageWaveVariant, templates int) error {
	if len(variants) == 0 || len(variants) > 8 || templates < 1 || templates > 1024 {
		return fmt.Errorf("invalid stage wave catalogue size")
	}
	var covered [9]bool
	for _, v := range variants {
		if v.MinPlayers < 1 || v.MaxPlayers > 8 || v.MinPlayers > v.MaxPlayers || len(v.Waves) == 0 || len(v.Waves) > 256 {
			return fmt.Errorf("invalid stage party range or wave count")
		}
		for n := v.MinPlayers; n <= v.MaxPlayers; n++ {
			if covered[n] {
				return fmt.Errorf("overlapping stage party ranges")
			}
			covered[n] = true
		}
		for _, w := range v.Waves {
			if len(w.Monsters) == 0 || len(w.Monsters) > templates {
				return fmt.Errorf("invalid stage monster set")
			}
			var total uint64
			for id, count := range w.Monsters {
				if id >= uint32(templates) || count == 0 {
					return fmt.Errorf("invalid stage template or count")
				}
				total += uint64(count)
			}
			if total > 10000 {
				return fmt.Errorf("stage wave exceeds monster limit")
			}
		}
	}
	return nil
}
