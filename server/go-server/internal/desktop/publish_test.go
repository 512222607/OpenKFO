package desktop

import (
	"bytes"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestWeaponPublicationDoesNotOverwriteLocalClient(t *testing.T) {
	client := os.Getenv("OPENKFO_WEAPON_TEST_CLIENT")
	if client == "" {
		t.Skip("set OPENKFO_WEAPON_TEST_CLIENT for installed resource validation")
	}
	items, err := Catalog(client)
	if err != nil {
		t.Fatal(err)
	}
	raw, err := os.ReadFile(filepath.Join(client, "Data", "config.spf2"))
	if err != nil {
		t.Fatal(err)
	}
	target := t.TempDir()
	os.Mkdir(filepath.Join(target, "Data"), 0700)
	os.WriteFile(filepath.Join(target, "Data", "config.spf2"), raw, 0600)
	catalog, err := weaponHandle(Request{Operation: "weapon_catalog"}, target, items, "")
	if err != nil {
		t.Fatal(err)
	}
	c := catalog.(map[string]any)
	weapons := c["weapons"].([]Weapon)
	var chosen Weapon
	var stage Stage
	for _, w := range weapons {
		if w.ID == 253013 {
			chosen = w
			for _, s := range w.Stages {
				if s.Supported && len(s.PropertyIDs) > 0 {
					stage = s
					break
				}
			}
		}
	}
	if stage.Stage == 0 {
		t.Fatal("missing supported fixture weapon")
	}
	request := Request{Operation: "weapon_publish", Weapon: chosen.ID, Revision: c["revision"].(string), Notes: "测试：调整命中伤害", Rules: []Rule{{Stage: stage.Stage, Buff: 0, Level: 1, Duration: 3000, Properties: map[string]map[string]float64{stage.PropertyIDs[0]: {"SkillDamage": 31}}}}}
	result, err := weaponHandle(request, target, items, "")
	if err != nil {
		t.Fatal(err)
	}
	release := result.(weaponRelease)
	if bytes.Equal(release.Data, raw) || !strings.Contains(release.Notes, chosen.Name) {
		t.Fatal("missing edited resource or named release notes")
	}
	current, _ := os.ReadFile(filepath.Join(target, "Data", "config.spf2"))
	if !bytes.Equal(current, raw) {
		t.Fatal("publish overwrote local resource")
	}
	archive, err := parseArchive(release.Data)
	if err != nil {
		t.Fatal(err)
	}
	if err = archive.verify(); err != nil {
		t.Fatal(err)
	}
	if _, err = weaponHandle(request, target, items, ""); err == nil {
		t.Fatal("stale publication revision accepted")
	}
}
