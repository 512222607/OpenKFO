package persistence

import (
	"database/sql"
	"encoding/json"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
)

func TestTaskLifecycleLocalDatabase(t *testing.T) {
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
		`CREATE TEMPORARY TABLE accounts(uid BIGINT UNSIGNED PRIMARY KEY,profile BLOB NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE task_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE task_progress(uid BIGINT UNSIGNED,task_key SMALLINT UNSIGNED,state TINYINT UNSIGNED,baseline BINARY(116),rule_revision BIGINT UNSIGNED,rule_data MEDIUMBLOB,PRIMARY KEY(uid,task_key)) ENGINE=InnoDB`,
	} {
		if _, err = db.Exec(q); err != nil {
			t.Fatal(err)
		}
	}
	profile := make([]byte, 360)
	protocol.WriteUint32(profile, 0, 7)
	protocol.WriteUint32(profile, 129, 50)
	for _, uid := range []int{1, 2} {
		if _, err = db.Exec("INSERT INTO accounts VALUES(?,?)", uid, profile); err != nil {
			t.Fatal(err)
		}
	}
	rules := TaskRules{Enabled: true, Tasks: []TaskRule{{ID: 1001, Enabled: true, Next: 1002, Matches: 10, Counters: make([]uint32, 29), Experience: 100}, {ID: 1002, Enabled: true, Matches: 20, Counters: make([]uint32, 29)}}}
	data, _ := json.Marshal(rules)
	if _, err = db.Exec("INSERT INTO task_rules VALUES(1,7,?)", data); err != nil {
		t.Fatal(err)
	}
	store := &Store{DB: db}
	list, err := store.Tasks(1, 0, 0)
	if err != nil || len(list) != 1 || list[0].Key != 1001 || list[0].State != 1 {
		t.Fatal(list, err)
	}
	if _, err = store.Tasks(1, 6050, 1002); err == nil {
		t.Fatal("locked successor accepted")
	}
	list, err = store.Tasks(1, 6050, 1001)
	if err != nil || list[0].State != 2 || list[0].ProfileBaseline[0] != 50 {
		t.Fatal(list, err)
	}
	protocol.WriteUint32(profile, 129, 60)
	if _, err = db.Exec("UPDATE accounts SET profile=? WHERE uid=1", profile); err != nil {
		t.Fatal(err)
	}
	list, err = store.Tasks(1, 6050, 1001)
	if err != nil || list[0].ProfileBaseline[0] != 50 {
		t.Fatal("repeat acceptance reset baseline", list, err)
	}
	var revision uint64
	var snapshot []byte
	if err = db.QueryRow("SELECT rule_revision,rule_data FROM task_progress WHERE uid=1 AND task_key=1001").Scan(&revision, &snapshot); err != nil {
		t.Fatal(err)
	}
	var frozen TaskRule
	if err = json.Unmarshal(snapshot, &frozen); err != nil || revision != 7 || frozen.Experience != 100 {
		t.Fatal(frozen, err)
	}
	list, err = store.Tasks(2, 0, 0)
	if err != nil || list[0].State != 1 {
		t.Fatal("account isolation failed", list, err)
	}
	list, err = store.Tasks(1, 6080, 1001)
	if err != nil || list[0].State != 1 || list[0].ProfileBaseline[0] != 0 {
		t.Fatal(list, err)
	}
	list, err = store.Tasks(1, 6050, 1001)
	if err != nil || list[0].ProfileBaseline[0] != 60 {
		t.Fatal("new acceptance did not snapshot", list, err)
	}
	// Simulate a completed record only in the temporary fixture, not via client claims.
	if _, err = db.Exec("UPDATE task_progress SET state=3 WHERE uid=1 AND task_key=1001"); err != nil {
		t.Fatal(err)
	}
	list, err = store.Tasks(1, 0, 0)
	if err != nil || len(list) != 2 || list[1].Key != 1002 || list[1].State != 1 {
		t.Fatal("successor not unlocked", list, err)
	}
	if _, err = store.Tasks(1, 6080, 1001); err == nil {
		t.Fatal("completed task cancelled")
	}
	if _, err = store.Tasks(3, 6050, 1001); err == nil {
		t.Fatal("unknown account accepted")
	}
	if _, err = store.Tasks(1, 6030, 1001); err == nil {
		t.Fatal("client completion accepted")
	}
	rules.Enabled = false
	data, _ = json.Marshal(rules)
	if _, err = db.Exec("UPDATE task_rules SET rules=?", data); err != nil {
		t.Fatal(err)
	}
	list, err = store.Tasks(1, 0, 0)
	if err != nil || len(list) != 0 {
		t.Fatal(list, err)
	}
	if _, err = store.Tasks(1, 6050, 1002); err == nil {
		t.Fatal("disabled task accepted")
	}
	var count int
	if err = db.QueryRow("SELECT COUNT(*) FROM task_progress WHERE uid=1").Scan(&count); err != nil || count != 1 {
		t.Fatal("state lost on disable", count, err)
	}
}
