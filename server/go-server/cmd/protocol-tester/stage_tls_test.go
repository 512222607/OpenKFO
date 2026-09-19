package main

import (
	"encoding/json"
	"fmt"
	"net"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/game"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
)

func TestStageGateTLS(t *testing.T) {
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
	exec := func(q string, args ...any) {
		t.Helper()
		if _, e := store.DB.Exec(q, args...); e != nil {
			t.Fatal(e)
		}
	}
	// Rules exist only on this test connection; running server settings stay intact.
	exec(`CREATE TEMPORARY TABLE stage_access(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE stage_player_unlocks(uid BIGINT,client_hash CHAR(64),revision BIGINT,maps BLOB,PRIMARY KEY(uid,client_hash)) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE stage_player_unlock_audit(uid BIGINT,client_hash CHAR(64),revision BIGINT,before_data BLOB,after_data BLOB,PRIMARY KEY(uid,client_hash,revision)) ENGINE=InnoDB`)
	access := persistence.StageAccess{ClientHash: strings.Repeat("a", 64), PVEMaps: []uint32{104}, RequirementsEnabled: true, Requirements: []persistence.StageTitleRequirement{{MapID: 104, Name: "Test map", TitleLevel: 3}}}
	save := func() {
		t.Helper()
		b, e := json.Marshal(access)
		if e != nil {
			t.Fatal(e)
		}
		exec("REPLACE INTO stage_access VALUES(1,1,?)", b)
	}
	save()
	accounts := make([]persistence.Account, 2)
	uid := uint64(time.Now().UnixMicro())
	for i := range accounts {
		a, e := persistence.NewAccount(uid+uint64(i), fmt.Sprintf("sg%d", uid+uint64(i)), "test123456")
		if e != nil {
			t.Fatal(e)
		}
		a.Profile[123] = 1
		if i == 0 {
			a.Profile[123] = 3
		}
		if e = store.Create(a); e != nil {
			t.Fatal(e)
		}
		accounts[i] = a
		id := a.UID
		defer func() {
			for _, table := range []string{"inventory", "accounts"} {
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
	hub := game.NewHub(store, game.Config{ConfigHash: access.ClientHash, Pools: map[string][]uint32{"0:2": {104}}})
	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	defer listener.Close()
	go game.NewServer(hub, cert).ServeTLS(listener)
	config := filepath.Join(root, "bridge.json")
	b, err := json.Marshal(map[string]string{"url": "tls://" + listener.Addr().String(), "server_certificate": filepath.Join(root, "origin.crt"), "config_hash": hub.Config.ConfigHash})
	if err != nil {
		t.Fatal(err)
	}
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
	absent := func(ms []protocol.Message, id uint32) {
		t.Helper()
		for _, m := range ms {
			if m.ID == id {
				t.Fatalf("unexpected protocol %d", id)
			}
		}
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
	host, peer := clients[0], clients[1]
	send := func(c *client, id uint32, p []byte) {
		t.Helper()
		if e := c.game(3, id, p); e != nil {
			t.Fatal(e)
		}
	}
	req := make([]byte, 81)
	copy(req, "TLS stage")
	req[37] = 2
	protocol.WriteUint32(req, 38, 104)
	protocol.WriteUint16(req, 47, 180)
	send(peer, 3010, req)
	denied := drain(peer)
	find(denied, 3030)
	absent(denied, 3100)
	send(host, 3010, req)
	entry := find(drain(host), 3100).Payload
	join := make([]byte, 14)
	protocol.WriteUint16(join, 0, protocol.ReadUint16(entry, 0))
	send(peer, 3070, join)
	denied = drain(peer)
	find(denied, 3080)
	absent(denied, 3100)
	// Turning off only the title gate retains the catalogue and permits joining.
	access.RequirementsEnabled = false
	save()
	send(peer, 3070, join)
	find(drain(peer), 3100)
	drain(host)
	send(peer, 4030, nil)
	find(drain(peer), 4050)
	drain(host)
	// Re-enable while waiting: owner must not bypass the other member's title.
	access.RequirementsEnabled = true
	save()
	send(host, 4030, nil)
	denied = drain(host)
	find(denied, 20150)
	absent(denied, 4080)
	absent(drain(peer), 4080)
	// A global closure still wins even when title conditions are disabled.
	access.RequirementsEnabled = false
	access.Disabled = []uint32{104}
	save()
	send(host, 4030, nil)
	denied = drain(host)
	find(denied, 20150)
	absent(denied, 4080)
	absent(drain(peer), 4080)
	access.Disabled = nil
	access.RequirementsEnabled = true
	required := true
	access.Requirements[0].UnlockRequired = &required
	save()
	accounts[1].Profile[123] = 3
	exec("UPDATE accounts SET profile=? WHERE uid=?", accounts[1].Profile, accounts[1].UID)
	setGrants := func(i int, maps []uint32) {
		t.Helper()
		read, e := store.Admin(persistence.AdminRequest{Operation: "stage_unlocks_get", UID: accounts[i].UID})
		if e != nil {
			t.Fatal(e)
		}
		p := read.(persistence.StagePlayerUnlocks)
		p.Maps = maps
		if _, e = store.Admin(persistence.AdminRequest{Operation: "stage_unlocks_save", UID: p.UID, StageUnlocks: &p}); e != nil {
			t.Fatal(e)
		}
	}
	setGrants(0, []uint32{104})
	receiveSelection := func(c *client, want int) {
		t.Helper()
		messages := drain(c)
		if len(messages) < 2 || len(messages)%2 != 0 {
			t.Fatal("stage records must precede selection", messages)
		}
		for i := 0; i < len(messages); i += 2 {
			if messages[i].ID != 21372 || messages[i+1].ID != 21373 {
				t.Fatal("invalid refresh sequence", messages)
			}
		}
		messages = messages[len(messages)-2:]
		records, e := protocol.ParseStageRecords(messages[0].Payload)
		if e != nil || len(records) != 1 || records[0].MapID != 104 || records[0].RequiredMapID != 0xffffffff || records[0].Unknown != [4]uint32{} {
			t.Fatal("invalid stage catalogue records", records, e)
		}
		m := messages[1]
		p, e := protocol.ParseStageSelection(m.Payload)
		if e != nil || p.Header != 0 || len(p.MapIDs) != want {
			t.Fatal("wrong selection projection", p, e)
		}
		if want == 1 && p.MapIDs[0] != 104 {
			t.Fatal("wrong map", p)
		}
		if want == 0 && string(m.Payload[4:7]) != "0,\x00" {
			t.Fatal("empty list did not clear controls")
		}
	}
	selection := func(c *client, want int) { t.Helper(); send(c, 21370, nil); receiveSelection(c, want) }
	refresh := func(i int) {
		t.Helper()
		hub.Mutex.Lock()
		s := hub.Sessions[accounts[i].UID]
		hub.Mutex.Unlock()
		if s == nil {
			t.Fatal("missing session")
		}
		if e := hub.RefreshExpiredInventory(s); e != nil {
			t.Fatal(e)
		}
	}
	selection(host, 1)
	selection(peer, 0)
	send(peer, 21370, []byte{1})
	find(drain(peer), 20150)
	send(host, 4030, nil)
	denied = drain(host)
	find(denied, 20150)
	absent(denied, 4080)
	absent(drain(peer), 4080)
	setGrants(1, []uint32{104})
	refresh(1)
	receiveSelection(peer, 1) // No new 21370 request: same hook as the 15-second ticker.
	refresh(1)
	absent(drain(peer), 21373)
	// Revocation must clear a previously populated client list and block the
	// owner's start, even though the member joined and readied before revocation.
	setGrants(1, []uint32{})
	refresh(1)
	receiveSelection(peer, 0)
	selection(host, 1)
	send(host, 4030, nil)
	denied = drain(host)
	find(denied, 20150)
	absent(denied, 4080)
	absent(drain(peer), 4080)
	setGrants(1, []uint32{104})
	selection(peer, 1)
	send(host, 4030, nil)
	find(drain(host), 4080)
	find(drain(peer), 4080)
}
