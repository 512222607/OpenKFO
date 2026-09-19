package game

import (
	"database/sql"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
	"time"
)

func TestRenewalProtocolLocalDatabase(t *testing.T) {
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
		"CREATE TEMPORARY TABLE renewal_reminders(uid BIGINT,instance INT,ignored_deadline BIGINT,PRIMARY KEY(uid,instance)) ENGINE=InnoDB",
	} {
		exec(q)
	}
	h, s, _, _ := waitingRoomFixture()
	h.Store = &persistence.Store{DB: db}
	c := make([]byte, 108)
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
	exec("INSERT INTO accounts VALUES(?,1000)", s.UID)
	exec("INSERT INTO inventory VALUES(?,42,?)", s.UID, item)
	exec("INSERT INTO offers VALUES(7,?,?,TRUE)", c, item)
	exec("INSERT INTO offer_lifetimes VALUES(7,2)")
	deadline := time.Now().Unix() + 3600
	exec("INSERT INTO inventory_expirations VALUES(?,42,?,FALSE)", s.UID, deadline)
	p := make([]byte, 173)
	protocol.WriteUint32(p, 0, 42)
	protocol.WriteUint32(p, 4, 105)
	protocol.WriteUint64(p, 8, s.UID)
	protocol.WriteUint64(p, 58, s.UID)
	protocol.WriteUint32(p, 149, 7)
	protocol.WriteUint32(p, 161, 100)
	send := func(id uint32, p []byte) {
		t.Helper()
		if e := h.route(s, s.game(), protocol.Message{ID: id, Payload: p}); e != nil {
			t.Fatal(e)
		}
	}
	failed := func() {
		t.Helper()
		out := roomOutputs(t, s, 1430)
		if out[0].Payload[0] != 0 {
			t.Fatal("expected failure")
		}
	}
	send(1420, p)
	failed()
	send(1400, nil)
	if out := roomOutputs(t, s, 1410); len(out[0].Payload) != 0 {
		t.Fatal("active item listed")
	}
	expired := time.Now().Unix() - 3600
	exec("UPDATE inventory_expirations SET expires_at=?", expired)
	invalid := append([]byte(nil), item...)
	protocol.WriteUint32(invalid, 0, 43)
	protocol.WriteUint32(invalid, 19, 0xffffffff)
	exec("INSERT INTO inventory VALUES(?,43,?)", s.UID, invalid)
	exec("INSERT INTO inventory_expirations VALUES(?,43,?,FALSE)", s.UID, expired)
	send(1400, nil)
	reminders := roomOutputs(t, s, 1410)
	rows, err := protocol.ParseRenewalRecords(reminders[0].Payload)
	if err != nil || len(rows) != 1 || rows[0].InventoryInstance() != 42 || rows[0].InventoryState() != 2 || rows[0].DiscountRaw() != 100 || rows[0].ItemID() != 253013 {
		t.Fatal(rows, err)
	}
	var invalidStored []byte
	if e = db.QueryRow("SELECT record FROM inventory WHERE uid=? AND instance=43", s.UID).Scan(&invalidStored); e != nil || protocol.ReadUint32(invalidStored, 19) != 0xffffffff {
		t.Fatal("expiry revived invalid item", e)
	}
	exec("DELETE FROM inventory_expirations WHERE instance=43")
	exec("DELETE FROM inventory WHERE instance=43")
	send(1440, protocol.Uint32Bytes(99))
	roomOutputs(t, s, 20150)
	send(1440, protocol.Uint32Bytes(42))
	roomOutputs(t, s, 1450)
	send(1440, protocol.Uint32Bytes(42))
	roomOutputs(t, s, 1450)
	send(1400, nil)
	if out := roomOutputs(t, s, 1410); len(out[0].Payload) != 0 {
		t.Fatal("ignored reminder returned")
	}
	var kept int
	if e = db.QueryRow("SELECT COUNT(*) FROM inventory WHERE uid=? AND instance=42", s.UID).Scan(&kept); e != nil || kept != 1 {
		t.Fatal("ignore deleted item", e)
	}
	// A later expiry cycle is not hidden by the previous deadline's choice.
	exec("UPDATE inventory_expirations SET expires_at=?", expired+1)
	send(1400, nil)
	if out := roomOutputs(t, s, 1410); len(out[0].Payload) != 124 {
		t.Fatal("new deadline stayed hidden")
	}
	exec("UPDATE inventory_expirations SET expires_at=?", deadline)
	query := make([]byte, 9)
	query[0] = protocol.ItemWeapon
	protocol.WriteUint32(query, 1, 253013)
	protocol.WriteUint32(query, 5, 1)
	send(1500, query)
	out := roomOutputs(t, s, 1510)
	if len(out[0].Payload) != 108 || s.RenewalQuote == nil {
		t.Fatal("missing price binding")
	}
	// A delivered offer becoming stale must fail without charging.
	exec("UPDATE offer_lifetimes SET days=3")
	send(1420, p)
	failed()
	exec("UPDATE offer_lifetimes SET days=2")
	for i := 0; i < 2; i++ {
		send(1420, p)
		out = roomOutputs(t, s, 2161, 1230, 1430)
		if protocol.ReadUint32(out[0].Payload, 0) != 42 || out[0].Payload[45] != 9 || protocol.ReadUint32(out[1].Payload, 0) != 900 || out[2].Payload[0] != 1 {
			t.Fatal(out)
		}
	}
	var end int64
	var n int
	if e = db.QueryRow("SELECT expires_at FROM inventory_expirations WHERE uid=?", s.UID).Scan(&end); e != nil || end != deadline+2*86400 {
		t.Fatal(end, e)
	}
	db.QueryRow("SELECT COUNT(*) FROM inventory").Scan(&n)
	if n != 1 {
		t.Fatal("renewal allocated another instance", n)
	}
	s.RenewalQuote.Expires = time.Now().Add(-time.Second)
	send(1420, p)
	failed()
	send(1420, p[:172])
	failed()
}
