package game

import (
	"bytes"
	"database/sql"
	"os"
	"strings"
	"testing"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

func TestTutorialCompletionLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, e := mysql.ParseDSN(dsn)
	if e != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("not debug database")
	}
	db, e := sql.Open("mysql", dsn)
	if e != nil {
		t.Fatal(e)
	}
	defer db.Close()
	db.SetMaxOpenConns(1)
	db.SetMaxIdleConns(1)
	if _, e = db.Exec("CREATE TEMPORARY TABLE title_rewards(uid BIGINT,title_level TINYINT,choices BLOB,claimed_key INT UNSIGNED NULL,claimed_instance INT UNSIGNED NULL,PRIMARY KEY(uid,title_level)) ENGINE=InnoDB"); e != nil {
		t.Fatal(e)
	}
	if _, e = db.Exec("CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,profile BLOB,gold INT DEFAULT 0,tickets INT DEFAULT 0) ENGINE=InnoDB"); e != nil {
		t.Fatal(e)
	}
	for _, q := range []string{"CREATE TEMPORARY TABLE tutorial_rewards(uid BIGINT PRIMARY KEY,reward BLOB) ENGINE=InnoDB", "CREATE TEMPORARY TABLE battle_reward_rules(id INT PRIMARY KEY,rules BLOB) ENGINE=InnoDB"} {
		if _, e = db.Exec(q); e != nil {
			t.Fatal(e)
		}
	}
	for _, level := range []byte{0, 1, 2, 8} {
		if _, e = db.Exec("DELETE FROM tutorial_rewards"); e != nil {
			t.Fatal(e)
		}
		h, s, peer, _ := combatFixture()
		r := s.Room
		delete(r.Members, peer.UID)
		r.Request[37], r.Request[46] = 1, 4
		protocol.WriteUint32(r.Request, 38, 1201)
		protocol.WriteUint32(r.Request, 42, 1201)
		r.Members[s.UID].Input = true
		original := bytes.Repeat([]byte{0x12}, 360)
		original[123] = level
		if _, e = db.Exec("REPLACE INTO accounts(uid,profile) VALUES(?,?)", s.UID, original); e != nil {
			t.Fatal(e)
		}
		// Ineligible requests must never touch the store or acknowledge completion.
		for _, bad := range []string{"phase", "map", "players", "input", "length"} {
			ch := s.game()
			ch.Phase = "battle"
			r.Members[s.UID].Input = true
			payload := []byte(nil)
			switch bad {
			case "phase":
				ch.Phase = "loading"
			case "map":
				protocol.WriteUint32(r.Request, 38, 104)
			case "players":
				r.Members[peer.UID] = &Member{Session: peer}
			case "input":
				r.Members[s.UID].Input = false
			case "length":
				payload = []byte{1}
			}
			e = h.completeTutorial(s, ch, payload)
			if bad == "length" && e == nil {
				t.Fatal("bad length accepted")
			}
			if bad != "length" && e != nil {
				t.Fatal(e)
			}
			if len(s.Output) != 0 || s.Room != r {
				t.Fatal("ineligible completion changed room")
			}
			ch.Phase = "battle"
			r.Members[s.UID].Input = true
			protocol.WriteUint32(r.Request, 38, 1201)
			delete(r.Members, peer.UID)
		}
		h.Store = &persistence.Store{DB: db}
		if e = h.route(s, s.game(), protocol.Message{ID: 4124}); e != nil {
			t.Fatal(e)
		}
		want := level
		if want < 2 {
			want = 2
		}
		out := roomOutputs(t, s, 4125, 1240, 1230, 3115, notice("").ID)
		if len(out[0].Payload) != 64 || out[0].Payload[0] != want {
			t.Fatal("native guide gate not synchronized before leave")
		}

		if s.Room != nil || s.game().Phase != "lobby" || len(h.Rooms) != 0 {
			t.Fatal("tutorial room not released")
		}
		var stored []byte
		if e = db.QueryRow("SELECT profile FROM accounts WHERE uid=?", s.UID).Scan(&stored); e != nil {
			t.Fatal(e)
		}
		original[123] = want
		if !bytes.Equal(stored, original) {
			t.Fatal("unrelated progress changed")
		}
		if e = h.route(s, s.game(), protocol.Message{ID: 4124}); e != nil {
			t.Fatal(e)
		}
		roomOutputs(t, s)
		// Reproduce the stale native 3010 that arrived 100ms after 3115.
		for i := 0; i < 2; i++ {
			roomRequest(t, h, s, 3010, r.Request)
			repair := roomOutputs(t, s, 4125, 3115, 20150)
			if repair[0].Payload[0] != want || s.Room != nil || len(h.Rooms) != 0 {
				t.Fatal("completed guide recreated")
			}
		}
	}
	t.Run("native weapon selection and relogin", func(t *testing.T) {
		exec := func(q string, args ...any) {
			t.Helper()
			if _, err := db.Exec(q, args...); err != nil {
				t.Fatal(err)
			}
		}
		for _, q := range []string{
			"CREATE TEMPORARY TABLE item_definitions(definition_key INT PRIMARY KEY,revision BIGINT,record BLOB,days INT) ENGINE=InnoDB",
			"CREATE TEMPORARY TABLE offers(catalog_key INT PRIMARY KEY,record BLOB,enabled BOOL) ENGINE=InnoDB",
			"CREATE TEMPORARY TABLE inventory(uid BIGINT,instance INT UNSIGNED,record BLOB,PRIMARY KEY(uid,instance)) ENGINE=InnoDB",
			"CREATE TEMPORARY TABLE inventory_expirations(uid BIGINT,instance INT UNSIGNED,expires_at BIGINT,PRIMARY KEY(uid,instance)) ENGINE=InnoDB",
			"DELETE FROM tutorial_rewards", "DELETE FROM title_rewards",
		} {
			exec(q)
		}
		h, s, peer, _ := combatFixture()
		h.Store = &persistence.Store{DB: db}
		r := s.Room
		delete(r.Members, peer.UID)
		r.Request[37], r.Request[46] = 1, 4
		protocol.WriteUint32(r.Request, 38, 1201)
		protocol.WriteUint32(r.Request, 42, 1201)
		r.Members[s.UID].Input = true
		exec("REPLACE INTO accounts(uid,profile) VALUES(?,?)", s.UID, make([]byte, 360))
		for key := uint32(1); key <= 2; key++ {
			record := make([]byte, 68)
			record[4] = 25
			protocol.WriteUint32(record, 5, 253000+key)
			protocol.WriteUint16(record, 23, 1)
			exec("INSERT INTO item_definitions VALUES(?,1,?,1)", key, record)
		}
		exec("INSERT INTO battle_reward_rules VALUES(1,?)", []byte(`{"tutorial_reward":{"items":[1,2],"gold":0,"tickets":0}}`))
		// A missing reward definition must not disconnect the valid guide
		// session, consume completion, or replace the selector with an empty one.
		exec("UPDATE battle_reward_rules SET rules=? WHERE id=1", []byte(`{"tutorial_reward":{"items":[999]}}`))
		if err := h.route(s, s.game(), protocol.Message{ID: 4124}); err != nil {
			t.Fatal("reward configuration failure disconnected player", err)
		}
		roomOutputs(t, s, 20150)
		if s.Room != r || r.Stage != "battle" || s.game().Phase != "battle" {
			t.Fatal("failed completion lost guide session")
		}
		var receipts int
		if err := db.QueryRow("SELECT COUNT(*) FROM tutorial_rewards").Scan(&receipts); err != nil || receipts != 0 {
			t.Fatal("failed completion consumed reward", receipts, err)
		}
		exec("UPDATE battle_reward_rules SET rules=? WHERE id=1", []byte(`{"tutorial_reward":{"items":[1,2],"gold":0,"tickets":0}}`))
		if err := h.route(s, s.game(), protocol.Message{ID: 4124}); err != nil {
			t.Fatal(err)
		}
		out := roomOutputs(t, s, 1550, 4125, 1240, 1230, 3115, 20150)
		if len(out[0].Payload) != 216 || protocol.ReadUint32(out[1].Payload, 8) != 1 || protocol.ReadUint32(out[1].Payload, 16) != 2 || s.TitleOffer != 2 {
			t.Fatal("missing catalogue or selection")
		}
		var count int
		db.QueryRow("SELECT COUNT(*) FROM inventory").Scan(&count)
		if count != 0 {
			t.Fatal("weapon granted before selection")
		}
		// Session reset: restore via the existing login task refresh hook,
		// including when ordinary title advancement is disabled.
		s.TitleOffer = 0
		h.Config.TitleLevels = nil
		if err := h.announceTitleReward(s); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, s, 1550, 4125)
		claim := make([]byte, 149)
		protocol.WriteUint32(claim, 145, 2)
		if err := h.route(s, s.game(), protocol.Message{ID: 4126, Payload: claim}); err != nil {
			t.Fatal(err)
		}
		awarded := roomOutputs(t, s, 2160, 20150)
		if protocol.ReadUint32(awarded[0].Payload, 5) != 253002 {
			t.Fatal("wrong choice")
		}
		if err := h.route(s, s.game(), protocol.Message{ID: 4126, Payload: claim}); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, s, 2161, 20150)
		protocol.WriteUint32(claim, 145, 1)
		if err := h.route(s, s.game(), protocol.Message{ID: 4126, Payload: claim}); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, s, 20150)
		db.QueryRow("SELECT COUNT(*) FROM inventory").Scan(&count)
		if count != 1 {
			t.Fatal("duplicate reward", count)
		}
	})
}
