package persistence

import (
	"database/sql"
	"encoding/json"
	"github.com/go-sql-driver/mysql"
	"os"
	"strings"
	"testing"
)

func TestExtendedTaskTransitionsLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, e := mysql.ParseDSN(dsn)
	if e != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("not debug DB")
	}
	db, e := sql.Open("mysql", dsn)
	if e != nil {
		t.Fatal(e)
	}
	defer db.Close()
	db.SetMaxOpenConns(1)
	db.SetMaxIdleConns(1)
	for _, q := range []string{
		`CREATE TEMPORARY TABLE accounts(uid BIGINT UNSIGNED PRIMARY KEY) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE task_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE extended_task_progress(uid BIGINT UNSIGNED,task_key SMALLINT UNSIGNED,cycle VARCHAR(10),state TINYINT UNSIGNED,rule_revision BIGINT UNSIGNED,rule_data MEDIUMBLOB,counts BINARY(12),PRIMARY KEY(uid,task_key,cycle)) ENGINE=InnoDB`,
		`INSERT INTO accounts VALUES(1),(2)`,
	} {
		if _, e = db.Exec(q); e != nil {
			t.Fatal(e)
		}
	}
	rules := TaskRules{Extended: extendedTaskFixture()}
	daily := rules.Extended.Catalogue[0]
	daily.Kind = "daily"
	daily.ID = 2001
	rules.Extended.Catalogue = append(rules.Extended.Catalogue, daily)
	dr := rules.Extended.Tasks[0]
	dr.Kind = "daily"
	dr.ID = 2001
	rules.Extended.Tasks = append(rules.Extended.Tasks, dr)
	save := func(revision int) {
		t.Helper()
		data, e := json.Marshal(rules)
		if e != nil {
			t.Fatal(e)
		}
		if _, e = db.Exec("REPLACE INTO task_rules VALUES(1,?,?)", revision, data); e != nil {
			t.Fatal(e)
		}
	}
	save(1)
	s := &Store{DB: db}
	hash := strings.Repeat("a", 64)
	list, e := s.ExtendedTasks(1, hash)
	if e != nil || len(list) != 2 || list[0].State != 1 || list[1].State != 1 {
		t.Fatal("initial list", list, e)
	}
	r, changed, e := s.ExtendedTaskTransition(1, hash, 6052, 3002)
	if e != nil || !changed || r.State != 2 || r.Cycle != "" || r.Snapshot.Rule.Gold != 500 {
		t.Fatal(r, changed, e)
	}
	counts := make([]byte, 12)
	counts[0] = 1
	if _, e = db.Exec("UPDATE extended_task_progress SET counts=? WHERE uid=1", counts); e != nil {
		t.Fatal(e)
	}
	rules.Extended.Tasks[0].Gold = 900
	save(2)
	r, changed, e = s.ExtendedTaskTransition(1, hash, 6052, 3002)
	if e != nil || changed || r.Counts[0] != 1 || r.Snapshot.Rule.Gold != 500 || r.Revision != 1 {
		t.Fatal("repeated accept reset snapshot", r, changed, e)
	}
	list, e = s.ExtendedTasks(1, hash)
	if e != nil || len(list) != 2 || list[0].Counts[0] != 1 || list[0].Snapshot.Rule.Gold != 500 {
		t.Fatal("list lost snapshot", list, e)
	}
	for _, c := range []struct {
		uid    uint64
		hash   string
		action uint32
		key    uint16
	}{{1, strings.Repeat("b", 64), 6052, 3002}, {1, hash, 6051, 3002}, {1, hash, 6312, 3002}, {3, hash, 6052, 3002}, {1, hash, 6052, 3999}} {
		if _, _, e = s.ExtendedTaskTransition(c.uid, c.hash, c.action, c.key); e == nil {
			t.Fatal("invalid action accepted", c)
		}
	}
	r, changed, e = s.ExtendedTaskTransition(2, hash, 6052, 3002)
	if e != nil || !changed || r.Counts[0] != 0 || r.Snapshot.Rule.Gold != 900 {
		t.Fatal("cross account state", r, e)
	}
	r, changed, e = s.ExtendedTaskTransition(1, hash, 6082, 3002)
	if e != nil || !changed || r.State != 1 || r.Counts[0] != 0 {
		t.Fatal(r, e)
	}
	if _, changed, e = s.ExtendedTaskTransition(1, hash, 6082, 3002); e != nil || changed {
		t.Fatal("repeat cancel changed", e)
	}
	if _, _, e = s.ExtendedTaskTransition(1, hash, 6052, 3002); e != nil {
		t.Fatal(e)
	}
	if _, e = db.Exec("UPDATE extended_task_progress SET state=4 WHERE uid=1 AND task_key=3002"); e != nil {
		t.Fatal(e)
	}
	if _, _, e = s.ExtendedTaskTransition(1, hash, 6082, 3002); e == nil {
		t.Fatal("cancelled completed task")
	}
	r, changed, e = s.ExtendedTaskTransition(1, hash, 6051, 2001)
	if e != nil || !changed || len(r.Cycle) != 10 {
		t.Fatal(r, e)
	}
	if _, e = db.Exec("UPDATE extended_task_progress SET cycle='1999-01-01',state=3 WHERE uid=1 AND task_key=2001"); e != nil {
		t.Fatal(e)
	}
	r, changed, e = s.ExtendedTaskTransition(1, hash, 6051, 2001)
	if e != nil || !changed || r.State != 2 || r.Cycle == "1999-01-01" {
		t.Fatal("daily cycle not isolated", r, e)
	}
	var n int
	if e = db.QueryRow("SELECT COUNT(*) FROM extended_task_progress WHERE uid=1 AND task_key=2001").Scan(&n); e != nil || n != 2 {
		t.Fatal("history removed", n, e)
	}
	if _, e = db.Exec("UPDATE extended_task_progress SET state=3 WHERE uid=1 AND task_key=3002"); e != nil {
		t.Fatal(e)
	}
	list, e = s.ExtendedTasks(1, hash)
	if e != nil || len(list) != 1 || list[0].Key != 2001 || list[0].Cycle == "1999-01-01" {
		t.Fatal("claimed/new cycle list", list, e)
	}
	list, e = s.ExtendedTasks(2, hash)
	if e != nil || len(list) != 2 || list[0].State != 2 || list[1].State != 1 {
		t.Fatal("list account isolation", list, e)
	}
	rules.Extended.Tasks[1].Enabled = false
	save(3)
	if _, _, e = s.ExtendedTaskTransition(1, hash, 6051, 2001); e == nil {
		t.Fatal("disabled accepted")
	}
	list, e = s.ExtendedTasks(1, hash)
	if e != nil || list == nil || len(list) != 0 {
		t.Fatal("configured empty list", list, e)
	}
	if _, e = s.ExtendedTasks(1, strings.Repeat("b", 64)); e == nil {
		t.Fatal("mismatched list allowed")
	}
	rules.Extended = nil
	save(4)
	if list, e = s.ExtendedTasks(1, hash); e != nil || list != nil {
		t.Fatal("unconfigured list", list, e)
	}
}
