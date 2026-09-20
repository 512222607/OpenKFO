package game

import (
	"fmt"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
	"time"
)

func TestMailClaimProtocolLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent database required")
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
	a, e := persistence.NewAccountWithStarterCharacter(uid, fmt.Sprintf("mc%d", uid), "test123456")
	if e != nil {
		t.Fatal(e)
	}
	a.Inventory = nil
	if e = store.Create(a); e != nil {
		t.Fatal(e)
	}
	defer func() {
		for _, table := range []string{"inventory", "accounts"} {
			if _, e := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); e != nil {
				t.Error(e)
			}
		}
	}()
	h := NewHub(store, Config{})
	s, e := h.Attach(a, 19091)
	if e != nil {
		t.Fatal(e)
	}
	defer h.Detach(s)
	s.GameChannel = 1
	s.Channels[1] = &Channel{ID: 1, Kind: "game", Phase: "lobby"}
	s.rememberInventory(nil)
	send := func(op, key uint32) {
		p := make([]byte, 12)
		protocol.WriteUint64(p, 0, uid)
		protocol.WriteUint32(p, 8, key)
		if e := h.route(s, s.game(), protocol.Message{ID: op, Payload: p}); e != nil {
			t.Fatal(e)
		}
	}
	for _, valid := range []bool{true, false} {
		r, _ := (protocol.MailRecord{ID: 1, Title: "test", Sender: "tester"}).Encode()
		d, _ := (protocol.MailDetail{MailKey: 1}).Encode()
		result, e := store.DB.Exec(`INSERT INTO mailbox(uid,list_record,detail_record) VALUES(?,?,?)`, uid, r, d)
		if e != nil {
			t.Fatal(e)
		}
		m, e := result.LastInsertId()
		if e != nil {
			t.Fatal(e)
		}
		item := make([]byte, 68)
		item[4] = 25
		item[5] = 42
		if !valid {
			item = item[:67]
		}
		result, e = store.DB.Exec(`INSERT INTO mail_attachments(mail_id,uid,grant_record) VALUES(?,?,?)`, m, uid, item)
		if e != nil {
			t.Fatal(e)
		}
		key, e := result.LastInsertId()
		if e != nil {
			t.Fatal(e)
		}
		protocol.WriteUint32(d, 8, uint32(key))
		if _, e = store.DB.Exec(`UPDATE mailbox SET detail_record=? WHERE id=?`, d, m); e != nil {
			t.Fatal(e)
		}
		send(1320, uint32(m))
		roomOutputs(t, s, 1330)
		send(2171, uint32(key))
		if valid {
			roomOutputs(t, s, 2160)
			send(2171, uint32(key))
			roomOutputs(t, s)
		} else {
			roomOutputs(t, s, 20150)
		}
		send(1340, uint32(m))
		r = roomOutputs(t, s, 1350)[0].Payload
		if (r[0] != 0) != valid {
			t.Fatal("automatic delete did not match claim result")
		}
		var deleted bool
		if e = store.DB.QueryRow(`SELECT deleted FROM mailbox WHERE id=?`, m).Scan(&deleted); e != nil || deleted != valid {
			t.Fatal("mail retention", e)
		}
		if !valid {
			send(1340, uint32(m))
			if roomOutputs(t, s, 1350)[0].Payload[0] != 1 {
				t.Fatal("later explicit delete blocked")
			}
		}
	}
	var count int
	if e = store.DB.QueryRow(`SELECT COUNT(*) FROM inventory WHERE uid=?`, uid).Scan(&count); e != nil || count != 1 {
		t.Fatal("wrong inventory count", e)
	}
}
