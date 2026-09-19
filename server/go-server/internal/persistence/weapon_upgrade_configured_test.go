package persistence

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
)

func TestWeaponUpgradeConfiguredLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("not independent debug DB")
	}
	s, err := Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer s.DB.Close()
	uid := uint64(time.Now().UnixMicro())
	a, err := NewAccount(uid, fmt.Sprintf("wu%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	a.Gold = 1000
	if err = s.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"weapon_upgrades", "inventory", "accounts"} {
			if _, err := s.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); err != nil {
				t.Error(err)
			}
		}
	}()
	item := make([]byte, 68)
	protocol.WriteUint32(item, 0, 1)
	item[4] = 25
	protocol.WriteUint32(item, 5, 253002)
	protocol.WriteUint32(item, 47, 500)
	if _, err = s.DB.Exec(`INSERT INTO inventory VALUES(?,?,?)`, uid, 1, item); err != nil {
		t.Fatal(err)
	}

	s.DB.SetMaxOpenConns(1)
	s.DB.SetMaxIdleConns(1)
	if _, err = s.DB.Exec(`CREATE TEMPORARY TABLE weapon_rules(id INT PRIMARY KEY,revision BIGINT,rules BLOB)`); err != nil {
		t.Fatal(err)
	}
	policy := WeaponRules{Enabled: true, Levels: []WeaponLevel{{Level: 0, ScoreThreshold: 100, Gold: 70, DisplayOdds: 100}, {Level: 1, ScoreThreshold: 200, Gold: 90, DisplayOdds: 0}, {Level: 2, ScoreThreshold: 300}}}
	save := func(rev int) {
		t.Helper()
		b, e := json.Marshal(policy)
		if e != nil {
			t.Fatal(e)
		}
		if _, e = s.DB.Exec("REPLACE INTO weapon_rules VALUES(1,?,?)", rev, b); e != nil {
			t.Fatal(e)
		}
	}
	save(2)
	for _, rev := range []uint64{0, 1, 3} {
		if _, e := s.UpgradeWeaponConfigured(uid, fmt.Sprintf("old%d", rev), 1, rev); e == nil {
			t.Fatal("unquoted/stale version charged", rev)
		}
	}
	var balance uint32
	if e := s.DB.QueryRow("SELECT gold FROM accounts WHERE uid=?", uid).Scan(&balance); e != nil || balance != 1000 {
		t.Fatal(balance, e)
	}
	r, e := s.UpgradeWeaponConfigured(uid, "valid", 1, 2)
	if e != nil || !r.Success || r.Gold != 930 || protocol.ReadUint32(r.Item, 43) != 1 {
		t.Fatal(r, e)
	}
	policy.Enabled = false
	save(3)
	if _, e = s.UpgradeWeaponConfigured(uid, "disabled", 1, 3); e == nil {
		t.Fatal("disabled policy charged")
	}
	// An already committed operation still recovers its result after config change.
	retry, e := s.UpgradeWeaponConfigured(uid, "valid", 1, 2)
	if e != nil || retry.Gold != 930 || !bytes.Equal(r.Item, retry.Item) {
		t.Fatal(retry, e)
	}
	var count int
	if e = s.DB.QueryRow("SELECT COUNT(*) FROM weapon_upgrades WHERE uid=?", uid).Scan(&count); e != nil || count != 1 {
		t.Fatal(count, e)
	}
}
