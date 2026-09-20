package game

import (
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

func TestWeaponUpgradeProtocolLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("not debug DB")
	}
	store, err := persistence.Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	store.DB.SetMaxOpenConns(1)
	store.DB.SetMaxIdleConns(1)
	if _, err = store.DB.Exec(`CREATE TEMPORARY TABLE weapon_rules(id INT PRIMARY KEY,revision BIGINT,rules BLOB)`); err != nil {
		t.Fatal(err)
	}
	uid := uint64(time.Now().UnixMicro())
	a, err := persistence.NewAccountWithStarterCharacter(uid, fmt.Sprintf("wg%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	a.Gold = 1000
	item := make([]byte, 68)
	protocol.WriteUint32(item, 0, 1)
	item[4] = 25
	protocol.WriteUint32(item, 5, 253002)
	protocol.WriteUint32(item, 47, 300)
	a.Inventory = [][]byte{item}
	if err = store.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"weapon_upgrades", "inventory", "accounts"} {
			if _, err := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); err != nil {
				t.Error(err)
			}
		}
	}()
	h := NewHub(store, Config{WeaponUpgradeMode: "consume_score_keep_level", WeaponLevels: []WeaponLevel{{Level: 0, ScoreThreshold: 100, Gold: 70, DisplayOdds: 100}, {Level: 1, ScoreThreshold: 200, Gold: 90, DisplayOdds: 0}, {Level: 2, ScoreThreshold: 300}}})
	if err = store.ItemManager().SeedWeaponSettings(persistence.WeaponRules{Enabled: true, Levels: h.Config.WeaponLevels}); err != nil {
		t.Fatal(err)
	}
	s, err := h.Attach(a, 19091)
	if err != nil {
		t.Fatal(err)
	}
	defer h.Detach(s)
	s.GameChannel = 1
	s.Channels[1] = &Channel{ID: 1, Kind: "game", Phase: "lobby", Sequence: 1}
	s.rememberInventory(a.Inventory)
	request := protocol.Message{ID: 21412, Payload: protocol.Uint32Bytes(1)}
	if err = h.route(s, s.game(), request); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 20150) // No displayed table: no charge.
	if err = h.route(s, s.game(), protocol.Message{ID: 21410}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 21411)
	if _, err = store.DB.Exec("UPDATE weapon_rules SET revision=2 WHERE id=1"); err != nil {
		t.Fatal(err)
	}
	if err = h.route(s, s.game(), request); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 20150) // A GM change invalidates the old quote.
	if err = h.route(s, s.game(), protocol.Message{ID: 21410}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 21411)
	for attempt := 0; attempt < 2; attempt++ {
		if err = h.route(s, s.game(), request); err != nil {
			t.Fatal(err)
		}
		out := roomOutputs(t, s, 1240, 2161, 21413)
		if protocol.ReadUint32(out[0].Payload, 0) != 930 || protocol.ReadUint32(out[1].Payload, 43) != 1 || protocol.ReadUint32(out[1].Payload, 47) != 200 || len(out[2].Payload) != 22 || out[2].Payload[0] != 1 || protocol.ReadUint32(out[2].Payload, 9) != 1 {
			t.Fatal("success/replay wire", out)
		}
	}
	s.game().Sequence++
	if err = h.route(s, s.game(), request); err != nil {
		t.Fatal(err)
	}
	out := roomOutputs(t, s, 1240, 2161, 21413)
	if protocol.ReadUint32(out[0].Payload, 0) != 840 || protocol.ReadUint32(out[1].Payload, 43) != 1 || protocol.ReadUint32(out[1].Payload, 47) != 0 || out[2].Payload[0] != 0 {
		t.Fatal("failure wire", out)
	}
	s.game().Sequence++
	if err = h.route(s, s.game(), request); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 20150)
	var gold uint32
	if err = store.DB.QueryRow(`SELECT gold FROM accounts WHERE uid=?`, uid).Scan(&gold); err != nil || gold != 840 {
		t.Fatal("rejected request charged", gold, err)
	}
}
