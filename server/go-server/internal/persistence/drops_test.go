package persistence

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
	"os"
	"reflect"
	"strings"
	"testing"
	"time"
)

func TestDropRulesValidation(t *testing.T) {
	r := RewardRules{Drops: []DropRule{{CatalogKey: 1, Outcome: "win", MinLevel: 1, MaxLevel: 150, Chance: 10000}}}.Normalized()
	if err := r.Validate(); err != nil {
		t.Fatal(err)
	}
	r.Drops[0].Chance = 10001
	if r.Validate() == nil {
		t.Fatal("invalid probability accepted")
	}
	r.Drops[0].Chance = 1
	r.Drops[0].Outcome = "unconfirmed"
	if r.Validate() == nil {
		t.Fatal("unconfirmed drop accepted")
	}
}

func TestDropsAndDefaultEquipMySQL(t *testing.T) {
	dsn := os.Getenv("KK_TEST_MYSQL_DSN")
	if dsn == "" {
		t.Skip("isolated MySQL required")
	}
	store, err := Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	var name string
	if err = store.DB.QueryRow("SELECT DATABASE()").Scan(&name); err != nil || (!strings.HasPrefix(name, "openkfo_debug_") && name != "kungfu_game_test") {
		t.Fatal("isolated database required")
	}
	uid := uint64(time.Now().UnixMilli())
	a, err := NewAccount(uid, fmt.Sprintf("dp%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	if err = store.Create(a); err != nil {
		t.Fatal(err)
	}
	defer store.DB.Exec("DELETE FROM accounts WHERE uid=?", uid)
	defer store.DB.Exec("DELETE FROM inventory WHERE uid=?", uid)
	key := uint32(uid)
	item := make([]byte, 68)
	item[4] = 25
	protocol.WriteUint32(item, 5, 253030)
	protocol.WriteUint16(item, 23, 1)
	if _, err = store.DB.Exec("INSERT INTO offers VALUES(?,?,?,?,?,TRUE)", key, 25, 0, make([]byte, 108), item); err != nil {
		t.Fatal(err)
	}
	if _, err = store.DB.Exec(seedDefinitionsSQL); err != nil {
		t.Fatal(err)
	}
	defer store.DB.Exec("DELETE FROM item_definitions WHERE definition_key=?", key)
	defer store.DB.Exec("DELETE FROM offers WHERE catalog_key=?", key)
	serial, err := store.BattleManager().NextBattle()
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Exec("DELETE FROM battle_settlements WHERE serial=?", serial)
	rules := RewardRules{Drops: []DropRule{{key, "win", 3, 3, 10000}}}.Normalized()
	awards := []BattleReward{{UID: uid, Outcome: "win", StartLevel: 3, Gold: 5}}
	got, err := store.BattleManager().SettleBattle(serial, []byte("{}"), awards, rules)
	if err != nil || len(got) != 1 || len(got[0].Items) != 1 {
		t.Fatal("guaranteed eligible drop failed", err)
	}
	again, err := store.BattleManager().SettleBattle(serial, []byte("{}"), awards, rules)
	if err != nil || !reflect.DeepEqual(got, again) {
		t.Fatal("retry changed award", err)
	}
	instance := protocol.ReadUint32(got[0].Items[0], 0)
	changed, err := store.EquipmentManager().EquipDefault(uid, instance, 0)
	if err != nil || protocol.ReadUint16(changed, 17) != 8 {
		t.Fatal("slot0 did not equip main weapon", err)
	}
	changed, err = store.EquipmentManager().Equip(uid, instance, 0)
	if err != nil || protocol.ReadUint16(changed, 17) != 0 {
		t.Fatal("2300 semantics changed", err)
	}
	if _, err = store.EquipmentManager().EquipDefault(uid+1, instance, 0); err == nil {
		t.Fatal("other owner equipped item")
	}
	var count int
	if err = store.DB.QueryRow("SELECT COUNT(*) FROM inventory WHERE uid=? AND instance=?", uid, instance).Scan(&count); err != nil || count != 1 {
		t.Fatal("duplicate item on settlement replay", err)
	}
}
