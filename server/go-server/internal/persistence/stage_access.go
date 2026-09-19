package persistence

import (
	"bytes"
	"database/sql"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"kungfu.local/server/internal/protocol"
	"strings"
)

// StageAccess only restricts maps already supported by the server's pools.
// It cannot enable an unsupported game mode or fabricate player unlocks.
type StageAccess struct {
	Revision            uint64                  `json:"revision"`
	Disabled            []uint32                `json:"disabled_maps"`
	RequirementsEnabled bool                    `json:"requirements_enabled"`
	ClientHash          string                  `json:"client_hash,omitempty"`
	Requirements        []StageTitleRequirement `json:"requirements,omitempty"`
	PVEMaps             []uint32                `json:"pve_maps,omitempty"`
}

type StageTitleRequirement struct {
	MapID      uint32 `json:"map_id"`
	Name       string `json:"name"`
	TitleLevel byte   `json:"title_level"`
	// nil preserves this condition when an older GM omits the new field.
	UnlockRequired *bool `json:"unlock_required,omitempty"`
}

func (r StageTitleRequirement) NeedsUnlock() bool {
	return r.UnlockRequired != nil && *r.UnlockRequired
}

func (a StageAccess) AllowsPlayer(id uint32, title byte, hash string, grants map[uint32]bool) bool {
	if !a.AllowsTitle(id, title, hash) {
		return false
	}
	if !a.RequirementsEnabled {
		return true
	}
	for _, r := range a.Requirements {
		if r.MapID == id {
			return !r.NeedsUnlock() || grants[id]
		}
	}
	return false
}

func (a StageAccess) Validate() error {
	if a.RequirementsEnabled || len(a.Requirements) > 0 || a.ClientHash != "" || len(a.PVEMaps) > 0 {
		hash, err := hex.DecodeString(a.ClientHash)
		if err != nil || len(hash) != 32 || strings.ToLower(a.ClientHash) != a.ClientHash || len(a.Requirements) == 0 || len(a.Requirements) > 4096 {
			return fmt.Errorf("关卡条件需要有效客户端指纹及1至4096条地图规则")
		}
		seen := map[uint32]bool{}
		for _, r := range a.Requirements {
			if r.MapID == 0 || r.MapID > 0x7fffffff || seen[r.MapID] || strings.TrimSpace(r.Name) == "" || len(r.Name) > 256 {
				return fmt.Errorf("关卡条件地图编号或名称无效")
			}
			seen[r.MapID] = true
		}
		for _, id := range a.PVEMaps {
			if !seen[id] {
				return fmt.Errorf("PVE地图不在关卡目录中：%d", id)
			}
		}
		if _, err := (protocol.StageProgress{MapIDs: a.PVEMaps}).Encode(); err != nil {
			return fmt.Errorf("PVE目录重复、无效或超过客户端进度包容量")
		}
	}
	if len(a.Disabled) > 4096 {
		return fmt.Errorf("关闭地图不能超过4096项")
	}
	seen := map[uint32]bool{}
	for _, id := range a.Disabled {
		if id == 0 || id > 0x7fffffff || seen[id] {
			return fmt.Errorf("地图ID须为不重复的正整数")
		}
		seen[id] = true
	}
	return nil
}

// An enabled catalogue must match the authenticated client package. Unknown
// concrete maps fail closed; random map 0 must be resolved before this check.
func (a StageAccess) AllowsTitle(id uint32, title byte, clientHash string) bool {
	if !a.Allows(id) {
		return false
	}
	if !a.RequirementsEnabled {
		return true
	}
	if clientHash == "" || a.ClientHash != clientHash {
		return false
	}
	for _, r := range a.Requirements {
		if r.MapID == id {
			return title >= r.TitleLevel
		}
	}
	return false
}

func (s *Store) AccountTitle(uid uint64) (byte, error) {
	if uid == 0 {
		return 0, ErrDenied
	}
	var profile []byte
	if err := s.DB.QueryRow("SELECT profile FROM accounts WHERE uid=?", uid).Scan(&profile); err != nil {
		return 0, err
	}
	if len(profile) != 360 {
		return 0, ErrDenied
	}
	return profile[TitleLevelOffset], nil
}

func decodeStageAccess(data []byte, revision uint64) (StageAccess, error) {
	a := StageAccess{}
	data = bytes.TrimSpace(data)
	var err error
	if len(data) > 0 && data[0] == '[' {
		err = json.Unmarshal(data, &a.Disabled)
	} else {
		err = json.Unmarshal(data, &a)
	}
	if err != nil {
		return a, err
	}
	if bytes.Equal(data, []byte("null")) {
		return a, fmt.Errorf("invalid null stage rules")
	}
	a.Revision = revision // Database revision is authoritative, never JSON content.
	if a.Disabled == nil {
		a.Disabled = []uint32{}
	}
	return a, a.Validate()
}
func (a StageAccess) Allows(id uint32) bool {
	for _, disabled := range a.Disabled {
		if id == disabled {
			return false
		}
	}
	return true
}
func (s *Store) StageAccess() (StageAccess, error) {
	a := StageAccess{Disabled: []uint32{}}
	var data []byte
	err := s.DB.QueryRow("SELECT revision,rules FROM stage_access WHERE id=1").Scan(&a.Revision, &data)
	if err == sql.ErrNoRows {
		return a, nil
	}
	if err != nil {
		return a, err
	}
	return decodeStageAccess(data, a.Revision)
}
func (s *Store) SaveStageAccess(a StageAccess) (StageAccess, error) {
	if err := a.Validate(); err != nil {
		return StageAccess{}, err
	}
	if a.Disabled == nil {
		a.Disabled = []uint32{}
	}
	tx, err := s.DB.Begin()
	if err != nil {
		return StageAccess{}, err
	}
	defer tx.Rollback()
	if _, err = tx.Exec("INSERT IGNORE INTO stage_access(id,revision,rules) VALUES(1,0,'[]')"); err != nil {
		return StageAccess{}, err
	}
	var revision uint64
	var before []byte
	if err = tx.QueryRow("SELECT revision,rules FROM stage_access WHERE id=1 FOR UPDATE").Scan(&revision, &before); err != nil {
		return StageAccess{}, err
	}
	if revision != a.Revision {
		return StageAccess{}, fmt.Errorf("关卡开关已被修改，请重新读取后保存")
	}
	previous, err := decodeStageAccess(before, revision)
	if err != nil {
		return StageAccess{}, err
	}
	if previous.ClientHash != "" && a.ClientHash == "" {
		return StageAccess{}, fmt.Errorf("请更新GM后保留关卡目录；关闭条件时请保留配置")
	}
	if previous.ClientHash == a.ClientHash {
		if a.PVEMaps == nil {
			a.PVEMaps = previous.PVEMaps
		}
		old := map[uint32]*bool{}
		for _, r := range previous.Requirements {
			old[r.MapID] = r.UnlockRequired
		}
		for i := range a.Requirements {
			if a.Requirements[i].UnlockRequired == nil {
				a.Requirements[i].UnlockRequired = old[a.Requirements[i].MapID]
			}
		}
	}
	if err = a.Validate(); err != nil {
		return StageAccess{}, err
	}
	data, err := json.Marshal(a.Disabled)
	if a.ClientHash != "" {
		data, err = json.Marshal(a)
	}
	if err != nil {
		return StageAccess{}, err
	}
	if _, err = tx.Exec("UPDATE stage_access SET revision=revision+1,rules=? WHERE id=1", data); err != nil {
		return StageAccess{}, err
	}
	if _, err = tx.Exec("INSERT INTO stage_access_audit(revision,before_data,after_data) VALUES(?,?,?)", revision+1, before, data); err != nil {
		return StageAccess{}, err
	}
	if err = tx.Commit(); err != nil {
		return StageAccess{}, err
	}
	a.Revision++
	return a, nil
}
