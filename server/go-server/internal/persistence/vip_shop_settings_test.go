package persistence

import (
	"database/sql"
	"github.com/go-sql-driver/mysql"
	"os"
	"strings"
	"testing"
)

func TestVIPShopPricing(t *testing.T) {
	if _, err := (&Store{}).Admin(AdminRequest{Operation: "vip_shop_settings_save"}); err == nil {
		t.Fatal("missing policy accepted")
	}
	for _, c := range []struct {
		base, rate, want uint32
		deny             bool
	}{
		{100, 80, 80, false}, {101, 80, 80, false}, {199, 75, 149, false},
		{100, 0, 100, false}, {0, 80, 0, false}, {100, 100, 100, false},
		{1, 80, 0, true}, {100, 101, 0, true}, {0x80000000, 0, 0, true},
		{21474836, 100, 21474836, false}, {21474837, 100, 0, true},
		{0x7fffffff, 0, 0x7fffffff, false},
	} {
		got, err := vipShopPrice(c.base, c.rate)
		if (err != nil) != c.deny || (!c.deny && got != c.want) {
			t.Fatal(c, got, err)
		}
	}
	r := VIPShopRules{Enabled: true, Silver: 90, Gold: 80, Platinum: 70}
	for k, want := range []uint32{0, 0, 90, 80, 70, 0} {
		if r.Percent(uint32(k)) != want {
			t.Fatal(k)
		}
	}
	r.Enabled = false
	if r.Percent(4) != 0 || r.Platinum != 70 {
		t.Fatal("disabled policy lost values")
	}
	r.Gold = 101
	if (VIPShopSettings{Rules: r}).Validate() == nil {
		t.Fatal("invalid disabled configuration")
	}
}

func TestVIPShopSettingsLocalDatabase(t *testing.T) {
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
	exec := func(q string) {
		t.Helper()
		if _, e := db.Exec(q); e != nil {
			t.Fatal(e)
		}
	}
	exec(`CREATE TEMPORARY TABLE vip_shop_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE vip_shop_rules_audit(revision BIGINT UNSIGNED PRIMARY KEY,before_data MEDIUMBLOB NOT NULL,after_data MEDIUMBLOB NOT NULL) ENGINE=InnoDB`)
	s := &Store{DB: db}
	a, err := s.VIPShopSettings()
	if err != nil || a.Revision != 0 || a.Rules.Enabled {
		t.Fatal(a, err)
	}
	a.Rules = VIPShopRules{Enabled: true, Silver: 90, Gold: 80, Platinum: 70}
	saved, err := s.SaveVIPShopSettings(a)
	if err != nil || saved.Revision != 1 {
		t.Fatal(saved, err)
	}
	if _, err = s.SaveVIPShopSettings(a); err == nil {
		t.Fatal("stale write")
	}
	exec(`INSERT INTO vip_shop_rules_audit VALUES(2,'{}','{}')`)
	saved.Rules.Enabled = false
	if _, err = s.SaveVIPShopSettings(saved); err == nil {
		t.Fatal("audit error ignored")
	}
	got, err := s.VIPShopSettings()
	if err != nil || got.Revision != 1 || !got.Rules.Enabled {
		t.Fatal("rollback", got, err)
	}
	exec(`DELETE FROM vip_shop_rules_audit WHERE revision=2`)
	saved, err = s.SaveVIPShopSettings(saved)
	if err != nil || saved.Revision != 2 || saved.Rules.Enabled || saved.Rules.Gold != 80 {
		t.Fatal(saved, err)
	}
	exec(`UPDATE vip_shop_rules SET rules='{"gold":101}'`)
	if _, err = s.VIPShopSettings(); err == nil {
		t.Fatal("invalid stored policy")
	}
}
