package persistence

import (
	"bytes"
	"database/sql"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
)

func TestTitleRewardLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug DB")
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
		`CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,profile BLOB) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE title_rewards(uid BIGINT,title_level TINYINT UNSIGNED,choices BLOB,claimed_key INT UNSIGNED NULL,claimed_instance INT UNSIGNED NULL,PRIMARY KEY(uid,title_level)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE offers(catalog_key INT PRIMARY KEY,record BLOB,grant_record BLOB,enabled BOOL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE offer_lifetimes(catalog_key INT PRIMARY KEY,days INT UNSIGNED) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE inventory(uid BIGINT,instance INT UNSIGNED,record BLOB,PRIMARY KEY(uid,instance)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE inventory_expirations(uid BIGINT,instance INT UNSIGNED,expires_at BIGINT,PRIMARY KEY(uid,instance)) ENGINE=InnoDB`,
	} {
		exec(q)
	}
	for _, uid := range []int{1, 2} {
		exec("INSERT INTO accounts VALUES(?,?)", uid, make([]byte, 360))
	}
	for _, key := range []uint32{7, 8} {
		catalog, item := make([]byte, 108), make([]byte, 68)
		catalog[4], item[4] = 25, 25
		protocol.WriteUint32(catalog, 9, key)
		protocol.WriteUint32(catalog, 5, 250001)
		protocol.WriteUint32(item, 5, 250001)
		protocol.WriteUint32(item, 13, 24)
		exec("INSERT INTO offers VALUES(?,?,?,TRUE)", key, catalog, item)
		exec("INSERT INTO offer_lifetimes VALUES(?,1)", key)
		exec(seedDefinitionsSQL)
	}
	s := &Store{DB: db}
	for _, choices := range [][]uint32{nil, {0}, {7, 7}, {1, 2, 3, 4, 5, 6, 7, 8}} {
		if e := s.TitleManager().GrantTitleChoices(1, 1, choices); e == nil {
			t.Fatal("bad choices accepted", choices)
		}
	}
	if err = s.TitleManager().GrantTitleChoices(1, 1, []uint32{7, 8}); err != nil {
		t.Fatal(err)
	}
	if err = s.TitleManager().GrantTitleChoices(1, 1, []uint32{7, 8}); err != nil {
		t.Fatal("grant retry", err)
	}
	if err = s.TitleManager().GrantTitleChoices(1, 1, []uint32{8}); err == nil {
		t.Fatal("changed grant accepted")
	}
	if err = s.TitleManager().GrantTitleChoices(1, 2, []uint32{8}); err == nil {
		t.Fatal("overlapping offers accepted")
	}
	for _, r := range []struct {
		uid   uint64
		level byte
		key   uint32
	}{{2, 1, 7}, {1, 2, 7}, {1, 1, 9}} {
		if _, e := s.TitleManager().ClaimTitleReward(r.uid, r.level, r.key); e == nil {
			t.Fatal("unauthorized reward", r)
		}
	}
	// Fail late in the item transaction and prove no item/claim is committed.
	exec("INSERT INTO inventory_expirations VALUES(1,1048576,1)")
	if _, err = s.TitleManager().ClaimTitleReward(1, 1, 7); err == nil {
		t.Fatal("expiry failure ignored")
	}
	var count int
	if err = db.QueryRow("SELECT COUNT(*) FROM inventory").Scan(&count); err != nil || count != 0 {
		t.Fatal("inventory rollback", count, err)
	}
	if err = db.QueryRow("SELECT COUNT(*) FROM title_rewards WHERE claimed_key IS NOT NULL").Scan(&count); err != nil || count != 0 {
		t.Fatal("claim rollback", count, err)
	}
	exec("DELETE FROM inventory_expirations WHERE uid=1")
	item, err := s.TitleManager().ClaimTitleReward(1, 1, 7)
	if err != nil || len(item) != 68 {
		t.Fatal(item, err)
	}
	again, err := s.TitleManager().ClaimTitleReward(1, 1, 7)
	if err != nil || !bytes.Equal(item, again) {
		t.Fatal("retry", err)
	}
	if _, err = s.TitleManager().ClaimTitleReward(1, 1, 8); err == nil {
		t.Fatal("second choice awarded")
	}
	exec("DELETE FROM inventory WHERE uid=1")
	again, err = s.TitleManager().ClaimTitleReward(1, 1, 7)
	if err != nil || len(again) != 0 {
		t.Fatal("consumed item resurrected", err)
	}
	if err = s.TitleManager().GrantTitleChoices(1, 2, []uint32{8}); err != nil {
		t.Fatal("next title", err)
	}
	again, err = s.TitleManager().ClaimTitleReward(1, 1, 7)
	if err != nil || len(again) != 0 {
		t.Fatal("old retry consumed new title", err)
	}
	var profile []byte
	if err = db.QueryRow("SELECT profile FROM accounts WHERE uid=1").Scan(&profile); err != nil || profile[TitleLevelOffset] != 2 {
		t.Fatal("title persistence", err)
	}
}
