package persistence

import (
	"database/sql"
	"encoding/json"
	"kungfu.local/server/internal/protocol"
	"math"
	"sort"
)

// 4300 -> 9CD5B0 stores DWORDs at profile+F5/+F9. 9CD2D0 reads +F5
// for the experience delta. +F9 is txtTotalScore in native 7E138C.
const ExperienceOffset = 0xF5
const LevelOffset = 120

func ProfileLevel(profile []byte) uint16 {
	level := protocol.ReadUint16(profile, LevelOffset)
	if level < 1 {
		return 1
	}
	if level > 150 {
		return 150
	}
	return level
}
func AdvanceLevel(level uint16, experience uint64, rules RewardRules) (uint16, uint32) {
	for level < 150 {
		cost := rules.AtLevel(level).NextExperience
		if cost == 0 || experience < uint64(cost) {
			break
		}
		experience -= uint64(cost)
		level++
	}
	if experience > math.MaxInt32 {
		experience = math.MaxInt32
	}
	return level, uint32(experience)
}

type BattleReward struct {
	UID         uint64 `json:"uid"`
	Outcome     string `json:"outcome"`
	Gold        uint32 `json:"gold"`
	GoldBalance uint32 `json:"gold_balance"`
	Experience  uint32 `json:"experience"`
	Profile     []byte `json:"profile"`
}

// Commit the entire room once. The persisted response makes retries independent
// of subsequent reward configuration changes or process restarts.
func (store *Store) SettleBattle(serial uint32, reports []byte, rewards []BattleReward, growth ...RewardRules) ([]BattleReward, error) {
	if serial == 0 || len(rewards) == 0 || len(rewards) > 8 {
		return nil, ErrDenied
	}
	sort.Slice(rewards, func(i, j int) bool { return rewards[i].UID < rewards[j].UID })
	tx, err := store.DB.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()
	// Lock the persistent battle counter to serialize settlement creation even
	// if duplicate requests come from separate service processes.
	var counter uint64
	if err = tx.QueryRow("SELECT value FROM counters WHERE name='battle' FOR UPDATE").Scan(&counter); err != nil {
		return nil, err
	}
	if uint64(serial) > counter {
		return nil, ErrDenied
	}
	var previous []byte
	err = tx.QueryRow("SELECT result FROM battle_settlements WHERE serial=?", serial).Scan(&previous)
	if err == nil {
		var saved []BattleReward
		if err = json.Unmarshal(previous, &saved); err != nil {
			return nil, err
		}
		return saved, tx.Commit()
	}
	if err != sql.ErrNoRows {
		return nil, err
	}
	for i := range rewards {
		r := &rewards[i]
		if r.UID == 0 || (i > 0 && rewards[i-1].UID == r.UID) {
			return nil, ErrDenied
		}
		var gold uint64
		if err = tx.QueryRow("SELECT profile,gold FROM accounts WHERE uid=? FOR UPDATE", r.UID).Scan(&r.Profile, &gold); err != nil {
			return nil, err
		}
		if len(r.Profile) != 360 || gold+uint64(r.Gold) > math.MaxUint32 {
			return nil, ErrDenied
		}
		experience := uint64(protocol.ReadUint32(r.Profile, ExperienceOffset)) + uint64(r.Experience)
		if r.Gold > math.MaxInt32 {
			return nil, ErrDenied
		}
		if len(growth) > 0 && growth[0].GrowthEnabled && r.Outcome != "unconfirmed" {
			level, xp := AdvanceLevel(ProfileLevel(r.Profile), experience, growth[0])
			protocol.WriteUint16(r.Profile, LevelOffset, level)
			experience = uint64(xp)
		}
		total := uint64(protocol.ReadUint32(r.Profile, ExperienceOffset+4)) + uint64(r.Experience)
		if total > math.MaxInt32 {
			total = math.MaxInt32
		}
		protocol.WriteUint32(r.Profile, ExperienceOffset+4, uint32(total))
		if experience > math.MaxInt32 {
			return nil, ErrDenied
		}
		protocol.WriteUint32(r.Profile, ExperienceOffset, uint32(experience))
		r.GoldBalance = uint32(gold + uint64(r.Gold))
		if _, err = tx.Exec("UPDATE accounts SET gold=?,profile=? WHERE uid=?", r.GoldBalance, r.Profile, r.UID); err != nil {
			return nil, err
		}
	}
	data, err := json.Marshal(rewards)
	if err != nil {
		return nil, err
	}
	if _, err = tx.Exec("INSERT INTO battle_settlements(serial,reports,result) VALUES(?,?,?)", serial, reports, data); err != nil {
		return nil, err
	}
	return rewards, tx.Commit()
}
