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

func TestRenewalTLS(t *testing.T) {
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
	a, err := persistence.NewAccount(uid, fmt.Sprintf("rn%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	a.Tickets = 1000
	item := make([]byte, 68)
	protocol.WriteUint32(item, 0, 9999)
	item[4] = protocol.ItemWeapon
	protocol.WriteUint32(item, 5, 253013)
	protocol.WriteUint32(item, 13, 24)
	item[45] = 9
	a.Inventory = append(a.Inventory, item)
	if err = store.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"inventory", "accounts"} {
			if _, e := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); e != nil {
				t.Error(e)
			}
		}
	}()
	store.DB.SetMaxOpenConns(1)
	store.DB.SetMaxIdleConns(1)
	exec := func(q string, args ...any) {
		t.Helper()
		if _, e := store.DB.Exec(q, args...); e != nil {
			t.Fatal(e)
		}
	}
	exec("CREATE TEMPORARY TABLE offers(catalog_key INT PRIMARY KEY,category INT,variant INT,record BLOB,grant_record BLOB,enabled BOOL) ENGINE=InnoDB")
	exec("CREATE TEMPORARY TABLE offer_lifetimes(catalog_key INT PRIMARY KEY,days INT) ENGINE=InnoDB")
	catalog := make([]byte, 108)
	protocol.WriteUint32(catalog, 0, 7)
	catalog[4] = protocol.ItemWeapon
	protocol.WriteUint32(catalog, 5, 253013)
	protocol.WriteUint32(catalog, 9, 7)
	protocol.WriteUint32(catalog, 22, 48)
	protocol.WriteUint32(catalog, 38, 100)
	protocol.WriteUint32(catalog, 42, 100)
	catalog[48] = 1
	catalog[83] = 1
	exec("INSERT INTO offers VALUES(7,0,0,?,?,TRUE)", catalog, item)
	exec("INSERT INTO offer_lifetimes VALUES(7,2)")
	exec("INSERT INTO inventory_expirations(uid,instance,expires_at) VALUES(?,9999,?)", uid, time.Now().Unix()-3600)
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

	ms := send(1400, nil)
	expect(ms, 1410)
	reminders, e := protocol.ParseRenewalRecords(ms[0].Payload)
	if e != nil || len(reminders) != 1 || reminders[0].InventoryInstance() != 9999 || reminders[0].DiscountRaw() != 100 {
		t.Fatal(reminders, e)
	}
	ms = send(1440, protocol.Uint32Bytes(9999))
	expect(ms, 1450)
	ms = send(1400, nil)
	expect(ms, 1410)
	if len(ms[0].Payload) != 0 {
		t.Fatal("ignore did not persist")
	}
	query := make([]byte, 9)
	query[0] = protocol.ItemWeapon
	protocol.WriteUint32(query, 1, 253013)
	protocol.WriteUint32(query, 5, 1)
	request := make([]byte, 173)
	protocol.WriteUint32(request, 0, 9999)
	protocol.WriteUint32(request, 4, 105)
	protocol.WriteUint64(request, 8, uid)
	protocol.WriteUint64(request, 58, uid)
	protocol.WriteUint32(request, 149, 7)
	protocol.WriteUint32(request, 161, 100)
	ms = send(1420, request)
	expect(ms, 1430)
	if ms[0].Payload[0] != 0 {
		t.Fatal("unquoted renewal succeeded")
	}
	ms = send(1500, query)
	expect(ms, 1510)
	if len(ms[0].Payload) != 108 {
		t.Fatal("missing price")
	}
	exec("UPDATE offer_lifetimes SET days=3")
	ms = send(1420, request)
	expect(ms, 1430)
	if ms[0].Payload[0] != 0 {
		t.Fatal("stale duration charged")
	}
	exec("UPDATE offer_lifetimes SET days=2")
	before := time.Now().Unix()
	for i := 0; i < 2; i++ {
		ms = send(1420, request)
		expect(ms, 2161, 1230, 1430)
		ack, e := protocol.ParseRenewalResult(ms[2].Payload)
		if e != nil || !ack.Succeeded || ack.InventoryInstance != 9999 || protocol.ReadUint32(ms[1].Payload, 0) != 900 || protocol.ReadUint32(ms[0].Payload, 0) != 9999 || ms[0].Payload[45] != 9 {
			t.Fatal("renewal result mismatch", e)
		}
	}
	var end int64
	var count int
	if e = store.DB.QueryRow("SELECT expires_at FROM inventory_expirations WHERE uid=? AND instance=9999", uid).Scan(&end); e != nil || end < before+2*86400 || end > time.Now().Unix()+2*86400 {
		t.Fatal("deadline or repeated extension", end, e)
	}
	if e = store.DB.QueryRow("SELECT COUNT(*) FROM renewal_receipts WHERE uid=?", uid).Scan(&count); e != nil || count != 1 {
		t.Fatal("duplicate receipt", count, e)
	}
	ms = send(1400, nil)
	expect(ms, 1410)
	if len(ms[0].Payload) != 0 {
		t.Fatal("renewed item still listed")
	}
}
