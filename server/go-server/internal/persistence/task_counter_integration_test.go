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

func TestTaskCountersSettlementLocalDatabase(t *testing.T) {
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
		`CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,profile BLOB NOT NULL,gold INT UNSIGNED NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE counters(name VARCHAR(32) PRIMARY KEY,value BIGINT UNSIGNED) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE battle_settlements(serial INT UNSIGNED PRIMARY KEY,reports BLOB,result MEDIUMBLOB) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE task_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE extended_task_progress(uid BIGINT UNSIGNED,task_key SMALLINT UNSIGNED,cycle VARCHAR(10),state TINYINT UNSIGNED,rule_revision BIGINT UNSIGNED,rule_data MEDIUMBLOB,counts BINARY(12),PRIMARY KEY(uid,task_key,cycle)) ENGINE=InnoDB`,
	} {
		if _, err = db.Exec(q); err != nil {
			t.Fatal(err)
		}
	}
	if _, err = db.Exec("INSERT INTO counters VALUES('battle',5)"); err != nil {
		t.Fatal(err)
	}
	p := make([]byte, 360)
	if _, err = db.Exec("INSERT INTO accounts VALUES(1,?,0),(2,?,0)", p, p); err != nil {
		t.Fatal(err)
	}
	store := &Store{DB: db}
	rules := TaskRules{Extended: extendedTaskFixture()}
	rules.Extended.Catalogue[0].Conditions = []ExtendedTaskRequirement{{Key: 0, Required: 3, Event: "battle_play"}, {}, {}}
	data, err := json.Marshal(rules)
	if err != nil {
		t.Fatal(err)
	}
	if _, err = db.Exec("INSERT INTO task_rules VALUES(1,1,?)", data); err != nil {
		t.Fatal(err)
	}
	hash := rules.Extended.ClientHash
	for _, uid := range []uint64{1, 2} {
		if _, _, err = store.ExtendedTaskTransition(uid, hash, 6052, 3002); err != nil {
			t.Fatal(err)
		}
	}
	checkTask := func(uid uint64, count uint32, state byte) {
		t.Helper()
		list, e := store.ExtendedTasks(uid, hash)
		if e != nil || len(list) != 1 || list[0].Counts[0] != count || list[0].State != state {
			t.Fatalf("task uid=%d count=%d state=%d: %+v %v", uid, count, state, list, e)
		}
	}
	mode := byte(0)
	run := func(serial uint32, outcome string) []BattleReward {
		t.Helper()
		r, e := store.SettleBattle(serial, []byte{}, []BattleReward{{TaskClientHash: hash, UID: 1, Outcome: outcome, BattleMode: &mode}, {TaskClientHash: hash, UID: 2, Outcome: "loss", BattleMode: &mode}})
		if e != nil {
			t.Fatal(e)
		}
		return r
	}
	r := run(1, "win")
	if protocol.ReadUint32(r[0].Profile, 133) != 1 || protocol.ReadUint32(r[0].Profile, 137) != 1 || protocol.ReadUint32(r[1].Profile, 133) != 1 || protocol.ReadUint32(r[1].Profile, 137) != 0 {
		t.Fatal("first match counters wrong")
	}
	run(1, "win")
	checkTask(1, 1, 2)
	checkTask(2, 1, 2)
	if _, err = store.ClaimExtendedTask(1, hash, 6312, 3002, (RewardRules{}).Normalized()); err == nil {
		t.Fatal("unfinished task claimed")
	}
	var saved []byte
	if err = db.QueryRow("SELECT profile FROM accounts WHERE uid=1").Scan(&saved); err != nil || protocol.ReadUint32(saved, 133) != 1 {
		t.Fatal("replay counted twice", err)
	}
	r = run(2, "unconfirmed")
	checkTask(1, 1, 2)
	if protocol.ReadUint32(r[0].Profile, 133) != 1 {
		t.Fatal("unconfirmed outcome counted")
	}
	mode = 5
	r = run(3, "win")
	checkTask(1, 1, 2)
	if protocol.ReadUint32(r[0].Profile, 133) != 1 {
		t.Fatal("practice counted")
	}
	mode = 3
	r = run(4, "draw")
	checkTask(1, 2, 2)
	checkTask(2, 3, 4)
	if protocol.ReadUint32(r[0].Profile, 157) != 1 || protocol.ReadUint32(r[0].Profile, 161) != 0 {
		t.Fatal("team deathmatch draw mismatch")
	}
	// A later account failure must roll back the first account's counter too.
	if _, err = store.SettleBattle(5, []byte{}, []BattleReward{{UID: 1, Outcome: "win", BattleMode: &mode}, {UID: 99, Outcome: "loss", BattleMode: &mode}}); err == nil {
		t.Fatal("missing account accepted")
	}
	if err = db.QueryRow("SELECT profile FROM accounts WHERE uid=1").Scan(&saved); err != nil || protocol.ReadUint32(saved, 157) != 1 || protocol.ReadUint32(saved, 161) != 0 {
		t.Fatal("failed settlement changed counters", err)
	}
	// Fail after participant one's task update, not just during pre-locking.
	if _, err = store.SettleBattle(5, nil, []BattleReward{{TaskClientHash: hash, UID: 1, Outcome: "win", BattleMode: &mode}, {TaskClientHash: hash, UID: 2, Outcome: "loss", BattleMode: &mode, Gold: 0xffffffff}}); err == nil {
		t.Fatal("invalid later reward accepted")
	}
	checkTask(1, 2, 2)
	checkTask(2, 3, 4)
	run(5, "win")
	checkTask(1, 3, 4)
	run(5, "win")
	checkTask(1, 3, 4)
	for _, request := range []struct {
		uid    uint64
		hash   string
		action uint32
		key    uint16
	}{
		{1, strings.Repeat("b", 64), 6312, 3002}, {1, hash, 6311, 3002}, {99, hash, 6312, 3002}, {1, hash, 6312, 3999},
	} {
		if _, err = store.ClaimExtendedTask(request.uid, request.hash, request.action, request.key, (RewardRules{}).Normalized()); err == nil {
			t.Fatal("invalid claim accepted", request)
		}
	}
	if _, err = db.Exec("UPDATE accounts SET gold=4294967295 WHERE uid=1"); err != nil {
		t.Fatal(err)
	}
	if _, err = store.ClaimExtendedTask(1, hash, 6312, 3002, (RewardRules{}).Normalized()); err == nil {
		t.Fatal("overflow accepted")
	}
	checkTask(1, 3, 4)
	if _, err = db.Exec("UPDATE accounts SET gold=0 WHERE uid=1"); err != nil {
		t.Fatal(err)
	}
	award, err := store.ClaimExtendedTask(1, hash, 6312, 3002, (RewardRules{}).Normalized())
	if err != nil || award.GoldBalance != 500 || protocol.ReadUint32(award.Profile, ExperienceOffset) != 50 {
		t.Fatal("claim", award, err)
	}
	if _, err = store.ClaimExtendedTask(1, hash, 6312, 3002, (RewardRules{}).Normalized()); err == nil {
		t.Fatal("duplicate claim accepted")
	}
	var balance uint32
	if err = db.QueryRow("SELECT profile,gold FROM accounts WHERE uid=1").Scan(&saved, &balance); err != nil || balance != 500 || protocol.ReadUint32(saved, ExperienceOffset) != 50 {
		t.Fatal("replay changed rewards", err)
	}
	list, err := store.ExtendedTasks(1, hash)
	if err != nil || len(list) != 0 {
		t.Fatal("claimed newbie remains", list, err)
	}
}
