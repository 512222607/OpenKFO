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

func TestTitlesTLS(t *testing.T) {
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
	a, err := persistence.NewAccount(uid, fmt.Sprintf("tt%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	if err = store.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"title_rewards", "task_rewards", "task_progress", "training", "inventory", "accounts"} {
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

	exec(`CREATE TEMPORARY TABLE task_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE battle_reward_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	for _, table := range []string{"stage_access", "honour_rules"} {
		exec("CREATE TEMPORARY TABLE " + table + "(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB")
	}
	exec(`CREATE TEMPORARY TABLE battle_settlements(serial INT UNSIGNED PRIMARY KEY,reports MEDIUMBLOB NOT NULL,result MEDIUMBLOB NOT NULL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE offers(catalog_key INT PRIMARY KEY,category INT,variant INT,record BLOB,grant_record BLOB,enabled BOOL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE offer_lifetimes(catalog_key INT PRIMARY KEY,days INT UNSIGNED) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE item_definitions(definition_key INT PRIMARY KEY,revision BIGINT,record BLOB,days INT) ENGINE=InnoDB`)
	item, catalog := make([]byte, 68), make([]byte, 108)
	item[4], catalog[4] = 25, 25
	protocol.WriteUint32(item, 5, 250001)
	protocol.WriteUint32(item, 13, 24)
	protocol.WriteUint32(catalog, 5, 250001)
	protocol.WriteUint32(catalog, 9, 7)
	protocol.WriteUint32(catalog, 0, 7)
	exec(`INSERT INTO offers VALUES(7,0,0,?,?,TRUE)`, catalog, item)
	exec(`INSERT INTO item_definitions VALUES(7,1,?,1)`, item)
	exec(`INSERT INTO offer_lifetimes VALUES(7,1)`)
	exec(`CREATE TEMPORARY TABLE title_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	rules := persistence.TitleRules{ClientHash: strings.Repeat("a", 64), Catalogue: []persistence.TitleCatalogueEntry{{Level: 1, Name: "One"}, {Level: 2, Name: "Two"}}, Enabled: true, Titles: []persistence.TitleRule{
		{Level: 1, Enabled: true, MinPlayerLevel: 1, Choices: []uint32{7}},
		{Level: 2, Enabled: true, MinPlayerLevel: 1, Choices: []uint32{7}},
	}}
	data, _ := json.Marshal(rules)
	exec("INSERT INTO title_rules VALUES(1,1,?)", data)
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
	query := func() []protocol.Message { return send(6000, protocol.Uint32Bytes(protocol.ReadUint32(a.Profile, 0))) }
	claim := make([]byte, 149)
	protocol.WriteUint64(claim, 0, uid+999) // This ignored prefix cannot authorize another account.
	protocol.WriteUint32(claim, 145, 7)
	expect(send(4126, claim), 20150) // No announcement yet.
	checkOffer := func(ms []protocol.Message, level byte) {
		t.Helper()
		expect(ms, 4300, 1240, 6020, 1550, 4125)
		if len(ms[3].Payload) != 108 || protocol.ReadUint32(ms[3].Payload, 0) != 7 || protocol.ReadUint32(ms[3].Payload, 5) != 250001 {
			t.Fatal("reward catalogue missing before offer")
		}
		if len(ms[4].Payload) != 64 || ms[4].Payload[0] != level || protocol.ReadUint32(ms[4].Payload, 8) != 7 {
			t.Fatal("wrong title offer")
		}
	}
	checkOffer(query(), 1)
	exec("DELETE FROM offers") // Reward-only definitions must remain displayable and claimable.
	checkOffer(query(), 1)     // Refresh recovers a missed offer response.
	expect(send(4126, claim[:148]), 20150)
	protocol.WriteUint32(claim, 145, 8)
	expect(send(4126, claim), 20150)
	protocol.WriteUint32(claim, 145, 7)
	ms := send(4126, claim)
	expect(ms, 2160, 20150)
	first := protocol.ReadUint32(ms[0].Payload, 0)
	if len(ms[0].Payload) != 68 || protocol.ReadUint32(ms[0].Payload, 5) != 250001 {
		t.Fatal("wrong reward item")
	}
	ms = send(4126, claim)
	expect(ms, 2161, 20150)
	if protocol.ReadUint32(ms[0].Payload, 0) != first {
		t.Fatal("retry produced a new instance")
	}
	expect(query(), 4300, 1240, 6020) // Must not advance session binding to next title.
	reconnect := func() {
		t.Helper()
		if e := c.send(tunnel.Frame{Op: "logout"}); e != nil {
			t.Fatal(e)
		}
		for {
			f, _, e := c.read()
			if f.Op == "logged_out" {
				break
			}
			if e != nil {
				t.Fatal(e)
			}
		}
		c.conn.Close()
		var e error
		c, e = connect(command{Config: config, Account: a.Account, Password: "test123456"})
		if e != nil {
			t.Fatal(e)
		}
		t.Cleanup(func() { c.conn.Close() })
		drain()
	}
	reconnect()
	checkOffer(query(), 2)
	ms = send(4126, claim)
	expect(ms, 2160, 20150)
	if protocol.ReadUint32(ms[0].Payload, 0) == first {
		t.Fatal("second title reused item instance")
	}
	expect(send(4126, claim), 2161, 20150)
	reconnect()
	expect(query(), 4300, 1240, 6020)
	expect(send(4126, claim), 20150) // No pending offer after both titles were claimed.
	snapshot, e := store.RoleManager().Snapshot(uid)
	if e != nil || snapshot.Profile[persistence.TitleLevelOffset] != 2 || len(snapshot.Inventory) != len(a.Inventory)+2 {
		t.Fatal("persistent title/inventory mismatch", e)
	}
	var count int
	if e = store.DB.QueryRow("SELECT COUNT(*) FROM title_rewards WHERE uid=? AND claimed_key=7", uid).Scan(&count); e != nil || count != 2 {
		t.Fatal(count, e)
	}
}
