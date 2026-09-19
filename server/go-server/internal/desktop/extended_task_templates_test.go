package desktop

import (
	"crypto/sha256"
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestExtendedTaskTemplatesValidation(t *testing.T) {
	f := make([]string, 27)
	for i := range f {
		f[i] = "0"
	}
	f[0], f[22], f[24] = "2001", "test", "description"
	f[2], f[3], f[4] = "condition", "17", "5"
	line := strings.Join(f, "\t")
	r, err := extendedTaskTemplates("\ufeff" + line + "\r\n")
	if err != nil || len(r) != 1 || r[0].ID != 2001 || r[0].Name != "test" || r[0].Fields[24] != "description" {
		t.Fatal(r, err)
	}
	if r[0].Conditions[0] != (ExtendedTaskRequirement{Description: "condition", Key: 17, Required: 5}) {
		t.Fatal("condition columns", r)
	}
	for _, c := range []struct {
		i     int
		value string
	}{{0, "0"}, {0, "65536"}, {1, "65536"}, {4, "65536"}, {7, "-1"}, {10, "65536"}, {11, "4294967296"}, {22, " "}, {26, "invalid"}} {
		x := append([]string(nil), f...)
		x[c.i] = c.value
		if _, err := extendedTaskTemplates(strings.Join(x, "\t")); err == nil {
			t.Fatal("invalid accepted", c)
		}
	}
	for _, text := range []string{"", line + "\n" + line, strings.Join(f[:26], "\t"), line + "\t0"} {
		if _, err := extendedTaskTemplates(text); err == nil {
			t.Fatal("invalid table accepted")
		}
	}
}

func TestExtendedTaskNativeArchive(t *testing.T) {
	path := os.Getenv("OPENKFO_CLIENT_ARCHIVE")
	if path == "" {
		t.Skip("archive required")
	}
	before, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	root := t.TempDir()
	if err := os.MkdirAll(filepath.Join(root, "runtime-local"), 0700); err != nil {
		t.Fatal(err)
	}
	config, _ := json.Marshal(map[string]string{"client_directory": filepath.Dir(filepath.Dir(path))})
	if err := os.WriteFile(filepath.Join(root, "runtime-local", "client-path.json"), config, 0600); err != nil {
		t.Fatal(err)
	}
	// This catalogue action reads only the selected local archive, even while
	// preparing rules for online. No database or remote callback is available.
	admin := &Admin{Root: root}
	data, err := admin.Call(Request{Environment: "online", Operation: "task_extended_templates"})
	if err != nil {
		t.Fatal(err)
	}
	result := data.(map[string]any)
	rows := result["catalogues"].(map[string][]ExtendedTaskTemplate)
	if len(rows["daily"]) != 42 || len(rows["newbie"]) != 15 || rows["daily"][0].ID != 2001 || rows["newbie"][0].ID != 3001 {
		t.Fatal("native catalogue mismatch")
	}
	// Key zero is a real training condition, not necessarily an empty slot.
	if rows["daily"][1].Conditions[0].Key != 17 || rows["daily"][1].Conditions[0].Required != 5 || rows["newbie"][1].Conditions[0].Key != 0 || rows["newbie"][1].Conditions[0].Required != 1 || rows["newbie"][1].Conditions[1].Key != 3 {
		t.Fatal("native condition catalogue mismatch")
	}
	if result["client_hash"] != fmt.Sprintf("%x", sha256.Sum256(before)) {
		t.Fatal("hash mismatch")
	}
	after, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	if sha256.Sum256(before) != sha256.Sum256(after) {
		t.Fatal("archive changed")
	}
	t.Log("daily=42 newbie=15; catalogue API and archive immutability verified")
}
