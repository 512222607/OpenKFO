package persistence

import (
	"database/sql"
	"os"
	"strings"
	"testing"

	"github.com/go-sql-driver/mysql"
)

func TestStageAccessValidation(t *testing.T) {
	for _, ids := range [][]uint32{{0}, {1, 1}, {0xffffffff}, make([]uint32, 4097)} {
		if (StageAccess{Disabled: ids}).Validate() == nil {
			t.Fatal("invalid stage access accepted")
		}
	}
	a := StageAccess{Disabled: []uint32{104, 8110}}
	if a.Validate() != nil || a.Allows(104) || !a.Allows(105) {
		t.Fatal("wrong map gate")
	}
}

func TestStageTitleRequirementRules(t *testing.T) {
	hash := strings.Repeat("a", 64)
	a := StageAccess{RequirementsEnabled: true, ClientHash: hash, Requirements: []StageTitleRequirement{{MapID: 8110, Name: "Map", TitleLevel: 3}}}
	if err := a.Validate(); err != nil {
		t.Fatal(err)
	}
	if a.AllowsTitle(8110, 2, hash) || a.AllowsTitle(8111, 4, hash) || a.AllowsTitle(8110, 4, strings.Repeat("b", 64)) || !a.AllowsTitle(8110, 3, hash) {
		t.Fatal("bad title gate")
	}
	a.Disabled = []uint32{8110}
	if a.AllowsTitle(8110, 4, hash) {
		t.Fatal("disabled map bypass")
	}
	a.Disabled = nil
	a.RequirementsEnabled = false
	if !a.AllowsTitle(8110, 0, hash) || len(a.Requirements) != 1 {
		t.Fatal("disabled requirement lost")
	}
	for _, data := range []string{`[]`, `[8110]`, `{"revision":999,"disabled_maps":[8110]}`} {
		r, e := decodeStageAccess([]byte(data), 7)
		if e != nil || r.Revision != 7 {
			t.Fatal(r, e)
		}
	}
	for _, data := range []string{`null`, `{`, `{"requirements_enabled":true}`, `{"client_hash":"bad"}`} {
		if _, e := decodeStageAccess([]byte(data), 0); e == nil {
			t.Fatal("invalid stage rules accepted")
		}
	}
}

// Connection-local temporary tables shadow configuration tables without changing
// the running debug server's map rules. Do not call Open (schema migration) here.
func TestStageAccessLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("not independent debug DB")
	}
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	db.SetMaxOpenConns(1)
	db.SetMaxIdleConns(1)
	for _, query := range []string{
		`CREATE TEMPORARY TABLE stage_access(id TINYINT UNSIGNED PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE stage_access_audit(revision BIGINT UNSIGNED PRIMARY KEY,before_data MEDIUMBLOB NOT NULL,after_data MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
	} {
		if _, err = db.Exec(query); err != nil {
			t.Fatal(err)
		}
	}
	s := &Store{DB: db}
	a, err := s.StageAccess()
	if err != nil || a.Revision != 0 || len(a.Disabled) != 0 {
		t.Fatal(a, err)
	}
	a.Disabled = []uint32{8110}
	saved, err := s.SaveStageAccess(a)
	if err != nil || saved.Revision != 1 {
		t.Fatal(saved, err)
	}
	if _, err = s.SaveStageAccess(a); err == nil {
		t.Fatal("stale revision accepted")
	}
	var before, after string
	if err = db.QueryRow(`SELECT before_data,after_data FROM stage_access_audit WHERE revision=1`).Scan(&before, &after); err != nil || before != "[]" || after != "[8110]" {
		t.Fatal(before, after, err)
	}
	// Force an audit insertion failure after the configuration UPDATE. Both must
	// roll back together; a failed save must never silently change map access.
	if _, err = db.Exec(`INSERT INTO stage_access_audit VALUES(2,'[]','[]')`); err != nil {
		t.Fatal(err)
	}
	saved.Disabled = []uint32{8111}
	if _, err = s.SaveStageAccess(saved); err == nil {
		t.Fatal("audit failure accepted")
	}
	a, err = s.StageAccess()
	if err != nil || a.Revision != 1 || a.Allows(8110) || !a.Allows(8111) {
		t.Fatal(a, err)
	}
	if _, err = db.Exec(`DELETE FROM stage_access_audit WHERE revision=2`); err != nil {
		t.Fatal(err)
	}
	saved.Disabled = nil
	a, err = s.SaveStageAccess(saved)
	if err != nil || a.Revision != 2 || !a.Allows(8110) {
		t.Fatal(a, err)
	}
	a.ClientHash = strings.Repeat("a", 64)
	a.RequirementsEnabled = true
	a.Requirements = []StageTitleRequirement{{MapID: 8110, Name: "Map", TitleLevel: 3}}
	a, err = s.SaveStageAccess(a)
	if err != nil || a.Revision != 3 {
		t.Fatal(a, err)
	}
	loaded, err := s.StageAccess()
	if err != nil || loaded.Revision != 3 || loaded.AllowsTitle(8110, 2, a.ClientHash) || !loaded.AllowsTitle(8110, 3, a.ClientHash) {
		t.Fatal("requirement persistence", loaded, err)
	}
	if _, err = s.SaveStageAccess(StageAccess{Revision: 3}); err == nil {
		t.Fatal("old GM erased requirements")
	}
	a.RequirementsEnabled = false
	a, err = s.SaveStageAccess(a)
	if err != nil || a.Revision != 4 {
		t.Fatal(a, err)
	}
	loaded, err = s.StageAccess()
	if err != nil || loaded.RequirementsEnabled || len(loaded.Requirements) != 1 || loaded.ClientHash != a.ClientHash {
		t.Fatal("disabled requirements lost", err)
	}
	required := true
	loaded.Requirements[0].UnlockRequired = &required
	loaded, err = s.SaveStageAccess(loaded)
	if err != nil {
		t.Fatal(err)
	}
	loaded.Requirements[0].UnlockRequired = nil // older GM does not know this field
	loaded, err = s.SaveStageAccess(loaded)
	if err != nil || !loaded.Requirements[0].NeedsUnlock() {
		t.Fatal("old GM erased unlock condition", err)
	}
	disabled := false
	loaded.Requirements[0].UnlockRequired = &disabled
	loaded, err = s.SaveStageAccess(loaded)
	if err != nil || loaded.Requirements[0].NeedsUnlock() {
		t.Fatal("explicit false ignored", err)
	}
	loaded.PVEMaps = []uint32{8110}
	loaded, err = s.SaveStageAccess(loaded)
	if err != nil {
		t.Fatal(err)
	}
	loaded.PVEMaps = nil
	loaded, err = s.SaveStageAccess(loaded)
	if err != nil || len(loaded.PVEMaps) != 1 || loaded.PVEMaps[0] != 8110 {
		t.Fatal("old GM erased PVE catalogue", loaded, err)
	}
	loaded.PVEMaps = []uint32{}
	loaded, err = s.SaveStageAccess(loaded)
	if err != nil || len(loaded.PVEMaps) != 0 {
		t.Fatal("explicit empty catalogue ignored", err)
	}
	if _, err = db.Exec(`UPDATE stage_access SET rules='invalid' WHERE id=1`); err != nil {
		t.Fatal(err)
	}
	if _, err = s.StageAccess(); err == nil {
		t.Fatal("corrupt rules accepted")
	}
}

func TestStagePVECatalogueValidation(t *testing.T) {
	a := StageAccess{ClientHash: strings.Repeat("a", 64), Requirements: []StageTitleRequirement{{MapID: 8110, Name: "Map"}}}
	for _, ids := range [][]uint32{{8111}, {8110, 8110}, {0}} {
		a.PVEMaps = ids
		if a.Validate() == nil {
			t.Fatal("invalid PVE catalogue", ids)
		}
	}
	a.PVEMaps = []uint32{8110}
	if e := a.Validate(); e != nil {
		t.Fatal(e)
	}
	a.Requirements = nil
	if a.Validate() == nil {
		t.Fatal("missing directory accepted")
	}
}

func TestStagePlayerPolicyIntersection(t *testing.T) {
	required := true
	hash := strings.Repeat("a", 64)
	a := StageAccess{ClientHash: hash, RequirementsEnabled: true, Requirements: []StageTitleRequirement{{MapID: 8110, Name: "Map", TitleLevel: 3, UnlockRequired: &required}}}
	grants := map[uint32]bool{8110: true}
	if a.AllowsPlayer(8110, 2, hash, grants) || a.AllowsPlayer(8110, 3, hash, nil) || a.AllowsPlayer(8111, 3, hash, grants) || a.AllowsPlayer(8110, 3, strings.Repeat("b", 64), grants) || !a.AllowsPlayer(8110, 3, hash, grants) {
		t.Fatal("title/unlock/version policies disagree")
	}
	a.RequirementsEnabled = false
	if !a.AllowsPlayer(8110, 0, hash, nil) {
		t.Fatal("disabled condition still blocks")
	}
	a.Disabled = []uint32{8110}
	if a.AllowsPlayer(8110, 3, hash, grants) {
		t.Fatal("grant bypasses global closure")
	}
}
