package persistence

import (
	"bytes"
	"database/sql"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
	"time"
)

func TestShopRenewalLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, e := mysql.ParseDSN(dsn)
	if e != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("not debug database")
	}
	db, e := sql.Open("mysql", dsn)
	if e != nil {
		t.Fatal(e)
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
		"CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,tickets INT) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE inventory(uid BIGINT,instance INT,record BLOB,PRIMARY KEY(uid,instance)) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE inventory_expirations(uid BIGINT,instance INT,expires_at BIGINT,processed BOOL,PRIMARY KEY(uid,instance)) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE offers(catalog_key INT PRIMARY KEY,record BLOB,grant_record BLOB,enabled BOOL) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE offer_lifetimes(catalog_key INT PRIMARY KEY,days INT) ENGINE=InnoDB",
		"CREATE TEMPORARY TABLE renewal_receipts(uid BIGINT,operation_id VARCHAR(128),request_hash BINARY(32),instance INT,PRIMARY KEY(uid,operation_id)) ENGINE=InnoDB",
	} {
		exec(q)
	}
	quote := RenewalQuote{Days: 2}
	c := quote.Catalog[:]
	protocol.WriteUint32(c, 0, 7)
	c[4] = protocol.ItemWeapon
	protocol.WriteUint32(c, 5, 253013)
	protocol.WriteUint32(c, 9, 7)
	protocol.WriteUint32(c, 38, 100)
	protocol.WriteUint32(c, 42, 100)
	c[48] = 1
	c[83] = 1
	item := make([]byte, 68)
	protocol.WriteUint32(item, 0, 42)
	item[4] = protocol.ItemWeapon
	protocol.WriteUint32(item, 5, 253013)
	item[45] = 9
	exec("INSERT INTO accounts VALUES(1,1000)")
	exec("INSERT INTO inventory VALUES(1,42,?)", item)
	exec("INSERT INTO offers VALUES(7,?,?,TRUE)", c, item)
	exec("INSERT INTO offer_lifetimes VALUES(7,2)")
	p := make([]byte, 173)
	protocol.WriteUint32(p, 0, 42)
	protocol.WriteUint32(p, 4, 105)
	protocol.WriteUint64(p, 8, 1)
	protocol.WriteUint64(p, 58, 1)
	protocol.WriteUint32(p, 149, 7)
	protocol.WriteUint32(p, 161, 100)
	m := (&Store{DB: db}).ShopManager()
	unchanged := func() {
		t.Helper()
		var b, n int
		db.QueryRow("SELECT tickets FROM accounts WHERE uid=1").Scan(&b)
		db.QueryRow("SELECT COUNT(*) FROM renewal_receipts").Scan(&n)
		if b != 1000 || n != 0 {
			t.Fatal("partial debit", b, n)
		}
	}
	// Missing expiration fails after the debit statement; rollback must restore it.
	if _, e = m.RenewItem(1, "op", p, quote); e == nil {
		t.Fatal("permanent item accepted")
	}
	unchanged()
	deadline := time.Now().Unix() + 3600
	exec("INSERT INTO inventory_expirations VALUES(1,42,?,FALSE)", deadline)
	bad := quote
	bad.Days = 1
	if _, e = m.RenewItem(1, "op", p, bad); e == nil {
		t.Fatal("stale duration accepted")
	}
	unchanged()
	bad = quote
	bad.Catalog[38]++
	if _, e = m.RenewItem(1, "op", p, bad); e == nil {
		t.Fatal("stale price accepted")
	}
	unchanged()
	for _, offset := range []int{0, 4, 8, 58, 149, 161} {
		altered := bytes.Clone(p)
		altered[offset]++
		if _, e = m.RenewItem(1, "op", altered, quote); e == nil {
			t.Fatal("untrusted field accepted", offset)
		}
		unchanged()
	}
	out, e := m.RenewItem(1, "op", p, quote)
	if e != nil || out.Tickets != 900 || out.Replay || len(out.Item) != 68 || out.Item[45] != 9 || protocol.ReadUint32(out.Item, 0) != 42 {
		t.Fatal(out, e)
	}
	var end int64
	if e = db.QueryRow("SELECT expires_at FROM inventory_expirations WHERE uid=1 AND instance=42").Scan(&end); e != nil || end != deadline+2*86400 {
		t.Fatal(end, e)
	}
	// Configuration changes do not invalidate a committed receipt or repeat debit.
	exec("UPDATE offers SET enabled=FALSE")
	for i := 0; i < 2; i++ {
		out, e = m.RenewItem(1, "op", p, RenewalQuote{})
		if e != nil || !out.Replay || out.Tickets != 900 {
			t.Fatal(out, e)
		}
	}
	var after int64
	db.QueryRow("SELECT expires_at FROM inventory_expirations WHERE uid=1 AND instance=42").Scan(&after)
	if after != end {
		t.Fatal("duplicate extension")
	}
	altered := bytes.Clone(p)
	altered[172] = 1
	if _, e = m.RenewItem(1, "op", altered, quote); e == nil {
		t.Fatal("same operation changed request accepted")
	}
	exec("DELETE FROM inventory_expirations")
	exec("DELETE FROM inventory")
	out, e = m.RenewItem(1, "op", p, quote)
	if e != nil || !out.Replay || len(out.Item) != 0 || out.Tickets != 900 {
		t.Fatal("deleted item resurrected", out, e)
	}
}
