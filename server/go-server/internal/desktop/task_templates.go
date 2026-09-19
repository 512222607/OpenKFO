package desktop

import (
	"crypto/sha256"
	"fmt"
	"strconv"
	"strings"
)

// BaseQuest is the native A4B220 configuration, not TitleMission training.
// Unknown reward fields are retained until their consumers are established.
type BaseQuest struct {
	ID             uint16     `json:"id"`
	Name           string     `json:"name"`
	Icon           string     `json:"icon"`
	Description    string     `json:"description"`
	CompletionText string     `json:"completion_text"`
	Matches        uint32     `json:"matches"`
	MaxCombo       uint32     `json:"max_combo"`
	Counters       [29]uint32 `json:"counters"`
	UnknownReward  uint16     `json:"unknown_reward"`
	Item           uint32     `json:"item"`
	TitleLevel     uint16     `json:"title_level"`
	UnknownRank    uint16     `json:"unknown_rank"`
	Next           uint16     `json:"next"`
	Enabled        bool       `json:"enabled"`
}

func ReadBaseQuests(path string) ([]BaseQuest, error) {
	rows, _, err := readBaseQuestCatalogue(path)
	return rows, err
}
func readBaseQuestCatalogue(path string) ([]BaseQuest, string, error) {
	a, err := loadArchive(path)
	if err != nil {
		return nil, "", err
	}
	text, err := a.text("basequest.txt")
	if err != nil {
		return nil, "", err
	}
	rows, err := baseQuests(text)
	if err != nil {
		return nil, "", err
	}
	return rows, fmt.Sprintf("%x", sha256.Sum256(a.data)), nil
}

func baseQuests(text string) ([]BaseQuest, error) {
	rows := []BaseQuest{}
	seen := map[uint16]bool{}
	for line, raw := range strings.Split(strings.TrimPrefix(text, "\ufeff"), "\n") {
		raw = strings.TrimSuffix(raw, "\r")
		if strings.TrimSpace(raw) == "" {
			continue
		}
		f := strings.Split(raw, "\t")
		if len(f) != 41 {
			return nil, fmt.Errorf("BaseQuest line %d: expected 41 fields", line+1)
		}
		var values [41]uint64
		for i := 0; i < len(f); i++ {
			if i >= 1 && i <= 4 {
				continue
			}
			bits := 32
			if i == 0 || i == 36 || i == 38 || i == 39 {
				bits = 16
			}
			if i == 40 {
				bits = 1
			}
			v, err := strconv.ParseUint(f[i], 10, bits)
			if err != nil {
				return nil, fmt.Errorf("BaseQuest line %d: invalid field %d", line+1, i)
			}
			values[i] = v
		}
		r := BaseQuest{ID: uint16(values[0]), Name: f[1], Icon: f[2], Description: f[3], CompletionText: f[4], Matches: uint32(values[5]), MaxCombo: uint32(values[6]), UnknownReward: uint16(values[36]), Item: uint32(values[37]), UnknownRank: uint16(values[38]), TitleLevel: uint16(values[38]), Next: uint16(values[39]), Enabled: values[40] != 0}
		if r.ID == 0 || seen[r.ID] || strings.TrimSpace(r.Name) == "" {
			return nil, fmt.Errorf("BaseQuest line %d: invalid identity", line+1)
		}
		for i := range r.Counters {
			r.Counters[i] = uint32(values[7+i])
		}
		seen[r.ID] = true
		rows = append(rows, r)
	}
	if len(rows) == 0 {
		return nil, fmt.Errorf("empty BaseQuest catalogue")
	}
	for _, r := range rows {
		if r.Next != 0 && (!seen[r.Next] || r.Next == r.ID) {
			return nil, fmt.Errorf("BaseQuest %d: invalid next task", r.ID)
		}
	}
	return rows, nil
}
