package persistence

import (
	"database/sql"
	"github.com/go-sql-driver/mysql"
	"os"
	"strings"
	"testing"
)

func TestTitlePolicyValidation(t *testing.T) {
	good := func() TitleSettings {
		return TitleSettings{Rules: TitleRules{Enabled: true, Titles: []TitleRule{{Level: 1, Enabled: true, Matches: 10, Choices: []uint32{7}}}}}
	}
	for _, mutate := range []func(*TitleSettings){
		func(a *TitleSettings) { a.Rules.Titles = nil },
		func(a *TitleSettings) { a.Rules.Titles[0].Level = 0 },
		func(a *TitleSettings) { a.Rules.Titles = append(a.Rules.Titles, a.Rules.Titles[0]) },
		func(a *TitleSettings) { a.Rules.Titles[0].Matches = 0 },
		func(a *TitleSettings) { a.Rules.Titles[0].MinPlayerLevel = 151 },
		func(a *TitleSettings) { a.Rules.Titles[0].Wins = 0x80000000 },
		func(a *TitleSettings) { a.Rules.Titles[0].Choices = nil },
		func(a *TitleSettings) { a.Rules.Titles[0].Choices = []uint32{7, 7} },
		func(a *TitleSettings) { a.Rules.Titles[0].Choices = []uint32{0} },
		func(a *TitleSettings) { a.Rules.Titles[0].Choices = []uint32{1, 2, 3, 4, 5, 6, 7, 8} },
	} {
		a := good()
		mutate(&a)
		if a.Validate() == nil {
			t.Fatal("invalid title rules accepted", a)
		}
	}
	a := good()
	if err := a.Validate(); err != nil {
		t.Fatal(err)
	}
	a.Rules.Enabled = false
	if err := a.Validate(); err != nil || len(a.Rules.Titles[0].Choices) != 1 {
		t.Fatal("disabled rules lost", err)
	}
}

func TestTitleCatalogueBinding(t *testing.T) {
	r := TitleRules{ClientHash: strings.Repeat("a", 64), Catalogue: []TitleCatalogueEntry{{Level: 0, Name: "Initial"}, {Level: 1, Name: "One"}}, Titles: []TitleRule{{Level: 1, Enabled: true, MinPlayerLevel: 1, Choices: []uint32{7}}}}
	if err := (TitleSettings{Rules: r}).Validate(); err != nil {
		t.Fatal(err)
	}
	if len(r.SupportedLevels(strings.Repeat("b", 64))) != 0 || len(r.SupportedLevels("")) != 0 {
		t.Fatal("mismatched catalogue enabled")
	}
	if levels := r.SupportedLevels(r.ClientHash); len(levels) != 1 || levels[0] != 1 {
		t.Fatal(levels)
	}
	for _, mutate := range []func(*TitleRules){
		func(r *TitleRules) { r.ClientHash = "invalid" },
		func(r *TitleRules) { r.ClientHash = strings.Repeat("A", 64) },
		func(r *TitleRules) { r.Catalogue = nil },
		func(r *TitleRules) {
			r.Catalogue = []TitleCatalogueEntry{{Level: 1, Name: "One"}, {Level: 1, Name: "Other"}}
		},
		func(r *TitleRules) { r.Catalogue = []TitleCatalogueEntry{{Level: 256, Name: "Bad"}} },
		func(r *TitleRules) { r.Catalogue = []TitleCatalogueEntry{{Level: 1, Name: ""}} },
		func(r *TitleRules) { r.Catalogue = []TitleCatalogueEntry{{Level: 2, Name: "Wrong level"}} },
	} {
		copy := r
		mutate(&copy)
		if (TitleSettings{Rules: copy}).Validate() == nil {
			t.Fatal("invalid catalogue accepted")
		}
	}
}

func TestTitleSettingsLocalDatabase(t *testing.T) {
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
		`CREATE TEMPORARY TABLE title_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE title_rules_audit(revision BIGINT UNSIGNED PRIMARY KEY,before_data MEDIUMBLOB NOT NULL,after_data MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
	} {
		if _, err = db.Exec(q); err != nil {
			t.Fatal(err)
		}
	}
	s := &Store{DB: db}
	a, err := s.TitleManager().TitleSettings()
	if err != nil || a.Revision != 0 || a.Rules.Enabled {
		t.Fatal(a, err)
	}
	a.Rules.Enabled = true
	a.Rules.Titles = []TitleRule{{Level: 1, Enabled: true, Matches: 10, Choices: []uint32{7}}}
	saved, err := s.TitleManager().SaveTitleSettings(a)
	if err != nil || saved.Revision != 1 {
		t.Fatal(saved, err)
	}
	if _, err = s.TitleManager().SaveTitleSettings(a); err == nil {
		t.Fatal("stale save accepted")
	}
	if _, err = db.Exec(`INSERT INTO title_rules_audit VALUES(2,'{}','{}')`); err != nil {
		t.Fatal(err)
	}
	saved.Rules.Enabled = false
	if _, err = s.TitleManager().SaveTitleSettings(saved); err == nil {
		t.Fatal("audit failure accepted")
	}
	restored, err := s.TitleManager().TitleSettings()
	if err != nil || restored.Revision != 1 || !restored.Rules.Enabled {
		t.Fatal(restored, err)
	}
	if _, err = db.Exec(`DELETE FROM title_rules_audit WHERE revision=2`); err != nil {
		t.Fatal(err)
	}
	saved, err = s.TitleManager().SaveTitleSettings(saved)
	if err != nil || saved.Rules.Enabled || len(saved.Rules.Titles) != 1 {
		t.Fatal(saved, err)
	}
	if _, err = db.Exec(`UPDATE title_rules SET rules='{"enabled":true,"titles":[]}'`); err != nil {
		t.Fatal(err)
	}
	if _, err = s.TitleManager().TitleSettings(); err == nil {
		t.Fatal("corrupt enabled rules accepted")
	}
}
