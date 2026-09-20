// Package releases defines the public, read-only update feed. Publishing is SSH-only.
package releases

import (
	"archive/zip"
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

const MaxPackage = 256 << 20

type Manifest struct {
	Kind           string `json:"kind"`
	Version        string `json:"version"`
	Notes          string `json:"notes"`
	SHA256         string `json:"sha256"`
	Size           int64  `json:"size"`
	Package        string `json:"package"`
	ConfigHash     string `json:"config_hash,omitempty"`
	ExecutableHash string `json:"executable_hash,omitempty"`
}

var hashPattern = regexp.MustCompile(`^[0-9a-f]{64}$`)

func Hash(data []byte) string { sum := sha256.Sum256(data); return hex.EncodeToString(sum[:]) }
func (m Manifest) Validate() error {
	if (m.Kind != "weapons" && m.Kind != "client" && m.Kind != "gm" && m.Kind != "launcher") || !hashPattern.MatchString(m.SHA256) || m.Size < 1 || m.Size > MaxPackage || len(m.Version) < 1 || len(m.Version) > 100 || len(m.Notes) < 1 || len(m.Notes) > 16384 || m.Package != m.SHA256+".zip" {
		return fmt.Errorf("invalid release manifest")
	}
	if (m.Kind == "client" || m.Kind == "weapons") && !hashPattern.MatchString(m.ConfigHash) {
		return fmt.Errorf("invalid configuration hash")
	}
	if m.Kind == "launcher" && !hashPattern.MatchString(m.ExecutableHash) {
		return fmt.Errorf("invalid executable hash")
	}
	return nil
}
func ValidatePackage(m Manifest, data []byte) error {
	if err := m.Validate(); err != nil {
		return err
	}
	if int64(len(data)) != m.Size || Hash(data) != m.SHA256 {
		return fmt.Errorf("package checksum mismatch")
	}
	z, err := zip.NewReader(bytes.NewReader(data), int64(len(data)))
	if err != nil {
		return err
	}
	seen := map[string]bool{}
	var total uint64
	for _, f := range z.File {
		name := f.Name
		lower := strings.ToLower(name)
		if f.FileInfo().IsDir() {
			continue
		}
		if strings.Contains(name, "\\") || strings.Contains(name, ":") || strings.HasPrefix(name, "/") || strings.Contains(name, "..") || seen[lower] || f.Mode()&os.ModeSymlink != 0 {
			return fmt.Errorf("invalid package entry %q", name)
		}
		seen[lower] = true
		total += f.UncompressedSize64
		if total > 512<<20 {
			return fmt.Errorf("expanded package too large")
		}
		if m.Kind == "weapons" && name != "Data/config.spf2" {
			return fmt.Errorf("unexpected weapon resource")
		}
		if m.Kind == "client" && !AllowedClientFile(name) {
			return fmt.Errorf("unsupported client file %q", name)
		}
		if m.Kind == "launcher" && name != "launcher.exe" {
			return fmt.Errorf("unexpected launcher file")
		}
		if m.Kind == "gm" && !(name == "OpenKFO.Updater.exe" || name == "GM管理器.exe" || name == "kungfu-desktop-admin.exe" || strings.HasSuffix(lower, ".dll") && !strings.Contains(name, "/") || strings.HasPrefix(name, "data/")) {
			return fmt.Errorf("private or unsupported GM file %q", name)
		}
		r, e := f.Open()
		if e != nil {
			return e
		}
		raw, e := io.ReadAll(io.LimitReader(r, 513<<20))
		r.Close()
		if e != nil {
			return e
		}
		if m.Kind != "gm" && name == "Data/config.spf2" && Hash(raw) != m.ConfigHash {
			return fmt.Errorf("resource checksum mismatch")
		}
		if m.Kind == "launcher" && Hash(raw) != m.ExecutableHash {
			return fmt.Errorf("executable checksum mismatch")
		}
	}
	if m.Kind == "weapons" && len(seen) != 1 {
		return fmt.Errorf("missing weapon resource")
	}
	if m.Kind == "client" && !seen["data/config.spf2"] {
		return fmt.Errorf("missing client configuration")
	}
	if m.Kind == "launcher" && len(seen) != 1 {
		return fmt.Errorf("missing launcher executable")
	}
	if m.Kind == "gm" && (!seen["gm管理器.exe"] || !seen["kungfu-desktop-admin.exe"] || !seen["flutter_windows.dll"] || !seen["data/icudtl.dat"]) {
		return fmt.Errorf("incomplete GM runtime")
	}
	return nil
}

// Client packages contain resources and runtime DLLs, never launcher settings,
// credentials, or the version-specific main executable.
func AllowedClientFile(name string) bool {
	if strings.ContainsAny(name, "\\:") || strings.Contains(name, "..") {
		return false
	}
	for _, part := range strings.Split(name, "/") {
		if part == "" || strings.HasSuffix(part, ".") || strings.HasSuffix(part, " ") {
			return false
		}
	}
	for _, prefix := range []string{"Data/", "effect/", "GPK/", "HostWidgets/", "SDO/", "spdata/", "UI/", "Weapon/"} {
		if strings.HasPrefix(name, prefix) {
			return true
		}
	}
	return !strings.Contains(name, "/") && strings.HasSuffix(strings.ToLower(name), ".dll")
}

// Keep earlier resource updates when publishing a weapon-only or partial update.
// Packages are cumulative so clients may skip any number of versions.
func MergeClient(previous Manifest, old []byte, next Manifest, data []byte) (Manifest, []byte, error) {
	if err := ValidatePackage(previous, old); err != nil {
		return next, nil, err
	}
	if err := ValidatePackage(next, data); err != nil {
		return next, nil, err
	}
	if previous.Kind != "client" || (next.Kind != "client" && next.Kind != "weapons") {
		return next, nil, fmt.Errorf("not client resources")
	}
	a, _ := zip.NewReader(bytes.NewReader(old), int64(len(old)))
	b, _ := zip.NewReader(bytes.NewReader(data), int64(len(data)))
	replaced := map[string]bool{}
	for _, f := range b.File {
		replaced[strings.ToLower(f.Name)] = true
	}
	var out bytes.Buffer
	z := zip.NewWriter(&out)
	for _, f := range a.File {
		if !replaced[strings.ToLower(f.Name)] {
			if err := z.Copy(f); err != nil {
				return next, nil, err
			}
		}
	}
	for _, f := range b.File {
		if err := z.Copy(f); err != nil {
			return next, nil, err
		}
	}
	if err := z.Close(); err != nil {
		return next, nil, err
	}
	next.Kind = "client"
	next.Size = int64(out.Len())
	next.SHA256 = Hash(out.Bytes())
	next.Package = next.SHA256 + ".zip"
	return next, out.Bytes(), ValidatePackage(next, out.Bytes())
}
func Load(dir, kind string) (Manifest, error) {
	var m Manifest
	data, err := os.ReadFile(filepath.Join(dir, kind+".json"))
	if err == nil {
		err = json.Unmarshal(data, &m)
	}
	if err == nil {
		err = m.Validate()
	}
	return m, err
}
func Handler(dir string) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		name := strings.TrimPrefix(r.URL.Path, "/updates/")
		if dir == "" || !(name == "login.crt" || name == "launcher.json" || name == "client.json" || name == "weapons.json" || name == "gm.json" || len(name) == 68 && hashPattern.MatchString(strings.TrimSuffix(name, ".zip")) && strings.HasSuffix(name, ".zip")) {
			http.NotFound(w, r)
			return
		}
		w.Header().Set("Cache-Control", "no-store")
		w.Header().Set("X-Content-Type-Options", "nosniff")
		http.ServeFile(w, r, filepath.Join(dir, name))
	})
}
