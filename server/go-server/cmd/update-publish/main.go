// SSH stdin: one JSON manifest line, followed by the exact ZIP bytes.
package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io"
	"kungfu.local/server/internal/releases"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

func run() error {
	dir := "/opt/kungfu-go/updates"
	if err := os.MkdirAll(dir, 0755); err != nil {
		return err
	}
	lock, err := os.OpenFile(filepath.Join(dir, "publish.lock"), os.O_CREATE|os.O_EXCL|os.O_WRONLY, 0600)
	if err != nil {
		return fmt.Errorf("another publication is running: %w", err)
	}
	lock.Close()
	defer os.Remove(filepath.Join(dir, "publish.lock"))
	reader := bufio.NewReaderSize(os.Stdin, 64<<10)
	line, err := reader.ReadSlice('\n')
	if err != nil {
		return err
	}
	var m releases.Manifest
	if err = json.Unmarshal(line, &m); err != nil {
		return err
	}
	if err = m.Validate(); err != nil {
		return err
	}
	raw, err := io.ReadAll(io.LimitReader(reader, releases.MaxPackage+1))
	if err != nil {
		return err
	}
	if err = releases.ValidatePackage(m, raw); err != nil {
		return err
	}
	if m.Kind == "client" || m.Kind == "weapons" {
		previous, loadErr := releases.Load(dir, "client")
		if loadErr == nil {
			oldPackage, e := os.ReadFile(filepath.Join(dir, previous.Package))
			if e != nil {
				return e
			}
			m, raw, err = releases.MergeClient(previous, oldPackage, m, raw)
			if err != nil {
				return err
			}
		} else if !os.IsNotExist(loadErr) {
			return loadErr
		}
		m.Kind = "client"
		if err = releases.ValidatePackage(m, raw); err != nil {
			return err
		}
	}
	pkg := filepath.Join(dir, m.Package)
	if err = os.WriteFile(pkg+".next", raw, 0644); err != nil {
		return err
	}
	if err = os.Rename(pkg+".next", pkg); err != nil {
		return err
	}
	path := filepath.Join(dir, m.Kind+".json")
	old, readErr := os.ReadFile(path)
	if readErr != nil && !os.IsNotExist(readErr) {
		return readErr
	}
	if len(old) > 0 {
		if err = os.WriteFile(path+".before-"+time.Now().UTC().Format("20060102T150405.000000000"), old, 0600); err != nil {
			return err
		}
	}
	encoded, _ := json.MarshalIndent(m, "", "  ")
	if err = os.WriteFile(path+".next", encoded, 0644); err != nil {
		return err
	}
	if err = os.Rename(path+".next", path); err != nil {
		return err
	}
	if m.Kind == "client" || m.Kind == "weapons" {
		restart := func() error {
			if output, e := exec.Command("systemctl", "restart", "kungfu-go").CombinedOutput(); e != nil {
				return fmt.Errorf("restart: %s: %w", output, e)
			}
			client := http.Client{Timeout: time.Second}
			for n := 0; n < 25; n++ {
				r, e := client.Get("http://127.0.0.1:19090/health")
				if e == nil {
					r.Body.Close()
					if r.StatusCode == 200 {
						return nil
					}
				}
				time.Sleep(time.Second)
			}
			return fmt.Errorf("server health check failed")
		}
		if err = restart(); err != nil {
			var rollback error
			if len(old) > 0 {
				rollback = os.WriteFile(path+".next", old, 0644)
				if rollback == nil {
					rollback = os.Rename(path+".next", path)
				}
			} else {
				rollback = os.Remove(path)
			}
			if rollback == nil {
				rollback = restart()
			}
			return fmt.Errorf("activation failed: %v; rollback: %v", err, rollback)
		}
	}
	return json.NewEncoder(os.Stdout).Encode(map[string]any{"message": "已发布：" + m.Version, "version": m.Version, "config_hash": m.ConfigHash})
}
func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
