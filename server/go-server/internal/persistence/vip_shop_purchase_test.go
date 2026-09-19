package persistence

import (
	"database/sql"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
	"time"
)

func TestVIPShopPurchaseLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("not independent debug DB")
	}
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()
	db.SetMaxOpenConns(1)
	db.SetMaxIdleConns(1)
	exec := func(q string, args ...any) {
		t.Helper()
		if _, e := db.Exec(q, args...); e != nil {
			t.Fatal(e)
		}
	}
	for _, ddl := range []string{
		`CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,account VARCHAR(64),nickname VARCHAR(64),profile BLOB,salt BLOB,digest BLOB,legacy_salt BLOB,legacy_digest BLOB,gold INT UNSIGNED,tickets INT UNSIGNED) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE inventory(uid BIGINT,instance INT UNSIGNED,record BLOB,PRIMARY KEY(uid,instance)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE inventory_expirations(uid BIGINT,instance INT UNSIGNED,expires_at BIGINT,PRIMARY KEY(uid,instance)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE offers(catalog_key INT PRIMARY KEY,category INT,variant INT,record BLOB,grant_record BLOB,enabled BOOL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE offer_lifetimes(catalog_key INT PRIMARY KEY,days INT UNSIGNED) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE purchases(uid BIGINT,operation_id VARCHAR(128),request_hash BINARY(32),balance INT UNSIGNED,item_record BLOB,catalog_record BLOB,PRIMARY KEY(uid,operation_id)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE mailbox(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,uid BIGINT,list_record BLOB,detail_record BLOB,deleted BOOL DEFAULT FALSE) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE mail_attachments(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,mail_id INT UNSIGNED,uid BIGINT,grant_record BLOB,expiry_days INT UNSIGNED) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE gift_receipts(uid BIGINT,operation_id VARCHAR(128),request_hash BINARY(32),recipient BIGINT,mail_id INT UNSIGNED,cost INT UNSIGNED,PRIMARY KEY(uid,operation_id)) ENGINE=InnoDB`,
	} {
		exec(ddl)
	}
	exec(`CREATE TEMPORARY TABLE vip_shop_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED,rules MEDIUMBLOB) ENGINE=InnoDB`)
	exec(`INSERT INTO vip_shop_rules VALUES(1,1,'{"enabled":true,"silver":90,"gold":80,"platinum":70}')`)
	s := &Store{DB: db}
	for _, uid := range []uint64{1, 2} {
		name := "vipbuyer"
		if uid == 2 {
			name = "viprecipient"
		}
		a, e := NewAccount(uid, name, "test123456")
		if e != nil {
			t.Fatal(e)
		}
		a.Nickname = name
		a.Inventory = nil
		a.Gold = 1000
		a.Tickets = 1000
		if e = s.Create(a); e != nil {
			t.Fatal(e)
		}
	}
	card := make([]byte, 68)
	card[4] = 73
	protocol.WriteUint32(card, 0, 7)
	protocol.WriteUint32(card, 5, 730002)
	protocol.WriteUint32(card, 19, 1)
	exec("INSERT INTO inventory VALUES(1,7,?)", card)
	exec("INSERT INTO inventory_expirations VALUES(1,7,?)", time.Now().Unix()+3600)
	o := adminFixtureOffer(7)
	o.Record[48] = 1
	protocol.WriteUint32(o.Record, 0, 7)
	protocol.WriteUint32(o.Record, 9, 7)
	exec("INSERT INTO offers(catalog_key,category,variant,record,grant_record,enabled) VALUES(7,0,0,?,?,TRUE)", o.Record, o.Grant)
	p := make([]byte, 169)
	protocol.WriteUint32(p, 0, 109)
	protocol.WriteUint64(p, 4, 1)
	protocol.WriteUint64(p, 54, 1)
	protocol.WriteUint32(p, 145, 7)
	if rate, e := s.ShopManager().VIPShopPercent(1); e != nil || rate != 80 {
		t.Fatal(rate, e)
	}
	if rate, e := s.ShopManager().VIPShopPercent(2); e != nil || rate != 0 {
		t.Fatal("nonmember", rate, e)
	}
	protocol.WriteUint32(p, 157, 1)
	if _, _, _, e := s.ShopManager().Purchase(1, "forged", p); e == nil {
		t.Fatal("forged price accepted")
	}
	protocol.WriteUint32(p, 157, 61)
	if balance, _, _, e := s.ShopManager().Purchase(1, "first", p); e != nil || balance != 939 {
		t.Fatal("VIP purchase", balance, e)
	}
	exec(`UPDATE vip_shop_rules SET revision=2,rules='{"enabled":true,"silver":90,"gold":50,"platinum":70}'`)
	if balance, _, _, e := s.ShopManager().Purchase(1, "first", p); e != nil || balance != 939 {
		t.Fatal("replay after price change", balance, e)
	}
	if _, _, _, e := s.ShopManager().Purchase(1, "stale", p); e == nil {
		t.Fatal("stale price accepted")
	}
	protocol.WriteUint32(p, 157, 38)
	if balance, _, _, e := s.ShopManager().Purchase(1, "second", p); e != nil || balance != 901 {
		t.Fatal("updated VIP purchase", balance, e)
	}
	exec("UPDATE inventory_expirations SET expires_at=? WHERE uid=1 AND instance=7", time.Now().Unix()-1)
	if rate, e := s.ShopManager().VIPShopPercent(1); e != nil || rate != 0 {
		t.Fatal("expired membership", rate, e)
	}
	if _, _, _, e := s.ShopManager().Purchase(1, "expired", p); e == nil {
		t.Fatal("expired VIP discount")
	}
	protocol.WriteUint32(p, 157, 77)
	if balance, _, _, e := s.ShopManager().Purchase(1, "third", p); e != nil || balance != 824 {
		t.Fatal("normal purchase", balance, e)
	}
	exec("UPDATE inventory_expirations SET expires_at=? WHERE uid=1 AND instance=7", time.Now().Unix()+3600)
	exec(`UPDATE vip_shop_rules SET rules='{"enabled":true,"silver":90,"gold":80,"platinum":70}'`)
	gift := make([]byte, 426)
	gift[0] = 109
	copy(gift[83:], "viprecipient")
	copy(gift[170:], "VIP gift")
	protocol.WriteUint32(gift, 145, 7)
	protocol.WriteUint32(gift, 157, 61)
	gr, e := s.MailManager().Gift(1, "gift", gift)
	if e != nil || gr.Balance != 763 || !gr.Created {
		t.Fatal("VIP gift", gr, e)
	}
	exec("UPDATE inventory_expirations SET expires_at=? WHERE uid=1 AND instance=7", time.Now().Unix()-1)
	if gr, e = s.MailManager().Gift(1, "gift", gift); e != nil || gr.Balance != 763 || gr.Created {
		t.Fatal("gift replay", gr, e)
	}
	if _, e = s.MailManager().Gift(1, "expired-gift", gift); e == nil {
		t.Fatal("expired gift discount")
	}
	protocol.WriteUint32(gift, 157, 77)
	if gr, e = s.MailManager().Gift(1, "normal-gift", gift); e != nil || gr.Balance != 686 {
		t.Fatal("normal gift", gr, e)
	}
	var purchases, mail int
	if e = db.QueryRow("SELECT COUNT(*) FROM purchases").Scan(&purchases); e != nil || purchases != 3 {
		t.Fatal(purchases, e)
	}
	if e = db.QueryRow("SELECT COUNT(*) FROM mailbox").Scan(&mail); e != nil || mail != 2 {
		t.Fatal(mail, e)
	}
	protocol.WriteUint32(o.Record, 30, 100)
	protocol.WriteUint32(o.Record, 34, 100)
	protocol.WriteUint32(o.Record, 38, 0)
	protocol.WriteUint32(o.Record, 42, 0)
	exec("UPDATE offers SET record=? WHERE catalog_key=7", o.Record)
	protocol.WriteUint32(p, 0, 111)
	protocol.WriteUint32(p, 149, 100)
	protocol.WriteUint32(p, 157, 0)
	if balance, _, _, e := s.ShopManager().Purchase(1, "gold", p); e != nil || balance != 900 {
		t.Fatal("gold purchase", balance, e)
	}
	exec("UPDATE inventory_expirations SET expires_at=? WHERE uid=1 AND instance=7", time.Now().Unix()+3600)
	protocol.WriteUint32(p, 149, 80)
	if balance, _, _, e := s.ShopManager().Purchase(1, "vip-gold", p); e != nil || balance != 820 {
		t.Fatal("VIP gold", balance, e)
	}
}
