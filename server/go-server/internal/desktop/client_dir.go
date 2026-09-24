package desktop

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

// Which game client the admin tool reads and writes is configuration, not
// hard-coded: client-path.json holds it and the GM exposes a picker. Detection
// is deliberately shallow — a game client is simply a folder that carries a
// parseable Data/config.spf2 — so we only look one level around the server
// tree instead of walking the disk.
func (admin *Admin) clientDirectory(request Request) (any, error) {
	path := filepath.Join(admin.Root, "runtime-local", "client-path.json")
	current := ""
	if data, err := os.ReadFile(path); err == nil {
		var config struct {
			Directory string `json:"client_directory"`
		}
		if json.Unmarshal(data, &config) == nil {
			current = strings.TrimSpace(config.Directory)
		}
	}
	resolved := resolveDirectory(admin.Root, current)
	if request.Operation == "client_directory_get" {
		return map[string]any{
			"directory":   resolved,
			"valid":       isClientDirectory(resolved),
			"config_hash": configHash(resolved),
			"detected":    detectClients(admin.Root, resolved),
			"servers":     describeConfigHashFiles(admin.Root, configHash(resolved)),
		}, nil
	}
	directory := strings.TrimSpace(request.Directory)
	if directory == "" {
		return nil, fmt.Errorf("请选择客户端目录")
	}
	directory = resolveDirectory(admin.Root, directory)
	if !isClientDirectory(directory) {
		return nil, fmt.Errorf("%s 不是客户端目录：找不到可解析的 Data/config.spf2", directory)
	}
	encoded, err := encodeClientPath(directory)
	if err != nil {
		return nil, err
	}
	if err = atomicWrite(path, encoded); err != nil {
		return nil, err
	}
	return map[string]any{
		"directory":   directory,
		"config_hash": configHash(directory),
		"detected":    detectClients(admin.Root, directory),
		"servers":     describeConfigHashFiles(admin.Root, configHash(directory)),
		"message":     "已切换客户端；重新读取后生效",
	}, nil
}

// The game server checks the client's Data/config.spf2 against the config_hash
// recorded in its own config.json (a mismatch only logs and auto-adopts, but
// keeping it in step avoids the warning and the drift). The GM surfaces both
// sides so the value can be copied or written without hunting for the file.
func describeConfigHashFiles(root, clientHash string) []map[string]any {
	result := []map[string]any{}
	for _, path := range configHashFiles(root) {
		data, err := os.ReadFile(path)
		if err != nil {
			continue
		}
		var payload struct {
			ConfigHash string `json:"config_hash"`
		}
		if json.Unmarshal(data, &payload) != nil {
			continue
		}
		result = append(result, map[string]any{
			"path":        path,
			"config_hash": payload.ConfigHash,
			"match":       payload.ConfigHash != "" && strings.EqualFold(payload.ConfigHash, clientHash),
		})
	}
	return result
}

// configHashFiles locates the server config files that carry a config_hash. The
// walk is shallow and prunes build/dependency directories so it stays cheap.
func configHashFiles(root string) []string {
	skip := map[string]bool{
		"build": true, ".git": true, ".dart_tool": true, "node_modules": true,
		"bin": true, "obj": true, ".idea": true, "ephmeral": true, "ephemeral": true,
	}
	found := []string{}
	var walk func(dir string, depth int)
	walk = func(dir string, depth int) {
		if depth > 4 {
			return
		}
		entries, err := os.ReadDir(dir)
		if err != nil {
			return
		}
		for _, entry := range entries {
			name := entry.Name()
			if entry.IsDir() {
				if skip[name] || strings.HasPrefix(name, ".") {
					continue
				}
				walk(filepath.Join(dir, name), depth+1)
				continue
			}
			if name != "config.json" {
				continue
			}
			path := filepath.Join(dir, name)
			if data, err := os.ReadFile(path); err == nil && bytes.Contains(data, []byte(`"config_hash"`)) {
				found = append(found, path)
			}
		}
	}
	walk(root, 0)
	sort.Strings(found)
	return found
}

// setServerConfigHash writes the client's current config.spf2 digest into one of
// the discovered server config files. The path must be one we found ourselves,
// so this can never be pointed at an arbitrary file.
func (admin *Admin) setServerConfigHash(request Request) (any, error) {
	wanted := strings.TrimSpace(request.Path)
	if wanted == "" {
		return nil, fmt.Errorf("请指定要写入的服务端配置")
	}
	wanted = filepath.Clean(wanted)
	hash := configHash(resolveDirectory(admin.Root, readClientDirectory(admin.Root)))
	if hash == "" {
		return nil, fmt.Errorf("当前客户端没有可用的 Data/config.spf2")
	}
	for _, path := range configHashFiles(admin.Root) {
		if !strings.EqualFold(filepath.Clean(path), wanted) {
			continue
		}
		data, err := os.ReadFile(path)
		if err != nil {
			return nil, err
		}
		var payload map[string]any
		if err = json.Unmarshal(data, &payload); err != nil {
			return nil, err
		}
		payload["config_hash"] = hash
		encoded, err := json.MarshalIndent(payload, "", "  ")
		if err != nil {
			return nil, err
		}
		encoded = append(encoded, '\n')
		if err = atomicWrite(path, encoded); err != nil {
			return nil, err
		}
		return map[string]any{
			"path":        path,
			"config_hash": hash,
			"servers":     describeConfigHashFiles(admin.Root, hash),
			"message":     "已写入 " + filepath.Base(filepath.Dir(path)) + "/config.json",
		}, nil
	}
	return nil, fmt.Errorf("只能写入探测到的服务端配置，%s 不在其中", wanted)
}

func readClientDirectory(root string) string {
	path := filepath.Join(root, "runtime-local", "client-path.json")
	data, err := os.ReadFile(path)
	if err != nil {
		return ""
	}
	var config struct {
		Directory string `json:"client_directory"`
	}
	if json.Unmarshal(data, &config) != nil {
		return ""
	}
	return config.Directory
}

func resolveDirectory(root, directory string) string {
	directory = strings.TrimSpace(directory)
	if directory == "" {
		return ""
	}
	if !filepath.IsAbs(directory) {
		directory = filepath.Join(root, directory)
	}
	return filepath.Clean(directory)
}

func configHash(directory string) string {
	if directory == "" {
		return ""
	}
	data, err := os.ReadFile(configPath(directory))
	if err != nil {
		return ""
	}
	return digest(data)
}

// isClientDirectory accepts a folder only when its config package parses and
// passes its own checksums, so a wrong pick is rejected before anything else
// tries to use it.
func isClientDirectory(directory string) bool {
	if directory == "" {
		return false
	}
	info, err := os.Stat(directory)
	if err != nil || !info.IsDir() {
		return false
	}
	data, err := os.ReadFile(configPath(directory))
	if err != nil {
		return false
	}
	archive, err := parseArchive(data)
	if err != nil {
		return false
	}
	return archive.verify() == nil
}

// detectClients lists plausible client folders next to the server tree, marking
// the one in use and flagging any that cannot be read.
func detectClients(root, current string) []map[string]any {
	seen := map[string]bool{}
	candidates := []string{}
	add := func(directory string) {
		directory = filepath.Clean(directory)
		key := normalizeDir(directory)
		if seen[key] {
			return
		}
		seen[key] = true
		candidates = append(candidates, directory)
	}
	for _, parent := range []string{filepath.Dir(root), root} {
		entries, err := os.ReadDir(parent)
		if err != nil {
			continue
		}
		for _, entry := range entries {
			if !entry.IsDir() {
				continue
			}
			if _, err := os.Stat(configPath(filepath.Join(parent, entry.Name()))); err == nil {
				add(filepath.Join(parent, entry.Name()))
			}
		}
	}
	if current != "" {
		add(current)
	}
	sort.Strings(candidates)
	result := []map[string]any{}
	for _, directory := range candidates {
		valid := isClientDirectory(directory)
		entry := map[string]any{
			"directory":   directory,
			"label":       filepath.Base(directory),
			"valid":       valid,
			"current":     normalizeDir(directory) == normalizeDir(current),
			"config_hash": "",
		}
		if valid {
			entry["config_hash"] = configHash(directory)
		}
		result = append(result, entry)
	}
	return result
}
