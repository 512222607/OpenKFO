package persistence

import (
	"database/sql"
	"github.com/go-sql-driver/mysql"
	"os"
	"strings"
	"testing"
)

func TestTrainingSettingsLocalDatabase(t *testing.T) {
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
		`CREATE TEMPORARY TABLE training_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE training_rules_audit(revision BIGINT UNSIGNED PRIMARY KEY,before_data MEDIUMBLOB NOT NULL,after_data MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
	} {
		if _, err = db.Exec(q); err != nil {
			t.Fatal(err)
		}
	}
	s := &Store{DB: db}
	a, err := s.TrainingManager().TrainingSettings()
	if err != nil || a.Revision != 0 || a.Rules.Enabled {
		t.Fatal(a, err)
	}
	a.Rules.Enabled = true
	for i := uint32(0); i <= 8; i++ {
		a.Rules.Levels = append(a.Rules.Levels, TrainingRule{Level: i, XPPerHour: 100, XPCap: 1000})
	}
	saved, err := s.TrainingManager().SaveTrainingSettings(a)
	if err != nil || saved.Revision != 1 {
		t.Fatal(saved, err)
	}
	if _, err = s.TrainingManager().SaveTrainingSettings(a); err == nil {
		t.Fatal("stale save accepted")
	}
	if _, err = db.Exec(`INSERT INTO training_rules_audit VALUES(2,'{}','{}')`); err != nil {
		t.Fatal(err)
	}
	saved.Rules.Enabled = false
	if _, err = s.TrainingManager().SaveTrainingSettings(saved); err == nil {
		t.Fatal("audit failure accepted")
	}
	restored, err := s.TrainingManager().TrainingSettings()
	if err != nil || restored.Revision != 1 || !restored.Rules.Enabled {
		t.Fatal(restored, err)
	}
	if _, err = db.Exec(`DELETE FROM training_rules_audit WHERE revision=2`); err != nil {
		t.Fatal(err)
	}
	saved, err = s.TrainingManager().SaveTrainingSettings(saved)
	if err != nil || saved.Rules.Enabled || len(saved.Rules.Levels) != 9 {
		t.Fatal(saved, err)
	}
	if _, err = db.Exec(`UPDATE training_rules SET rules='{"enabled":true,"levels":[]}'`); err != nil {
		t.Fatal(err)
	}
	if _, err = s.TrainingManager().TrainingSettings(); err == nil {
		t.Fatal("corrupt enabled rules accepted")
	}
}

func TestTrainingRewardPolicy(t *testing.T) {
	a := TrainingSettings{}
	if err := a.Validate(); err != nil {
		t.Fatal(err)
	}
	a.Rules.Enabled = true
	if a.Validate() == nil {
		t.Fatal("enabled without levels")
	}
	for i := uint32(0); i <= 8; i++ {
		a.Rules.Levels = append(a.Rules.Levels, TrainingRule{Level: i, XPPerHour: 100, XPCap: 250})
	}
	if err := a.Validate(); err != nil {
		t.Fatal(err)
	}
	for _, c := range []struct{ minutes, want uint32 }{{0, 0}, {59, 0}, {60, 100}, {119, 100}, {120, 200}, {180, 250}, {0xffffffff, 250}} {
		if got := a.Rules.Levels[0].Award(c.minutes); got != c.want {
			t.Fatalf("minutes=%d got=%d want=%d", c.minutes, got, c.want)
		}
	}
	a.Rules.Levels[8].Level = 7
	if a.Validate() == nil {
		t.Fatal("duplicate level accepted")
	}
	a.Rules.Levels[8].Level = 8
	a.Rules.Levels[0].XPPerHour = 0
	if a.Validate() == nil {
		t.Fatal("zero rate with positive cap")
	}
	a.Rules.Levels[0].XPPerHour = 0x80000000
	if a.Validate() == nil {
		t.Fatal("signed overflow")
	}
	if got := (TrainingRule{XPPerHour: 0x7fffffff, XPCap: 0x7fffffff}).Award(0xffffffff); got != 0x7fffffff {
		t.Fatal(got)
	}
}
