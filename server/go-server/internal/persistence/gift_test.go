package persistence

import (
	"bytes"
	"fmt"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"sync"
	"testing"
	"time"
)

func TestGiftLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, e := mysql.ParseDSN(dsn)
	if e != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug DB")
	}
	s, e := Open(dsn)
	if e != nil {
		t.Fatal(e)
	}
	defer s.DB.Close()
	uid := uint64(time.Now().UnixMicro())
	for i := uint64(0); i < 2; i++ {
		a, e := NewAccount(uid+i, fmt.Sprintf("gt%d", uid+i), "test123456")
		if e != nil {
			t.Fatal(e)
		}
		a.Inventory = nil
		a.Tickets = 500
		a.Nickname = fmt.Sprintf("g%d", uid+i)
		if e = s.Create(a); e != nil {
			t.Fatal(e)
		}
		id := uid + i
		defer func() {
			for _, table := range []string{"gift_receipts", "inventory", "accounts"} {
				if _, e := s.DB.Exec("DELETE FROM "+table+" WHERE uid=?", id); e != nil {
					t.Error(e)
				}
			}
		}()
	}
	o := adminFixtureOffer(uint32(uid%80000000) + 10000000)
	o.Record[48] = 1
	if _, e = s.DB.Exec(`INSERT INTO offers(catalog_key,category,variant,record,grant_record,enabled) VALUES(?,?,?,?,?,TRUE)`, o.Key, o.Category, o.Variant, o.Record, o.Grant); e != nil {
		t.Fatal(e)
	}
	defer func() {
		if _, e := s.DB.Exec(`DELETE FROM offers WHERE catalog_key=?`, o.Key); e != nil {
			t.Error(e)
		}
	}()
	p := make([]byte, 426)
	p[0] = 109
	copy(p[83:], fmt.Sprintf("g%d", uid+1))
	copy(p[170:], "hello")
	protocol.WriteUint32(p, 145, o.Key)
	protocol.WriteUint32(p, 157, 77)
	var wg sync.WaitGroup
	results := make(chan GiftResult, 2)
	errs := make(chan error, 2)
	for i := 0; i < 2; i++ {
		wg.Add(1)
		go func() { defer wg.Done(); r, e := s.MailManager().Gift(uid, "same", p); results <- r; errs <- e }()
	}
	wg.Wait()
	close(results)
	close(errs)
	for e := range errs {
		if e != nil {
			t.Fatal(e)
		}
	}
	var mail uint32
	for r := range results {
		if r.Balance != 423 || r.Recipient != uid+1 || (mail != 0 && mail != r.MailID) {
			t.Fatal("bad duplicate receipt", r)
		}
		mail = r.MailID
	}
	for _, mutate := range []func([]byte){func(p []byte) { protocol.WriteUint32(p, 157, 1) }, func(p []byte) { protocol.WriteUint64(p, 54, uid) }, func(p []byte) { copy(p[83:104], make([]byte, 21)); copy(p[83:], fmt.Sprintf("g%d", uid)) }, func(p []byte) { p[169] = 1 }, func(p []byte) { copy(p[170:], bytes.Repeat([]byte{'a'}, 201)) }} {
		bad := bytes.Clone(p)
		mutate(bad)
		if _, e = s.MailManager().Gift(uid, "bad", bad); e == nil {
			t.Fatal("invalid gift accepted")
		}
	}
	var balance, count uint32
	if e = s.DB.QueryRow(`SELECT tickets FROM accounts WHERE uid=?`, uid).Scan(&balance); e != nil || balance != 423 {
		t.Fatal("bad debit", e)
	}
	if e = s.DB.QueryRow(`SELECT COUNT(*) FROM mailbox WHERE uid=?`, uid+1).Scan(&count); e != nil || count != 1 {
		t.Fatal("duplicate delivery", e)
	}
	detail, e := s.MailManager().ReadMail(uid+1, mail)
	if e != nil {
		t.Fatal(e)
	}
	if !bytes.Equal(detail[28:], o.Record) {
		t.Fatal("wrong gift catalog")
	}
	key := protocol.ReadUint32(detail, 8)
	item, e := s.MailManager().ClaimMailItem(uid+1, key)
	if e != nil || len(item) != 68 || protocol.ReadUint32(item, 5) != protocol.ReadUint32(o.Grant, 5) {
		t.Fatal("gift claim", e)
	}
	if e = s.MailManager().DeleteMail(uid+1, mail); e != nil {
		t.Fatal(e)
	}
	if _, e = s.MailManager().Gift(uid, "same", p); e != nil {
		t.Fatal("retry after claim/delete", e)
	}
	if e = s.DB.QueryRow(`SELECT COUNT(*) FROM mailbox WHERE uid=?`, uid+1).Scan(&count); e != nil || count != 1 {
		t.Fatal("recreated mail", e)
	}
	if e = s.DB.QueryRow(`SELECT COUNT(*) FROM inventory WHERE uid=?`, uid+1).Scan(&count); e != nil || count != 1 {
		t.Fatal("duplicate gift item", e)
	}
}
