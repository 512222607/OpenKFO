package persistence

import (
	"database/sql"
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
)

func TestHonourSettlementLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("not independent debug DB")
	}
	s, err := Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer s.DB.Close()
	uid := uint64(time.Now().UnixMicro())
	period := uint32(uid%900000000) + 1000000000
	var exists int
	if err = s.DB.QueryRow(`SELECT COUNT(*) FROM honour_stats WHERE period IN (?,?)`, period, period+1).Scan(&exists); err != nil || exists != 0 {
		t.Fatal("test period collision", err)
	}
	for i := uint64(0); i < 2; i++ {
		a, e := NewAccount(uid+i, fmt.Sprintf("hn%d", uid+i), "test123456")
		if e != nil {
			t.Fatal(e)
		}
		if e = s.Create(a); e != nil {
			t.Fatal(e)
		}
		id := uid + i
		defer func() {
			if _, e := s.DB.Exec(`DELETE FROM inventory WHERE uid=?`, id); e != nil {
				t.Error(e)
			}
			if _, e := s.DB.Exec(`DELETE FROM accounts WHERE uid=?`, id); e != nil {
				t.Error(e)
			}
		}()
	}
	var serials []uint32
	allocate := func() uint32 {
		id, e := s.BattleManager().NextBattle()
		if e != nil {
			t.Fatal(e)
		}
		serials = append(serials, id)
		return id
	}
	defer func() {
		for _, id := range serials {
			if _, e := s.DB.Exec(`DELETE FROM battle_settlements WHERE serial=?`, id); e != nil {
				t.Error(e)
			}
		}
	}()
	awards := []BattleReward{{UID: uid, Outcome: "win", Gold: 7, HonourPeriod: period, HonourPoints: 10}, {UID: uid + 1, Outcome: "loss", HonourPeriod: period, HonourPoints: 2}}
	serial := allocate()
	if _, err = s.BattleManager().SettleBattle(serial, []byte("{}"), awards); err != nil {
		t.Fatal(err)
	}
	if _, err = s.BattleManager().SettleBattle(serial, []byte("{}"), awards); err != nil {
		t.Fatal(err)
	}
	a, err := s.Honour(uid, period)
	if err != nil || a != (HonourStats{Points: 10, Games: 1, Wins: 1, Rank: 1}) {
		t.Fatal(a, err)
	}
	b, err := s.Honour(uid+1, period)
	if err != nil || b != (HonourStats{Points: 2, Games: 1, Wins: 0, Rank: 2}) {
		t.Fatal(b, err)
	}
	p := a.Payload("本服第一期")
	if protocol.ReadUint32(p, 16) != 1 || protocol.ReadUint32(p, 20) != 10 || protocol.ReadUint32(p, 24) != 0 || protocol.ReadUint32(p, 28) != 1 || protocol.ReadUint32(p, 32) != 1 || p[len(p)-1] != 0 {
		t.Fatal("wire offsets")
	}
	if _, err = s.Honour(uid, period+1); err != sql.ErrNoRows {
		t.Fatal("history leaked", err)
	}
	if _, err = s.Honour(uid+2, period); err != sql.ErrNoRows {
		t.Fatal("identity leaked", err)
	}
	if _, err = s.BattleManager().SettleBattle(allocate(), []byte("{}"), []BattleReward{{UID: uid, Outcome: "draw", HonourPeriod: period + 1, HonourPoints: 3}}); err != nil {
		t.Fatal(err)
	}
	old, err := s.Honour(uid, period)
	if err != nil || old != a {
		t.Fatal("previous period changed")
	}
	if _, err = s.BattleManager().SettleBattle(allocate(), []byte("{}"), []BattleReward{{UID: uid, Outcome: "unconfirmed", Gold: 99, HonourPeriod: period, HonourPoints: 99}}); err == nil {
		t.Fatal("unconfirmed counted")
	}
	var gold uint32
	if err = s.DB.QueryRow(`SELECT gold FROM accounts WHERE uid=?`, uid).Scan(&gold); err != nil || gold != 7 {
		t.Fatal("partial transaction", gold, err)
	}
	if _, err = s.DB.Exec(`UPDATE honour_stats SET points=2147483646,games=2147483646,wins=2147483646 WHERE uid=? AND period=?`, uid, period); err != nil {
		t.Fatal(err)
	}
	for i := 0; i < 2; i++ {
		if _, err = s.BattleManager().SettleBattle(allocate(), []byte("{}"), []BattleReward{{UID: uid, Outcome: "win", HonourPeriod: period, HonourPoints: 10}}); err != nil {
			t.Fatal(err)
		}
	}
	a, err = s.Honour(uid, period)
	if err != nil || a.Points != 0x7fffffff || a.Games != 0x7fffffff || a.Wins != 0x7fffffff {
		t.Fatal("native signed range overflow", a, err)
	}
}
