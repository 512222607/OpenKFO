package persistence

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"os"
	"strings"
	"testing"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
)

func TestTutorialBundleLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("not debug database")
	}
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	db.SetMaxOpenConns(1)
	db.SetMaxIdleConns(1)
	exec := func(q string, args ...any) {
		t.Helper()
		if _, e := db.Exec(q, args...); e != nil {
			t.Fatal(e)
		}
	}
	for _, q := range []string{
		"CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,profile BLOB,gold INT,tickets INT) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE tutorial_rewards(uid BIGINT PRIMARY KEY,reward BLOB) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE title_rewards(uid BIGINT,title_level TINYINT,choices BLOB,claimed_key INT UNSIGNED NULL,claimed_instance INT UNSIGNED NULL,PRIMARY KEY(uid,title_level)) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE offers(catalog_key INT PRIMARY KEY,record BLOB,enabled BOOL) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE battle_reward_rules(id INT PRIMARY KEY,rules BLOB) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE task_rules(id INT PRIMARY KEY,revision BIGINT,rules BLOB) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE extended_task_progress(uid BIGINT,task_key INT,cycle VARCHAR(10),state INT,rule_revision BIGINT,rule_data BLOB,counts BLOB,PRIMARY KEY(uid,task_key,cycle)) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE item_definitions(definition_key INT PRIMARY KEY,revision BIGINT,record BLOB,days INT) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE inventory(uid BIGINT,instance INT UNSIGNED,record BLOB,PRIMARY KEY(uid,instance)) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE inventory_expirations(uid BIGINT,instance INT UNSIGNED,expires_at BIGINT,PRIMARY KEY(uid,instance)) ENGINE=InnoDB",
	} {
		exec(q)
	}
	profile := make([]byte, protocol.RoleProfileSize)
	exec("INSERT INTO accounts VALUES(1,?,10,20)", profile)
	store := &Store{DB: db}
	for i, kind := range []byte{protocol.ItemWeapon, 31, 29} {
		record := make([]byte, protocol.InventoryRecordSize)
		record[4] = kind
		protocol.WriteUint32(record, 5, uint32(250001+i))
		protocol.WriteUint16(record, 23, 1)
		if _, err = store.ItemManager().SaveDefinition(ItemDefinition{Key: uint32(i + 1), Record: record, Days: 1}); err != nil {
			t.Fatal(err)
		}
	}
	rules := RewardRules{Tutorial: &RewardBundle{Items: []uint32{1, 2, 3, 999}, Gold: 100, Tickets: 50}}
	save := func() {
		raw, e := json.Marshal(rules)
		if e != nil {
			t.Fatal(e)
		}
		exec("REPLACE INTO battle_reward_rules VALUES(1,?)", raw)
	}
	save()
	if _, err = store.RewardManager().CompleteTutorial(1, ""); err == nil {
		t.Fatal("missing definition accepted")
	}
	for _, table := range []string{"inventory", "inventory_expirations", "tutorial_rewards"} {
		var n int
		if err = db.QueryRow("SELECT COUNT(*) FROM " + table).Scan(&n); err != nil || n != 0 {
			t.Fatal("partial reward", table, n, err)
		}
	}
	var before []byte
	var gold, tickets uint32
	if err = db.QueryRow("SELECT profile,gold,tickets FROM accounts WHERE uid=1").Scan(&before, &gold, &tickets); err != nil || !bytes.Equal(before, profile) || gold != 10 || tickets != 20 {
		t.Fatal("failed reward mutated character", err)
	}
	rules.Tutorial.Items = []uint32{1, 2, 3}
	save()
	// A mismatched shop key used to commit completion and automatic gifts,
	// then fail while building 1550, leaving no usable selection for the client.
	badCatalog := make([]byte, 108)
	protocol.WriteUint32(badCatalog, 0, 1)
	badCatalog[4] = protocol.ItemWeapon
	protocol.WriteUint32(badCatalog, 5, 999999)
	exec("INSERT INTO offers VALUES(1,?,TRUE)", badCatalog)
	if _, err = store.RewardManager().CompleteTutorial(1, ""); err == nil {
		t.Fatal("conflicting display catalogue accepted")
	}
	for _, table := range []string{"inventory", "tutorial_rewards", "title_rewards"} {
		var n int
		if err = db.QueryRow("SELECT COUNT(*) FROM " + table).Scan(&n); err != nil || n != 0 {
			t.Fatal("unusable selector consumed reward", table, n, err)
		}
	}
	if err = db.QueryRow("SELECT profile,gold,tickets FROM accounts WHERE uid=1").Scan(&before, &gold, &tickets); err != nil || !bytes.Equal(before, profile) || gold != 10 || tickets != 20 {
		t.Fatal("unusable selector changed progress or balances", err)
	}
	exec("DELETE FROM offers")
	hash := strings.Repeat("a", 64)
	extended := &ExtendedTaskRules{ClientHash: hash}
	for i := uint16(0); i < 3; i++ {
		entry := ExtendedTaskCatalogueEntry{ID: 3001 + i, Kind: "newbie", Conditions: []ExtendedTaskRequirement{{Key: 0, Required: 1, Event: "tutorial_complete"}, {}, {}}}
		if i == 1 {
			entry.Conditions[0].Required = 2
		}
		rule := ExtendedTaskRule{ID: entry.ID, Kind: "newbie", Enabled: true}
		extended.Catalogue = append(extended.Catalogue, entry)
		extended.Tasks = append(extended.Tasks, rule)
		frozen, _ := json.Marshal(ExtendedTaskSnapshot{ClientHash: hash, Rule: rule, Template: entry})
		state := 2
		if i == 2 {
			state = 1
		}
		exec("INSERT INTO extended_task_progress VALUES(1,?,'',?,1,?,?)", entry.ID, state, frozen, make([]byte, 12))
	}
	taskRules, _ := json.Marshal(TaskRules{Extended: extended})
	exec("INSERT INTO task_rules VALUES(1,1,?)", taskRules)
	// Failure after reward allocation must roll back inventory, balances and receipt.
	if _, err = store.RewardManager().CompleteTutorial(1, strings.Repeat("b", 64)); err == nil {
		t.Fatal("wrong task catalogue accepted")
	}
	var rolledBack int
	if err = db.QueryRow("SELECT COUNT(*) FROM inventory").Scan(&rolledBack); err != nil || rolledBack != 0 {
		t.Fatal("task failure leaked rewards", err)
	}
	r, err := store.RewardManager().CompleteTutorial(1, hash)
	if err != nil || r.Replay || len(r.Items) != 2 || len(r.Choices) != 1 || r.Choices[0] != 1 || r.Gold != 110 || r.Tickets != 70 || r.Profile[TitleLevelOffset] != 2 {
		t.Fatal("tutorial reward", r, err)
	}
	for i := 0; i < 2; i++ {
		r, err = store.RewardManager().CompleteTutorial(1, hash)
		if err != nil || !r.Replay || len(r.Items) != 0 || r.Gold != 110 || r.Tickets != 70 {
			t.Fatal("duplicate tutorial reward", r, err)
		}
	}
	for i := uint16(0); i < 3; i++ {
		var state int
		var counts []byte
		if err = db.QueryRow("SELECT state,counts FROM extended_task_progress WHERE uid=1 AND task_key=?", 3001+i).Scan(&state, &counts); err != nil {
			t.Fatal(err)
		}
		wantState, wantCount := []int{4, 2, 1}[i], []uint32{1, 1, 0}[i]
		if state != wantState || protocol.ReadUint32(counts, 0) != wantCount {
			t.Fatal("tutorial task replay or acceptance mismatch", i, state, counts)
		}
	}
	var n int
	if err = db.QueryRow("SELECT COUNT(*) FROM inventory").Scan(&n); err != nil || n != 2 {
		t.Fatal(n, err)
	}
	// A fresh manager (relogin) restores the offer without re-running tutorial.
	choices, catalog, err := (&Store{DB: db}).RewardManager().TutorialChoices(1)
	if err != nil || len(choices) != 1 || choices[0] != 1 || len(catalog) != 108 || protocol.ReadUint32(catalog, 0) != 1 || protocol.ReadUint32(catalog, 5) != 250001 {
		t.Fatal("pending reward catalogue", choices, len(catalog), err)
	}
	if _, err = store.TitleManager().ClaimTitleReward(1, 2, 2); err == nil {
		t.Fatal("unoffered item claimed")
	}
	item, err := store.TitleManager().ClaimTitleReward(1, 2, 1)
	if err != nil || len(item) != 68 {
		t.Fatal("choice claim", err)
	}
	retry, err := store.TitleManager().ClaimTitleReward(1, 2, 1)
	if err != nil || !bytes.Equal(item, retry) {
		t.Fatal("claim retry", err)
	}
	choices, _, err = store.RewardManager().TutorialChoices(1)
	if err != nil || len(choices) != 0 {
		t.Fatal("claimed choice still offered", err)
	}
	if err = db.QueryRow("SELECT COUNT(*) FROM inventory").Scan(&n); err != nil || n != 3 {
		t.Fatal("claim inventory count", n, err)
	}
}

func TestForceOpenStagePolicy(t *testing.T) {
	locked := true
	a := StageAccess{ClientHash: strings.Repeat("a", 64), RequirementsEnabled: true, Requirements: []StageTitleRequirement{{MapID: 8101, Name: "Stage", TitleLevel: 20, UnlockRequired: &locked}}, ForceOpenMaps: []uint32{8101}}
	if err := a.Validate(); err != nil {
		t.Fatal(err)
	}
	if !a.AllowsPlayer(8101, 0, a.ClientHash, nil) {
		t.Fatal("explicit open still requires progression")
	}
	if a.AllowsPlayer(8101, 0, strings.Repeat("b", 64), nil) {
		t.Fatal("wrong client admitted")
	}
	a.Disabled = []uint32{8101}
	if a.AllowsPlayer(8101, 255, a.ClientHash, map[uint32]bool{8101: true}) {
		t.Fatal("closed map admitted")
	}
	a.Disabled = nil
	a.ForceOpenMaps = nil
	if a.AllowsPlayer(8101, 0, a.ClientHash, nil) {
		t.Fatal("normal rules lost")
	}
	a.ForceOpenAll = true
	if !a.AllowsPlayer(8101, 0, a.ClientHash, nil) || a.ForceOpens(999) {
		t.Fatal("all open ignored catalogue")
	}
}
