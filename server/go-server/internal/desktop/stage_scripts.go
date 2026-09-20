package desktop

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
	"regexp"
	"strconv"
	"strings"
)

var stageScriptTable = regexp.MustCompile(`(?m)^\s*configs\s*=\s*\{\s*maps\s*=\s*\{`)
var stageScriptRow = regexp.MustCompile(`^\s*\{\s*([0-9]+)\s*,\s*"([A-Za-z0-9_]+)"\s*\}\s*(,?)`)

// Read only the literal configs.maps table. Do not execute client Lua or infer
// bindings from map filenames, comments, or similarly named scripts.
func stageScriptBindings(text string) (map[uint32]string, error) {
	var lines []string
	for _, line := range strings.Split(strings.ReplaceAll(text, "\r", "\n"), "\n") {
		if strings.Contains(line, "--[[") || strings.Contains(line, "--[=") {
			return nil, fmt.Errorf("unsupported Lua block comment in stage configuration")
		}
		line, _, _ = strings.Cut(line, "--")
		lines = append(lines, line)
	}
	clean := strings.Join(lines, "\n")
	start := stageScriptTable.FindStringIndex(clean)
	if start == nil {
		return nil, fmt.Errorf("missing literal configs.maps table")
	}
	rest := clean[start[1]:]
	result := map[uint32]string{}
	for {
		rest = strings.TrimSpace(rest)
		if strings.HasPrefix(rest, "}") {
			if len(result) == 0 {
				return nil, fmt.Errorf("empty stage script table")
			}
			return result, nil
		}
		row := stageScriptRow.FindStringSubmatch(rest)
		if row == nil {
			return nil, fmt.Errorf("unsupported stage script binding")
		}
		id, err := strconv.ParseUint(row[1], 10, 32)
		if err != nil || id == 0 || result[uint32(id)] != "" {
			return nil, fmt.Errorf("invalid or duplicate stage script map %s", row[1])
		}
		result[uint32(id)] = "script/pve/" + strings.ToLower(row[2]) + ".lua"
		rest = rest[len(row[0]):]
		if row[3] == "" && !strings.HasPrefix(strings.TrimSpace(rest), "}") {
			return nil, fmt.Errorf("missing separator in stage script table")
		}
	}
}

func (a *archive) attachStageScripts(maps []StageMap) error {
	const config = "script/pve/config.lua"
	if _, exists := a.entries[config]; !exists {
		return nil
	}
	text, err := a.text(config)
	if err != nil {
		return err
	}
	bindings, err := stageScriptBindings(text)
	if err != nil {
		return err
	}
	configRaw, err := a.raw(config)
	if err != nil {
		return err
	}
	templates, err := fosterTemplates(configRaw)
	if err != nil {
		return err
	}
	var fosterRuntimeHash string
	for i := range maps {
		name := bindings[maps[i].MapID]
		if name == "" {
			return fmt.Errorf("PVE map %d has no script binding", maps[i].MapID)
		}
		raw, err := a.raw(name)
		if err != nil {
			return fmt.Errorf("PVE map %d script: %w", maps[i].MapID, err)
		}
		maps[i].Script, maps[i].ScriptHash = name, digest(raw)
		if maps[i].MapType == uint32(protocol.FosterMode) {
			// 942910 executes the compiled include before config.lua and the
			// selected map script. The adjacent pve.lua is not that runtime.
			const runtime = "script/pve/include"
			if fosterRuntimeHash == "" {
				compiled, e := a.raw(runtime)
				if e != nil {
					return fmt.Errorf("PVE mode 10 runtime: %w", e)
				}
				fosterRuntimeHash = digest(compiled)
			}
			maps[i].RuntimeScript, maps[i].RuntimeHash = runtime, fosterRuntimeHash
			maps[i].FosterTemplates = templates
			maps[i].FosterPreview, err = fosterPlanPreview(raw, fosterRuntimeHash, templates)
			if err != nil {
				return err
			}
		}
		if maps[i].MapType == uint32(protocol.StageAssault) {
			maps[i].WavePreview, err = a.stageWavePreview(name, raw)
			if err != nil {
				return err
			}
		}
	}
	return nil
}
