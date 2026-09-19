package persistence

import (
	"encoding/hex"
	"fmt"
	"strings"
	"unicode/utf8"
)

// Extended tasks have their own catalogue binding: their native 141B records
// and conditions are incompatible with BaseQuest. Rewards are server policy.
type ExtendedTaskRequirement struct {
	Event    string `json:"event,omitempty"`
	Key      uint32 `json:"key"`
	Required uint16 `json:"required"`
}

type ExtendedTaskCatalogueEntry struct {
	Name       string                    `json:"name,omitempty"`
	Kind       string                    `json:"kind"`
	ID         uint16                    `json:"id"`
	Conditions []ExtendedTaskRequirement `json:"conditions"`
}

type ExtendedTaskRule struct {
	Kind          string `json:"kind"`
	ID            uint16 `json:"id"`
	Enabled       bool   `json:"enabled"`
	Experience    uint32 `json:"experience"`
	Gold          uint32 `json:"gold"`
	RewardCatalog uint32 `json:"reward_catalog,omitempty"`
}

type ExtendedTaskRules struct {
	ClientHash string                       `json:"client_hash"`
	Catalogue  []ExtendedTaskCatalogueEntry `json:"catalogue"`
	Tasks      []ExtendedTaskRule           `json:"tasks"`
}

func (r ExtendedTaskRules) Validate() error {
	hash, err := hex.DecodeString(r.ClientHash)
	if err != nil || len(hash) != 32 || strings.ToLower(r.ClientHash) != r.ClientHash || len(r.Catalogue) == 0 || len(r.Catalogue) > 1024 || len(r.Tasks) > 1024 {
		return fmt.Errorf("每日/新手任务需要客户端SHA256和1至1024项目录")
	}
	catalogue := map[uint16]ExtendedTaskCatalogueEntry{}
	for _, entry := range r.Catalogue {
		if !utf8.ValidString(entry.Name) || utf8.RuneCountInString(entry.Name) > 128 {
			return fmt.Errorf("任务名称过长或编码无效")
		}
		if (entry.Kind != "daily" && entry.Kind != "newbie") || (entry.Kind == "daily" && (entry.ID < 2000 || entry.ID > 3000)) || (entry.Kind == "newbie" && entry.ID <= 3000) {
			return fmt.Errorf("每日/新手任务类别与编号不匹配")
		}
		if _, exists := catalogue[entry.ID]; exists || len(entry.Conditions) != 3 {
			return fmt.Errorf("任务目录编号重复或条件不是3项")
		}
		keys := map[uint32]bool{}
		for _, condition := range entry.Conditions {
			if !validExtendedTaskEvent(condition.Event) || (condition.Required == 0 && condition.Event != "") {
				return fmt.Errorf("任务条件事件无效")
			}
			if condition.Required == 0 {
				continue
			}
			// Zero is a valid native training key when the requirement is >0.
			if keys[condition.Key] {
				return fmt.Errorf("任务有效条件编号重复")
			}
			keys[condition.Key] = true
		}
		catalogue[entry.ID] = entry
	}
	seen := map[uint16]bool{}
	for _, task := range r.Tasks {
		entry, ok := catalogue[task.ID]
		if !ok || entry.Kind != task.Kind || seen[task.ID] {
			return fmt.Errorf("任务规则必须对应唯一的客户端目录项")
		}
		seen[task.ID] = true
		if task.Experience > 0x7fffffff || task.Gold > 0x7fffffff {
			return fmt.Errorf("任务奖励超过有符号32位范围")
		}
		hasCondition := false
		for _, condition := range entry.Conditions {
			hasCondition = hasCondition || condition.Required != 0
		}
		if task.Enabled && !hasCondition {
			return fmt.Errorf("启用任务必须有有效条件")
		}
	}
	return nil
}
