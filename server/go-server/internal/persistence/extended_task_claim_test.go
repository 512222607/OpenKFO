package persistence

import (
	"database/sql"
	"encoding/json"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
)

func TestExtendedTaskItemClaimLocalDatabase(t *testing.T) {
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
	exec := func(q string, args ...any) {
		t.Helper()
		if _, e := db.Exec(q, args...); e != nil {
			t.Fatal(e)
		}
	}
	for _, q := range []string{
		`CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,profile BLOB NOT NULL,gold INT UNSIGNED NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE task_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE extended_task_progress(uid BIGINT UNSIGNED,task_key SMALLINT UNSIGNED,cycle VARCHAR(10),state TINYINT UNSIGNED,rule_revision BIGINT UNSIGNED,rule_data MEDIUMBLOB,counts BINARY(12),PRIMARY KEY(uid,task_key,cycle)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE offers(catalog_key INT PRIMARY KEY,record BLOB,grant_record BLOB,enabled BOOL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE offer_lifetimes(catalog_key INT PRIMARY KEY,days INT UNSIGNED) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE inventory(uid BIGINT,instance INT UNSIGNED,record BLOB,PRIMARY KEY(uid,instance)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE inventory_expirations(uid BIGINT,instance INT UNSIGNED,expires_at BIGINT,PRIMARY KEY(uid,instance)) ENGINE=InnoDB`,
	} {
		exec(q)
	}
	exec("INSERT INTO accounts VALUES(1,?,50),(2,?,50)", make([]byte, 360), make([]byte, 360))
	rules := TaskRules{Extended: extendedTaskFixture()}
	rules.Extended.Catalogue[0].Conditions = []ExtendedTaskRequirement{{Key: 0, Required: 1, Event: "battle_win"}, {}, {}}
	rules.Extended.Tasks[0].RewardCatalog = 7
	save := func() {
		t.Helper()
		data, e := json.Marshal(rules)
		if e != nil {
			t.Fatal(e)
		}
		exec("REPLACE INTO task_rules VALUES(1,1,?)", data)
	}
	save()
	s := &Store{DB: db}
	hash := rules.Extended.ClientHash
	if _, _, err = s.TaskManager().ExtendedTaskTransition(1, hash, 6052, 3002); err != nil {
		t.Fatal(err)
	}
	counts := make([]byte, 12)
	counts[0] = 1
	exec("UPDATE extended_task_progress SET state=4,counts=? WHERE uid=1", counts)
	// GM edits after acceptance do not change the frozen entitlement.
	rules.Extended.Tasks[0].RewardCatalog = 8
	rules.Extended.Tasks[0].Gold = 999
	save()
	catalog, item := make([]byte, 108), make([]byte, 68)
	catalog[4], item[4] = 25, 25
	protocol.WriteUint32(catalog, 5, 250001)
	protocol.WriteUint32(catalog, 9, 7)
	protocol.WriteUint32(item, 5, 250001)
	protocol.WriteUint32(item, 13, 24)
	exec("INSERT INTO offers VALUES(7,?,?,FALSE)", catalog, item)
	exec("INSERT INTO offer_lifetimes VALUES(7,1)")
	claim := func() (TaskAwards, error) {
		return s.TaskManager().ClaimExtendedTask(1, hash, 6312, 3002, (RewardRules{}).Normalized())
	}
	unchanged := func() {
		t.Helper()
		var profile []byte
		var gold uint32
		var count, state int
		if e := db.QueryRow("SELECT profile,gold FROM accounts WHERE uid=1").Scan(&profile, &gold); e != nil || gold != 50 || protocol.ReadUint32(profile, ExperienceOffset) != 0 {
			t.Fatal("wallet changed", gold, e)
		}
		if e := db.QueryRow("SELECT COUNT(*) FROM inventory").Scan(&count); e != nil || count != 0 {
			t.Fatal("inventory changed", count, e)
		}
		if e := db.QueryRow("SELECT state FROM extended_task_progress WHERE uid=1").Scan(&state); e != nil || state != 4 {
			t.Fatal("entitlement lost", state, e)
		}
	}
	if _, err = claim(); err == nil {
		t.Fatal("missing definition awarded")
	}
	unchanged()
	exec(seedDefinitionsSQL) // Disabled shop item must still be grantable.
	// Expiry insert fails AFTER inventory insert; the item must roll back.
	exec("INSERT INTO inventory_expirations VALUES(1,1048576,1)")
	if _, err = claim(); err == nil {
		t.Fatal("expiry conflict ignored")
	}
	unchanged()
	exec("DELETE FROM inventory_expirations WHERE uid=1")
	start := time.Now().Unix()
	r, err := claim()
	if err != nil || r.GoldBalance != 550 || r.Experience != 50 || len(r.Items) != 1 || protocol.ReadUint32(r.Items[0], 5) != 250001 {
		t.Fatal("reward", r, err)
	}
	var deadline int64
	if err = db.QueryRow("SELECT expires_at FROM inventory_expirations WHERE uid=1").Scan(&deadline); err != nil || deadline < start+86400 || deadline > time.Now().Unix()+86400 {
		t.Fatal("expiry", deadline, err)
	}
	if _, err = claim(); err == nil {
		t.Fatal("duplicate award")
	}
	var count int
	if err = db.QueryRow("SELECT COUNT(*) FROM inventory WHERE uid=1").Scan(&count); err != nil || count != 1 {
		t.Fatal("duplicate inventory", count, err)
	}
	exec("DELETE FROM inventory_expirations WHERE uid=1")
	exec("DELETE FROM inventory WHERE uid=1")
	if _, err = claim(); err == nil {
		t.Fatal("deleted item resurrected")
	}
	if err = db.QueryRow("SELECT COUNT(*) FROM inventory").Scan(&count); err != nil || count != 0 {
		t.Fatal("resurrected inventory", count, err)
	}
	var gold uint32
	if err = db.QueryRow("SELECT gold FROM accounts WHERE uid=1").Scan(&gold); err != nil || gold != 550 {
		t.Fatal("duplicate money", gold, err)
	}
	if err = db.QueryRow("SELECT gold FROM accounts WHERE uid=2").Scan(&gold); err != nil || gold != 50 {
		t.Fatal("peer changed", gold, err)
	}
}
