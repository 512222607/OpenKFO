package desktop

import (
	"fmt"
	"strconv"
	"strings"
)

type StageMap struct {
	WavePreview       *StageWavePreview `json:"wave_preview,omitempty"`
	Script            string            `json:"script,omitempty"`
	ScriptHash        string            `json:"script_hash,omitempty"`
	Logic             uint32            `json:"logic"`
	Group             uint32            `json:"group"`
	Difficulty        uint32            `json:"difficulty"`
	MapID             uint32            `json:"map_id"`
	MapType           uint32            `json:"map_type"`
	DisplayDifficulty uint32            `json:"display_difficulty"`
	RewardItems       [3]uint32         `json:"reward_items"`
}

// Map requirements are separate from PVE difficulty/reward display entries.
type StageRequirement struct {
	MapID      uint32 `json:"map_id"`
	MapType    uint32 `json:"map_type"`
	Name       string `json:"name"`
	TitleLevel byte   `json:"title_level"`
}

// ReadStageCatalogue joins only by MapID. The two MapType attributes belong
// to different native tables and must retain their original values.
func ReadStageCatalogue(path string) ([]StageRequirement, []StageMap, string, error) {
	a, err := loadArchive(path)
	if err != nil {
		return nil, nil, "", err
	}
	mapRoot, err := a.xml("mapmgr.xml")
	if err != nil {
		return nil, nil, "", err
	}
	rows, err := stageRequirements(mapRoot)
	if err != nil {
		return nil, nil, "", err
	}
	pveRoot, err := a.xml("pveuiconfig.xml")
	if err != nil {
		return nil, nil, "", err
	}
	pve, err := stageMaps(pveRoot)
	if err != nil {
		return nil, nil, "", err
	}
	if err := a.attachStageScripts(pve); err != nil {
		return nil, nil, "", err
	}
	known := map[uint32]bool{}
	for _, r := range rows {
		known[r.MapID] = true
	}
	for _, r := range pve {
		if !known[r.MapID] {
			return nil, nil, "", fmt.Errorf("PVE地图%d不在MapInfo目录中", r.MapID)
		}
	}
	return rows, pve, digest(a.data), nil
}

func ReadStageRequirements(path string) ([]StageRequirement, string, error) {
	a, err := loadArchive(path)
	if err != nil {
		return nil, "", err
	}
	root, err := a.xml("mapmgr.xml")
	if err != nil {
		return nil, "", err
	}
	rows, err := stageRequirements(root)
	return rows, digest(a.data), err
}

func stageRequirements(root *xmlNode) ([]StageRequirement, error) {
	if root == nil || root.tag != "MapInfo" {
		return nil, fmt.Errorf("invalid MapInfo root")
	}
	var rows []StageRequirement
	seen := map[uint32]bool{}
	for _, n := range root.children {
		if n.comment || n.tag == "RandomMap" {
			continue
		}
		if n.tag != "MapConfig" {
			return nil, fmt.Errorf("unexpected MapInfo entry %s", n.tag)
		}
		id, e := strconv.ParseUint(n.get("MapId"), 10, 31)
		kind, kerr := strconv.ParseUint(n.get("MapType"), 10, 31)
		title, terr := strconv.ParseUint(n.get("NeedTitleLevel"), 10, 8)
		name := strings.TrimSpace(n.get("Name"))
		if e != nil || kerr != nil || terr != nil || seen[uint32(id)] || name == "" {
			return nil, fmt.Errorf("invalid/duplicate map requirement: id=%q type=%q title=%q name=%q", n.get("MapId"), n.get("MapType"), n.get("NeedTitleLevel"), name)
		}
		seen[uint32(id)] = true
		rows = append(rows, StageRequirement{uint32(id), uint32(kind), name, byte(title)})
	}
	if len(rows) == 0 {
		return nil, fmt.Errorf("empty map requirements")
	}
	return rows, nil
}

// ReadStageMaps only reads the existing client archive. It does not change
// unlock state, grant rewards or rewrite client resources.
func ReadStageMaps(path string) ([]StageMap, error) {
	a, err := loadArchive(path)
	if err != nil {
		return nil, err
	}
	root, err := a.xml("pveuiconfig.xml")
	if err != nil {
		return nil, err
	}
	maps, err := stageMaps(root)
	if err != nil {
		return nil, err
	}
	if err := a.attachStageScripts(maps); err != nil {
		return nil, err
	}
	return maps, nil
}

func stageMaps(root *xmlNode) ([]StageMap, error) {
	if root == nil || root.tag != "PVEEntryUI" {
		return nil, fmt.Errorf("invalid PVEEntryUI root")
	}
	var result []StageMap
	seen := map[[3]uint32]bool{}
	for _, n := range root.children {
		if n.comment {
			continue
		}
		if n.tag != "Map" {
			return nil, fmt.Errorf("unexpected PVE entry %s", n.tag)
		}
		fields := []string{"LogicType", "Group", "SelectDifficulty", "MapID", "MapType"}
		var values [5]uint32
		for i, key := range fields {
			v, e := strconv.ParseUint(n.get(key), 10, 31)
			if e != nil || v == 0 {
				return nil, fmt.Errorf("invalid PVE field %s", key)
			}
			values[i] = uint32(v)
		}
		key := [3]uint32{values[0], values[1], values[2]}
		if seen[key] {
			return nil, fmt.Errorf("duplicate PVE selection %v", key)
		}
		seen[key] = true
		r := StageMap{Logic: values[0], Group: values[1], Difficulty: values[2], MapID: values[3], MapType: values[4]}
		// These are native display hints, not drop odds or grant instructions.
		for i, field := range []string{"DisplayDifficulty", "RewardItem1", "RewardItem2", "RewardItem3"} {
			text := n.get(field)
			if text == "" {
				continue
			}
			v, e := strconv.ParseUint(text, 10, 32)
			if e != nil {
				return nil, fmt.Errorf("invalid PVE field %s", field)
			}
			if i == 0 {
				r.DisplayDifficulty = uint32(v)
			} else {
				r.RewardItems[i-1] = uint32(v)
			}
		}
		result = append(result, r)
	}
	if len(result) == 0 {
		return nil, fmt.Errorf("empty PVE map catalogue")
	}
	return result, nil
}
