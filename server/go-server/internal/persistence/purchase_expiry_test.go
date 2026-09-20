package persistence

import (
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
)

func TestPurchaseExpiryLocalDatabase(t *testing.T) {
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
	a, err := NewAccountWithStarterCharacter(uid, fmt.Sprintf("pe%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	a.Tickets = 1000
	if err = s.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"purchases", "inventory", "accounts"} {
			if _, err := s.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); err != nil {
				t.Error(err)
			}
		}
	}()
	o := adminFixtureOffer(uint32(uid%90000000) + 80000000)
	var count int
	if err = s.DB.QueryRow(`SELECT COUNT(*) FROM offers WHERE catalog_key=?`, o.Key).Scan(&count); err != nil || count != 0 {
		t.Fatal("fixture offer collision", err)
	}
	defer func() {
		if _, err := s.DB.Exec(`DELETE FROM offers WHERE catalog_key=?`, o.Key); err != nil {
			t.Error(err)
		}
	}()
	o.Record[48] = 1
	days := uint32(2)
	o.ServerExpiryDays = &days
	save := func(suffix string) {
		t.Helper()
		id := fmt.Sprintf("pe-%d-%s", uid, suffix)
		defer func() {
			if _, err := s.DB.Exec(`DELETE FROM desktop_admin_operations WHERE id=?`, id); err != nil {
				t.Error(err)
			}
		}()
		if _, err := s.Admin(AdminRequest{Operation: "shop_save", ID: id, Offers: []AdminOffer{o}}); err != nil {
			t.Fatal(err)
		}
	}
	save("set")
	// An older client that only changes price must not erase the expiry policy.
	o.ServerExpiryDays = nil
	save("legacy")
	rows, err := s.adminOffers()
	if err != nil {
		t.Fatal(err)
	}
	found := false
	for _, row := range rows {
		if row.Key == o.Key {
			found = row.ServerExpiryDays != nil && *row.ServerExpiryDays == 2
		}
	}
	if !found {
		t.Fatal("policy not returned or lost on legacy save")
	}
	p := make([]byte, 169)
	protocol.WriteUint32(p, 0, 109)
	protocol.WriteUint64(p, 4, uid)
	protocol.WriteUint64(p, 54, uid)
	protocol.WriteUint32(p, 145, o.Key)
	protocol.WriteUint32(p, 157, 77)
	before := time.Now().Unix()
	balance, item, _, err := s.ShopManager().Purchase(uid, "first", p)
	if err != nil || balance != 923 {
		t.Fatalf("purchase: balance=%d err=%v", balance, err)
	}
	instance := protocol.ReadUint32(item, 0)
	var deadline int64
	if err = s.DB.QueryRow(`SELECT expires_at FROM inventory_expirations WHERE uid=? AND instance=?`, uid, instance).Scan(&deadline); err != nil {
		t.Fatal(err)
	}
	if deadline < before+172800 || deadline > time.Now().Unix()+172800 {
		t.Fatal("incorrect purchase deadline")
	}
	// A policy change must not extend an already committed purchase on retry.
	days = 3
	o.ServerExpiryDays = &days
	save("change")
	balance, retry, _, err := s.ShopManager().Purchase(uid, "first", p)
	if err != nil || balance != 923 || protocol.ReadUint32(retry, 0) != instance {
		t.Fatal("purchase replay changed result", err)
	}
	var after int64
	if err = s.DB.QueryRow(`SELECT expires_at FROM inventory_expirations WHERE uid=? AND instance=?`, uid, instance).Scan(&after); err != nil || after != deadline {
		t.Fatal("retry changed deadline", err)
	}
	days = 0
	save("permanent")
	_, permanent, _, err := s.ShopManager().Purchase(uid, "second", p)
	if err != nil {
		t.Fatal(err)
	}
	if err = s.DB.QueryRow(`SELECT COUNT(*) FROM inventory_expirations WHERE uid=? AND instance=?`, uid, protocol.ReadUint32(permanent, 0)).Scan(&count); err != nil || count != 0 {
		t.Fatal("permanent purchase has deadline", err)
	}
	protocol.WriteUint32(p, 157, 1)
	if _, _, _, err = s.ShopManager().Purchase(uid, "tampered", p); err != ErrDenied {
		t.Fatal("price tampering accepted", err)
	}
	if err = s.DB.QueryRow(`SELECT COUNT(*) FROM purchases WHERE uid=?`, uid).Scan(&count); err != nil || count != 2 {
		t.Fatal("failed purchase persisted", err)
	}
}
