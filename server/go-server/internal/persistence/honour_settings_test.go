package persistence

import (
	"database/sql"
	"github.com/go-sql-driver/mysql"
	"os"
	"strings"
	"testing"
)

func TestHonourSettingsLocalDatabase(t *testing.T) {
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
		`CREATE TEMPORARY TABLE honour_rules(id TINYINT UNSIGNED PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE honour_rules_audit(revision BIGINT UNSIGNED PRIMARY KEY,before_data MEDIUMBLOB NOT NULL,after_data MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
	} {
		if _, err = db.Exec(query); err != nil {
			t.Fatal(err)
		}
	}

	s := &Store{DB: db}
	base := HonourRules{Periods: []string{"第一期"}, Modes: []byte{1}, Win: 10, LevelPoints: []uint32{100, 300}}
	initial, err := s.HonourSettings(base)
	if err != nil || initial.Revision != 0 || initial.Rules.Win != 10 {
		t.Fatal(initial, err)
	}
	if _, err = s.SaveHonourSettings(initial); err == nil {
		t.Fatal("unseeded GM save accepted")
	}
	if err = s.SeedHonourSettings(base); err != nil {
		t.Fatal(err)
	}
	if err = s.SeedHonourSettings(HonourRules{}); err != nil {
		t.Fatal(err)
	}
	initial, err = s.HonourSettings(HonourRules{})
	if err != nil || initial.Revision != 1 || len(initial.Rules.Periods) != 1 {
		t.Fatal("seed overwrote legacy rules", initial, err)
	}
	saved, err := s.SaveHonourSettings(initial)
	if err != nil || saved.Revision != 2 {
		t.Fatal(saved, err)
	}
	if _, err = s.SaveHonourSettings(initial); err == nil {
		t.Fatal("stale write accepted")
	}
	for _, periods := range [][]string{nil, {"改名"}, {"新期", "第一期"}} {
		bad := saved
		bad.Rules.Periods = periods
		if _, err = s.SaveHonourSettings(bad); err == nil {
			t.Fatal("historical period changed", periods)
		}
	}
	saved.Rules.Periods = []string{"第一期", "第二期"}
	saved, err = s.SaveHonourSettings(saved)
	if err != nil || saved.Revision != 3 {
		t.Fatal(saved, err)
	}
	var before, after string
	if err = db.QueryRow("SELECT before_data,after_data FROM honour_rules_audit WHERE revision=3").Scan(&before, &after); err != nil || !strings.Contains(before, "第一期") || strings.Contains(before, "第二期") || !strings.Contains(after, "第二期") {
		t.Fatal(before, after, err)
	}
	if _, err = db.Exec("INSERT INTO honour_rules_audit VALUES(4,'{}','{}')"); err != nil {
		t.Fatal(err)
	}
	saved.Rules.Win = 99
	if _, err = s.SaveHonourSettings(saved); err == nil {
		t.Fatal("audit failure accepted")
	}
	got, err := s.HonourSettings(HonourRules{})
	if err != nil || got.Revision != 3 || got.Rules.Win != 10 {
		t.Fatal(got, err)
	}
	if _, err = db.Exec("DELETE FROM honour_rules_audit WHERE revision=4"); err != nil {
		t.Fatal(err)
	}
	saved.Rules.Modes = nil
	saved.Rules.LevelPoints = nil
	saved, err = s.SaveHonourSettings(saved)
	if err != nil {
		t.Fatal(err)
	}
	got, err = s.HonourSettings(base)
	if err != nil || len(got.Rules.Modes) != 0 || len(got.Rules.LevelPoints) != 0 {
		t.Fatal("disabled config inherited fallback", got, err)
	}
}
