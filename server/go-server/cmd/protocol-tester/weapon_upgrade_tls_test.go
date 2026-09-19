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

func TestWeaponUpgradeTLS(t *testing.T) {
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
	a, err := persistence.NewAccount(uid, fmt.Sprintf("wt%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}

	a.Gold = 1000
	item := make([]byte, 68)
	protocol.WriteUint32(item, 0, 9999)
	item[4] = 25
	protocol.WriteUint32(item, 5, 253002)
	protocol.WriteUint32(item, 13, 8760)
	protocol.WriteUint32(item, 47, 500)
	a.Inventory = append(a.Inventory, item)
	if err = store.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"weapon_upgrades", "inventory", "accounts"} {
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

	exec(`CREATE TEMPORARY TABLE weapon_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	rules := persistence.WeaponRules{Enabled: true, Levels: []persistence.WeaponLevel{
		{Level: 0, ScoreThreshold: 100, Gold: 70, DisplayOdds: 100, Unknown16: 7, AttackBonusRaw: 100},
		{Level: 1, ScoreThreshold: 200, Gold: 90, DisplayOdds: 0, AttackBonusRaw: 200},
		{Level: 2, ScoreThreshold: 300},
	}}
	save := func(revision int) {
		t.Helper()
		b, e := json.Marshal(rules)
		if e != nil {
			t.Fatal(e)
		}
		exec("REPLACE INTO weapon_rules VALUES(1,?,?)", revision, b)
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

	request := protocol.Uint32Bytes(9999)
	expect(send(21412, request), 20150)
	table := send(21410, nil)
	expect(table, 21411)
	if len(table[0].Payload) != 63 || table[0].Payload[16] != 7 || protocol.ReadUint32(table[0].Payload, 8) != 70 {
		t.Fatal("wrong initial quote")
	}
	rules.Levels[0].Gold = 80
	save(2)
	expect(send(21412, request), 20150)
	var balance uint32
	if e := store.DB.QueryRow("SELECT gold FROM accounts WHERE uid=?", uid).Scan(&balance); e != nil || balance != 1000 {
		t.Fatal("stale quote charged", balance, e)
	}
	table = send(21410, nil)
	expect(table, 21411)
	if protocol.ReadUint32(table[0].Payload, 8) != 80 {
		t.Fatal("stale price displayed")
	}
	expect(send(21412, protocol.Uint32Bytes(9998)), 20150)
	result := send(21412, request)
	expect(result, 1240, 2161, 21413)
	if protocol.ReadUint32(result[0].Payload, 0) != 920 || protocol.ReadUint32(result[1].Payload, 43) != 1 || protocol.ReadUint32(result[1].Payload, 47) != 400 || result[2].Payload[0] != 1 {
		t.Fatal("wrong success balances")
	}
	result = send(21412, request)
	expect(result, 1240, 2161, 21413)
	if protocol.ReadUint32(result[0].Payload, 0) != 830 || protocol.ReadUint32(result[1].Payload, 43) != 1 || protocol.ReadUint32(result[1].Payload, 47) != 200 || result[2].Payload[0] != 0 {
		t.Fatal("wrong failure balances")
	}
	rules.Enabled = false
	save(3)
	expect(send(21412, request), 20150)
	var count int
	if e := store.DB.QueryRow("SELECT COUNT(*) FROM weapon_upgrades WHERE uid=?", uid).Scan(&count); e != nil || count != 2 {
		t.Fatal("wrong receipt count", count, e)
	}
	if e := store.DB.QueryRow("SELECT gold FROM accounts WHERE uid=?", uid).Scan(&balance); e != nil || balance != 830 {
		t.Fatal("disabled charged", balance, e)
	}
}
