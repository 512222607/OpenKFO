package desktop

import (
	"fmt"
	"strconv"
	"strings"
)

// RoleTitle describes roletitle.xml, not titlemission.xml or award conditions.
type RoleTitle struct {
	Level byte   `json:"level"`
	Name  string `json:"name"`
	Icon  string `json:"icon"`
}

func ReadRoleTitles(path string) ([]RoleTitle, error) {
	titles, _, err := readRoleTitleCatalogue(path)
	return titles, err
}

func readRoleTitleCatalogue(path string) ([]RoleTitle, string, error) {
	a, err := loadArchive(path)
	if err != nil {
		return nil, "", err
	}
	root, err := a.xml("roletitle.xml")
	if err != nil {
		return nil, "", err
	}
	titles, err := roleTitles(root)
	return titles, digest(a.data), err
}

func roleTitles(root *xmlNode) ([]RoleTitle, error) {
	if root == nil || root.tag != "TitleSetting" {
		return nil, fmt.Errorf("invalid title catalogue")
	}
	rows := []RoleTitle{}
	seen := map[byte]bool{}
	for _, n := range root.children {
		if n.comment {
			continue
		}
		level, err := strconv.ParseUint(n.get("Level"), 10, 8)
		if n.tag != "TitleLevel" || err != nil || seen[byte(level)] || strings.TrimSpace(n.get("Title")) == "" || strings.TrimSpace(n.get("Icon")) == "" {
			return nil, fmt.Errorf("invalid/duplicate title entry")
		}
		seen[byte(level)] = true
		rows = append(rows, RoleTitle{byte(level), n.get("Title"), n.get("Icon")})
	}
	if len(rows) == 0 {
		return nil, fmt.Errorf("empty title catalogue")
	}
	return rows, nil
}
