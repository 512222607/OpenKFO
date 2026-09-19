package persistence

import (
	"database/sql"
	"github.com/go-sql-driver/mysql"
	"os"
	"strings"
	"testing"
)

func TestTalismanSettingsLocalDatabase(t *testing.T) {
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
		`CREATE TEMPORARY TABLE talisman_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE talisman_rules_audit(revision BIGINT UNSIGNED PRIMARY KEY,before_data MEDIUMBLOB NOT NULL,after_data MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
	} {
		if _, err = db.Exec(q); err != nil {
			t.Fatal(err)
		}
	}
	s := &Store{DB: db}
	a, err := s.ItemManager().TalismanSettings()
	if err != nil || a.Revision != 0 || a.Rules.Enabled {
		t.Fatal(a, err)
	}
	a.Rules.Enabled = true
	a.Rules.Uses = []TalismanUseRule{{Item: 303002, ActiveCost: 100, PassiveCost: 1}}
	a.Rules.Repairs = []TalismanRepairRule{{Item: 303002, Material: 603001, Quantity: 2, Capacity: 10000}}
	saved, err := s.ItemManager().SaveTalismanSettings(a)
	if err != nil || saved.Revision != 1 {
		t.Fatal(saved, err)
	}
	if _, err = s.ItemManager().SaveTalismanSettings(a); err == nil {
		t.Fatal("stale save accepted")
	}
	if _, err = db.Exec(`INSERT INTO talisman_rules_audit VALUES(2,'{}','{}')`); err != nil {
		t.Fatal(err)
	}
	saved.Rules.Enabled = false
	if _, err = s.ItemManager().SaveTalismanSettings(saved); err == nil {
		t.Fatal("audit failure accepted")
	}
	restored, err := s.ItemManager().TalismanSettings()
	if err != nil || restored.Revision != 1 || !restored.Rules.Enabled {
		t.Fatal(restored, err)
	}
	if _, err = db.Exec(`DELETE FROM talisman_rules_audit WHERE revision=2`); err != nil {
		t.Fatal(err)
	}
	saved, err = s.ItemManager().SaveTalismanSettings(saved)
	if err != nil || saved.Rules.Enabled || len(saved.Rules.Uses) != 1 || len(saved.Rules.Repairs) != 1 {
		t.Fatal(saved, err)
	}
	if _, err = db.Exec(`UPDATE talisman_rules SET rules='{"enabled":true,"uses":[],"repairs":[]}'`); err != nil {
		t.Fatal(err)
	}
	if _, err = s.ItemManager().TalismanSettings(); err == nil {
		t.Fatal("corrupt enabled rules accepted")
	}
}

func TestTalismanSettingsValidation(t *testing.T) {
	if _, err := (&Store{}).Admin(AdminRequest{Operation: "talisman_settings_save"}); err == nil {
		t.Fatal("missing rules accepted")
	}
	a := TalismanSettings{Rules: TalismanRules{Enabled: true, Uses: []TalismanUseRule{{Item: 303002}}, Repairs: []TalismanRepairRule{{Item: 303002, Material: 603001, Quantity: 1, Capacity: 65535}}}}
	if err := a.Validate(); err != nil {
		t.Fatal(err)
	}
	a.Rules.Uses = append(a.Rules.Uses, a.Rules.Uses[0])
	if a.Validate() == nil {
		t.Fatal("duplicate use")
	}
	a.Rules.Uses = a.Rules.Uses[:1]
	a.Rules.Repairs[0].Material = 303002
	if a.Validate() == nil {
		t.Fatal("self repair")
	}
	a.Rules.Repairs[0].Material = 603001
	a.Rules.Repairs[0].Quantity = 0
	if a.Validate() == nil {
		t.Fatal("zero material quantity")
	}
	a.Rules.Repairs = nil
	a.Rules.Uses = nil
	if a.Validate() == nil {
		t.Fatal("enabled empty rules")
	}
	a.Rules.Enabled = false
	if err := a.Validate(); err != nil {
		t.Fatal(err)
	}
}
