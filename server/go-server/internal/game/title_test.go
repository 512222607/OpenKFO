package game

import (
	"database/sql"
	"os"
	"strings"
	"testing"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

func TestTitleClaimRequiresAnnouncement(t *testing.T) {
	h, s, _, _ := waitingRoomFixture()
	p := make([]byte, 149)
	protocol.WriteUint32(p, 145, 7)
	// No store: all unannounced or malformed requests must fail before DB use.
	for _, input := range [][]byte{nil, p[:148], p, append(p, 0)} {
		if err := h.route(s, s.game(), protocol.Message{ID: 4126, Payload: input}); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, s, 20150)
	}
	s.TitleOffer = 1
	s.game().Phase = "battle"
	if err := h.route(s, s.game(), protocol.Message{ID: 4126, Payload: p}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s)
}

func TestTitleClaimProtocolLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug DB")
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
	for _, q := range []string{
		`CREATE TEMPORARY TABLE title_rules(id INT PRIMARY KEY,revision BIGINT,rules BLOB) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,profile BLOB) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE title_rewards(uid BIGINT,title_level TINYINT UNSIGNED,choices BLOB,claimed_key INT UNSIGNED NULL,claimed_instance INT UNSIGNED NULL,PRIMARY KEY(uid,title_level)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE offers(catalog_key INT PRIMARY KEY,record BLOB,grant_record BLOB,enabled BOOL) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE offer_lifetimes(catalog_key INT PRIMARY KEY,days INT UNSIGNED) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE inventory(uid BIGINT,instance INT UNSIGNED,record BLOB,PRIMARY KEY(uid,instance)) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE inventory_expirations(uid BIGINT,instance INT UNSIGNED,expires_at BIGINT,PRIMARY KEY(uid,instance)) ENGINE=InnoDB`,
	} {
		exec(q)
	}
	exec("INSERT INTO accounts VALUES(1,?),(2,?)", make([]byte, 360), make([]byte, 360))
	catalog, item := make([]byte, 108), make([]byte, 68)
	catalog[4], item[4] = 25, 25
	protocol.WriteUint32(catalog, 9, 7)
	protocol.WriteUint32(catalog, 5, 250001)
	protocol.WriteUint32(item, 5, 250001)
	protocol.WriteUint32(item, 13, 24)
	exec("INSERT INTO offers VALUES(7,?,?,TRUE)", catalog, item)
	h, s, peer, _ := waitingRoomFixture()
	h.Store = &persistence.Store{DB: db}
	s.UID = 1
	s.Inventory = map[uint32][]byte{99: make([]byte, 68)}
	if err = h.Store.GrantTitleChoices(1, 1, []uint32{7}); err != nil {
		t.Fatal(err)
	}
	level, choices, err := h.Store.PendingTitleReward(1)
	if err != nil || level != 1 || len(choices) != 1 || choices[0] != 7 {
		t.Fatal(level, choices, err)
	}
	if level, _, err = h.Store.PendingTitleReward(2); err != nil || level != 0 {
		t.Fatal("cross account pending", err)
	}
	p := make([]byte, 149)
	protocol.WriteUint32(p, 145, 7)
	send := func(want ...uint32) {
		t.Helper()
		if e := h.route(s, s.game(), protocol.Message{ID: 4126, Payload: p}); e != nil {
			t.Fatal(e)
		}
		roomOutputs(t, s, want...)
	}
	send(20150) // Ownership alone is insufficient without an announced title.
	if err = h.announceTitleReward(s); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s)
	h.Config.TitleLevels = []byte{2}
	if err = h.announceTitleReward(s); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s)
	h.Config.TitleLevels = []byte{1, 2}
	for i := 0; i < 2; i++ {
		if err = h.announceTitleReward(s); err != nil {
			t.Fatal(err)
		}
		out := roomOutputs(t, s, 4125)
		if len(out[0].Payload) != 64 || out[0].Payload[0] != 1 || protocol.ReadUint32(out[0].Payload, 8) != 7 || s.TitleOffer != 1 {
			t.Fatal("announcement", out)
		}
	}
	protocol.WriteUint64(p, 0, 2) // Native unused prefix cannot select another UID.
	send(2160, 20150)
	send(2161, 20150)
	if len(s.Inventory) != 2 || s.TitleOffer != 1 {
		t.Fatal("cache or retry binding lost")
	}
	if level, _, err = h.Store.PendingTitleReward(1); err != nil || level != 0 {
		t.Fatal("claimed still pending", err)
	}
	if err = h.Store.GrantTitleChoices(1, 2, []uint32{7}); err != nil {
		t.Fatal(err)
	}
	if err = h.announceTitleReward(s); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s)
	send(2161, 20150) // Same product in next title must not be claimed by retry.
	if level, _, err = h.Store.PendingTitleReward(1); err != nil || level != 2 {
		t.Fatal("retry consumed next title", err)
	}
	var count int
	if err = db.QueryRow("SELECT COUNT(*) FROM inventory").Scan(&count); err != nil || count != 1 {
		t.Fatal(count, err)
	}
	exec("UPDATE inventory SET record=? WHERE uid=1", []byte{1})
	send(20150) // Corrupt stored inventory must not become a short native packet.
	exec("DELETE FROM inventory WHERE uid=1")
	send(20150) // A consumed/deleted award is never resurrected.
	protocol.WriteUint32(p, 145, 8)
	send(20150)
	exec("UPDATE title_rewards SET choices=? WHERE uid=1 AND title_level=2", []byte(`[7,7]`))
	if _, _, err = h.Store.PendingTitleReward(1); err == nil {
		t.Fatal("duplicate candidates accepted")
	}
	exec("UPDATE title_rewards SET choices=? WHERE uid=1 AND title_level=2", []byte(`[7]`))
	exec("INSERT INTO title_rewards(uid,title_level,choices) VALUES(1,3,?)", []byte(`[7]`))
	if _, _, err = h.Store.PendingTitleReward(1); err == nil {
		t.Fatal("ambiguous pending titles accepted")
	}
	roomOutputs(t, peer)
}
