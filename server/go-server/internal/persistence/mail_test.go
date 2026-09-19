package persistence

import (
	"database/sql"
	"fmt"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"sync"
	"testing"
	"time"
)

func TestMailboxLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent test database required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug database")
	}
	s, err := Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer s.DB.Close()
	uid := uint64(time.Now().UnixMilli())
	a, err := NewAccount(uid, fmt.Sprintf("ml%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	a.Inventory = nil
	if err = s.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		if _, err := s.DB.Exec(`DELETE FROM inventory WHERE uid=?`, uid); err != nil {
			t.Error(err)
		}
		if _, err := s.DB.Exec(`DELETE FROM accounts WHERE uid=?`, uid); err != nil {
			t.Error(err)
		}
	}()
	r, _ := (protocol.MailRecord{ID: 1, Title: "gift", Sender: "tester", Body: "hello", AttachmentKey: 91}).Encode()
	d, _ := (protocol.MailDetail{MailKey: 1, AttachmentKey: 91, Gold: 20}).Encode()
	result, err := s.DB.Exec(`INSERT INTO mailbox(uid,list_record,detail_record) VALUES(?,?,?)`, uid, r, d)
	if err != nil {
		t.Fatal(err)
	}
	id64, err := result.LastInsertId()
	if err != nil {
		t.Fatal(err)
	}
	id := uint32(id64)
	p, err := s.MailManager().Mailbox(uid)
	if err != nil || len(p) != 339 || protocol.ReadUint32(p, 0) != id || protocol.ReadUint32(p, 327) != 0 {
		t.Fatal("list", err)
	}
	if p, err := s.MailManager().Mailbox(uid + 1); err != nil || len(p) != 0 {
		t.Fatal("foreign inbox", err)
	}
	if _, err := s.MailManager().ReadMail(uid+1, id); err != sql.ErrNoRows {
		t.Fatal("foreign read", err)
	}
	if err := s.MailManager().DeleteMail(uid+1, id); err != ErrDenied {
		t.Fatal("foreign delete", err)
	}
	for i := 0; i < 2; i++ {
		p, err = s.MailManager().ReadMail(uid, id)
		if err != nil || len(p) != 136 || protocol.ReadUint32(p, 0) != id || protocol.ReadUint32(p, 4) != 1 || protocol.ReadUint32(p, 8) != 91 {
			t.Fatal("detail", err)
		}
	}
	var gold uint32
	var claimed bool
	if err = s.DB.QueryRow(`SELECT gold FROM accounts WHERE uid=?`, uid).Scan(&gold); err != nil || gold != a.Gold {
		t.Fatal("preview grants money", err)
	}
	if err = s.DB.QueryRow(`SELECT claimed FROM mailbox WHERE id=?`, id).Scan(&claimed); err != nil || claimed {
		t.Fatal("preview claims attachment", err)
	}
	p, err = s.MailManager().Mailbox(uid)
	if err != nil || protocol.ReadUint32(p, 327) != 1 {
		t.Fatal("read flag", err)
	}
	for i := 0; i < 2; i++ {
		if err = s.MailManager().DeleteMail(uid, id); err != nil {
			t.Fatal(err)
		}
	}
	if p, err = s.MailManager().Mailbox(uid); err != nil || len(p) != 0 {
		t.Fatal("deleted visible", err)
	}
	if _, err = s.MailManager().ReadMail(uid, id); err != sql.ErrNoRows {
		t.Fatal("deleted readable", err)
	}
	var count int
	if err = s.DB.QueryRow(`SELECT COUNT(*) FROM mailbox WHERE id=? AND deleted=TRUE`, id).Scan(&count); err != nil || count != 1 {
		t.Fatal("tombstone lost", err)
	}
	createAttachment := func() (uint32, uint32) {
		result, e := s.DB.Exec(`INSERT INTO mailbox(uid,list_record,detail_record) VALUES(?,?,?)`, uid, r, d)
		if e != nil {
			t.Fatal(e)
		}
		mail, e := result.LastInsertId()
		if e != nil {
			t.Fatal(e)
		}
		item := make([]byte, 68)
		item[4] = 25
		item[5] = 42
		result, e = s.DB.Exec(`INSERT INTO mail_attachments(mail_id,uid,grant_record,expiry_days) VALUES(?,?,?,?)`, mail, uid, item, 3)
		if e != nil {
			t.Fatal(e)
		}
		key, e := result.LastInsertId()
		if e != nil {
			t.Fatal(e)
		}
		return uint32(mail), uint32(key)
	}
	mail, key := createAttachment()
	if _, e := s.MailManager().ClaimMailItem(uid+1, key); e == nil {
		t.Fatal("foreign claim")
	}
	var wg sync.WaitGroup
	results := make(chan []byte, 2)
	failures := make(chan error, 2)
	for i := 0; i < 2; i++ {
		wg.Add(1)
		go func() { defer wg.Done(); p, e := s.MailManager().ClaimMailItem(uid, key); results <- p; failures <- e }()
	}
	wg.Wait()
	close(results)
	close(failures)
	for e := range failures {
		if e != nil {
			t.Fatal(e)
		}
	}
	var instance uint32
	for p := range results {
		if len(p) != 68 {
			t.Fatal("claim returned no item")
		}
		current := protocol.ReadUint32(p, 0)
		if instance != 0 && current != instance {
			t.Fatal("concurrent duplicate grant")
		}
		instance = current
	}
	if err = s.DB.QueryRow(`SELECT COUNT(*) FROM inventory WHERE uid=?`, uid).Scan(&count); err != nil || count != 1 {
		t.Fatal("duplicate inventory", err)
	}
	var deadline int64
	if err = s.DB.QueryRow(`SELECT expires_at FROM inventory_expirations WHERE uid=? AND instance=?`, uid, instance).Scan(&deadline); err != nil || deadline < time.Now().Unix()+2*86400 {
		t.Fatal("missing claim expiry", err)
	}
	if err = s.MailManager().DeleteMail(uid, mail); err != nil {
		t.Fatal(err)
	}
	if _, err = s.MailManager().ClaimMailItem(uid, key); err != nil {
		t.Fatal("claimed replay after delete", err)
	}
	if _, err = s.DB.Exec(`DELETE FROM inventory WHERE uid=? AND instance=?`, uid, instance); err != nil {
		t.Fatal(err)
	}
	if p, err = s.MailManager().ClaimMailItem(uid, key); err != nil || len(p) != 0 {
		t.Fatal("retry resurrected item", err)
	}
	mail, key = createAttachment()
	if err = s.MailManager().DeleteMail(uid, mail); err != nil {
		t.Fatal(err)
	}
	if _, err = s.MailManager().ClaimMailItem(uid, key); err != ErrDenied {
		t.Fatal("unclaimed deleted mail granted", err)
	}
}
