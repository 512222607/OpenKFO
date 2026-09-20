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

func TestHonourLevelsLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
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
	a, e := persistence.NewAccountWithStarterCharacter(uid, fmt.Sprintf("hl%d", uid), "test123456")
	if e != nil {
		t.Fatal(e)
	}
	a.Inventory = nil
	if e = store.Create(a); e != nil {
		t.Fatal(e)
	}
	defer func() {
		for _, table := range []string{"honour_stats", "accounts"} {
			if _, err := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); err != nil {
				t.Error(err)
			}
		}
	}()
	for i, points := range []uint32{500, 99} {
		if _, e = store.DB.Exec(`INSERT INTO honour_stats(period,uid,points,games,wins) VALUES(?,?,?,10,6)`, i+1, uid, points); e != nil {
			t.Fatal(e)
		}
	}
	h, s, _, _ := waitingRoomFixture()
	h.Store = store
	h.Config.Honour = HonourRules{Periods: []string{"第一期", "第二期"}, LevelPoints: []uint32{100, 300, 500}}
	for i, want := range []uint32{3, 0} {
		p := make([]byte, 12)
		protocol.WriteUint64(p, 0, uid)
		protocol.WriteUint32(p, 8, uint32(i+1))
		if e = h.route(s, s.game(), protocol.Message{ID: 20360, Payload: p}); e != nil {
			t.Fatal(e)
		}
		out := roomOutputs(t, s, 20370)[0].Payload
		if protocol.ReadUint32(out, 0) == 0 || protocol.ReadUint32(out, 24) != want || protocol.ReadUint32(out, 28) != 10 || protocol.ReadUint32(out, 32) != 6 {
			t.Fatal("wrong history response")
		}
	}
	h.Config.Honour.LevelPoints = nil
	p := make([]byte, 12)
	protocol.WriteUint64(p, 0, uid)
	protocol.WriteUint32(p, 8, 1)
	if e = h.route(s, s.game(), protocol.Message{ID: 20360, Payload: p}); e != nil {
		t.Fatal(e)
	}
	out := roomOutputs(t, s, 20370)[0].Payload
	if protocol.ReadUint32(out, 24) != 0 || protocol.ReadUint32(out, 20) != 500 {
		t.Fatal("disabling grades lost points")
	}
	protocol.WriteUint64(p, 0, uid+1)
	if e = h.route(s, s.game(), protocol.Message{ID: 20360, Payload: p}); e != nil {
		t.Fatal(e)
	}
	if protocol.ReadUint32(roomOutputs(t, s, 20370)[0].Payload, 0) != 0 {
		t.Fatal("unknown player inherited history")
	}
}
