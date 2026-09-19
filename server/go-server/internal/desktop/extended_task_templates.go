package desktop

import (
	"crypto/sha256"
	"fmt"
	"strconv"
	"strings"
)

// ExtendedTaskTemplate describes the native daily/newbie catalogue. Fields
// retain all 27 columns: reward and condition semantics are not inferred from
// their numeric values. These templates must not enter the BaseQuest importer.
type ExtendedTaskTemplate struct {
	ID         uint16                     `json:"id"`
	Name       string                     `json:"name"`
	Fields     [27]string                 `json:"fields"`
	Conditions [3]ExtendedTaskRequirement `json:"conditions"`
}

type ExtendedTaskRequirement struct {
	Description string `json:"description"`
	Key         uint32 `json:"key"`
	Required    uint16 `json:"required"`
}

func readExtendedTaskCatalogues(path string) (map[string][]ExtendedTaskTemplate, string, error) {
	a, err := loadArchive(path)
	if err != nil {
		return nil, "", err
	}
	result := map[string][]ExtendedTaskTemplate{}
	for _, entry := range []struct{ kind, file string }{{"daily", "basedailyquest.txt"}, {"newbie", "basenewbiequest.txt"}} {
		text, err := a.text(entry.file)
		if err != nil {
			return nil, "", err
		}
		rows, err := extendedTaskTemplates(text)
		if err != nil {
			return nil, "", fmt.Errorf("%s: %w", entry.file, err)
		}
		result[entry.kind] = rows
	}
	return result, fmt.Sprintf("%x", sha256.Sum256(a.data)), nil
}

func extendedTaskTemplates(text string) ([]ExtendedTaskTemplate, error) {
	var rows []ExtendedTaskTemplate
	seen := map[uint16]bool{}
	for line, raw := range strings.Split(strings.TrimPrefix(text, "\ufeff"), "\n") {
		raw = strings.TrimSuffix(raw, "\r")
		if strings.TrimSpace(raw) == "" {
			continue
		}
		fields := strings.Split(raw, "\t")
		if len(fields) != 27 {
			return nil, fmt.Errorf("line %d: expected 27 fields", line+1)
		}
		for i, f := range fields {
			switch i {
			case 2, 5, 8, 22, 23, 24, 25:
				continue
			}
			bits := 32
			switch i {
			case 0, 1, 4, 7, 10:
				bits = 16
			}
			if _, err := strconv.ParseUint(f, 10, bits); err != nil {
				return nil, fmt.Errorf("line %d: invalid field %d", line+1, i)
			}
		}
		id, _ := strconv.ParseUint(fields[0], 10, 16)
		if id == 0 || seen[uint16(id)] || strings.TrimSpace(fields[22]) == "" {
			return nil, fmt.Errorf("line %d: invalid identity", line+1)
		}
		r := ExtendedTaskTemplate{ID: uint16(id), Name: fields[22]}
		copy(r.Fields[:], fields)
		for i := range r.Conditions {
			key, _ := strconv.ParseUint(fields[3+i*3], 10, 32)
			required, _ := strconv.ParseUint(fields[4+i*3], 10, 16)
			r.Conditions[i] = ExtendedTaskRequirement{Description: fields[2+i*3], Key: uint32(key), Required: uint16(required)}
		}
		rows = append(rows, r)
		seen[r.ID] = true
	}
	if len(rows) == 0 {
		return nil, fmt.Errorf("empty extended task catalogue")
	}
	return rows, nil
}
