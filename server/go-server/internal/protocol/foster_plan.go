package protocol

import (
	"fmt"
	"math"
)

type FosterSpawn struct {
	Template  uint32     `json:"template"`
	Position  [3]float32 `json:"position"`
	Direction uint32     `json:"direction"`
}

// Each verified group currently contains one ordered sub-list. Groups are
// concurrent, not StageAssault waves. Global/group limits also count corpses.
type FosterGroup struct {
	Spawns     []FosterSpawn `json:"spawns"`
	SubLimit   uint32        `json:"sub_limit"`
	GroupLimit uint32        `json:"group_limit"`
	TriggerBox [6]float32    `json:"trigger_box"`
	Block      uint32        `json:"block,omitempty"`
}

type FosterPlan struct {
	InitialHP   []float32     `json:"initial_hp,omitempty"` // Native template index, not display units.
	Groups      []FosterGroup `json:"groups"`
	GlobalLimit uint32        `json:"global_limit"`
	PlayerLimit uint32        `json:"player_limit"`
}

// These bounds protect configuration and the native six-player/100-identity
// layout. Validation is not evidence that an arbitrary Lua script is supported.
func (p FosterPlan) Validate(templateCount int) error {
	if templateCount < 1 || templateCount > 1024 || p.PlayerLimit < 1 || p.PlayerLimit > 6 || p.GlobalLimit < 1 || p.GlobalLimit > 100 || len(p.Groups) == 0 || len(p.Groups) > 256 {
		return fmt.Errorf("模式10计划人数、怪物容量或事件组无效")
	}
	finite := func(v float32) bool { return !math.IsNaN(float64(v)) && !math.IsInf(float64(v), 0) }
	// Old saved plans remain readable; battle preparation requires the new data.
	if len(p.InitialHP) != 0 && len(p.InitialHP) != templateCount {
		return fmt.Errorf("模式10血量目录与模板数量不一致")
	}
	for _, hp := range p.InitialHP {
		if !finite(hp) || hp <= 0 {
			return fmt.Errorf("模式10怪物初始血量必须是有限正数")
		}
	}
	blocks := map[uint32]bool{}
	total := 0
	for _, group := range p.Groups {
		total += len(group.Spawns)
		if len(group.Spawns) == 0 || total > 10000 || group.SubLimit < 1 || group.SubLimit > group.GroupLimit || group.GroupLimit > p.GlobalLimit {
			return fmt.Errorf("模式10怪物数量或生成上限无效")
		}
		if group.Block != 0 {
			if blocks[group.Block] {
				return fmt.Errorf("模式10事件组重复管理同一阻挡")
			}
			blocks[group.Block] = true
		}
		for i := 0; i < 3; i++ {
			if !finite(group.TriggerBox[i]) || !finite(group.TriggerBox[i+3]) || group.TriggerBox[i] > group.TriggerBox[i+3] {
				return fmt.Errorf("模式10触发区域无效")
			}
		}
		for _, spawn := range group.Spawns {
			if spawn.Template >= uint32(templateCount) {
				return fmt.Errorf("模式10怪物模板索引越界")
			}
			for _, v := range spawn.Position {
				if !finite(v) {
					return fmt.Errorf("模式10怪物位置无效")
				}
			}
		}
	}
	return nil
}
