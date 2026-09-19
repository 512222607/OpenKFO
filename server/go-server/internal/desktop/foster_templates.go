package desktop

import (
	"fmt"
	"regexp"
	"sort"
)

const fosterConfigHash = "142515f07e84aaab3ba8ea4d4c2b2ba76a14b70d35abc40fc09996e04061d914"

type FosterTemplateCatalogue struct {
	ConfigHash string   `json:"config_hash"`
	Names      []string `json:"names"` // Index is the native 20400 template DWORD.
}

// A62D60 builds the global name vector from each definition's first field;
// A63407 sorts it before A62AE0 looks up the zero-based index. A changed Lua
// configuration is not parsed heuristically as an equivalent ruleset.
func fosterTemplates(raw []byte) (*FosterTemplateCatalogue, error) {
	if digest(raw) != fosterConfigHash {
		return nil, nil
	}
	matches := regexp.MustCompile(`(?m)^\["[^"\r\n]+"\]\s*=\s*\{"([^"\r\n]+)"`).FindAllStringSubmatch(string(raw), -1)
	if len(matches) != 262 {
		return nil, fmt.Errorf("unexpected verified Foster template count")
	}
	names := make([]string, 0, len(matches))
	for _, m := range matches {
		names = append(names, m[1])
	}
	// Preserve leading spaces and sort GBK bytes, not decoded Unicode names.
	sort.Strings(names)
	result := &FosterTemplateCatalogue{ConfigHash: digest(raw)}
	for i, name := range names {
		if i > 0 && name == names[i-1] {
			return nil, fmt.Errorf("duplicate Foster template name")
		}
		decoded, err := decodeText([]byte(name))
		if err != nil {
			return nil, err
		}
		result.Names = append(result.Names, decoded)
	}
	return result, nil
}
