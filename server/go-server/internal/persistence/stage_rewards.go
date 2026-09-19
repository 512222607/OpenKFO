package persistence

import "fmt"

// Stage rewards are explicit emulator configuration, not reconstructed prices.
type StageReward struct {
	RewardBundle
	Experience uint32 `json:"experience"`
}

type StageMapRewards struct {
	MapID  uint32      `json:"map_id"`
	Clear  StageReward `json:"clear"`
	Failed StageReward `json:"failed"`
}

func validateStageRewards(rules []StageMapRewards) error {
	if len(rules) > 256 {
		return fmt.Errorf("关卡奖励最多配置256张地图")
	}
	seen := map[uint32]bool{}
	for _, rule := range rules {
		if rule.MapID == 0 || seen[rule.MapID] {
			return fmt.Errorf("关卡奖励地图编号必须非零且不重复")
		}
		seen[rule.MapID] = true
		for _, reward := range []StageReward{rule.Clear, rule.Failed} {
			if reward.Experience > 1000000 {
				return fmt.Errorf("关卡经验奖励须为0–1000000")
			}
			if err := reward.RewardBundle.Validate(); err != nil {
				return err
			}
		}
	}
	return nil
}

func (r RewardRules) StageReward(mapID uint32, outcome string) (StageReward, bool) {
	for _, rule := range r.StageRewards {
		if rule.MapID != mapID {
			continue
		}
		switch outcome {
		case StageOutcomeClear:
			return rule.Clear, true
		case StageOutcomeFailed:
			return rule.Failed, true
		}
	}
	return StageReward{}, false
}
