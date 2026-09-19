package persistence

import (
	"fmt"
	"strings"
)

// Explicit local policy; no ordinary match is counted without configured modes.
type HonourRules struct {
	LevelPoints []uint32 `json:"level_points,omitempty"`
	Periods     []string `json:"periods"`
	Modes       []byte   `json:"modes"`
	Win         uint32   `json:"win_points"`
	Loss        uint32   `json:"loss_points"`
	Draw        uint32   `json:"draw_points"`
}

func (h HonourRules) Validate() error {
	if len(h.LevelPoints) > 10 || (len(h.LevelPoints) > 0 && len(h.Periods) == 0) {
		return fmt.Errorf("honour levels require periods and at most 10 thresholds")
	}
	for i, points := range h.LevelPoints {
		if points > 0x7fffffff || (i > 0 && points <= h.LevelPoints[i-1]) {
			return fmt.Errorf("honour level thresholds must increase within INT32_MAX")
		}
	}
	if len(h.Periods) > 1024 || h.Win > 0x7fffffff || h.Loss > 0x7fffffff || h.Draw > 0x7fffffff {
		return fmt.Errorf("invalid honour rules")
	}
	if len(h.Modes) > 0 && len(h.Periods) == 0 {
		return fmt.Errorf("honour modes require a period")
	}
	seen := map[byte]bool{}
	for _, m := range h.Modes {
		if m > 3 || seen[m] {
			return fmt.Errorf("invalid honour mode")
		}
		seen[m] = true
	}
	for _, name := range h.Periods {
		b := GBK(name)
		decoded, err := DecodeGBK(b)
		if err != nil || decoded != name || len(b) == 0 || len(b) > 200 || strings.TrimSpace(name) != name {
			return fmt.Errorf("invalid honour period name")
		}
	}
	return nil
}
func (h HonourRules) Award(mode byte, outcome string, players int) (uint32, uint32) {
	if len(h.Periods) == 0 || players < 2 || outcome == "unconfirmed" {
		return 0, 0
	}
	for _, m := range h.Modes {
		if m == mode {
			switch outcome {
			case "win":
				return uint32(len(h.Periods)), h.Win
			case "loss":
				return uint32(len(h.Periods)), h.Loss
			case "draw":
				return uint32(len(h.Periods)), h.Draw
			}
		}
	}
	return 0, 0
}

// Current native BattleLevel00..BattleLevel010 images support levels 0..10.
// These configurable thresholds are a server policy, not the original curve.
func (h HonourRules) Level(points uint32) uint32 {
	var level uint32
	for i, threshold := range h.LevelPoints {
		if i >= 10 || points < threshold {
			break
		}
		level = uint32(i + 1)
	}
	return level
}
