package desktop

import (
	"fmt"
	"strconv"
)

// TrainingMission is the native titlemission.xml scenario catalogue. It does
// not imply that the task-panel 60xx record keys use the same ID namespace.
type TrainingMission struct {
	ID           uint16   `json:"id"`
	Group        uint16   `json:"group"`
	Name         string   `json:"name"`
	MapID        uint32   `json:"map_id"`
	Seconds      uint32   `json:"seconds"`
	Dependencies []uint16 `json:"dependencies"`
}

func ReadTrainingMissions(path string) ([]TrainingMission, error) {
	a, err := loadArchive(path)
	if err != nil {
		return nil, err
	}
	root, err := a.xml("titlemission.xml")
	if err != nil {
		return nil, err
	}
	return trainingMissions(root)
}

func trainingMissions(root *xmlNode) ([]TrainingMission, error) {
	if root == nil || root.tag != "TitleMission" {
		return nil, fmt.Errorf("invalid TitleMission root")
	}
	var rows []TrainingMission
	seen := map[uint16]bool{}
	for _, group := range root.children {
		if group.comment {
			continue
		}
		gid, e := strconv.ParseUint(group.get("ID"), 10, 16)
		if group.tag != "Title" || e != nil || gid == 0 {
			return nil, fmt.Errorf("invalid training group")
		}
		for _, node := range group.children {
			if node.comment {
				continue
			}
			if node.tag != "Mission" {
				return nil, fmt.Errorf("unexpected training entry %s", node.tag)
			}
			id, e := strconv.ParseUint(node.get("ID"), 10, 16)
			if e != nil || seen[uint16(id)] {
				return nil, fmt.Errorf("invalid/duplicate training ID")
			}
			mapID, e := strconv.ParseUint(node.get("MapID"), 10, 32)
			if e != nil || mapID == 0 {
				return nil, fmt.Errorf("invalid training map")
			}
			seconds, e := strconv.ParseUint(node.get("Time"), 10, 32)
			if e != nil || seconds == 0 {
				return nil, fmt.Errorf("invalid training duration")
			}
			r := TrainingMission{ID: uint16(id), Group: uint16(gid), Name: node.get("Name"), MapID: uint32(mapID), Seconds: uint32(seconds), Dependencies: []uint16{}}
			if r.Name == "" {
				return nil, fmt.Errorf("empty training name")
			}
			deps := map[uint16]bool{}
			for _, child := range node.children {
				if child.tag != "DependentMission" || child.comment {
					continue
				}
				d, e := strconv.ParseUint(child.get("ID"), 10, 16)
				if e != nil || d == id || deps[uint16(d)] {
					return nil, fmt.Errorf("invalid training dependency")
				}
				deps[uint16(d)] = true
				r.Dependencies = append(r.Dependencies, uint16(d))
			}
			seen[r.ID] = true
			rows = append(rows, r)
		}
	}
	if len(rows) == 0 {
		return nil, fmt.Errorf("empty training catalogue")
	}
	for _, r := range rows {
		for _, id := range r.Dependencies {
			if !seen[id] {
				return nil, fmt.Errorf("training %d references missing %d", r.ID, id)
			}
		}
	}
	return rows, nil
}
