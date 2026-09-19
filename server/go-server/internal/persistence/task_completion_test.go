package persistence

import (
	"database/sql"
	"encoding/json"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
	"time"
)

func TestTaskCompletionLocalDatabase(t *testing.T) {
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
	if _, e := db.Exec("CREATE TEMPORARY TABLE item_definitions(definition_key INT PRIMARY KEY,revision BIGINT,record BLOB,days INT) ENGINE=InnoDB"); e != nil {
		t.Fatal(e)
	}

	for _, q := range []string{
		`CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,profile BLOB NOT NULL,gold INT UNSIGNED NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE task_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE task_progress(uid BIGINT,task_key INT,state INT,baseline BINARY(116),rule_revision BIGINT,rule_data BLOB,PRIMARY KEY(uid,task_key)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE task_rewards(uid BIGINT,task_key INT,rule_revision BIGINT,experience INT UNSIGNED,gold INT UNSIGNED,PRIMARY KEY(uid,task_key)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE offers(catalog_key INT PRIMARY KEY,record BLOB,grant_record BLOB,enabled BOOL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE offer_lifetimes(catalog_key INT PRIMARY KEY,days INT UNSIGNED) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE inventory(uid BIGINT,instance INT UNSIGNED,record BLOB,PRIMARY KEY(uid,instance)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE inventory_expirations(uid BIGINT,instance INT UNSIGNED,expires_at BIGINT,PRIMARY KEY(uid,instance)) ENGINE=InnoDB`,
	} {
		if _, err = db.Exec(q); err != nil {
			t.Fatal(err)
		}
	}
	profile := make([]byte, 360)
	protocol.WriteUint32(profile, 0, 1)
	for _, uid := range []int{1, 2} {
		if _, err = db.Exec("INSERT INTO accounts VALUES(?,?,50)", uid, profile); err != nil {
			t.Fatal(err)
		}
	}
	catalog, item := make([]byte, 108), make([]byte, 68)
	catalog[4], item[4] = 25, 25
	protocol.WriteUint32(catalog, 5, 250001)
	protocol.WriteUint32(catalog, 9, 7)
	protocol.WriteUint32(item, 5, 250001)
	protocol.WriteUint32(item, 13, 24)
	if _, err = db.Exec("INSERT INTO offers VALUES(7,?,?,TRUE)", catalog, item); err != nil {
		t.Fatal(err)
	}
	if _, err = db.Exec("INSERT INTO offer_lifetimes VALUES(7,1)"); err != nil {
		t.Fatal(err)
	}
	if _, err = db.Exec(seedDefinitionsSQL); err != nil {
		t.Fatal(err)
	}
	rule := TaskRule{ID: 1001, Enabled: true, Matches: 10, Counters: make([]uint32, 29), Experience: 100, Gold: 20, RewardCatalog: 7}
	rules := TaskRules{Enabled: true, Tasks: []TaskRule{rule}}
	data, _ := json.Marshal(rules)
	if _, err = db.Exec("INSERT INTO task_rules VALUES(1,7,?)", data); err != nil {
		t.Fatal(err)
	}
	store := &Store{DB: db}
	if _, err = store.TaskManager().Tasks(1, 6050, 1001); err != nil {
		t.Fatal(err)
	}
	reward, err := store.TaskManager().CompleteTasks(1, (RewardRules{}).Normalized())
	if err != nil || len(reward.Keys) != 0 {
		t.Fatal("early completion", reward, err)
	}
	// Accepted tasks keep their original reward after GM edits.
	rules.Tasks[0].Experience = 999
	rules.Tasks[0].RewardCatalog = 8
	data, _ = json.Marshal(rules)
	if _, err = db.Exec("UPDATE task_rules SET revision=8,rules=?", data); err != nil {
		t.Fatal(err)
	}
	protocol.WriteUint32(profile, 133, 10)
	if _, err = db.Exec("UPDATE accounts SET profile=? WHERE uid=1", profile); err != nil {
		t.Fatal(err)
	}
	// Force the receipt insert to fail, and verify all prior writes roll back.
	if _, err = db.Exec("INSERT INTO task_rewards VALUES(1,1001,0,0,0)"); err != nil {
		t.Fatal(err)
	}
	if _, err = store.TaskManager().CompleteTasks(1, (RewardRules{}).Normalized()); err == nil {
		t.Fatal("receipt conflict ignored")
	}
	var state int
	var gold uint32
	var persisted []byte
	if err = db.QueryRow("SELECT state FROM task_progress WHERE uid=1").Scan(&state); err != nil || state != 2 {
		t.Fatal("state not rolled back", state, err)
	}
	if err = db.QueryRow("SELECT profile,gold FROM accounts WHERE uid=1").Scan(&persisted, &gold); err != nil || gold != 50 || protocol.ReadUint32(persisted, ExperienceOffset) != 0 {
		t.Fatal("wallet not rolled back", gold, err)
	}
	for _, table := range []string{"inventory", "inventory_expirations"} {
		var count int
		if err = db.QueryRow("SELECT COUNT(*) FROM " + table).Scan(&count); err != nil || count != 0 {
			t.Fatal("item grant not rolled back", table, count, err)
		}
	}
	if _, err = db.Exec("DELETE FROM task_rewards WHERE uid=1"); err != nil {
		t.Fatal(err)
	}
	if _, err = db.Exec("UPDATE offers SET enabled=FALSE WHERE catalog_key=7"); err != nil {
		t.Fatal(err)
	}
	// Shop visibility must not control an earned task reward.
	reward, err = store.TaskManager().CompleteTasks(1, (RewardRules{}).Normalized())
	if err != nil || len(reward.Keys) != 1 || reward.Keys[0] != 1001 || reward.Experience != 100 || reward.GoldBalance != 70 || len(reward.Items) != 1 || protocol.ReadUint32(reward.Items[0], 5) != 250001 {
		t.Fatal(reward, err)
	}
	var deadline int64
	if err = db.QueryRow("SELECT expires_at FROM inventory_expirations WHERE uid=1").Scan(&deadline); err != nil || deadline < time.Now().Unix()+86390 || deadline > time.Now().Unix()+86410 {
		t.Fatal("reward expiry", deadline, err)
	}
	reward, err = store.TaskManager().CompleteTasks(1, (RewardRules{}).Normalized())
	if err != nil || len(reward.Keys) != 0 || reward.GoldBalance != 70 || len(reward.Items) != 0 {
		t.Fatal("duplicate award", reward, err)
	}
	var itemCount int
	if err = db.QueryRow("SELECT COUNT(*) FROM inventory WHERE uid=1").Scan(&itemCount); err != nil || itemCount != 1 {
		t.Fatal("duplicate item", itemCount, err)
	}
	if err = db.QueryRow("SELECT gold FROM accounts WHERE uid=2").Scan(&gold); err != nil || gold != 50 {
		t.Fatal("peer modified", err)
	}
	if _, err = store.TaskManager().CompleteTasks(99, (RewardRules{}).Normalized()); err == nil {
		t.Fatal("unknown account accepted")
	}
}

func TestTaskCompletionConditions(t *testing.T) {
	rule := TaskRule{Matches: 2, Counters: make([]uint32, 29)}
	p, b := make([]byte, 360), make([]byte, 116)
	protocol.WriteUint32(p, 133, 10)
	protocol.WriteUint32(b, 4, 9)
	if taskConditionsMet(rule, p, b) {
		t.Fatal("before baseline counted")
	}
	protocol.WriteUint32(p, 141, 1)
	if !taskConditionsMet(rule, p, b) {
		t.Fatal("cross-mode matches missing")
	}
	rule.Counters[2] = 1
	if taskConditionsMet(rule, p, b) {
		t.Fatal("win condition ignored")
	}
	protocol.WriteUint32(p, 137, 1)
	if !taskConditionsMet(rule, p, b) {
		t.Fatal("all conditions met")
	}
	rule.MaxCombo = 1
	if taskConditionsMet(rule, p, b) {
		t.Fatal("unsupported combo awarded")
	}
	rule.MaxCombo = 0
	rule.Counters[0] = 1
	protocol.WriteUint32(p, 129, 100)
	if taskConditionsMet(rule, p, b) {
		t.Fatal("unverified kills awarded")
	}
	if taskConditionsMet(TaskRule{Counters: make([]uint32, 29)}, p, b) {
		t.Fatal("empty condition awarded")
	}
	rule.Counters[0] = 0
	protocol.WriteUint32(p, 133, 0)
	if taskConditionsMet(rule, p, b) {
		t.Fatal("counter underflow awarded")
	}
}
