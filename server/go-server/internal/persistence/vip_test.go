package persistence

import (
	"bytes"
	"database/sql"
	"fmt"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
	"time"
)

func TestVIPSnapshotRemainingMinutes(t *testing.T) {
	card := vipCard(730002, 1)
	protocol.WriteUint32(card, 0, 12)
	protocol.WriteUint32(card, 13, 99999)
	original := bytes.Clone(card)
	for _, tc := range []struct {
		now            int64
		minutes, state uint32
	}{{100, 61, 1}, {101, 60, 1}, {3641, 1, 1}, {3701, 0, 2}, {4000, 0, 2}} {
		records := [][]byte{card}
		projectVIPMinutes(records, map[uint32]int64{12: 3701}, tc.now)
		if protocol.ReadUint32(records[0], 13) != tc.minutes || protocol.ReadUint32(records[0], 19) != tc.state {
			t.Fatal(tc, records[0])
		}
		if !bytes.Equal(original, card) {
			t.Fatal("mutated persistent/shared record")
		}
	}
	other := vipCard(730002, 0)
	wrong := vipCard(730002, 1)
	wrong[4] = 25
	records := [][]byte{card, other, wrong}
	projectVIPMinutes(records, nil, 100)
	if protocol.ReadUint32(records[0], 13) != 525600 || !bytes.Equal(records[1], other) || !bytes.Equal(records[2], wrong) {
		t.Fatal("wrong projection scope")
	}
}

func vipCard(id, state uint32) []byte {
	p := make([]byte, 68)
	p[4] = 73
	protocol.WriteUint32(p, 5, id)
	protocol.WriteUint32(p, 19, state)
	return p
}
func TestVIPMembershipSelection(t *testing.T) {
	card := vipCard(730003, 1)
	for _, state := range []uint32{0, 2, 0xffffffff} {
		v := VIPMembership{Kind: 1}
		if err := v.include(vipCard(730003, state), sql.NullInt64{}, 100); err != nil || v.Kind != 1 {
			t.Fatal(v, err)
		}
	}
	for _, end := range []int64{99, 100} {
		v := VIPMembership{Kind: 1}
		if err := v.include(card, sql.NullInt64{Int64: end, Valid: true}, 100); err != nil || v.Kind != 1 {
			t.Fatal(v, err)
		}
	}
	for _, reverse := range []bool{false, true} {
		v := VIPMembership{Kind: 1}
		ids := []uint32{730001, 730003, 730002, 730003}
		ends := []int64{999, 200, 888, 300}
		for n := range ids {
			i := n
			if reverse {
				i = len(ids) - 1 - n
			}
			if err := v.include(vipCard(ids[i], 1), sql.NullInt64{Int64: ends[i], Valid: true}, 100); err != nil {
				t.Fatal(err)
			}
		}
		if v.Kind != 4 || v.ExpiresAt == nil || *v.ExpiresAt != 300 {
			t.Fatal(v)
		}
		if err := v.include(card, sql.NullInt64{}, 100); err != nil || v.ExpiresAt != nil {
			t.Fatal(v, err)
		}
		if err := v.include(card, sql.NullInt64{Int64: 999, Valid: true}, 100); err != nil || v.ExpiresAt != nil {
			t.Fatal(v, err)
		}
	}
	v := VIPMembership{Kind: 1}
	wrong := vipCard(730003, 1)
	wrong[4] = 25
	for _, p := range [][]byte{wrong, vipCard(730004, 1)} {
		if err := v.include(p, sql.NullInt64{}, 100); err != nil || v.Kind != 1 {
			t.Fatal(v, err)
		}
	}
	if v.include(card[:67], sql.NullInt64{}, 100) == nil {
		t.Fatal("short record")
	}
}

func TestVIPMembershipLocalDatabase(t *testing.T) {
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
	for _, q := range []string{
		`CREATE TEMPORARY TABLE inventory(uid BIGINT UNSIGNED,instance INT UNSIGNED,record VARBINARY(68),PRIMARY KEY(uid,instance))`,
		`CREATE TEMPORARY TABLE inventory_expirations(uid BIGINT UNSIGNED,instance INT UNSIGNED,expires_at BIGINT,PRIMARY KEY(uid,instance))`,
	} {
		if _, err = db.Exec(q); err != nil {
			t.Fatal(err)
		}
	}
	end := time.Now().Unix() + 3600
	for _, x := range []struct {
		uid          uint64
		instance, id uint32
	}{{1, 1, 730001}, {1, 2, 730003}, {2, 1, 730003}} {
		if _, err = db.Exec("INSERT INTO inventory VALUES(?,?,?)", x.uid, x.instance, vipCard(x.id, 1)); err != nil {
			t.Fatal(err)
		}
	}
	if _, err = db.Exec("INSERT INTO inventory_expirations VALUES(1,1,?),(1,2,?)", end, end-7200); err != nil {
		t.Fatal(err)
	}
	st := &Store{DB: db}
	v, err := st.VIPMembership(1)
	if err != nil || v.Kind != 2 || v.ExpiresAt == nil || *v.ExpiresAt != end {
		t.Fatal(v, err)
	}
	v, err = st.VIPMembership(2)
	if err != nil || v.Kind != 4 || v.ExpiresAt != nil {
		t.Fatal(v, err)
	}
	v, err = st.VIPMembership(3)
	if err != nil || v.Kind != 1 {
		t.Fatal(v, err)
	}
	if _, err = db.Exec("UPDATE inventory_expirations SET expires_at=? WHERE uid=1 AND instance=1", end-7200); err != nil {
		t.Fatal(err)
	}
	v, err = st.VIPMembership(1)
	if err != nil || v.Kind != 1 {
		t.Fatal(v, err)
	}
}

func TestVIPGrantLocalDatabase(t *testing.T) {
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
	for _, q := range []string{
		`CREATE TEMPORARY TABLE accounts(uid BIGINT UNSIGNED PRIMARY KEY,account VARCHAR(20),nickname VARCHAR(40),profile VARBINARY(360),gold INT,tickets INT) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE inventory(uid BIGINT UNSIGNED,instance INT UNSIGNED,record VARBINARY(68),PRIMARY KEY(uid,instance)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE inventory_expirations(uid BIGINT UNSIGNED,instance INT UNSIGNED,expires_at BIGINT,processed BOOLEAN DEFAULT FALSE,PRIMARY KEY(uid,instance)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE counters(name VARCHAR(100) PRIMARY KEY,value BIGINT UNSIGNED) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE desktop_admin_operations(id VARCHAR(100) CHARACTER SET ascii PRIMARY KEY,request_hash BINARY(32),before_data LONGBLOB,result_data LONGBLOB) ENGINE=InnoDB`,
		`INSERT INTO accounts VALUES(1,'viptest','viptest',REPEAT(CHAR(0),360),0,0)`,
	} {
		if _, err = db.Exec(q); err != nil {
			t.Fatal(err)
		}
	}
	st := &Store{DB: db}
	end := time.Now().Unix() + 3600
	req := AdminRequest{Operation: "vip_grant", ID: "vip-test-one", UID: 1, VIPKind: 3, ExpiresAt: &end}
	if _, err = st.Admin(req); err != nil {
		t.Fatal(err)
	}
	if _, err = st.Admin(req); err != nil {
		t.Fatal(err)
	}
	var n int
	if err = db.QueryRow("SELECT COUNT(*) FROM inventory").Scan(&n); err != nil || n != 1 {
		t.Fatal("duplicate grant", n, err)
	}
	var record []byte
	if err = db.QueryRow("SELECT record FROM inventory WHERE uid=1").Scan(&record); err != nil || record[4] != 73 || protocol.ReadUint32(record, 5) != 730002 || protocol.ReadUint32(record, 19) != 1 || protocol.ReadUint32(record, 13) != 60 {
		t.Fatal("invalid card", record, err)
	}
	if _, err = db.Exec("UPDATE inventory_expirations SET expires_at=? WHERE uid=1", time.Now().Unix()+120); err != nil {
		t.Fatal(err)
	}
	account, err := st.RoleManager().Snapshot(1)
	if err != nil || len(account.Inventory) != 1 || protocol.ReadUint32(account.Inventory[0], 13) != 2 {
		t.Fatal("snapshot did not use deadline", account.Inventory, err)
	}
	if err = db.QueryRow("SELECT record FROM inventory WHERE uid=1").Scan(&record); err != nil || protocol.ReadUint32(record, 13) != 60 {
		t.Fatal("snapshot changed persisted duration", err)
	}
	bad := req
	bad.VIPKind = 4
	if _, err = st.Admin(bad); err == nil {
		t.Fatal("changed replay accepted")
	}
	for i, bad := range []AdminRequest{
		{UID: 2, VIPKind: 3, ExpiresAt: &end}, {UID: 1, VIPKind: 5, ExpiresAt: &end}, {UID: 1, VIPKind: 3},
	} {
		bad.Operation = "vip_grant"
		bad.ID = fmt.Sprintf("vip-invalid-%d", i)
		if _, err = st.Admin(bad); err == nil {
			t.Fatal("invalid grant accepted", bad)
		}
	}
	// A deadline insertion conflict after inventory INSERT must roll back both
	// inventory and audit. This emulates a storage error within the grant path.
	if _, err = db.Exec("INSERT INTO inventory_expirations(uid,instance,expires_at) VALUES(1,1048577,?)", end); err != nil {
		t.Fatal(err)
	}
	req.ID = "vip-test-rollback"
	if _, err = st.Admin(req); err == nil {
		t.Fatal("deadline failure accepted")
	}
	if err = db.QueryRow("SELECT COUNT(*) FROM inventory").Scan(&n); err != nil || n != 1 {
		t.Fatal("partial inventory committed", n, err)
	}
	if err = db.QueryRow("SELECT COUNT(*) FROM desktop_admin_operations").Scan(&n); err != nil || n != 1 {
		t.Fatal("partial audit committed", n, err)
	}
}
