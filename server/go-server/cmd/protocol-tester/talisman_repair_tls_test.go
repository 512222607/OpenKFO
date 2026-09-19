package main

import (
	"encoding/json"
	"fmt"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/game"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"net"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func TestTalismanRepairTLS(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	db, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(db.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug DB")
	}
	store, err := persistence.Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	uid := uint64(time.Now().UnixMicro())
	a, err := persistence.NewAccount(uid, fmt.Sprintf("rt%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}

	a.Gold = 1000
	item := make([]byte, 68)
	protocol.WriteUint32(item, 0, 9999)
	item[4] = 30
	protocol.WriteUint32(item, 5, 303002)
	protocol.WriteUint32(item, 13, 8760)
	protocol.WriteUint16(item, 23, 5)
	a.Inventory = append(a.Inventory, item)
	material := make([]byte, 68)
	protocol.WriteUint32(material, 0, 9998)
	material[4] = 60
	protocol.WriteUint32(material, 5, 603001)
	protocol.WriteUint32(material, 13, 8760)
	protocol.WriteUint16(material, 23, 3)
	a.Inventory = append(a.Inventory, material)
	if err = store.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"talisman_repairs", "inventory", "accounts"} {
			if _, e := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); e != nil {
				t.Error(e)
			}
		}
	}()
	// Connection-local rules do not alter the running debug server's settings.
	store.DB.SetMaxOpenConns(1)
	store.DB.SetMaxIdleConns(1)
	exec := func(q string, args ...any) {
		t.Helper()
		if _, e := store.DB.Exec(q, args...); e != nil {
			t.Fatal(e)
		}
	}

	exec(`CREATE TEMPORARY TABLE talisman_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	rules := persistence.TalismanRules{Enabled: true, Repairs: []persistence.TalismanRepairRule{{Item: 303002, Material: 603001, Quantity: 2, Capacity: 10000}}}

	save := func(revision int) {
		t.Helper()
		b, e := json.Marshal(rules)
		if e != nil {
			t.Fatal(e)
		}
		exec("REPLACE INTO talisman_rules VALUES(1,?,?)", revision, b)
	}
	save(1)
	root := t.TempDir()
	cert, err := tunnel.Certificate(root)
	if err != nil {
		t.Fatal(err)
	}
	hub := game.NewHub(store, game.Config{ConfigHash: strings.Repeat("a", 64), Pools: map[string][]uint32{"0:2": {104}}})
	l, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	defer l.Close()
	go game.NewServer(hub, cert).ServeTLS(l)
	config := filepath.Join(root, "bridge.json")
	b, _ := json.Marshal(map[string]string{"url": "tls://" + l.Addr().String(), "server_certificate": filepath.Join(root, "origin.crt"), "config_hash": hub.Config.ConfigHash})
	if err = os.WriteFile(config, b, 0600); err != nil {
		t.Fatal(err)
	}
	c, err := connect(command{Config: config, Account: a.Account, Password: "test123456"})
	if err != nil {
		t.Fatal(err)
	}
	defer c.conn.Close()
	drain := func() []protocol.Message {
		t.Helper()
		if e := c.send(tunnel.Frame{Op: "ping"}); e != nil {
			t.Fatal(e)
		}
		var result []protocol.Message
		for {
			f, ms, e := c.read()
			if e != nil {
				t.Fatal(e)
			}
			result = append(result, ms...)
			if f.Op == "pong" {
				return result
			}
		}
	}
	send := func(id uint32, p []byte) []protocol.Message {
		t.Helper()
		if e := c.game(3, id, p); e != nil {
			t.Fatal(e)
		}
		return drain()
	}
	expect := func(ms []protocol.Message, ids ...uint32) {
		t.Helper()
		if len(ms) != len(ids) {
			t.Fatalf("replies %v want %v", ms, ids)
		}
		for i, id := range ids {
			if ms[i].ID != id {
				t.Fatalf("reply=%d want=%d", ms[i].ID, id)
			}
		}
	}

	drain()

	request := make([]byte, 12)
	protocol.WriteUint32(request, 0, 9999)
	protocol.WriteUint32(request, 4, 603001)
	checkInventory := func(quota, materials uint16, receipts int) {
		t.Helper()
		account, e := store.RoleManager().Snapshot(uid)
		if e != nil {
			t.Fatal(e)
		}
		var gotQuota, gotMaterials uint16
		for _, p := range account.Inventory {
			switch protocol.ReadUint32(p, 0) {
			case 9999:
				gotQuota = protocol.ReadUint16(p, 23)
			case 9998:
				gotMaterials = protocol.ReadUint16(p, 23)
			}
		}
		var count int
		if e = store.DB.QueryRow("SELECT COUNT(*) FROM talisman_repairs WHERE uid=?", uid).Scan(&count); e != nil {
			t.Fatal(e)
		}
		if gotQuota != quota || gotMaterials != materials || count != receipts || account.Gold != 1000 {
			t.Fatalf("inventory quota=%d material=%d receipts=%d gold=%d", gotQuota, gotMaterials, count, account.Gold)
		}
	}
	expect(send(4204, request), 20150)
	expect(send(4202, protocol.Uint32Bytes(9997)), 20150)
	quote := send(4202, protocol.Uint32Bytes(9999))
	expect(quote, 4203)
	q := quote[0].Payload
	if len(q) != 32 || protocol.ReadUint32(q, 0) != 9999 || protocol.ReadUint32(q, 4) != 303002 || protocol.ReadUint32(q, 8) != 603001 || protocol.ReadUint32(q, 16) != 2 || protocol.ReadUint32(q, 20) != 5 || protocol.ReadUint32(q, 24) != 10000 {
		t.Fatal("incorrect quote")
	}
	rules.Repairs[0].Quantity = 4
	save(2)
	expect(send(4204, request), 20150)
	checkInventory(5, 3, 0)
	quote = send(4202, protocol.Uint32Bytes(9999))
	expect(quote, 4203)
	if protocol.ReadUint32(quote[0].Payload, 16) != 4 {
		t.Fatal("old price")
	}
	expect(send(4204, request), 20150)
	checkInventory(5, 3, 0) // insufficient materials
	rules.Repairs[0].Quantity = 3
	save(3)
	expect(send(4202, protocol.Uint32Bytes(9999)), 4203)
	protocol.WriteUint32(request, 4, 603002)
	expect(send(4204, request), 20150)
	protocol.WriteUint32(request, 4, 603001)
	result := send(4204, request)
	expect(result, 2161, 2162, 4205)
	if protocol.ReadUint16(result[0].Payload, 23) != 10000 || protocol.ReadUint32(result[1].Payload, 0) != 9998 || len(result[2].Payload) != 8 || protocol.ReadUint32(result[2].Payload, 4) != 0 {
		t.Fatal("incorrect repair synchronization")
	}
	checkInventory(10000, 0, 1)
	expect(send(4204, request), 20150)
	checkInventory(10000, 0, 1)
	rules.Enabled = false
	save(4)
	expect(send(4202, protocol.Uint32Bytes(9999)), 20150)
	expect(send(4204, request), 20150)
	checkInventory(10000, 0, 1)
}
