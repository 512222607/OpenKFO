// SSH-only desktop administration. No public HTTP endpoint or database password
// is shipped to the desktop manager; the DSN remains in the server environment.
package main

import (
	"encoding/json"
	"io"
	"os"

	"kungfu.local/server/internal/persistence"
)

func main() {
	var request persistence.AdminRequest
	var result any
	err := json.NewDecoder(io.LimitReader(os.Stdin, 4<<20)).Decode(&request)
	if err == nil {
		var store *persistence.Store
		store, err = persistence.Open(os.Getenv("KK_MYSQL_DSN"))
		if err == nil {
			defer store.DB.Close()
			result, err = store.Admin(request)
		}
	}
	if err != nil {
		json.NewEncoder(os.Stdout).Encode(map[string]any{"ok": false, "error": err.Error()})
		return
	}
	json.NewEncoder(os.Stdout).Encode(map[string]any{"ok": true, "result": result})
}
