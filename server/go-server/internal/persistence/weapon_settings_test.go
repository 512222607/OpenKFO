package persistence

import (
	"database/sql"
	"github.com/go-sql-driver/mysql"
	"os"
	"strings"
	"testing"
)

func TestWeaponSettingsLocalDatabase(t *testing.T) {
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
	for _, q := range []string{
		`CREATE TEMPORARY TABLE weapon_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE weapon_rules_audit(revision BIGINT UNSIGNED PRIMARY KEY,before_data MEDIUMBLOB NOT NULL,after_data MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
	} {
		if _, err = db.Exec(q); err != nil {
			t.Fatal(err)
		}
	}
	s := &Store{DB: db}
	a, err := s.ItemManager().WeaponSettings()
	if err != nil || a.Revision != 0 || a.Rules.Enabled {
		t.Fatal(a, err)
	}
	a.Rules.Enabled = true
	for i := uint32(0); i <= 1; i++ {
		a.Rules.Levels = append(a.Rules.Levels, WeaponLevel{Level: i, ScoreThreshold: 100, Gold: 50, DisplayOdds: 75})
	}
	saved, err := s.ItemManager().SaveWeaponSettings(a)
	if err != nil || saved.Revision != 1 {
		t.Fatal(saved, err)
	}
	if _, err = s.ItemManager().SaveWeaponSettings(a); err == nil {
		t.Fatal("stale save accepted")
	}
	if _, err = db.Exec(`INSERT INTO weapon_rules_audit VALUES(2,'{}','{}')`); err != nil {
		t.Fatal(err)
	}
	saved.Rules.Enabled = false
	if _, err = s.ItemManager().SaveWeaponSettings(saved); err == nil {
		t.Fatal("audit failure accepted")
	}
	restored, err := s.ItemManager().WeaponSettings()
	if err != nil || restored.Revision != 1 || !restored.Rules.Enabled {
		t.Fatal(restored, err)
	}
	if _, err = db.Exec(`DELETE FROM weapon_rules_audit WHERE revision=2`); err != nil {
		t.Fatal(err)
	}
	saved, err = s.ItemManager().SaveWeaponSettings(saved)
	if err != nil || saved.Rules.Enabled || len(saved.Rules.Levels) != 2 {
		t.Fatal(saved, err)
	}
	if _, err = db.Exec(`UPDATE weapon_rules SET rules='{"enabled":true,"levels":[]}'`); err != nil {
		t.Fatal(err)
	}
	if _, err = s.ItemManager().WeaponSettings(); err == nil {
		t.Fatal("corrupt enabled rules accepted")
	}
}

func TestWeaponSettingsValidation(t *testing.T) {
	if _, err := (&Store{}).Admin(AdminRequest{Operation: "weapon_settings_save"}); err == nil {
		t.Fatal("missing configuration accepted")
	}
	a := WeaponSettings{Rules: WeaponRules{Enabled: true, Levels: []WeaponLevel{{Level: 0, ScoreThreshold: 1, DisplayOdds: 100}, {Level: 1, ScoreThreshold: 2}}}}
	if e := a.Validate(); e != nil {
		t.Fatal(e)
	}
	a.Rules.Levels[1].Level = 2
	if a.Validate() == nil {
		t.Fatal("sparse levels accepted")
	}
	a.Rules.Levels[1].Level = 1
	a.Rules.Levels[0].DisplayOdds = 101
	if a.Validate() == nil {
		t.Fatal("invalid odds accepted")
	}
	a.Rules.Levels[0].DisplayOdds = 100
	a.Rules.Levels[0].ScoreThreshold = 0
	if a.Validate() == nil {
		t.Fatal("zero threshold accepted")
	}
	a.Rules.Levels = nil
	if a.Validate() == nil {
		t.Fatal("enabled empty table")
	}
	a.Rules.Enabled = false
	if e := a.Validate(); e != nil {
		t.Fatal(e)
	}
}
