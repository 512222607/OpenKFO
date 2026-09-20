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

func TestGiftTLS(t *testing.T) {
	t.Run("offline", func(t *testing.T) { testGiftTLS(t, false, false) })
	t.Run("online", func(t *testing.T) { testGiftTLS(t, true, false) })
}
func TestVIPGiftTLS(t *testing.T) {
	testGiftTLS(t, true, true)
}
func testGiftTLS(t *testing.T, online, vip bool) {
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
	// Keep this scenario independent of the operator's current VIP rules.
	if _, err = store.DB.Exec(`CREATE TEMPORARY TABLE vip_shop_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED,rules MEDIUMBLOB) ENGINE=InnoDB`); err != nil {
		t.Fatal(err)
	}
	if vip {
		if _, err = store.DB.Exec(`INSERT INTO vip_shop_rules VALUES(1,1,'{"enabled":true,"silver":90,"gold":80,"platinum":70}')`); err != nil {
			t.Fatal(err)
		}
	}
	uid := uint64(time.Now().UnixMicro())
	accounts := make([]persistence.Account, 2)
	for i := range accounts {
		a, e := persistence.NewAccountWithStarterCharacter(uid+uint64(i), fmt.Sprintf("gtls%d", uid+uint64(i)), "test123456")
		if e != nil {
			t.Fatal(e)
		}
		a.Nickname = fmt.Sprintf("t%d", a.UID)
		a.Inventory = nil
		a.Tickets = 200
		if e = store.Create(a); e != nil {
			t.Fatal(e)
		}
		accounts[i] = a
		id := a.UID
		defer func() {
			for _, table := range []string{"gift_receipts", "inventory", "accounts"} {
				if _, e := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", id); e != nil {
					t.Error(e)
				}
			}
		}()
	}
	if vip {
		op := fmt.Sprintf("gift-vip-%d", uid)
		defer func() {
			if _, e := store.DB.Exec("DELETE FROM desktop_admin_operations WHERE id=?", op); e != nil {
				t.Error(e)
			}
		}()
		end := time.Now().Unix() + 3600
		if _, err = store.Admin(persistence.AdminRequest{Operation: "vip_grant", ID: op, UID: uid, VIPKind: 3, ExpiresAt: &end}); err != nil {
			t.Fatal(err)
		}
	}
	key := uint32(uid%80000000) + 0x50000000
	catalog, grant := make([]byte, 108), make([]byte, 68)
	protocol.WriteUint32(catalog, 0, key)
	protocol.WriteUint32(catalog, 9, key)
	catalog[4], grant[4] = 25, 25
	protocol.WriteUint32(catalog, 5, 253001)
	protocol.WriteUint32(grant, 5, 253001)
	protocol.WriteUint32(catalog, 38, 77)
	protocol.WriteUint32(catalog, 42, 77)
	catalog[48], catalog[83] = 1, 1
	if _, err = store.DB.Exec(`INSERT INTO offers(catalog_key,category,variant,record,grant_record,enabled) VALUES(?,10,25,?,?,TRUE)`, key, catalog, grant); err != nil {
		t.Fatal(err)
	}
	defer func() {
		if _, e := store.DB.Exec(`DELETE FROM offers WHERE catalog_key=?`, key); e != nil {
			t.Error(e)
		}
	}()
	root := t.TempDir()
	cert, err := tunnel.Certificate(root)
	if err != nil {
		t.Fatal(err)
	}
	cfg := game.Config{ConfigHash: strings.Repeat("a", 64)}
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
	login := func(i int) *client {
		c, e := connect(command{Config: config, Account: accounts[i].Account, Password: "test123456"})
		if e != nil {
			t.Fatal(e)
		}
		if e = c.send(tunnel.Frame{Op: "ping"}); e != nil {
			t.Fatal(e)
		}
		f, _, e := c.read()
		if e != nil || f.Op != "pong" {
			t.Fatal("login not ready", e)
		}
		return c
	}
	receive := func(c *client, ids ...uint32) []protocol.Message {
		t.Helper()
		var out []protocol.Message
		for len(out) < len(ids) {
			f, ms, e := c.read()
			if e != nil {
				t.Fatal(e)
			}
			if f.Channel != 3 {
				t.Fatalf("unexpected channel %d", f.Channel)
			}
			out = append(out, ms...)
		}
		if len(out) != len(ids) {
			t.Fatal("unexpected extra messages")
		}
		for i, id := range ids {
			if out[i].ID != id {
				t.Fatalf("want %d got %d", id, out[i].ID)
			}
		}
		return out
	}
	s := login(0)
	defer s.conn.Close()
	var r *client
	if online {
		r = login(1)
		defer r.conn.Close()
	}
	p := make([]byte, 426)
	p[0] = 109
	copy(p[83:], accounts[1].Nickname)
	protocol.WriteUint32(p, 145, key)
	price := uint32(77)
	if vip {
		price = 61 // Native integer pricing: 77 * 80 / 100.
	}
	protocol.WriteUint32(p, 157, price)
	if err = s.game(3, 9090, p); err != nil {
		t.Fatal(err)
	}
	replies := receive(s, 1230, 9100)
	if protocol.ReadUint32(replies[0].Payload, 0) != 200-price || len(replies[1].Payload) == 0 {
		t.Fatal("gift response")
	}
	if online {
		pushed := receive(r, 1310)[0].Payload
		if len(pushed) != 339 || protocol.ReadUint32(pushed, 327) != 0 {
			t.Fatal("online unread notification missing")
		}
	} else {
		r = login(1)
		defer r.conn.Close()
	}

	if err = r.game(3, 1300, nil); err != nil {
		t.Fatal(err)
	}
	list := receive(r, 1310)[0].Payload
	if len(list) != 339 {
		t.Fatal("offline delivery missing")
	}
	mail := protocol.ReadUint32(list, 0)
	action := func(id, key uint32) {
		b := make([]byte, 12)
		protocol.WriteUint64(b, 0, uid+1)
		protocol.WriteUint32(b, 8, key)
		if e := r.game(3, id, b); e != nil {
			t.Fatal(e)
		}
	}
	action(1320, mail)
	detail := receive(r, 1330)[0].Payload
	if len(detail) != 136 {
		t.Fatal("detail length")
	}
	attachment := protocol.ReadUint32(detail, 8)
	// Send the native back-to-back claim/delete sequence without awaiting claim.
	action(2171, attachment)
	action(1340, mail)
	claimed := receive(r, 2160, 1350)
	if len(claimed[0].Payload) != 68 || protocol.ReadUint32(claimed[0].Payload, 5) != 253001 || claimed[1].Payload[0] != 1 {
		t.Fatal("claim/delete sequence")
	}
	action(2171, attachment)
	if err = r.send(tunnel.Frame{Op: "ping"}); err != nil {
		t.Fatal(err)
	}
	if f, ms, e := r.read(); e != nil || f.Op != "pong" || len(ms) != 0 {
		t.Fatal("duplicate claim emitted inventory or disconnected", e)
	}
	var count int
	if err = store.DB.QueryRow(`SELECT COUNT(*) FROM inventory WHERE uid=?`, uid+1).Scan(&count); err != nil || count != 1 {
		t.Fatal("duplicate item", err)
	}
	if vip {
		if _, err = store.DB.Exec("UPDATE inventory_expirations SET expires_at=? WHERE uid=?", time.Now().Unix()-1, uid); err != nil {
			t.Fatal(err)
		}
		hub.Mutex.Lock()
		session := hub.Sessions[uid]
		hub.Mutex.Unlock()
		if session == nil {
			t.Fatal("sender session missing")
		}
		if err = hub.RefreshExpiredInventory(session); err != nil {
			t.Fatal(err)
		}
		expiry := receive(s, 2161, 2121, 1038)
		status, e := protocol.ParseVIPStatus(expiry[2].Payload)
		if e != nil || status.Kind != 1 || status.ShopPercent != 0 {
			t.Fatal("expired sender still VIP", status, e)
		}
		// A previously valid price must not authorize a second gift after expiry.
		if err = s.game(3, 9090, p); err != nil {
			t.Fatal(err)
		}
		receive(s, 20150)
		var balance uint32
		if err = store.DB.QueryRow("SELECT tickets FROM accounts WHERE uid=?", uid).Scan(&balance); err != nil || balance != 139 {
			t.Fatal("rejected gift charged sender", balance, err)
		}
		if err = store.DB.QueryRow("SELECT COUNT(*) FROM gift_receipts WHERE uid=?", uid).Scan(&count); err != nil || count != 1 {
			t.Fatal("rejected gift created receipt", count, err)
		}
		if err = s.send(tunnel.Frame{Op: "ping"}); err != nil {
			t.Fatal(err)
		}
		if f, ms, e := s.read(); e != nil || f.Op != "pong" || len(ms) != 0 {
			t.Fatal("sender disconnected after rejection", e)
		}
	}
}
