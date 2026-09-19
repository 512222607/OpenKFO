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

func TestTasksTLS(t *testing.T) {
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
	a, err := persistence.NewAccount(uid, fmt.Sprintf("qt%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	if err = store.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"task_rewards", "task_progress", "training", "inventory", "accounts"} {
			if _, e := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); e != nil {
				t.Error(e)
			}
		}
	}()
	peer, err := persistence.NewAccount(uid+1, fmt.Sprintf("qt%d", uid+1), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	if err = store.Create(peer); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"task_rewards", "task_progress", "training", "inventory", "accounts"} {
			if _, e := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", peer.UID); e != nil {
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
	exec(`CREATE TEMPORARY TABLE extended_task_progress(uid BIGINT UNSIGNED,task_key SMALLINT UNSIGNED,cycle VARCHAR(10),state TINYINT UNSIGNED,rule_revision BIGINT UNSIGNED,rule_data MEDIUMBLOB,counts BINARY(12),PRIMARY KEY(uid,task_key,cycle)) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE battle_reward_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	for _, table := range []string{"stage_access", "honour_rules"} {
		exec("CREATE TEMPORARY TABLE " + table + "(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB")
	}
	exec(`CREATE TEMPORARY TABLE battle_settlements(serial INT UNSIGNED PRIMARY KEY,reports MEDIUMBLOB NOT NULL,result MEDIUMBLOB NOT NULL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE offers(catalog_key INT PRIMARY KEY,category INT,variant INT,record BLOB,grant_record BLOB,enabled BOOL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE offer_lifetimes(catalog_key INT PRIMARY KEY,days INT UNSIGNED) ENGINE=InnoDB`)
	item, catalog := make([]byte, 68), make([]byte, 108)
	item[4], catalog[4] = 25, 25
	protocol.WriteUint32(item, 5, 250001)
	protocol.WriteUint32(item, 13, 24)
	protocol.WriteUint32(catalog, 5, 250001)
	protocol.WriteUint32(catalog, 9, 7)
	exec(`INSERT INTO offers VALUES(7,0,0,?,?,TRUE)`, catalog, item)
	exec(`INSERT INTO offer_lifetimes VALUES(7,1)`)
	rules := persistence.TaskRules{ClientHash: strings.Repeat("a", 64), Catalogue: []persistence.TaskCatalogueEntry{{ID: 1001, Next: 1002, Enabled: true}, {ID: 1002, Enabled: true}}, Enabled: true, Tasks: []persistence.TaskRule{
		{ID: 1001, Enabled: true, Matches: 2, Next: 1002, Counters: make([]uint32, 29), Experience: 40, Gold: 30, RewardCatalog: 7},
		{ID: 1002, Enabled: true, Matches: 1, Counters: make([]uint32, 29), Experience: 20},
	}}
	rules.Extended = &persistence.ExtendedTaskRules{ClientHash: rules.ClientHash}
	for i, kind := range []string{"daily", "newbie"} {
		key := uint16(2001 + i*1001)
		rules.Extended.Catalogue = append(rules.Extended.Catalogue, persistence.ExtendedTaskCatalogueEntry{Kind: kind, ID: key, Conditions: []persistence.ExtendedTaskRequirement{{Key: 0, Required: 2, Event: "battle_play"}, {Key: 3, Required: 1, Event: "battle_win"}, {}}})
		rules.Extended.Tasks = append(rules.Extended.Tasks, persistence.ExtendedTaskRule{Kind: kind, ID: key, Enabled: true, Experience: 5, Gold: 7, RewardCatalog: 7})
	}
	data, e := json.Marshal(rules)
	if e != nil {
		t.Fatal(e)
	}
	exec(`INSERT INTO task_rules VALUES(1,1,?)`, data)
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
	ms := query()
	expect(ms, 4300, 1240, 6020, 6041, 6042)
	list, e := protocol.ParseTaskRecords(6020, ms[2].Payload)
	if e != nil || len(list) != 1 || list[0].Key != 1001 || list[0].Raw[6] != 1 {
		t.Fatal(list, e)
	}
	p := make([]byte, 14)
	protocol.WriteUint64(p, 0, uid+1)
	protocol.WriteUint16(p, 12, 1001)
	ms = send(6050, p)
	expect(ms, 6060)
	if protocol.ReadUint64(ms[0].Payload, 0) != uid {
		t.Fatal("trusted forged UID")
	}
	expect(send(6050, p), 20150)
	ms = query()
	expect(ms, 4300, 1240, 6020, 6041, 6042)
	progress, e := protocol.ParseTaskProgress(ms[2].Payload)
	if e != nil || progress.State != 2 {
		t.Fatal(progress, e)
	}
	for i, key := range []uint16{2001, 3002} {
		request := make([]byte, 19)
		protocol.WriteUint16(request, 0, key)
		request[2] = 2
		expect(send(uint32(6051+i), request), uint32(6061+i))
	}
	r, e := connect(command{Config: config, Account: peer.Account, Password: "test123456"})
	if e != nil {
		t.Fatal(e)
	}
	defer r.conn.Close()
	// Counters must come from actual two-player settlements, never SQL fixtures.
	playTaskBattlesTLS(t, c, r, a, peer, func() {
		ms := query()
		expect(ms, 4300, 1240, 6020, 6041, 6042)
		p, e := protocol.ParseTaskProgress(ms[2].Payload)
		if e != nil || p.State != 2 || protocol.ReadUint32(ms[0].Payload, 0) != protocol.ReadUint32(a.Profile, persistence.ExperienceOffset) || protocol.ReadUint32(ms[1].Payload, 0) != a.Gold {
			t.Fatal("task must remain active and unpaid after one battle", p, e)
		}
	}, func(round int, returnedUID uint64, messages []protocol.Message) {
		lists, notices := 0, 0
		for _, m := range messages {
			if m.ID == 6041 || m.ID == 6042 {
				lists++
				entry, e := protocol.ParseExtendedTaskProgress(m.Payload)
				if e != nil {
					t.Fatal(e)
				}
				wantState := byte(1)
				if returnedUID == uid {
					wantState = 2
					if round == 1 {
						wantState = 4
					}
				}
				if entry.State != wantState {
					t.Fatal("return state", round, returnedUID, entry)
				}
				if returnedUID == uid && (entry.Conditions[0].Current != uint32(round+1) || entry.Conditions[1].Current != 1) {
					t.Fatal("natural task counters", entry)
				}
			}
			if m.ID == 6031 || m.ID == 6032 {
				if lists != 2 || round != 1 || returnedUID != uid || len(m.Payload) != 3 || m.Payload[2] != 4 {
					t.Fatal("unexpected completion", m)
				}
				notices++
			}
		}
		wantNotices := 0
		if round == 1 && returnedUID == uid {
			wantNotices = 2
		}
		if lists != 2 || notices != wantNotices {
			t.Fatal("missing return task messages", round, returnedUID, lists, notices)
		}
	})
	for _, account := range []persistence.Account{a, peer} {
		current, err := store.RoleManager().Snapshot(account.UID)
		if err != nil {
			t.Fatal(err)
		}
		if protocol.ReadUint32(current.Profile, 133) != protocol.ReadUint32(account.Profile, 133)+2 || protocol.ReadUint32(current.Profile, 137) != protocol.ReadUint32(account.Profile, 137)+1 {
			t.Fatal("settlement must record exactly two matches and one win per player")
		}
		if current.Gold != account.Gold || protocol.ReadUint32(current.Profile, persistence.ExperienceOffset) != protocol.ReadUint32(account.Profile, persistence.ExperienceOffset) {
			t.Fatal("battle fixture changed balances before task reward")
		}
	}
	ms = query()
	expect(ms, 4300, 1240, 6020, 2160, 6030, 6040, 20150, 6041, 6042)
	if len(ms[4].Payload) != 14 || protocol.ReadUint64(ms[4].Payload, 0) != uid || protocol.ReadUint16(ms[4].Payload, 12) != 1001 {
		t.Fatal("task completion notification mismatch")
	}
	if len(ms[3].Payload) != 68 || protocol.ReadUint32(ms[3].Payload, 5) != 250001 {
		t.Fatal("task item notification mismatch")
	}
	expectedXP := protocol.ReadUint32(a.Profile, persistence.ExperienceOffset) + 40
	expectedGold := a.Gold + 30
	if protocol.ReadUint32(ms[0].Payload, 0) != expectedXP || protocol.ReadUint32(ms[1].Payload, 0) != a.Gold+30 {
		t.Fatal("reward mismatch")
	}
	checkStates := func(ms []protocol.Message) {
		t.Helper()
		list, e := protocol.ParseTaskRecords(6020, ms[2].Payload)
		if e != nil || len(list) != 2 || list[0].Key != 1001 || list[0].Raw[6] != 3 || list[1].Key != 1002 || list[1].Raw[6] != 1 {
			t.Fatal("completed/successor state", list, e)
		}
	}
	if len(ms[5].Payload) != 6 || protocol.ReadUint16(ms[5].Payload, 4) != 1002 {
		t.Fatal("successor notification mismatch")
	}
	initial, e := protocol.ParseTaskRecords(6020, ms[2].Payload)
	if e != nil || len(initial) != 1 || initial[0].Key != 1001 || initial[0].Raw[6] != 3 {
		t.Fatal("successor duplicated in full list", initial, e)
	}
	ms = query()
	expect(ms, 4300, 1240, 6020, 6041, 6042)
	checkStates(ms)
	for i, key := range []uint16{2001, 3002} {
		request := make([]byte, 19)
		protocol.WriteUint16(request, 0, key)
		request[2] = 3
		claim := send(uint32(6311+i), request)
		expect(claim, 4300, 1240, 2160, uint32(6301+i))
		expectedXP += 5
		expectedGold += 7
		if protocol.ReadUint32(claim[0].Payload, 0) != expectedXP || protocol.ReadUint32(claim[1].Payload, 0) != expectedGold || protocol.ReadUint32(claim[2].Payload, 5) != 250001 {
			t.Fatal("extended reward mismatch", claim)
		}
		expect(send(uint32(6311+i), request), 20150)
	}
	// Await explicit transport logout acknowledgement before re-authentication.
	if e = c.send(tunnel.Frame{Op: "logout"}); e != nil {
		t.Fatal(e)
	}
	for {
		f, _, e := c.read()
		// Interactive read reports logout as terminal; this test requested it.
		if f.Op == "logged_out" {
			break
		}
		if e != nil {
			t.Fatal(e)
		}
	}
	c.conn.Close()
	c, e = connect(command{Config: config, Account: a.Account, Password: "test123456"})
	if e != nil {
		t.Fatal(e)
	}
	defer c.conn.Close()
	drain()
	ms = query()
	expect(ms, 4300, 1240, 6020, 6041, 6042)
	checkStates(ms)
	if protocol.ReadUint32(ms[0].Payload, 0) != expectedXP || protocol.ReadUint32(ms[1].Payload, 0) != expectedGold {
		t.Fatal("reconnect lost reward")
	}
	if daily, e := protocol.ParseExtendedTaskProgress(ms[3].Payload); e != nil || daily.State != 3 || len(ms[4].Payload) != 0 {
		t.Fatal("reconnect task receipt", daily, e)
	}
	var receipts int
	if e = store.DB.QueryRow("SELECT COUNT(*) FROM task_rewards WHERE uid=?", uid).Scan(&receipts); e != nil || receipts != 1 {
		t.Fatal("duplicate receipt", receipts, e)
	}
	var inventoryCount int
	if e = store.DB.QueryRow("SELECT COUNT(*) FROM inventory WHERE uid=?", uid).Scan(&inventoryCount); e != nil || inventoryCount != len(a.Inventory)+3 {
		t.Fatal("item missing or duplicated after reconnect", inventoryCount, e)
	}
}

// Exercise the same native room/load/report/return messages as the game.
func playTaskBattlesTLS(t *testing.T, owner, peer *client, a, b persistence.Account, afterFirst func(), onReturn ...func(int, uint64, []protocol.Message)) {
	t.Helper()
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
	find := func(ms []protocol.Message, id uint32) []byte {
		t.Helper()
		for _, m := range ms {
			if m.ID == id {
				return m.Payload
			}
		}
		t.Fatalf("missing protocol %d in %v", id, ms)
		return nil
	}
	send := func(c *client, id uint32, p []byte) {
		t.Helper()
		if e := c.game(3, id, p); e != nil {
			t.Fatal(e)
		}
	}
	drain(peer)
	drain(owner)
	request := make([]byte, 81)
	copy(request, "TLS task battles")
	request[37] = 2
	protocol.WriteUint32(request, 38, 104)
	protocol.WriteUint16(request, 47, 180)
	send(owner, 3010, request)
	room := protocol.ReadUint16(find(drain(owner), 3100), 0)
	join := make([]byte, 14)
	protocol.WriteUint16(join, 0, room)
	send(peer, 3070, join)
	find(drain(peer), 3100)
	drain(owner)
	clients := []*client{owner, peer}
	accounts := []persistence.Account{a, b}
	for round := 0; round < 2; round++ {
		send(peer, 4030, nil)
		find(drain(peer), 4050)
		drain(owner)
		send(owner, 4030, nil)
		start := find(drain(owner), 4080)
		find(drain(peer), 4080)
		serial := protocol.ReadUint32(start, 5)
		send(owner, 4160, nil)
		drain(owner)
		drain(peer)
		send(peer, 4160, nil)
		find(drain(peer), 4180)
		find(drain(owner), 4180)
		for i, c := range clients {
			p := make([]byte, 14)
			protocol.WriteUint16(p, 0, room)
			protocol.WriteUint64(p, 2, accounts[i].UID)
			send(c, 8040, p)
			if i == 0 {
				drain(c)
			}
		}
		find(drain(peer), 8070)
		find(drain(owner), 8070)
		report := make([]byte, 696)
		for i, account := range accounts {
			p := report[i*87 : (i+1)*87]
			protocol.WriteUint64(p, 29, account.UID)
			protocol.WriteUint32(p, 67, uint32(room))
			protocol.WriteUint32(p, 71, serial)
			if i == round { // One win and one loss for each player.
				protocol.WriteUint16(p, 2, 100)
			}
		}
		send(owner, 4110, report)
		drain(owner)
		find(drain(peer), 4100)
		send(peer, 4110, report)
		for _, c := range clients {
			find(drain(c), 4120)
		}
		// Duplicate settlement reports must not advance task counters again.
		for _, c := range clients {
			send(c, 4110, report)
			if ms := drain(c); len(ms) != 0 {
				t.Fatal("duplicate settlement emitted replies", ms)
			}
		}
		for i, c := range clients {
			p := make([]byte, 12)
			protocol.WriteUint64(p, 0, accounts[i].UID)
			send(c, 3550, p)
			messages := drain(c)
			find(messages, 3550)
			for _, observe := range onReturn {
				observe(round, accounts[i].UID, messages)
			}
		}
		drain(owner)
		drain(peer)
		if round == 0 {
			afterFirst()
		}
	}
}
