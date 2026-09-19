package persistence

import (
	"encoding/hex"
	"fmt"
	"kungfu.local/server/internal/protocol"
	"strings"
)

// StageWaveConfig is a GM-imported, version-bound plan. Saving a plan does not
// enable a game mode; admission is controlled separately by the game server.
type StageWaveConfig struct {
	MapID       uint32                      `json:"map_id"`
	ScriptHash  string                      `json:"script_hash"`
	RuntimeHash string                      `json:"runtime_hash"`
	Templates   []string                    `json:"templates"`
	Variants    []protocol.StageWaveVariant `json:"variants"`
}

func (a StageAccess) validateWavePlans() error {
	if len(a.WavePlans) > 256 {
		return fmt.Errorf("关卡波次配置最多256张地图")
	}
	known := map[uint32]bool{}
	for _, id := range a.PVEMaps {
		known[id] = true
	}
	seen := map[uint32]bool{}
	for _, p := range a.WavePlans {
		if !known[p.MapID] || seen[p.MapID] {
			return fmt.Errorf("关卡波次须对应不重复的PVE地图")
		}
		seen[p.MapID] = true
		for _, hash := range []string{a.ClientHash, p.ScriptHash, p.RuntimeHash} {
			decoded, err := hex.DecodeString(hash)
			if err != nil || len(decoded) != 32 || strings.ToLower(hash) != hash {
				return fmt.Errorf("关卡波次缺少有效版本指纹")
			}
		}
		names := map[string]bool{}
		for _, name := range p.Templates {
			if strings.TrimSpace(name) == "" || len(name) > 256 || names[name] {
				return fmt.Errorf("怪物模板名称为空、过长或重复")
			}
			names[name] = true
		}
		if err := protocol.ValidateStageWaveVariants(p.Variants, len(p.Templates)); err != nil {
			return err
		}
	}
	return nil
}
