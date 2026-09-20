package persistence

import (
	"encoding/hex"
	"fmt"
	"kungfu.local/server/internal/protocol"
	"strings"
)

type FosterConfig struct {
	MapID       uint32              `json:"map_id"`
	ScriptHash  string              `json:"script_hash"`
	RuntimeHash string              `json:"runtime_hash"`
	ConfigHash  string              `json:"config_hash"`
	Templates   []string            `json:"templates"`
	Plan        protocol.FosterPlan `json:"plan"`
}

func (a StageAccess) validateFosterPlans() error {
	if len(a.FosterPlans) > 256 {
		return fmt.Errorf("模式10计划最多256张地图")
	}
	known, seen := map[uint32]bool{}, map[uint32]bool{}
	for _, id := range a.PVEMaps {
		known[id] = true
	}
	for _, wave := range a.WavePlans {
		seen[wave.MapID] = true
	}
	for _, p := range a.FosterPlans {
		if !known[p.MapID] || seen[p.MapID] {
			return fmt.Errorf("模式10计划须对应独立PVE地图，不能与波次计划混用")
		}
		seen[p.MapID] = true
		for _, hash := range []string{a.ClientHash, p.ScriptHash, p.RuntimeHash, p.ConfigHash} {
			decoded, err := hex.DecodeString(hash)
			if err != nil || len(decoded) != 32 || strings.ToLower(hash) != hash {
				return fmt.Errorf("模式10计划缺少有效版本指纹")
			}
		}
		names := map[string]bool{}
		for _, name := range p.Templates {
			if strings.TrimSpace(name) == "" || len(name) > 256 || names[name] {
				return fmt.Errorf("模式10模板名称为空、过长或重复")
			}
			names[name] = true
		}
		if err := p.Plan.Validate(len(p.Templates)); err != nil {
			return err
		}
	}
	return nil
}
