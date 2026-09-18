package desktop

import (
	"encoding/json"
	"os"
	"path/filepath"
	"testing"

	"kungfu.local/server/internal/persistence"
)

func TestEnvironmentIsolation(t *testing.T) {
	admin := New(t.TempDir())
	remoteCalls := 0
	admin.Remote = func(r persistence.AdminRequest) (json.RawMessage, error) {
		remoteCalls++
		return json.RawMessage(`{}`), nil
	}
	for _, env := range []string{"invalid", "local"} {
		if _, err := admin.Call(Request{Environment: env, Operation: "rewards_get"}); err == nil {
			t.Fatal("invalid environment/config accepted")
		}
	}
	if remoteCalls != 0 {
		t.Fatal("local error fell back to online")
	}
	admin.LocalSettings = filepath.Join(admin.Root, "settings.private.json")
	for _, dsn := range []string{"user@tcp(example.com:3306)/openkfo_debug_test", "user@tcp(127.0.0.1:3306)/production"} {
		data, _ := json.Marshal(map[string]string{"dsn": dsn, "database": "openkfo_debug_test"})
		if err := os.WriteFile(admin.LocalSettings, data, 0600); err != nil {
			t.Fatal(err)
		}
		if _, err := admin.Call(Request{Environment: "local", Operation: "accounts"}); err == nil {
			t.Fatal("unsafe local DSN accepted")
		}
	}
	if remoteCalls != 0 {
		t.Fatal("invalid local DSN routed online")
	}
	if _, err := admin.Call(Request{Environment: "online", Operation: "rewards_get"}); err != nil || remoteCalls != 1 {
		t.Fatal("online request not routed explicitly")
	}
}
