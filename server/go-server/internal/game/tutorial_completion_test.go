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
	if _, e = db.Exec("CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,profile BLOB) ENGINE=InnoDB"); e != nil {
		t.Fatal(e)
	}
	for _, level := range []byte{0, 1, 2, 8} {
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
		if want == 2 {
			out := roomOutputs(t, s, 4125, 3115)
			if len(out[0].Payload) != 64 || out[0].Payload[0] != want || !bytes.Equal(out[0].Payload[1:], make([]byte, 63)) {
				t.Fatal("invalid title status")
			}
		} else {
			roomOutputs(t, s, 3115)
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
	}
}
