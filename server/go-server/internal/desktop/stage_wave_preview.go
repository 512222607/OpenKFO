package desktop

import (
	"fmt"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

// This adapter mirrors one verified native script revision. A changed script
// must not silently inherit its formulas or template numbering.
const zombieNormalHash = "2d966acbb0f2c255e3f0b644b45a845c863ab90acc4eec0dc517235920587c94"
const stageAssaultHash = "0528f4d1d668b73982d66cd7ff167fc869e2ce1e410bbe81f34ef2d41b21a84d"

type StageWavePreview struct {
	RuntimeHash string                    `json:"runtime_hash"`
	Templates   []string                  `json:"templates"`
	Variants    []StageWavePreviewVariant `json:"variants"`
}
type StageWavePreviewVariant struct {
	MinPlayers int                   `json:"min_players"`
	MaxPlayers int                   `json:"max_players"`
	Waves      []StageWavePreviewRow `json:"waves"`
}
type StageWavePreviewRow struct {
	Monsters map[uint32]uint32 `json:"monsters"`
}

func zombieWavePreview(raw, runtime []byte) (*StageWavePreview, error) {
	if digest(raw) != zombieNormalHash || digest(runtime) != stageAssaultHash {
		return nil, fmt.Errorf("unverified stage script revision")
	}
	// Keep original GBK bytes until after sorting: Unicode/UTF-8 order differs.
	source := string(raw)
	names := regexp.MustCompile(`(?m)^\["[^"\r\n]+"\]\s*=\s*\{"([^"\r\n]+)"`).FindAllStringSubmatch(source, -1)
	if len(names) != 5 {
		return nil, fmt.Errorf("unexpected monster definitions")
	}
	keys := make([]string, 0, len(names))
	for _, n := range names {
		keys = append(keys, n[1])
	}
	sort.Strings(keys)
	indices := map[string]uint32{}
	p := &StageWavePreview{RuntimeHash: digest(runtime)}
	for i, key := range keys {
		if _, found := indices[key]; found {
			return nil, fmt.Errorf("duplicate monster name")
		}
		indices[key] = uint32(i)
		name, err := decodeText([]byte(key))
		if err != nil {
			return nil, err
		}
		p.Templates = append(p.Templates, name)
	}
	lists := map[[2]int][]uint32{}
	groups := regexp.MustCompile(`(?s)tMonsterBorn([0-9]+)_([1-4])\s*=\s*\{.*?MonsterList\s*=\s*\{([^}]*)\}`).FindAllStringSubmatch(source, -1)
	quoted := regexp.MustCompile(`"([^"\r\n]+)"`)
	for _, group := range groups {
		wave, _ := strconv.Atoi(group[1])
		point, _ := strconv.Atoi(group[2])
		key := [2]int{wave, point}
		if _, exists := lists[key]; exists {
			return nil, fmt.Errorf("duplicate spawn group")
		}
		for _, name := range quoted.FindAllStringSubmatch(group[3], -1) {
			id, exists := indices[name[1]]
			if !exists {
				return nil, fmt.Errorf("unknown spawn template")
			}
			lists[key] = append(lists[key], id)
		}
	}
	if len(lists) != 40 {
		return nil, fmt.Errorf("unexpected spawn group count")
	}
	for _, party := range []struct {
		min, max int
		points   []int
	}{{1, 2, []int{2, 4}}, {3, 4, []int{1, 2, 4}}, {5, 8, []int{1, 2, 3, 4}}} {
		variant := StageWavePreviewVariant{MinPlayers: party.min, MaxPlayers: party.max}
		for wave := 1; wave <= 25; wave++ {
			group, count := wave, 4
			if wave%5 != 0 {
				group = (wave/5)*5 + 1
				count = 2 + wave - group
				if group == 11 || group == 16 {
					count++
				}
			}
			row := StageWavePreviewRow{Monsters: map[uint32]uint32{}}
			for _, point := range party.points {
				list := lists[[2]int{group, point}]
				if len(list) == 0 {
					return nil, fmt.Errorf("missing spawn list")
				}
				// StageAssault's CreateAMonster ignores nil past the list end.
				for _, id := range list[:min(count, len(list))] {
					row.Monsters[id]++
				}
			}
			variant.Waves = append(variant.Waves, row)
		}
		p.Variants = append(p.Variants, variant)
	}
	return p, nil
}

func (a *archive) stageWavePreview(script string, raw []byte) (*StageWavePreview, error) {
	if !strings.EqualFold(script, "script/pve/act_zombiedefend_normal.lua") || digest(raw) != zombieNormalHash {
		return nil, nil
	}
	runtime, err := a.raw("script/pve/stageassault.lua")
	if err != nil {
		return nil, err
	}
	if digest(runtime) != stageAssaultHash {
		return nil, nil
	}
	return zombieWavePreview(raw, runtime)
}
