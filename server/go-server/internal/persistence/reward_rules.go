package persistence

import (
	"database/sql"
	"encoding/json"
	"fmt"
)

type LevelReward struct {
	Level          uint16 `json:"level"`
	NextExperience uint32 `json:"next_experience"`
	WinGold        uint32 `json:"win_gold"`
	LossGold       uint32 `json:"loss_gold"`
	DrawGold       uint32 `json:"draw_gold"`
	WinExperience  uint32 `json:"win_experience"`
	LossExperience uint32 `json:"loss_experience"`
	DrawExperience uint32 `json:"draw_experience"`
}

type RewardRules struct {
	GrowthEnabled  bool          `json:"growth_enabled"`
	Levels         []LevelReward `json:"levels,omitempty"`
	WinGold        uint32        `json:"win_gold"`
	LossGold       uint32        `json:"loss_gold"`
	DrawGold       uint32        `json:"draw_gold"`
	WinExperience  uint32        `json:"win_experience"`
	LossExperience uint32        `json:"loss_experience"`
	DrawExperience uint32        `json:"draw_experience"`
}

type RewardSettings struct {
	Revision uint64      `json:"revision"`
	Rules    RewardRules `json:"rules"`
}

func (store *Store) BattleRewards(fallback RewardRules) (RewardSettings, error) {
	result := RewardSettings{Rules: fallback}
	var data []byte
	err := store.DB.QueryRow("SELECT revision,rules FROM battle_reward_rules WHERE id=1").Scan(&result.Revision, &data)
	if err == sql.ErrNoRows {
		result.Rules = result.Rules.Normalized()
		return result, result.Rules.Validate()
	}
	if err != nil {
		return result, err
	}
	err = json.Unmarshal(data, &result.Rules)
	result.Rules = result.Rules.Normalized()
	if err == nil {
		err = result.Rules.Validate()
	}
	return result, err
}

func (store *Store) SeedBattleRewards(rules RewardRules) error {
	rules = rules.Normalized()
	if err := rules.Validate(); err != nil {
		return err
	}
	data, err := json.Marshal(rules)
	if err != nil {
		return err
	}
	_, err = store.DB.Exec("INSERT IGNORE INTO battle_reward_rules(id,revision,rules) VALUES(1,1,?)", data)
	return err
}

func (store *Store) SaveBattleRewards(revision uint64, rules RewardRules) (RewardSettings, error) {
	rules = rules.Normalized()
	if err := rules.Validate(); err != nil {
		return RewardSettings{}, err
	}
	data, err := json.Marshal(rules)
	if err != nil {
		return RewardSettings{}, err
	}
	var result sql.Result
	if revision == 0 {
		result, err = store.DB.Exec("INSERT IGNORE INTO battle_reward_rules(id,revision,rules) VALUES(1,1,?)", data)
	} else {
		result, err = store.DB.Exec("UPDATE battle_reward_rules SET rules=?,revision=revision+1 WHERE id=1 AND revision=?", data, revision)
	}
	if err != nil {
		return RewardSettings{}, err
	}
	n, err := result.RowsAffected()
	if err != nil {
		return RewardSettings{}, err
	}
	if n != 1 {
		return RewardSettings{}, fmt.Errorf("奖励配置已被修改，请重新读取后保存")
	}
	return RewardSettings{Revision: revision + 1, Rules: rules}, nil
}

// Expand old settings without changing amounts or enabling a made-up curve.
func (r RewardRules) Normalized() RewardRules {
	if len(r.Levels) == 0 {
		for level := 1; level <= 150; level++ {
			r.Levels = append(r.Levels, LevelReward{uint16(level), 0, r.WinGold, r.LossGold, r.DrawGold, r.WinExperience, r.LossExperience, r.DrawExperience})
		}
	}
	return r
}
func (r RewardRules) Validate() error {
	if len(r.Levels) != 150 {
		return fmt.Errorf("必须包含 1–150 级，共 150 行")
	}
	for i, row := range r.Levels {
		if int(row.Level) != i+1 {
			return fmt.Errorf("等级必须按 1–150 顺序且不能重复")
		}
		for _, v := range []uint32{row.WinGold, row.LossGold, row.DrawGold, row.WinExperience, row.LossExperience, row.DrawExperience} {
			if v > 1000000 {
				return fmt.Errorf("第 %d 级单局奖励须为 0–1000000", row.Level)
			}
		}
		if row.NextExperience > 2147483647 || (row.Level == 150 && row.NextExperience != 0) {
			return fmt.Errorf("升级经验超出范围或 150 级升级经验不为 0")
		}
		if r.GrowthEnabled && row.Level < 150 && row.NextExperience == 0 {
			return fmt.Errorf("启用升级前必须填写 1–149 级升级经验")
		}
	}
	return nil
}
func (r RewardRules) AtLevel(level uint16) LevelReward {
	if level < 1 {
		level = 1
	}
	if level > 150 {
		level = 150
	}
	return r.Normalized().Levels[int(level)-1]
}
