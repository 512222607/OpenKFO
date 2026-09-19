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

func TestExtendedTaskActionsTLS(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, e := mysql.ParseDSN(dsn)
	if e != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug DB")
	}
	store, e := persistence.Open(dsn)
	if e != nil {
		t.Fatal(e)
	}
	defer store.DB.Close()
	uid := uint64(time.Now().UnixMicro())
	a, e := persistence.NewAccount(uid, fmt.Sprintf("ext%d", uid), "test123456")
	if e != nil {
		t.Fatal(e)
	}
	if e = store.Create(a); e != nil {
		t.Fatal(e)
	}
	defer func() {
		for _, table := range []string{"training", "inventory", "accounts"} {
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
	exec(`CREATE TEMPORARY TABLE task_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE extended_task_progress(uid BIGINT UNSIGNED,task_key SMALLINT UNSIGNED,cycle VARCHAR(10),state TINYINT UNSIGNED,rule_revision BIGINT UNSIGNED,rule_data MEDIUMBLOB,counts BINARY(12),PRIMARY KEY(uid,task_key,cycle)) ENGINE=InnoDB`)
	hash := strings.Repeat("a", 64)
	rules := persistence.TaskRules{Extended: &persistence.ExtendedTaskRules{ClientHash: hash}}
	for _, kind := range []string{"daily", "newbie"} {
		id := uint16(2001)
		if kind == "newbie" {
			id = 3002
		}
		rules.Extended.Catalogue = append(rules.Extended.Catalogue, persistence.ExtendedTaskCatalogueEntry{ID: id, Kind: kind, Conditions: []persistence.ExtendedTaskRequirement{{Key: 0, Required: 1}, {Key: 3, Required: 1}, {}}})
		rules.Extended.Tasks = append(rules.Extended.Tasks, persistence.ExtendedTaskRule{ID: id, Kind: kind, Enabled: true, Gold: 20})
	}
	save := func() {
		t.Helper()
		data, e := json.Marshal(rules)
		if e != nil {
			t.Fatal(e)
		}
		exec("REPLACE INTO task_rules VALUES(1,1,?)", data)
	}
	save()
	root := t.TempDir()
	cert, e := tunnel.Certificate(root)
	if e != nil {
		t.Fatal(e)
	}
	hub := game.NewHub(store, game.Config{ConfigHash: hash, Pools: map[string][]uint32{"0:2": {104}}})
	listener, e := net.Listen("tcp", "127.0.0.1:0")
	if e != nil {
		t.Fatal(e)
	}
	defer listener.Close()
	go game.NewServer(hub, cert).ServeTLS(listener)
	config := filepath.Join(root, "bridge.json")
	b, _ := json.Marshal(map[string]string{"url": "tls://" + listener.Addr().String(), "server_certificate": filepath.Join(root, "origin.crt"), "config_hash": hash})
	if e = os.WriteFile(config, b, 0600); e != nil {
		t.Fatal(e)
	}
	c, e := connect(command{Config: config, Account: a.Account, Password: "test123456"})
	if e != nil {
		t.Fatal(e)
	}
	defer c.conn.Close()
	drain := func() []protocol.Message {
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
	drain()
	completionNotices := map[uint16]int{}
	query := func() map[uint16]protocol.ExtendedTaskProgress {
		t.Helper()
		if e := c.game(3, 6000, protocol.Uint32Bytes(protocol.ReadUint32(a.Profile, 0))); e != nil {
			t.Fatal(e)
		}
		ms := drain()
		result := map[uint16]protocol.ExtendedTaskProgress{}
		seen := map[uint32]bool{}
		for _, m := range ms {
			if m.ID == 6031 || m.ID == 6032 {
				if !seen[6041] || !seen[6042] || len(m.Payload) != 3 || m.Payload[2] != 4 {
					t.Fatal("completion before complete lists", m)
				}
				completionNotices[protocol.ReadUint16(m.Payload, 0)]++
			}
			if m.ID == 20150 {
				t.Fatal("list query failed", m)
			}
			if m.ID != 6041 && m.ID != 6042 {
				continue
			}
			if seen[m.ID] {
				t.Fatal("split task list", m.ID)
			}
			seen[m.ID] = true
			rows, e := protocol.ParseTaskRecords(m.ID, m.Payload)
			if e != nil {
				t.Fatal(e)
			}
			for _, row := range rows {
				r, e := protocol.ParseExtendedTaskProgress(row.Raw)
				if e != nil {
					t.Fatal(e)
				}
				result[r.Key] = r
			}
		}
		if !seen[6041] || !seen[6042] {
			t.Fatal("missing task lists", ms)
		}
		return result
	}
	if rows := query(); len(rows) != 2 || rows[2001].State != 1 || rows[3002].State != 1 {
		t.Fatal("initial lists", rows)
	}
	send := func(id uint32, p []byte, want uint32) protocol.Message {
		t.Helper()
		if e := c.game(3, id, p); e != nil {
			t.Fatal(e)
		}
		ms := drain()
		if len(ms) != 1 || ms[0].ID != want {
			t.Fatalf("request %d replies %+v want %d", id, ms, want)
		}
		return ms[0]
	}
	for _, pair := range []struct {
		accept, cancel uint32
		key            uint16
	}{{6051, 6081, 2001}, {6052, 6082, 3002}} {
		p := make([]byte, 19)
		protocol.WriteUint16(p, 0, pair.key)
		p[2] = 2
		for i := 3; i < len(p); i++ {
			p[i] = 255
		}
		out := send(pair.accept, p, pair.accept+10)
		if len(out.Payload) != 3 || protocol.ReadUint16(out.Payload, 0) != pair.key || out.Payload[2] != 2 {
			t.Fatal("bad acknowledgement", out)
		}
		if rows := query(); rows[pair.key].State != 2 {
			t.Fatal("accepted list", rows)
		}
		counts := make([]byte, 12)
		counts[0] = 1
		exec("UPDATE extended_task_progress SET counts=? WHERE uid=? AND task_key=?", counts, uid, pair.key)
		send(pair.accept, p, 20150)
		var stored []byte
		if e = store.DB.QueryRow("SELECT counts FROM extended_task_progress WHERE uid=? AND task_key=?", uid, pair.key).Scan(&stored); e != nil || stored[0] != 1 {
			t.Fatal("replay reset counters", e)
		}
		if rows := query(); rows[pair.key].Conditions[0].Current != 1 || rows[pair.key].Conditions[0].Key != 0 {
			t.Fatal("list counter", rows)
		}
		send(pair.accept, p[:18], 20150)
		p[2] = 4
		send(pair.accept, p, 20150)
		p[2] = 1
		out = send(pair.cancel, p, pair.cancel+10)
		if len(out.Payload) != 3 || out.Payload[2] != 1 {
			t.Fatal(out)
		}
		send(pair.cancel, p, 20150)
		if rows := query(); rows[pair.key].State != 1 || rows[pair.key].Conditions[0].Current != 0 {
			t.Fatal("cancelled list", rows)
		}
	}
	var other int
	if e = store.DB.QueryRow("SELECT COUNT(*) FROM extended_task_progress WHERE uid<>?", uid).Scan(&other); e != nil || other != 0 {
		t.Fatal("untrusted context selected account", other, e)
	}
	rules.Extended.Tasks[0].Enabled = false
	save()
	if rows := query(); len(rows) != 1 || rows[3002].Key != 3002 {
		t.Fatal("disabled task remained", rows)
	}
	p := make([]byte, 19)
	protocol.WriteUint16(p, 0, 2001)
	p[2] = 2
	send(6051, p, 20150)
	rules.Extended.ClientHash = strings.Repeat("b", 64)
	save()
	protocol.WriteUint16(p, 0, 3002)
	send(6052, p, 20150)
	// Isolate the claim wire contract using persisted completion fixtures.
	// Natural battle counters are covered separately by settlement DB tests.
	rules.Extended.ClientHash = hash
	rules.Extended.Tasks[0].Enabled = true
	for i := range rules.Extended.Catalogue {
		rules.Extended.Catalogue[i].Conditions[0].Event = "battle_play"
		rules.Extended.Catalogue[i].Conditions[1].Event = "battle_win"
	}
	save()
	before, e := store.RoleManager().Snapshot(uid)
	if e != nil {
		t.Fatal(e)
	}
	for i, key := range []uint16{2001, 3002} {
		protocol.WriteUint16(p, 0, key)
		p[2] = 2
		send(uint32(6051+i), p, uint32(6061+i))
		p[2] = 3
		send(uint32(6311+i), p, 20150)
		counts := make([]byte, 12)
		counts[0], counts[4] = 1, 1
		exec("UPDATE extended_task_progress SET state=4,counts=? WHERE uid=? AND task_key=?", counts, uid, key)
		if rows := query(); rows[key].State != 4 {
			t.Fatal("completion list", rows)
		}
		query()
		if completionNotices[key] != 1 {
			t.Fatal("completion notification not exactly once", completionNotices)
		}
		if e = c.game(3, uint32(6311+i), p); e != nil {
			t.Fatal(e)
		}
		messages := drain()
		if len(messages) != 3 || messages[0].ID != 4300 || messages[1].ID != 1240 || messages[2].ID != uint32(6301+i) || len(messages[2].Payload) != 3 || protocol.ReadUint16(messages[2].Payload, 0) != key || messages[2].Payload[2] != 3 {
			t.Fatal("claim responses", messages)
		}
		send(uint32(6311+i), p, 20150)
	}
	after, e := store.RoleManager().Snapshot(uid)
	if e != nil || after.Gold != before.Gold+40 {
		t.Fatal("claim balances", e)
	}
	if rows := query(); len(rows) != 1 || rows[2001].State != 3 {
		t.Fatal("claimed task lists", rows)
	}
}
