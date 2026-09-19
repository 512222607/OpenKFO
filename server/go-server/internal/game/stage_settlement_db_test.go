package game

import (
	"database/sql"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

func TestStageSettlementRouteLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("not debug database")
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
		`CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,profile BLOB,gold INT,tickets INT) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE counters(name VARCHAR(32) PRIMARY KEY,value BIGINT) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE battle_settlements(serial INT PRIMARY KEY,reports BLOB,result BLOB) ENGINE=InnoDB`,
		`CREATE TEMPORARY TABLE battle_reward_rules(id INT PRIMARY KEY,revision BIGINT,rules BLOB) ENGINE=InnoDB`,
	} {
		exec(q)
	}
	h, owner, peer, outsider := combatFixture()
	r := owner.Room
	h.Store = &persistence.Store{DB: db}
	r.Request[46] = byte(protocol.StageAssault)
	r.Serial = 1
	protocol.WriteUint32(r.Request, protocol.RoomMapOffset, 20051)
	r.StageWaves, _ = newStageWaves([]StageWavePlan{{Monsters: map[uint32]uint32{7: 1}}})
	r.StageWaves.finished = true
	r.StageWaves.index = 1
	r.BattleStartedAt = time.Now().Add(-125 * time.Second)
	h.Config.Settlement = persistence.RewardRules{StageRewards: []persistence.StageMapRewards{{MapID: 20051, Clear: persistence.StageReward{Experience: 20, RewardBundle: persistence.RewardBundle{Gold: 7, Tickets: 2}}}}}
	profile := make([]byte, protocol.RoleProfileSize)
	protocol.WriteUint16(profile, persistence.LevelOffset, 1)
	exec("INSERT INTO counters VALUES('battle',1)")
	exec("INSERT INTO accounts VALUES(?,?,10,3),(?,?,10,3)", owner.UID, profile, peer.UID, []byte{1})
	p := settlementReport(r)
	for _, m := range r.Members {
		protocol.WriteUint16(p, int(m.Slot)*87+65, 1)
	}
	// A corrupt later account rolls back the whole room and schedules a retry.
	if err = h.route(owner, owner.game(), protocol.Message{ID: 4110, Payload: p}); err != nil {
		t.Fatal(err)
	}
	if r.LoadTimer == nil || r.Stage != "finishing" {
		t.Fatal("failure lost pending state")
	}
	r.LoadTimer.Stop()
	defer func() {
		if r.LoadTimer != nil {
			r.LoadTimer.Stop()
		}
	}()
	roomOutputs(t, owner, 20150)
	roomOutputs(t, peer)
	var gold int
	if err = db.QueryRow("SELECT gold FROM accounts WHERE uid=?", owner.UID).Scan(&gold); err != nil || gold != 10 {
		t.Fatal("partial reward", gold, err)
	}
	exec("UPDATE accounts SET profile=? WHERE uid=?", profile, peer.UID)
	// Same native report can resume after the transient persistence failure.
	if err = h.route(owner, owner.game(), protocol.Message{ID: 4110, Payload: p}); err != nil {
		t.Fatal(err)
	}
	if r.Stage != "settlement" || r.LoadTimer != nil {
		t.Fatal("settlement did not finish")
	}
	for _, s := range []*Session{owner, peer} {
		out := roomOutputs(t, s, 4300, 1240, 1230, 4120)
		if protocol.ReadUint32(out[1].Payload, 0) != 17 || protocol.ReadUint32(out[2].Payload, 0) != 5 {
			t.Fatal("wrong balances")
		}
		rows, err := protocol.ParseStageResults(out[3].Payload)
		if err != nil || len(rows) != 2 || rows[1].UID != s.UID {
			t.Fatal("recipient profile not last", err)
		}
		for _, row := range rows {
			if row.Waves != 1 || row.ElapsedSeconds < 125 || row.Experience != 20 || row.Gold != 7 || protocol.ReadUint32(row.Raw[:], 87) != 0xffffffff {
				t.Fatal("bad result record", row)
			}
		}
		if s.game().Phase != "settlement" {
			t.Fatal("wrong client phase")
		}
	}
	roomOutputs(t, outsider)
	if err = h.route(owner, owner.game(), protocol.Message{ID: 4110, Payload: p}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, owner)
	roomOutputs(t, peer)
	var receipts int
	if err = db.QueryRow("SELECT COUNT(*) FROM battle_settlements").Scan(&receipts); err != nil || receipts != 1 {
		t.Fatal("duplicate receipt", receipts, err)
	}
	// A verified all-zero-health reason 2 uses failure configuration, not PvP.
	r.Serial = 2
	r.Stage = "battle"
	r.Reports = nil
	r.StageWaves.finished = false
	r.StageWaves.index = 0
	h.Config.Settlement.StageRewards[0].Failed = persistence.StageReward{RewardBundle: persistence.RewardBundle{Gold: 1}}
	exec("UPDATE counters SET value=2 WHERE name='battle'")
	p = settlementReport(r)
	for _, m := range r.Members {
		m.Session.game().Phase = "battle"
		protocol.WriteUint16(p, int(m.Slot)*87+65, 2)
		protocol.WriteUint16(p, int(m.Slot)*87+2, 0)
	}
	if err = h.route(owner, owner.game(), protocol.Message{ID: 4110, Payload: p}); err != nil {
		t.Fatal(err)
	}
	for _, s := range []*Session{owner, peer} {
		out := roomOutputs(t, s, 4300, 1240, 1230, 4120)
		rows, err := protocol.ParseStageResults(out[3].Payload)
		if err != nil || rows[0].ResultValue != 2 || rows[0].Gold != 1 || rows[0].Experience != 0 || rows[0].Waves != 0 || protocol.ReadUint32(out[1].Payload, 0) != 18 {
			t.Fatal("failure rewards mixed with clearance", err)
		}
	}
}
