package game

import (
	"database/sql"
	"encoding/json"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
	"time"
)

func TestTrainingClaimProtocolLocalDatabase(t *testing.T) {
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
	exec(`CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,profile BLOB NOT NULL,gold INT NOT NULL DEFAULT 0,tickets INT NOT NULL DEFAULT 0) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE training_ranks(uid BIGINT PRIMARY KEY,training_rank INT NOT NULL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE training(uid BIGINT PRIMARY KEY,started BIGINT NULL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE training_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE training_claims(uid BIGINT NOT NULL,operation_id VARCHAR(128) NOT NULL,started BIGINT NOT NULL,training_rank INT NOT NULL,revision BIGINT NOT NULL,experience INT NOT NULL,PRIMARY KEY(uid,operation_id),UNIQUE KEY cycle(uid,started)) ENGINE=InnoDB`)
	rules := persistence.TrainingRules{Enabled: true}
	for i := uint32(0); i <= 8; i++ {
		rules.Levels = append(rules.Levels, persistence.TrainingRule{Level: i, XPPerHour: 100, XPCap: 250})
	}
	saveRules := func() {
		b, e := json.Marshal(rules)
		if e != nil {
			t.Fatal(e)
		}
		exec(`REPLACE INTO training_rules VALUES(1,7,?)`, b)
	}
	saveRules()
	profile := make([]byte, 360)
	protocol.WriteUint16(profile, persistence.LevelOffset, 1)
	exec(`INSERT INTO accounts(uid,profile) VALUES(1,?),(2,?)`, profile, profile)
	now := time.Now().Unix()
	exec(`INSERT INTO training VALUES(1,?),(2,?)`, now-7200, now-60)
	exec(`CREATE TEMPORARY TABLE battle_reward_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	h, player, peer, _ := waitingRoomFixture()
	player.UID = 1
	h.Store = &persistence.Store{DB: db}
	player.game().Phase = "lobby"
	player.game().Sequence = 42
	if err := h.route(player, player.game(), protocol.Message{ID: 21000, Payload: protocol.Uint64Bytes(1)}); err != nil {
		t.Fatal(err)
	}
	preview := roomOutputs(t, player, 21001)
	pv, err := protocol.ParseTrainingStatus(preview[0].Payload)
	if err != nil || pv.RewardPerHour != 100 || pv.RewardCap != 250 || pv.Minutes != 120 {
		t.Fatal(pv, err)
	}
	if err := h.route(player, player.game(), protocol.Message{ID: 21006, Payload: []byte{1}}); err == nil {
		t.Fatal("bad length accepted")
	}
	roomOutputs(t, player)
	if err := h.route(player, player.game(), protocol.Message{ID: 21006}); err != nil {
		t.Fatal(err)
	}
	messages := roomOutputs(t, player, 4300, 21007)
	if len(messages) != 2 || protocol.ReadUint32(messages[0].Payload, 0) != 200 {
		t.Fatal(messages)
	}
	status, err := protocol.ParseTrainingStatus(messages[1].Payload)
	if err != nil || status.UID != 1 || status.Minutes != 0 || status.Active != 0 {
		t.Fatal(status, err)
	}
	roomOutputs(t, peer)
	if err := h.route(player, player.game(), protocol.Message{ID: 21006}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, player, 4300, 21007)
	var count int
	if err := db.QueryRow(`SELECT COUNT(*) FROM training_claims`).Scan(&count); err != nil || count != 1 {
		t.Fatal(count, err)
	}
	player.game().Sequence++
	if err := h.route(player, player.game(), protocol.Message{ID: 21006}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, player, 20150)
	player.game().Phase = "battle"
	if err := h.route(player, player.game(), protocol.Message{ID: 21006}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, player)
}
