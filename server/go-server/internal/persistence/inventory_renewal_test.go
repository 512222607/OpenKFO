package persistence

import (
	"bytes"
	"database/sql"
	"os"
	"strings"
	"testing"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
)

func TestExtendInventoryLocalDatabase(t *testing.T) {
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
		if _, err := db.Exec(q, args...); err != nil {
			t.Fatal(err)
		}
	}
	exec("CREATE TEMPORARY TABLE inventory(uid BIGINT,instance INT,record BLOB,PRIMARY KEY(uid,instance)) ENGINE=InnoDB")
	exec("CREATE TEMPORARY TABLE inventory_expirations(uid BIGINT,instance INT,expires_at BIGINT,processed BOOL,PRIMARY KEY(uid,instance)) ENGINE=InnoDB")
	const now = int64(1800000000)
	for _, tc := range []struct {
		name            string
		deadline        int64
		state           uint32
		uid             uint64
		kind            byte
		days            uint32
		valid, rollback bool
	}{
		{"active", now + 3600, 0, 1, protocol.ItemWeapon, 2, true, false},
		{"expired", now - 3600, 2, 1, protocol.ItemWeapon, 2, true, false},
		{"expiry not processed", now - 3600, 0, 1, protocol.ItemWeapon, 2, true, false},
		{"rollback", now + 3600, 0, 1, protocol.ItemWeapon, 2, true, true},
		{"other owner", now + 3600, 0, 2, protocol.ItemWeapon, 2, false, false},
		{"invalidated", now + 3600, 0xffffffff, 1, protocol.ItemWeapon, 2, false, false},
		{"permanent", 0, 0, 1, protocol.ItemWeapon, 2, false, false},
		{"VIP uses minutes", now + 3600, 1, 1, protocol.ItemVIPCard, 2, false, false},
		{"term overflow", 1<<63 - 1, 0, 1, protocol.ItemWeapon, 2, false, false},
		{"zero extension", now + 3600, 0, 1, protocol.ItemWeapon, 0, false, false},
	} {
		t.Run(tc.name, func(t *testing.T) {
			exec("DELETE FROM inventory")
			exec("DELETE FROM inventory_expirations")
			original := bytes.Repeat([]byte{0x35}, 68)
			protocol.WriteUint32(original, 0, 42)
			original[4] = tc.kind
			protocol.WriteUint32(original, 19, tc.state)
			exec("INSERT INTO inventory VALUES(1,42,?)", original)
			if tc.deadline != 0 {
				exec("INSERT INTO inventory_expirations VALUES(1,42,?,TRUE)", tc.deadline)
			}
			tx, err := db.Begin()
			if err != nil {
				t.Fatal(err)
			}
			item, err := (InventoryManager{}).ExtendItem(tx, tc.uid, 42, tc.days, now)
			if (err == nil) != tc.valid {
				tx.Rollback()
				t.Fatal(err)
			}
			if !tc.valid || tc.rollback {
				tx.Rollback()
			} else if err = tx.Commit(); err != nil {
				t.Fatal(err)
			}
			var stored []byte
			if err = db.QueryRow("SELECT record FROM inventory WHERE uid=1 AND instance=42").Scan(&stored); err != nil {
				t.Fatal(err)
			}
			if !tc.valid || tc.rollback {
				if !bytes.Equal(stored, original) {
					t.Fatal("failed transaction changed inventory")
				}
				if tc.deadline != 0 {
					var end int64
					var processed bool
					if err = db.QueryRow("SELECT expires_at,processed FROM inventory_expirations WHERE uid=1 AND instance=42").Scan(&end, &processed); err != nil || end != tc.deadline || !processed {
						t.Fatal("failed transaction changed expiration", end, processed, err)
					}
				}
				return
			}
			var end int64
			var processed bool
			if err = db.QueryRow("SELECT expires_at,processed FROM inventory_expirations WHERE uid=1 AND instance=42").Scan(&end, &processed); err != nil {
				t.Fatal(err)
			}
			if end != max(now, tc.deadline)+int64(tc.days)*86400 || processed {
				t.Fatal(end, processed)
			}
			want := bytes.Clone(original)
			protocol.WriteUint32(want, 13, uint32((end-now+3599)/3600))
			if tc.deadline <= now || tc.state == 2 {
				protocol.WriteUint16(want, 17, 0)
				protocol.WriteUint32(want, 19, 0)
			}
			if !bytes.Equal(stored, want) || !bytes.Equal(item, want) {
				t.Fatal("instance or upgrade fields changed")
			}
		})
	}
}
