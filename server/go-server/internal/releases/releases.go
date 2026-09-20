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
	Kind       string `json:"kind"`
	Version    string `json:"version"`
	Notes      string `json:"notes"`
	SHA256     string `json:"sha256"`
	Size       int64  `json:"size"`
	Package    string `json:"package"`
	ConfigHash string `json:"config_hash,omitempty"`
}

var hashPattern = regexp.MustCompile(`^[0-9a-f]{64}$`)

func Hash(data []byte) string { sum := sha256.Sum256(data); return hex.EncodeToString(sum[:]) }
func (m Manifest) Validate() error {
	if (m.Kind != "weapons" && m.Kind != "gm") || !hashPattern.MatchString(m.SHA256) || m.Size < 1 || m.Size > MaxPackage || len(m.Version) < 1 || len(m.Version) > 100 || len(m.Notes) < 1 || len(m.Notes) > 16384 || m.Package != m.SHA256+".zip" {
		return fmt.Errorf("invalid release manifest")
	}
	if m.Kind == "weapons" && !hashPattern.MatchString(m.ConfigHash) {
		return fmt.Errorf("invalid configuration hash")
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
		if m.Kind == "weapons" && Hash(raw) != m.ConfigHash {
			return fmt.Errorf("resource checksum mismatch")
		}
	}
	if m.Kind == "weapons" && len(seen) != 1 {
		return fmt.Errorf("missing weapon resource")
	}
	if m.Kind == "gm" && (!seen["gm管理器.exe"] || !seen["kungfu-desktop-admin.exe"] || !seen["flutter_windows.dll"] || !seen["data/icudtl.dat"]) {
		return fmt.Errorf("incomplete GM runtime")
	}
	return nil
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
		if dir == "" || !(name == "weapons.json" || name == "gm.json" || len(name) == 68 && hashPattern.MatchString(strings.TrimSuffix(name, ".zip")) && strings.HasSuffix(name, ".zip")) {
			http.NotFound(w, r)
			return
		}
		w.Header().Set("Cache-Control", "no-store")
		w.Header().Set("X-Content-Type-Options", "nosniff")
		http.ServeFile(w, r, filepath.Join(dir, name))
	})
}
