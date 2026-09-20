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

func TestVIPTLS(t *testing.T) {
	testVIPTLS(t, false)
}

func TestVIPShopTLS(t *testing.T) {
	testVIPTLS(t, true)
}

func testVIPTLS(t *testing.T, discount bool) {
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
	exec(`CREATE TEMPORARY TABLE vip_shop_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED,rules MEDIUMBLOB) ENGINE=InnoDB`)
	if discount {
		exec(`INSERT INTO vip_shop_rules VALUES(1,1,'{"enabled":true,"silver":90,"gold":80,"platinum":70}')`)
		exec(`CREATE TEMPORARY TABLE offers(catalog_key INT PRIMARY KEY,category INT,variant INT,record BLOB,grant_record BLOB,enabled BOOL) ENGINE=InnoDB`)
		exec(`CREATE TEMPORARY TABLE offer_lifetimes(catalog_key INT PRIMARY KEY,days INT UNSIGNED) ENGINE=InnoDB`)
		exec(`CREATE TEMPORARY TABLE purchases(uid BIGINT,operation_id VARCHAR(128),request_hash BINARY(32),balance INT UNSIGNED,item_record BLOB,catalog_record BLOB,PRIMARY KEY(uid,operation_id)) ENGINE=InnoDB`)
		catalog, item := make([]byte, 108), make([]byte, 68)
		catalog[4], item[4] = 25, 25
		catalog[48], catalog[83] = 1, 1
		protocol.WriteUint32(catalog, 5, 250001)
		protocol.WriteUint32(catalog, 9, 7)
		protocol.WriteUint32(catalog, 38, 101)
		protocol.WriteUint32(catalog, 42, 101)
		protocol.WriteUint32(item, 5, 250001)
		protocol.WriteUint32(item, 13, 8760)
		exec("INSERT INTO offers VALUES(7,0,0,?,?,TRUE)", catalog, item)
	}
	uid := uint64(time.Now().UnixMicro())
	a, err := persistence.NewAccountWithStarterCharacter(uid, fmt.Sprintf("vt%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	a.Inventory = nil
	a.Tickets = 1000
	if err = store.Create(a); err != nil {
		t.Fatal(err)
	}
	op := fmt.Sprintf("vip-tls-%d", uid)
	defer func() {
		if _, e := store.DB.Exec("DELETE FROM desktop_admin_operations WHERE id=?", op); e != nil {
			t.Error(e)
		}
		for _, table := range []string{"inventory", "accounts"} {
			if _, e := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); e != nil {
				t.Error(e)
			}
		}
	}()
	end := time.Now().Unix() + 3600
	request := persistence.AdminRequest{Operation: "vip_grant", ID: op, UID: uid, VIPKind: 4, ExpiresAt: &end}
	if _, err = store.Admin(request); err != nil {
		t.Fatal(err)
	}
	if _, err = store.Admin(request); err != nil {
		t.Fatal(err)
	}
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
	extraItems := 0
	login := func(want uint32) *client {
		t.Helper()
		var loginKind, statusKind uint32
		items := 0
		c, e := connectObserved(command{Config: config, Account: a.Account, Password: "test123456"}, func(m protocol.Message) {
			switch m.ID {
			case 1020:
				if len(m.Payload) >= 37 {
					loginKind = protocol.ReadUint32(m.Payload, 33)
				}
			case 1038:
				r, e := protocol.ParseVIPStatus(m.Payload)
				if e != nil {
					t.Error(e)
					return
				}
				statusKind = r.Kind
				wantPercent := uint32(0)
				if discount && want == 4 {
					wantPercent = 70
				}
				if r.ShopPercent != wantPercent {
					t.Error("incorrect VIP discount", r.ShopPercent, wantPercent)
				}
			case 1120:
				if len(m.Payload) != 68*(1+extraItems) {
					t.Errorf("duplicate or missing card: %d bytes", len(m.Payload))
					return
				}
				var card []byte
				for off := 0; off < len(m.Payload); off += 68 {
					if protocol.ReadUint32(m.Payload, off+5) == 730003 {
						items++
						card = m.Payload[off : off+68]
					}
				}
				if len(card) != 68 {
					t.Error("missing card")
					return
				}
				if want == 4 && (protocol.ReadUint32(card, 13) > 60 || protocol.ReadUint32(card, 13) == 0) {
					t.Error("wrong remaining minutes")
				}
				if want == 1 && protocol.ReadUint32(card, 19) != 2 {
					t.Error("expired card still active")
				}
			}
		})
		if e != nil {
			t.Fatal(e)
		}
		c.observe = nil
		if loginKind != want || statusKind != want || items != 1 {
			c.conn.Close()
			t.Fatalf("bootstrap type=%d status=%d inventories=%d want=%d", loginKind, statusKind, items, want)
		}
		if e = c.send(tunnel.Frame{Op: "ping"}); e != nil {
			t.Fatal(e)
		}
		f, _, e := c.read()
		if e != nil || f.Op != "pong" {
			t.Fatal("login incomplete", e)
		}
		return c
	}
	c := login(4)
	defer c.conn.Close()
	expectedRate := uint32(70)
	buy := func(price, balance uint32, ids ...uint32) {
		t.Helper()
		p := make([]byte, 169)
		protocol.WriteUint32(p, 0, 109)
		protocol.WriteUint64(p, 4, uid)
		protocol.WriteUint64(p, 54, uid)
		protocol.WriteUint32(p, 145, 7)
		protocol.WriteUint32(p, 157, price)
		if e := c.game(3, 9040, p); e != nil {
			t.Fatal(e)
		}
		if e := c.send(tunnel.Frame{Op: "ping"}); e != nil {
			t.Fatal(e)
		}
		var replies []protocol.Message
		for {
			f, ms, e := c.read()
			if e != nil {
				t.Fatal(e)
			}
			replies = append(replies, ms...)
			if f.Op == "pong" {
				break
			}
		}
		if len(replies) != len(ids) {
			t.Fatal("purchase response count", replies, ids)
		}
		for i, id := range ids {
			if replies[i].ID != id {
				t.Fatal("purchase response", replies, ids)
			}
			if id == 1230 && protocol.ReadUint32(replies[i].Payload, 0) != balance {
				t.Fatal("purchase balance")
			}
			if id == 1038 {
				status, e := protocol.ParseVIPStatus(replies[i].Payload)
				if e != nil || status.ShopPercent != expectedRate {
					t.Fatal("stale VIP percentage", status, e)
				}
			}
		}
		var saved uint32
		if e := store.DB.QueryRow("SELECT tickets FROM accounts WHERE uid=?", uid).Scan(&saved); e != nil || saved != balance {
			t.Fatal("persisted balance", saved, e)
		}
	}
	if discount {
		buy(70, 930, 1230, 2160, 9050)
		extraItems++
		exec(`UPDATE vip_shop_rules SET revision=2,rules='{"enabled":true,"silver":90,"gold":80,"platinum":50}'`)
		expectedRate = 50
		buy(70, 930, 1038, 9060)
		buy(50, 880, 1230, 2160, 9050)
		extraItems++
	}
	if _, err = store.DB.Exec("UPDATE inventory_expirations SET expires_at=? WHERE uid=?", time.Now().Unix()-1, uid); err != nil {
		t.Fatal(err)
	}
	hub.Mutex.Lock()
	s := hub.Sessions[uid]
	hub.Mutex.Unlock()
	if s == nil {
		t.Fatal("missing authenticated session")
	}
	if err = hub.RefreshExpiredInventory(s); err != nil {
		t.Fatal(err)
	}
	wantIDs := []uint32{2161, 2121, 1038}
	var replies []protocol.Message
	for len(replies) < len(wantIDs) {
		f, ms, e := c.read()
		if e != nil {
			t.Fatal(e)
		}
		if f.Channel != 3 {
			t.Fatal("wrong expiry channel", f.Channel)
		}
		replies = append(replies, ms...)
	}
	if len(replies) != len(wantIDs) {
		t.Fatal("extra expiry replies")
	}
	for i, id := range wantIDs {
		if replies[i].ID != id {
			t.Fatalf("expiry message %d got %d want %d", i, replies[i].ID, id)
		}
	}
	if protocol.ReadUint32(replies[2].Payload, 0) != 1 || protocol.ReadUint32(replies[2].Payload, 20) != 0 {
		t.Fatal("VIP did not downgrade")
	}
	if err = c.send(tunnel.Frame{Op: "ping"}); err != nil {
		t.Fatal(err)
	}
	if f, _, e := c.read(); e != nil || f.Op != "pong" {
		t.Fatal("disconnected after expiry", e)
	}
	// Finish the asynchronous inventory-expiry stream before asserting the
	// purchase-only stream. Expiry itself must deliver type 1 / percent 0.
	if discount {
		expectedRate = 0
		buy(50, 880, 9060)
		buy(101, 779, 1230, 2160, 9050)
		extraItems++
	}
	c.conn.Close()
	for n := 0; n < 100; n++ {
		hub.Mutex.Lock()
		online := hub.Sessions[uid] != nil
		hub.Mutex.Unlock()
		if !online {
			break
		}
		time.Sleep(10 * time.Millisecond)
	}
	r := login(1)
	defer r.conn.Close()
	if discount {
		var count int
		if e := store.DB.QueryRow("SELECT COUNT(*) FROM purchases WHERE uid=?", uid).Scan(&count); e != nil || count != 3 {
			t.Fatal("unexpected purchase receipts", count, e)
		}
	}
}
