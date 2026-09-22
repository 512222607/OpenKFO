// SSH-only desktop administration. No public HTTP endpoint or database password
// is shipped to the desktop manager; the DSN remains in the server environment.
package main

import (
	"encoding/json"
	"io"
	"os"
	"path/filepath"

	"kungfu.local/server/internal/gmversion"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/releases"
)

func main() {
	var request persistence.AdminRequest
	var result any
	err := json.NewDecoder(io.LimitReader(os.Stdin, 4<<20)).Decode(&request)
	if err == nil && request.Operation == "gm_version" {
		json.NewEncoder(os.Stdout).Encode(map[string]any{"ok": true, "result": gmversion.Info()})
		return
	}
	if err == nil {
		err = gmversion.Check(request.GMVersion)
	}
	if err == nil {
		var store *persistence.Store
		store, err = persistence.Open(os.Getenv("KK_MYSQL_DSN"))
		if err == nil {
			defer store.DB.Close()
			if request.Operation == "stages_get" || request.Operation == "stages_save" {
				executable, _ := os.Executable()
				dir := filepath.Dir(executable)
				updates := os.Getenv("OPENKFO_UPDATES_DIR")
				if updates == "" {
					updates = filepath.Join(dir, "updates")
				}
				var hash string
				hash, err = releases.ActiveConfigHash(filepath.Join(dir, "config.json"), updates)
				if err == nil {
					result, err = store.AdminStages(request, hash)
				}
			} else {
				result, err = store.Admin(request)
			}
		}
	}
	if err != nil {
		json.NewEncoder(os.Stdout).Encode(map[string]any{"ok": false, "error": err.Error()})
		return
	}
	json.NewEncoder(os.Stdout).Encode(map[string]any{"ok": true, "result": result})
}
