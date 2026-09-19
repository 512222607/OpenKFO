package persistence

import (
	"bytes"
	"database/sql"
	"os"
	"reflect"
	"strings"
	"testing"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
)

func TestStageSettlementLocalDatabase(t *testing.T) {
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
		if _, err := db.Exec(q, args...); err != nil {
			t.Fatal(err)
		}
	}
	for _, q := range []string{
		`CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,profile BLOB,gold INT UNSIGNED,tickets INT UNSIGNED) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE counters(name VARCHAR(32) PRIMARY KEY,value BIGINT UNSIGNED) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE battle_settlements(serial INT PRIMARY KEY,reports BLOB,result BLOB) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE level_reward_receipts(uid BIGINT,level INT,items BLOB,PRIMARY KEY(uid,level)) ENGINE=InnoDB`,
	} {
		exec(q)
	}
	exec("INSERT INTO counters VALUES('battle',10)")
	p := make([]byte, 360)
	protocol.WriteUint16(p, LevelOffset, 1)
	protocol.WriteUint32(p, ExperienceOffset, 90)
	exec("INSERT INTO accounts VALUES(1,?,10,0),(2,?,20,0)", p, p)
	m := (&Store{DB: db}).BattleManager()
	rules := RewardRules{}.Normalized()
	rules.GrowthEnabled = true
	for i := 0; i < 149; i++ {
		rules.Levels[i].NextExperience = 100
	}
	rules.LevelGifts = []LevelGift{{Level: 2, Gold: 5, Tickets: 3}}
	awards := []BattleReward{{UID: 2, Outcome: StageOutcomeClear, Gold: 7, Experience: 20}, {UID: 1, Outcome: StageOutcomeClear, Gold: 7, Experience: 20}}
	got, err := m.SettleStage(1, []byte("verified stage reports"), awards, rules)
	if err != nil {
		t.Fatal(err)
	}
	if awards[0].UID != 2 || awards[0].BattleMode != nil {
		t.Fatal("caller input mutated")
	}
	for _, r := range got {
		if r.Outcome != StageOutcomeClear || r.BattleMode == nil || *r.BattleMode != byte(protocol.StageAssault) || ProfileLevel(r.Profile) != 2 || protocol.ReadUint32(r.Profile, ExperienceOffset) != 10 || r.GoldBalance != uint32(r.UID)*10+12 {
			t.Fatal("stage progression wrong", r)
		}
		// No competitive counters in the profile may change.
		if !bytes.Equal(r.Profile[133:165], p[133:165]) {
			t.Fatal("competitive counters changed")
		}
		var tickets uint32
		if err := db.QueryRow("SELECT tickets FROM accounts WHERE uid=?", r.UID).Scan(&tickets); err != nil || tickets != 3 {
			t.Fatal("level gift missing", err, tickets)
		}
	}
	awards[0].Gold = 999
	again, err := m.SettleStage(1, nil, awards, rules)
	if err != nil || !reflect.DeepEqual(got, again) {
		t.Fatal("replay did not return original settlement", err)
	}
	if _, err = m.SettleStage(1, nil, awards[:1], rules); err == nil {
		t.Fatal("wrong party accepted replay")
	}
	if _, err = m.SettleBattle(1, nil, []BattleReward{{UID: 1, Outcome: "win"}}); err == nil {
		t.Fatal("stage receipt returned to PvP")
	}
	// Seed a competitive receipt to verify the reverse boundary without touching tasks.
	exec(`INSERT INTO battle_settlements VALUES(2,'[]','[{"uid":1,"outcome":"win"}]')`)
	if _, err = m.SettleStage(2, nil, awards, rules); err == nil {
		t.Fatal("PvP receipt returned to stage")
	}
	// A later participant's overflow must roll back the earlier account update.
	if _, err = m.SettleStage(3, nil, []BattleReward{{UID: 1, Outcome: StageOutcomeFailed, Gold: 1}, {UID: 2, Outcome: StageOutcomeFailed, Gold: 0xffffffff}}, rules); err == nil {
		t.Fatal("overflow accepted")
	}
	var gold, count int
	if err = db.QueryRow("SELECT gold FROM accounts WHERE uid=1").Scan(&gold); err != nil || gold != 22 {
		t.Fatal("partial stage reward committed", gold, err)
	}
	if err = db.QueryRow("SELECT COUNT(*) FROM battle_settlements WHERE serial=3").Scan(&count); err != nil || count != 0 {
		t.Fatal("failed stage receipt persisted", count, err)
	}
}

func TestStageSettlementRejectsCompetitiveInputs(t *testing.T) {
	m := (&Store{}).BattleManager() // Rejections must occur before DB access.
	for _, r := range []BattleReward{{Outcome: "win"}, {Outcome: StageOutcomeClear, HonourPeriod: 1}, {Outcome: StageOutcomeClear, HonourPoints: 1}} {
		if _, err := m.SettleStage(1, nil, []BattleReward{r}, RewardRules{}); err == nil {
			t.Fatal("competitive input accepted")
		}
	}
	for _, mode := range []protocol.RoomType{protocol.StageAssault, protocol.FosterMode} {
		v := byte(mode)
		if _, err := m.SettleBattle(1, nil, []BattleReward{{BattleMode: &v, UID: 1, Outcome: "win"}}); err == nil {
			t.Fatal("PVE accepted competitive settlement")
		}
	}
}
