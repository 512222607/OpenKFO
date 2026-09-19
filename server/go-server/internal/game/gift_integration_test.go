package game

import (
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

func TestGiftProtocolLocalDatabase(t *testing.T) {
	for _, mode := range []string{"offline", "online", "battle"} {
		t.Run(mode, func(t *testing.T) { testGiftProtocol(t, mode) })
	}
}
func testGiftProtocol(t *testing.T, mode string) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug DB")
	}
	store, err := persistence.Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	uid := uint64(time.Now().UnixMicro())
	accounts := make([]persistence.Account, 2)
	for i := range accounts {
		a, e := persistence.NewAccount(uid+uint64(i), fmt.Sprintf("gp%d", uid+uint64(i)), "test123456")
		if e != nil {
			t.Fatal(e)
		}
		a.Inventory = nil
		a.Tickets = 200
		a.Nickname = fmt.Sprintf("p%d", a.UID)
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
	key := uint32(uid%80000000) + 0x60000000
	catalog, grant := make([]byte, 108), make([]byte, 68)
	protocol.WriteUint32(catalog, 0, key)
	catalog[4], grant[4] = 25, 25
	protocol.WriteUint32(catalog, 5, 253001)
	protocol.WriteUint32(grant, 5, 253001)
	protocol.WriteUint32(catalog, 9, key)
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
	h := NewHub(store, Config{})
	attach := func(a persistence.Account) *Session {
		s, e := h.Attach(a, 19091)
		if e != nil {
			t.Fatal(e)
		}
		s.GameChannel = 1
		s.Channels[1] = &Channel{ID: 1, Kind: "game", Phase: "lobby", Sequence: 1}
		s.rememberInventory(nil)
		return s
	}
	s := attach(accounts[0])
	defer h.Detach(s)
	var r *Session
	if mode != "offline" {
		r = attach(accounts[1])
		defer h.Detach(r)
		if mode == "battle" {
			r.game().Phase = "battle"
		}
	}
	p := make([]byte, 426)
	p[0] = 109
	copy(p[83:], accounts[1].Nickname)
	protocol.WriteUint32(p, 145, key)
	protocol.WriteUint32(p, 157, 77)
	for i := 0; i < 2; i++ {
		if err = h.route(s, s.game(), protocol.Message{ID: 9090, Payload: p}); err != nil {
			t.Fatal(err)
		}
		if r != nil {
			if mode == "online" && i == 0 {
				messages := roomOutputs(t, r, 1310)
				if len(messages[0].Payload) != 339 || protocol.ReadUint32(messages[0].Payload, 327) != 0 {
					t.Fatal("missing unread notification")
				}
			} else {
				roomOutputs(t, r)
			}
		}
		out := roomOutputs(t, s, 1230, 9100)
		if protocol.ReadUint32(out[0].Payload, 0) != 123 || len(out[1].Payload) == 0 {
			t.Fatal("delivery response")
		}
	}
	if r == nil {
		r = attach(accounts[1])
		defer h.Detach(r)
	}
	if mode == "battle" {
		if !r.MailDirty {
			t.Fatal("battle notification lost")
		}
		if err = h.RefreshExpiredInventory(r); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, r)
		r.game().Phase = "lobby"
		if err = h.RefreshExpiredInventory(r); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, r, 1310)
		if r.MailDirty {
			t.Fatal("notification not cleared")
		}
		if err = h.RefreshExpiredInventory(r); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, r)
	}
	if err = h.route(r, r.game(), protocol.Message{ID: 1300}); err != nil {
		t.Fatal(err)
	}
	list := roomOutputs(t, r, 1310)[0].Payload
	if len(list) != 339 {
		t.Fatal("duplicate/missing mail", len(list))
	}
	mail := protocol.ReadUint32(list, 0)
	action := func(op, key uint32) {
		b := make([]byte, 12)
		protocol.WriteUint64(b, 0, r.UID)
		protocol.WriteUint32(b, 8, key)
		if e := h.route(r, r.game(), protocol.Message{ID: op, Payload: b}); e != nil {
			t.Fatal(e)
		}
	}
	action(1320, mail)
	detail := roomOutputs(t, r, 1330)[0].Payload
	attachment := protocol.ReadUint32(detail, 8)
	action(2171, attachment)
	item := roomOutputs(t, r, 2160)[0].Payload
	if len(item) != 68 || protocol.ReadUint32(item, 5) != 253001 {
		t.Fatal("wrong attachment")
	}
	action(2171, attachment)
	roomOutputs(t, r)
	action(1340, mail)
	if roomOutputs(t, r, 1350)[0].Payload[0] != 1 {
		t.Fatal("delete failed")
	}
	var balance, count uint32
	if err = store.DB.QueryRow(`SELECT tickets FROM accounts WHERE uid=?`, s.UID).Scan(&balance); err != nil || balance != 123 {
		t.Fatal("duplicate debit", err)
	}
	if err = store.DB.QueryRow(`SELECT COUNT(*) FROM inventory WHERE uid=?`, r.UID).Scan(&count); err != nil || count != 1 {
		t.Fatal("duplicate grant", err)
	}
}
