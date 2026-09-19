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
)

func TestTaskProtocolLocalDatabase(t *testing.T) {
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

	exec(`CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,profile BLOB NOT NULL,gold INT UNSIGNED NOT NULL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE task_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE task_progress(uid BIGINT,task_key INT,state INT,baseline BINARY(116),rule_revision BIGINT,rule_data BLOB,PRIMARY KEY(uid,task_key)) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE task_rewards(uid BIGINT,task_key INT,rule_revision BIGINT,experience INT,gold INT,PRIMARY KEY(uid,task_key)) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE battle_reward_rules(id INT PRIMARY KEY,revision BIGINT NOT NULL,rules BLOB NOT NULL) ENGINE=InnoDB`)
	rules := persistence.TaskRules{ClientHash: strings.Repeat("a", 64), Catalogue: []persistence.TaskCatalogueEntry{{ID: 1001, Enabled: true}}, Enabled: true, Tasks: []persistence.TaskRule{{ID: 1001, Enabled: true, Matches: 10, Experience: 100, Gold: 30, Counters: make([]uint32, 29)}}}
	data, _ := json.Marshal(rules)
	exec("INSERT INTO task_rules VALUES(1,1,?)", data)
	profile := make([]byte, 360)
	protocol.WriteUint32(profile, 0, 7)
	protocol.WriteUint32(profile, 129, 50)
	exec("INSERT INTO accounts VALUES(1,?,50),(2,?,50)", profile, profile)
	h, player, peer, _ := waitingRoomFixture()
	player.UID = 1
	h.Store = &persistence.Store{DB: db}
	h.Config.ConfigHash = strings.Repeat("a", 64)
	player.game().Phase = "lobby"
	send := func(id uint32, p []byte, want ...uint32) []protocol.Message {
		t.Helper()
		if e := h.route(player, player.game(), protocol.Message{ID: id, Payload: p}); e != nil {
			t.Fatal(e)
		}
		return roomOutputs(t, player, want...)
	}
	out := send(6000, protocol.Uint32Bytes(7), 4300, 1240, 6020)
	list, e := protocol.ParseTaskRecords(6020, out[2].Payload)
	if e != nil || len(list) != 1 || list[0].Raw[6] != 1 {
		t.Fatal(list, e)
	}
	p := make([]byte, 14)
	protocol.WriteUint64(p, 0, 999999)
	protocol.WriteUint32(p, 8, 123456)
	protocol.WriteUint16(p, 12, 1001)
	out = send(6050, p, 6060)
	if len(out[0].Payload) != 14 || protocol.ReadUint64(out[0].Payload, 0) != 1 || protocol.ReadUint16(out[0].Payload, 12) != 1001 {
		t.Fatal("echoed untrusted identity", out)
	}
	send(6050, p, 20150)
	out = send(6000, protocol.Uint32Bytes(7), 4300, 1240, 6020)
	progress, e := protocol.ParseTaskProgress(out[2].Payload)
	if e != nil || progress.State != 2 || progress.ProfileBaseline[0] != 50 {
		t.Fatal(progress, e)
	}
	send(6080, p, 6090)
	send(6080, p, 20150)
	send(6050, p[:13], 20150)
	player.game().Phase = "battle"
	send(6050, p)
	player.game().Phase = "lobby"
	send(6050, p, 6060)
	protocol.WriteUint32(profile, 133, 10)
	exec("UPDATE accounts SET profile=? WHERE uid=1", profile)
	out = send(6000, protocol.Uint32Bytes(7), 4300, 1240, 6020, 6030, 20150)
	if protocol.ReadUint32(out[0].Payload, 0) != 100 || protocol.ReadUint32(out[1].Payload, 0) != 80 {
		t.Fatal("reward balances wrong", out)
	}
	if len(out[3].Payload) != 14 || protocol.ReadUint16(out[3].Payload, 12) != 1001 {
		t.Fatal("completion notification missing")
	}
	progress, e = protocol.ParseTaskProgress(out[2].Payload)
	if e != nil || progress.State != 3 {
		t.Fatal("completed state missing", progress, e)
	}
	out = send(6000, protocol.Uint32Bytes(7), 4300, 1240, 6020)
	if protocol.ReadUint32(out[0].Payload, 0) != 100 || protocol.ReadUint32(out[1].Payload, 0) != 80 {
		t.Fatal("duplicate query changed reward")
	}
	var receipts int
	if e = db.QueryRow("SELECT COUNT(*) FROM task_rewards WHERE uid=1").Scan(&receipts); e != nil || receipts != 1 {
		t.Fatal(receipts, e)
	}
	roomOutputs(t, peer)
	var count int
	if e = db.QueryRow("SELECT COUNT(*) FROM task_progress WHERE uid<>1").Scan(&count); e != nil || count != 0 {
		t.Fatal("cross-account mutation", count, e)
	}
}
