package desktop

import (
	"crypto/sha256"
	"encoding/json"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"testing"

	"kungfu.local/server/internal/persistence"
)

func TestTrainingMissionCatalogue(t *testing.T) {
	base := `<Mission ID="0" Name="walk" MapID="10001" Time="45"/>`
	next := `<Mission ID="1" Name="run" MapID="10001" Time="30"><DependentMission ID="0"/></Mission>`
	parse := func(body string) ([]TrainingMission, error) {
		root, e := parseXML(`<TitleMission><Title ID="1">` + body + `</Title></TitleMission>`)
		if e != nil {
			return nil, e
		}
		return trainingMissions(root)
	}
	r, e := parse(base + next)
	if e != nil || len(r) != 2 || len(r[1].Dependencies) != 1 || r[1].Dependencies[0] != 0 {
		t.Fatal(r, e)
	}
	for _, body := range []string{base + base, next, strings.Replace(base, `Time="45"`, `Time="0"`, 1), strings.Replace(base, `ID="0"`, `ID="65536"`, 1), strings.Replace(next, `DependentMission ID="0"`, `DependentMission ID="1"`, 1)} {
		if _, e := parse(body); e == nil {
			t.Fatal("invalid catalogue accepted", body)
		}
	}
}

func TestTaskCatalogueClientArchive(t *testing.T) {
	path := os.Getenv("OPENKFO_CLIENT_ARCHIVE")
	if path == "" {
		t.Skip("OPENKFO_CLIENT_ARCHIVE required")
	}
	before, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	a, err := loadArchive(path)
	if err != nil {
		t.Fatal(err)
	}
	names := []string{}
	for name := range a.entries {
		if strings.HasSuffix(name, ".xml") && (strings.Contains(name, "mission") || strings.Contains(name, "quest") || strings.Contains(name, "task")) {
			names = append(names, name)
		}
	}
	sort.Strings(names)
	if len(names) == 0 {
		t.Fatal("no task catalogues")
	}
	for _, name := range names {
		root, e := a.xml(name)
		if e != nil {
			t.Fatal(name, e)
		}
		t.Logf("%s root=%s children=%d", name, root.tag, len(root.children))
	}
	missions, err := ReadTrainingMissions(path)
	if err != nil {
		t.Fatal(err)
	}
	found := false
	for _, m := range missions {
		if m.ID == 0 && m.MapID == 10001 && m.Seconds == 45 {
			found = true
		}
	}
	if !found {
		t.Fatal("native first training mission missing")
	}
	// Exercise the GM dispatch without a database, SSH or a second copy of
	// the game. Environment selection must not cause a remote catalogue read.
	root := t.TempDir()
	if err := os.MkdirAll(filepath.Join(root, "runtime-local"), 0700); err != nil {
		t.Fatal(err)
	}
	config, err := json.Marshal(map[string]string{"client_directory": filepath.Dir(filepath.Dir(path))})
	if err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(filepath.Join(root, "runtime-local", "client-path.json"), config, 0600); err != nil {
		t.Fatal(err)
	}
	admin := New(root)
	admin.Remote = func(persistence.AdminRequest) (json.RawMessage, error) {
		t.Fatal("catalogue unexpectedly contacted server")
		return nil, nil
	}
	for _, environment := range []string{"local", "online"} {
		result, err := admin.Call(Request{Operation: "training_missions", Environment: environment})
		if err != nil {
			t.Fatal(err)
		}
		data := result.(map[string]any)
		if data["source"] != "client_titlemission" || len(data["missions"].([]TrainingMission)) != len(missions) {
			t.Fatal("GM catalogue differs from native resource")
		}
	}
	t.Logf("Read %d native training missions", len(missions))
	after, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	if sha256.Sum256(before) != sha256.Sum256(after) {
		t.Fatal("archive changed")
	}
}
