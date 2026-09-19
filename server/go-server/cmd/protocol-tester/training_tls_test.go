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

func TestTrainingTLS(t *testing.T) {
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
	a, err := persistence.NewAccount(uid, fmt.Sprintf("mt%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	a.Inventory = nil
	if err = store.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"training_claims", "training_ranks", "training", "inventory", "accounts"} {
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
	exec(`CREATE TEMPORARY TABLE training_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE battle_reward_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	rules := persistence.TrainingRules{Enabled: true}
	for i := uint32(0); i <= 8; i++ {
		rules.Levels = append(rules.Levels, persistence.TrainingRule{Level: i, XPPerHour: 100 + i*10, XPCap: 500})
	}
	data, e := json.Marshal(rules)
	if e != nil {
		t.Fatal(e)
	}
	exec(`INSERT INTO training_rules VALUES(1,1,?)`, data)
	exec(`INSERT INTO training_ranks VALUES(?,2)`, uid)

	root := t.TempDir()
	cert, err := tunnel.Certificate(root)
	if err != nil {
		t.Fatal(err)
	}
	hub := game.NewHub(store, game.Config{ConfigHash: strings.Repeat("a", 64)})
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
	ms := send(21000, protocol.Uint64Bytes(uid))
	expect(ms, 21001)
	status, e := protocol.ParseTrainingStatus(ms[0].Payload)
	if e != nil || status.Level != 2 || status.RewardPerHour != 120 || status.Active != 0 {
		t.Fatal(status, e)
	}
	expect(send(21002, nil), 21005)
	var start int64
	if e := store.DB.QueryRow(`SELECT started FROM training WHERE uid=?`, uid).Scan(&start); e != nil {
		t.Fatal(e)
	}
	expect(send(21002, nil), 21005)
	var again int64
	if e := store.DB.QueryRow(`SELECT started FROM training WHERE uid=?`, uid).Scan(&again); e != nil || again != start {
		t.Fatal("duplicate start reset", again, start, e)
	}
	expect(send(21006, nil), 20150)
	// Advance only this newly created account; no wait and no existing user edits.
	exec(`UPDATE training SET started=? WHERE uid=?`, time.Now().Unix()-7200, uid)
	ms = send(21000, protocol.Uint64Bytes(uid))
	expect(ms, 21001)
	status, e = protocol.ParseTrainingStatus(ms[0].Payload)
	if e != nil || status.Minutes != 120 {
		t.Fatal(status, e)
	}
	ms = send(21006, nil)
	expect(ms, 4300, 21007)
	expected := protocol.ReadUint32(a.Profile, persistence.ExperienceOffset) + 240
	if protocol.ReadUint32(ms[0].Payload, 0) != expected {
		t.Fatal("wrong XP", ms)
	}
	expect(send(21006, nil), 20150)
	var count int
	if e := store.DB.QueryRow(`SELECT COUNT(*) FROM training_claims WHERE uid=?`, uid).Scan(&count); e != nil || count != 1 {
		t.Fatal(count, e)
	}
	expect(send(21002, nil), 21005)
	ms = send(21000, protocol.Uint64Bytes(uid))
	expect(ms, 21001)
	status, e = protocol.ParseTrainingStatus(ms[0].Payload)
	if e != nil || status.Active != 1 || status.Minutes != 0 || status.Level != 2 {
		t.Fatal(status, e)
	}
	var profile []byte
	if e := store.DB.QueryRow(`SELECT profile FROM accounts WHERE uid=?`, uid).Scan(&profile); e != nil || protocol.ReadUint32(profile, persistence.ExperienceOffset) != expected {
		t.Fatal("persistent XP", e)
	}
}
