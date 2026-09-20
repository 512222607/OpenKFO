package desktop

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
	"regexp"
	"slices"
	"strconv"
	"strings"
)

const fosterStreetEasyHash = "c227b5bf3dae47e461a2e59b3d0832065d83e52c3bd10f44f6dc6f72deb3c15f"
const fosterRuntimeHash = "0a083607cab1456c0976038f1e78658a208607355c015060a4492259cde5280f"

type FosterSpawn = protocol.FosterSpawn
type FosterGroup = protocol.FosterGroup

// Preview is not a cleared-stage receipt or admission grant. Groups run
// concurrently; their order must not be flattened into mode 21 wave counts.
type FosterPlanPreview = protocol.FosterPlan

// Only this exact map/config/runtime combination has been traced. Read the
// explicit spawn literals; never execute Lua or infer another map's rules.
func fosterPlanPreview(raw []byte, runtime string, catalogue *FosterTemplateCatalogue) (*FosterPlanPreview, error) {
	if digest(raw) != fosterStreetEasyHash || runtime != fosterRuntimeHash || catalogue == nil || catalogue.ConfigHash != fosterConfigHash {
		return nil, nil
	}
	text, err := decodeText(raw)
	if err != nil {
		return nil, err
	}
	groups := strings.Split(text, "event=EVENT_GROUP({")
	if len(groups) != 3 {
		return nil, fmt.Errorf("unexpected verified Foster event groups")
	}
	indices := map[string]uint32{}
	for i, name := range catalogue.Names {
		if _, exists := indices[name]; exists {
			return nil, fmt.Errorf("duplicate Foster template name")
		}
		indices[name] = uint32(i)
	}
	spawnPattern := regexp.MustCompile(`\{n="([^"]+)",p=\{(-?[0-9]+),(-?[0-9]+),(-?[0-9]+)\}(?:,\s*d=([0-9]+))?\}`)
	if len(catalogue.InitialHP) != len(catalogue.Names) {
		return nil, fmt.Errorf("Foster initial HP catalogue is missing")
	}
	p := &FosterPlanPreview{GlobalLimit: 32, PlayerLimit: 6, InitialHP: slices.Clone(catalogue.InitialHP)}
	for groupIndex, section := range groups[1:] {
		// This verified script has one sub-list per group. Runtime corpse
		// accounting affects the global/group limits, not this sub-list limit.
		group := FosterGroup{SubLimit: 2, GroupLimit: 20, TriggerBox: [6]float32{-2300, -5, -100, 1450, 10, 50}}
		if groupIndex == 0 {
			group.Block = 100
		}
		for _, row := range spawnPattern.FindAllStringSubmatch(section, -1) {
			index, exists := indices[row[1]] // Leading spaces distinguish native templates.
			if !exists {
				return nil, fmt.Errorf("Foster spawn template absent from catalogue: %q", row[1])
			}
			spawn := FosterSpawn{Template: index, Direction: 2} // libs/event.lua default.
			for i := range spawn.Position {
				v, e := strconv.ParseFloat(row[i+2], 32)
				if e != nil {
					return nil, e
				}
				spawn.Position[i] = float32(v)
			}
			if row[5] != "" {
				v, e := strconv.ParseUint(row[5], 10, 32)
				if e != nil {
					return nil, e
				}
				spawn.Direction = uint32(v)
			}
			group.Spawns = append(group.Spawns, spawn)
		}
		if len(group.Spawns) != []int{2, 21}[groupIndex] {
			return nil, fmt.Errorf("unexpected verified Foster spawn count")
		}
		p.Groups = append(p.Groups, group)
	}
	return p, p.Validate(len(catalogue.Names))
}
