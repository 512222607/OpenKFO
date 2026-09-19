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

func TestInventoryGrantAtomicityLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("debug DB required")
	}
	c, e := mysql.ParseDSN(dsn)
	if e != nil || !strings.HasPrefix(c.DBName, "openkfo_debug_") {
		t.Fatal("not debug DB")
	}
	db, e := sql.Open("mysql", dsn)
	if e != nil {
		t.Fatal(e)
	}
	defer db.Close()
	db.SetMaxOpenConns(1)
	db.SetMaxIdleConns(1)
	for _, q := range []string{"CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY)", "INSERT INTO accounts VALUES(1)", "CREATE TEMPORARY TABLE inventory(uid BIGINT,instance BIGINT,record BLOB,PRIMARY KEY(uid,instance)) ENGINE=InnoDB", "CREATE TEMPORARY TABLE inventory_expirations(uid BIGINT,instance BIGINT,expires_at BIGINT,PRIMARY KEY(uid,instance)) ENGINE=InnoDB"} {
		if _, e = db.Exec(q); e != nil {
			t.Fatal(e)
		}
	}
	template := make([]byte, 68)
	template[4] = 31
	protocol.WriteUint32(template, 5, 313203)
	before := bytes.Clone(template)
	for _, commit := range []bool{false, true} {
		tx, e := db.Begin()
		if e != nil {
			t.Fatal(e)
		}
		var uid uint64
		if e = tx.QueryRow("SELECT uid FROM accounts WHERE uid=1 FOR UPDATE").Scan(&uid); e != nil {
			t.Fatal(e)
		}
		first, e := deliverInventoryItem(tx, uid, template, 7)
		if e != nil {
			tx.Rollback()
			t.Fatal(e)
		}
		second := []byte(nil)
		if commit {
			second, e = deliverInventoryItem(tx, uid, template, 0)
			if e != nil {
				tx.Rollback()
				t.Fatal(e)
			}
			if protocol.ReadUint32(first, 0) == protocol.ReadUint32(second, 0) {
				t.Fatal("duplicate instance")
			}
			e = tx.Commit()
		} else {
			if _, err := deliverInventoryItem(tx, uid, template[:5], 0); err == nil {
				t.Fatal("invalid second grant accepted")
			}
			e = tx.Rollback()
		}
		if e != nil {
			t.Fatal(e)
		}
		var n, exp int
		if e = db.QueryRow("SELECT COUNT(*) FROM inventory").Scan(&n); e != nil {
			t.Fatal(e)
		}
		if e = db.QueryRow("SELECT COUNT(*) FROM inventory_expirations").Scan(&exp); e != nil {
			t.Fatal(e)
		}
		if (!commit && (n != 0 || exp != 0)) || (commit && (n != 2 || exp != 1)) {
			t.Fatal("partial grant or expiry", n, exp)
		}
		if !bytes.Equal(before, template) {
			t.Fatal("catalogue template mutated")
		}
	}
}
