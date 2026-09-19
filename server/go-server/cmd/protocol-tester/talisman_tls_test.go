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

func TestTalismanTLS(t *testing.T) {
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
	store.DB.SetMaxOpenConns(1)
	store.DB.SetMaxIdleConns(1)
	if _, err = store.DB.Exec("CREATE TEMPORARY TABLE talisman_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB"); err != nil {
		t.Fatal(err)
	}
	if err = store.ItemManager().SeedTalismanSettings(persistence.TalismanRules{Enabled: true, Uses: []persistence.TalismanUseRule{{Item: 303002, ActiveCost: 200, PassiveCost: 100}}}); err != nil {
		t.Fatal(err)
	}
	accounts := make([]persistence.Account, 2)
	uid := uint64(time.Now().UnixMicro())
	for i := range accounts {
		a, e := persistence.NewAccount(uid+uint64(i), fmt.Sprintf("tu%d", uid+uint64(i)), "test123456")
		if e != nil {
			t.Fatal(e)
		}
		if i == 0 {
			p := make([]byte, 68)
			protocol.WriteUint32(p, 0, 9999)
			p[4] = 30
			protocol.WriteUint32(p, 5, 303002)
			protocol.WriteUint32(p, 13, 8760)
			protocol.WriteUint16(p, 17, 37)
			protocol.WriteUint16(p, 23, 500)
			a.Inventory = append(a.Inventory, p)
		}
		if e = store.Create(a); e != nil {
			t.Fatal(e)
		}
		accounts[i] = a
		id := a.UID
		defer func() {
			for _, table := range []string{"talisman_uses", "inventory", "accounts"} {
				if _, e := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", id); e != nil {
					t.Error(e)
				}
			}
		}()
	}
	root := t.TempDir()
	cert, err := tunnel.Certificate(root)
	if err != nil {
		t.Fatal(err)
	}
	cfg := game.Config{ConfigHash: strings.Repeat("a", 64), Pools: map[string][]uint32{"0:2": {104}}, TalismanUses: []game.TalismanUseRule{{Item: 303002, ActiveCost: 200, PassiveCost: 100}}}
	hub := game.NewHub(store, cfg)
	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	defer listener.Close()
	go game.NewServer(hub, cert).ServeTLS(listener)
	config := filepath.Join(root, "bridge.json")
	b, _ := json.Marshal(map[string]string{"url": "tls://" + listener.Addr().String(), "server_certificate": filepath.Join(root, "origin.crt"), "config_hash": cfg.ConfigHash})
	if err = os.WriteFile(config, b, 0600); err != nil {
		t.Fatal(err)
	}
	drain := func(c *client) []protocol.Message {
		t.Helper()
		if e := c.send(tunnel.Frame{Op: "ping"}); e != nil {
			t.Fatal(e)
		}
		var out []protocol.Message
		for {
			f, ms, e := c.read()
			if e != nil {
				t.Fatal(e)
			}
			out = append(out, ms...)
			if f.Op == "pong" {
				return out
			}
		}
	}
	find := func(ms []protocol.Message, id uint32) protocol.Message {
		t.Helper()
		for _, m := range ms {
			if m.ID == id {
				return m
			}
		}
		t.Fatalf("missing protocol %d in %v", id, ms)
		return protocol.Message{}
	}
	clients := make([]*client, 2)
	for i, a := range accounts {
		c, e := connect(command{Config: config, Account: a.Account, Password: "test123456"})
		if e != nil {
			t.Fatal(e)
		}
		clients[i] = c
		defer c.conn.Close()
		drain(c)
	}
	s, r := clients[0], clients[1]
	send := func(c *client, id uint32, p []byte) {
		t.Helper()
		if e := c.game(3, id, p); e != nil {
			t.Fatal(e)
		}
	}
	request := make([]byte, 81)
	copy(request, "TLS talisman")
	request[37] = 2
	protocol.WriteUint32(request, 38, 104)
	protocol.WriteUint16(request, 47, 180)
	send(s, 3010, request)
	entry := find(drain(s), 3100).Payload
	room := protocol.ReadUint16(entry, 0)
	join := make([]byte, 14)
	protocol.WriteUint16(join, 0, room)
	send(r, 3070, join)
	find(drain(r), 3100)
	drain(s)
	send(r, 4030, nil)
	find(drain(r), 4050)
	drain(s)
	send(s, 4030, nil)
	start := find(drain(s), 4080).Payload
	peerStart := find(drain(r), 4080).Payload
	if len(start) != 53 || len(peerStart) != 53 || protocol.ReadUint16(start, 11) != 0 || protocol.ReadUint16(peerStart, 11) != 0 {
		t.Fatal("both native clients must select room owner's slot 0 as controller")
	}
	battle := protocol.ReadUint32(start, 5)
	send(s, 4160, nil)
	drain(s)
	drain(r)
	send(r, 4160, nil)
	find(drain(r), 4180)
	find(drain(s), 4180)
	for i, c := range clients {
		p := make([]byte, 14)
		protocol.WriteUint16(p, 0, room)
		protocol.WriteUint64(p, 2, accounts[i].UID)
		send(c, 8040, p)
		if i == 0 {
			drain(c)
		}
	}
	find(drain(r), 8070)
	find(drain(s), 8070)
	checkReliableTLS(t, s, r, accounts[0].UID, accounts[1].UID, uint32(room), battle, send, drain)
	event := make([]byte, 75)
	protocol.WriteUint32(event, 0, 8292)
	protocol.WriteUint64(event, 4, uid)
	event[12] = 1
	event[13] = 1
	protocol.WriteUint32(event, 19, 1)
	protocol.WriteUint32(event, 39, 37)
	protocol.WriteUint64(event, 59, uid)
	protocol.WriteUint32(event, 67, uint32(room))
	protocol.WriteUint32(event, 71, battle)
	confirm := make([]byte, 8)
	protocol.WriteUint32(confirm, 0, 9999)
	protocol.WriteUint32(confirm, 4, 0xffffffff)
	use := func(want uint32, relay bool) {
		t.Helper()
		send(s, 8071, event)
		send(s, 4201, confirm)
		ack := find(drain(s), 4206).Payload
		if len(ack) != 12 || protocol.ReadUint32(ack, 4) != want {
			t.Fatal("wrong quota")
		}
		got := drain(r)
		if relay {
			m := find(got, 8071)
			if protocol.ReadUint32(m.Payload, 0) != protocol.ReadUint32(event, 0) {
				t.Fatal("wrong effect")
			}
		} else if len(got) != 0 {
			t.Fatal("duplicate effect")
		}
	}
	updateRules := func(enabled bool, cost uint16) {
		t.Helper()
		data, e := json.Marshal(persistence.TalismanRules{Enabled: enabled, Uses: []persistence.TalismanUseRule{{Item: 303002, ActiveCost: cost, PassiveCost: 100}}})
		if e != nil {
			t.Fatal(e)
		}
		if _, e = store.DB.Exec("UPDATE talisman_rules SET revision=revision+1,rules=?", data); e != nil {
			t.Fatal(e)
		}
	}
	// An accepted event retains its original fee across a rule update.
	send(s, 8071, event)
	drain(s)
	updateRules(true, 250)
	use(300, true)
	use(300, false)
	updateRules(false, 200)
	send(s, 8071, event)
	send(s, 4201, confirm)
	if len(drain(s)) != 0 || len(drain(r)) != 0 {
		t.Fatal("disabled use emitted effect or charge response")
	}
	updateRules(true, 200)
	protocol.WriteUint32(event, 0, 8291)
	protocol.WriteUint32(event, 19, 2)
	use(200, true)
	protocol.WriteUint32(event, 19, 3)
	use(200, true)
	protocol.WriteUint32(event, 0, 8292)
	protocol.WriteUint32(event, 19, 4)
	use(0, true)
	protocol.WriteUint32(event, 19, 5)
	send(s, 8071, event)
	send(s, 4201, confirm)
	find(drain(s), 4207)
	if len(drain(r)) != 0 {
		t.Fatal("insufficient quota relayed")
	}
	a, e := store.RoleManager().Snapshot(uid)
	if e != nil {
		t.Fatal(e)
	}
	found := false
	for _, p := range a.Inventory {
		if protocol.ReadUint32(p, 0) == 9999 {
			found = true
			if protocol.ReadUint16(p, 23) != 0 {
				t.Fatal("quota not persisted")
			}
		}
	}
	if !found {
		t.Fatal("missing talisman")
	}
	send(s, 3110, nil)
	drain(s)
	drain(r)
	send(r, 3110, nil)
	drain(r)
}
