package persistence

import (
	"bytes"
	"fmt"
	"os"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
)

func TestWeaponUpgradeLocalDatabase(t *testing.T) {
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
	a, err := NewAccountWithStarterCharacter(uid, fmt.Sprintf("wu%d", uid), "test123456")
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
	rules := []WeaponUpgradeRule{{Score: 100, Gold: 70, Odds: 100}, {Score: 200, Gold: 90, Odds: 0}, {Score: 300, Gold: 100, Odds: 100}}
	// Concurrent delivery of one operation may roll/debit/update only once.
	var wg sync.WaitGroup
	results := make(chan WeaponUpgradeResult, 2)
	errs := make(chan error, 2)
	for i := 0; i < 2; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			r, e := s.ItemManager().UpgradeWeapon(uid, "same", 1, rules)
			results <- r
			errs <- e
		}()
	}
	wg.Wait()
	close(results)
	close(errs)
	for e := range errs {
		if e != nil {
			t.Fatal(e)
		}
	}
	for r := range results {
		if !r.Success || r.Gold != 930 || protocol.ReadUint32(r.Item, 43) != 1 || protocol.ReadUint32(r.Item, 47) != 400 {
			t.Fatal("bad concurrent success", r)
		}
	}
	r, err := s.ItemManager().UpgradeWeapon(uid, "failure", 1, rules)
	if err != nil || r.Success || r.Gold != 840 || protocol.ReadUint32(r.Item, 43) != 1 || protocol.ReadUint32(r.Item, 47) != 200 {
		t.Fatal("failure policy", r, err)
	}
	replay, err := s.ItemManager().UpgradeWeapon(uid, "failure", 1, rules)
	if err != nil || replay.Gold != 840 || !bytes.Equal(replay.Item, r.Item) {
		t.Fatal("failure replay charged twice", err)
	}
	if _, err = s.ItemManager().UpgradeWeapon(uid, "same", 2, rules); err == nil {
		t.Fatal("changed operation target accepted")
	}
	if _, err = s.ItemManager().UpgradeWeapon(uid, "missing", 2, rules); err == nil {
		t.Fatal("unowned instance accepted")
	}
	if _, err = s.ItemManager().UpgradeWeapon(uid+1, "other", 1, rules); err == nil {
		t.Fatal("other owner accepted")
	}
	// Keep a persisted copy to verify denied requests leave both balances and record intact.
	checkDenied := func(name string, record []byte, policy []WeaponUpgradeRule) {
		t.Helper()
		if _, err := s.DB.Exec(`UPDATE inventory SET record=? WHERE uid=? AND instance=1`, record, uid); err != nil {
			t.Fatal(err)
		}
		if _, err := s.ItemManager().UpgradeWeapon(uid, name, 1, policy); err == nil {
			t.Fatal("accepted", name)
		}
		var gold uint32
		var got []byte
		if err := s.DB.QueryRow(`SELECT gold FROM accounts WHERE uid=?`, uid).Scan(&gold); err != nil {
			t.Fatal(err)
		}
		if err := s.DB.QueryRow(`SELECT record FROM inventory WHERE uid=? AND instance=1`, uid).Scan(&got); err != nil {
			t.Fatal(err)
		}
		if gold != 840 || !bytes.Equal(got, record) {
			t.Fatal("denial changed data", name)
		}
	}
	base := bytes.Clone(r.Item)
	bad := bytes.Clone(base)
	bad[4] = 12
	checkDenied("type", bad, rules)
	bad = bytes.Clone(base)
	protocol.WriteUint32(bad, 43, 2)
	checkDenied("max", bad, rules)
	bad = bytes.Clone(base)
	protocol.WriteUint32(bad, 47, 199)
	checkDenied("score", bad, rules)
	bad = bytes.Clone(base)
	protocol.WriteUint32(bad, 19, 2)
	checkDenied("inactive", bad, rules)
	expensive := append([]WeaponUpgradeRule(nil), rules...)
	expensive[1].Gold = 841
	checkDenied("gold", base, expensive)
	if _, err = s.DB.Exec(`INSERT INTO inventory_expirations(uid,instance,expires_at) VALUES(?,?,?)`, uid, 1, time.Now().Unix()-1); err != nil {
		t.Fatal(err)
	}
	checkDenied("expired", base, rules)
	var count int
	if err = s.DB.QueryRow(`SELECT COUNT(*) FROM weapon_upgrades WHERE uid=?`, uid).Scan(&count); err != nil || count != 2 {
		t.Fatal("receipts", count, err)
	}
}
