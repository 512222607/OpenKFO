package persistence

import (
	"database/sql"
	"github.com/go-sql-driver/mysql"
	"os"
	"strings"
	"testing"
)

func TestTaskSettingsLocalDatabase(t *testing.T) {
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
		`CREATE TEMPORARY TABLE task_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE task_rules_audit(revision BIGINT UNSIGNED PRIMARY KEY,before_data MEDIUMBLOB NOT NULL,after_data MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
	} {
		if _, err = db.Exec(q); err != nil {
			t.Fatal(err)
		}
	}
	s := &Store{DB: db}
	a, err := s.TaskManager().TaskSettings()
	if err != nil || a.Revision != 0 || a.Rules.Enabled {
		t.Fatal(a, err)
	}
	a.Rules.Enabled = true
	a.Rules.ClientHash = strings.Repeat("a", 64)
	a.Rules.Catalogue = []TaskCatalogueEntry{{ID: 1001, TitleLevel: 2, Enabled: true}}
	a.Rules.Tasks = []TaskRule{{ID: 1001, Enabled: true, Matches: 10, Counters: make([]uint32, 29), Experience: 200, Gold: 100}}
	a.Rules.Extended = extendedTaskFixture()
	saved, err := s.TaskManager().SaveTaskSettings(a)
	if err != nil || saved.Revision != 1 {
		t.Fatal(saved, err)
	}
	if _, err = s.TaskManager().SaveTaskSettings(a); err == nil {
		t.Fatal("stale save accepted")
	}
	if _, err = db.Exec(`INSERT INTO task_rules_audit VALUES(2,'{}','{}')`); err != nil {
		t.Fatal(err)
	}
	saved.Rules.Enabled = false
	if _, err = s.TaskManager().SaveTaskSettings(saved); err == nil {
		t.Fatal("audit failure accepted")
	}
	restored, err := s.TaskManager().TaskSettings()
	if err != nil || restored.Revision != 1 || !restored.Rules.Enabled {
		t.Fatal(restored, err)
	}
	if _, err = db.Exec(`DELETE FROM task_rules_audit WHERE revision=2`); err != nil {
		t.Fatal(err)
	}
	saved, err = s.TaskManager().SaveTaskSettings(saved)
	if err != nil || saved.Rules.Enabled || len(saved.Rules.Tasks) != 1 {
		t.Fatal(saved, err)
	}
	restored, err = s.TaskManager().TaskSettings()
	if err != nil || restored.Rules.ClientHash != strings.Repeat("a", 64) || len(restored.Rules.Catalogue) != 1 || restored.Rules.Catalogue[0].TitleLevel != 2 {
		t.Fatal("catalogue round trip failed", restored, err)
	}
	stripped := saved
	stripped.Rules.Extended = nil
	if _, err = s.TaskManager().SaveTaskSettings(stripped); err == nil {
		t.Fatal("old GM erased extended rules")
	}
	if restored.Rules.Extended == nil || restored.Rules.Extended.Tasks[0].Gold != 500 || restored.Rules.Extended.Catalogue[0].Conditions[0].Required != 1 {
		t.Fatal("extended rules lost", restored)
	}
	stripped = saved
	stripped.Rules.ClientHash = ""
	stripped.Rules.Catalogue = nil
	if _, err = s.TaskManager().SaveTaskSettings(stripped); err == nil {
		t.Fatal("old GM erased binding")
	}
	if _, err = db.Exec(`UPDATE task_rules SET rules='{"enabled":true,"tasks":[]}'`); err != nil {
		t.Fatal(err)
	}
	if _, err = s.TaskManager().TaskSettings(); err == nil {
		t.Fatal("corrupt enabled rules accepted")
	}
}

func TestTaskPolicyValidation(t *testing.T) {
	good := func() TaskSettings {
		return TaskSettings{Rules: TaskRules{Enabled: true, Tasks: []TaskRule{{ID: 1001, Enabled: true, Matches: 10, Counters: make([]uint32, 29), Experience: 200}}}}
	}
	if err := good().Validate(); err != nil {
		t.Fatal(err)
	}
	for _, mutate := range []func(*TaskSettings){
		func(a *TaskSettings) { a.Rules.Tasks = nil },
		func(a *TaskSettings) { a.Rules.Tasks[0].ID = 0 },
		func(a *TaskSettings) { a.Rules.Tasks = append(a.Rules.Tasks, a.Rules.Tasks[0]) },
		func(a *TaskSettings) { a.Rules.Tasks[0].Matches = 0 },
		func(a *TaskSettings) { a.Rules.Tasks[0].Counters = make([]uint32, 30) },
		func(a *TaskSettings) { a.Rules.Tasks[0].Counters[0] = 0x80000000 },
		func(a *TaskSettings) { a.Rules.Tasks[0].Experience = 0x80000000 },
		func(a *TaskSettings) { a.Rules.Tasks[0].Next = 1001 },
		func(a *TaskSettings) { a.Rules.Tasks[0].Next = 1002 },
	} {
		a := good()
		mutate(&a)
		if a.Validate() == nil {
			t.Fatal("invalid policy accepted", a)
		}
	}
	a := good()
	a.Rules.Tasks[0].Next = 1002
	a.Rules.Tasks = append(a.Rules.Tasks, TaskRule{ID: 1002, Counters: make([]uint32, 29), Next: 1001})
	if a.Validate() == nil {
		t.Fatal("cycle accepted")
	}
	a.Rules.Tasks[1].Next = 0
	if e := a.Validate(); e != nil {
		t.Fatal(e)
	}
	a.Rules.Enabled = false
	if e := a.Validate(); e != nil || len(a.Rules.Tasks) != 2 {
		t.Fatal("disabling loses configuration", e)
	}
}
