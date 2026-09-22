package game

import (
	"bytes"
	"fmt"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"os"
	"testing"
	"time"
)

func TestObserverSettlementMySQL(t *testing.T) {
	dsn := os.Getenv("KK_TEST_MYSQL_DSN")
	if dsn == "" {
		t.Skip("isolated MySQL required")
	}
	store, err := persistence.Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	var dbName string
	if err = store.DB.QueryRow("SELECT DATABASE()").Scan(&dbName); err != nil || dbName != "kungfu_game_test" {
		t.Fatal("isolated test database required")
	}
	h := NewHub(store, Config{Settlement: SettlementRewards{WinGold: 5, LossGold: 2, WinExperience: 10, LossExperience: 5}})
	serial, err := store.BattleManager().NextBattle()
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Exec("DELETE FROM battle_settlements WHERE serial=?", serial)
	r := &Room{ID: 1, Serial: serial, Stage: "battle", Request: make([]byte, 81), Members: map[uint64]*Member{}}
	r.Request[46] = byte(protocol.TeamSurvival)
	h.Rooms[1] = r
	base := uint64(time.Now().UnixMilli())
	var players []*Session
	for i := 0; i < 3; i++ {
		a, err := persistence.NewAccountWithStarterCharacter(base+uint64(i), fmt.Sprintf("ob%d", base+uint64(i)), "test123456")
		if err != nil {
			t.Fatal(err)
		}
		a.Gold, a.Tickets = 17, 23
		if err = store.Create(a); err != nil {
			t.Fatal(err)
		}
		defer func(uid uint64) {
			store.DB.Exec("DELETE FROM inventory WHERE uid=?", uid)
			store.DB.Exec("DELETE FROM accounts WHERE uid=?", uid)
		}(a.UID)
		s := &Session{UID: a.UID, Room: r, GameChannel: 1, Channels: map[uint32]*Channel{1: {ID: 1, Kind: "game", Phase: "battle"}}, Output: make(chan tunnel.Frame, 64), Done: make(chan struct{})}
		m := &Member{Session: s, Slot: byte(i), Team: byte(i % 2), BattleLevel: 1}
		if i == 2 {
			m.Spectator = true
			m.Slot = spectatorSlot
			m.Spawn = spectatorSlot
		}
		r.Members[s.UID] = m
		players = append(players, s)
	}
	r.Owner = players[0].UID
	observer := players[2]
	before, err := store.RoleManager().Snapshot(observer.UID)
	if err != nil {
		t.Fatal(err)
	}
	report := settlementReport(r)
	if err = h.settleReport(observer, report); err != nil {
		t.Fatal(err)
	}
	if len(r.Reports) != 0 {
		t.Fatal("observer submitted vote")
	}
	if err = h.settleReport(players[0], report); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, observer)
	roomOutputs(t, players[1], 4100)
	if err = h.settleReport(players[1], report); err != nil {
		t.Fatal(err)
	}
	result := roomOutputs(t, observer, 4120)[0]
	if len(result.Payload) != 1000 {
		t.Fatal("observer added to reward roster")
	}
	for o := 0; o < len(result.Payload); o += 500 {
		if !bytes.Equal(result.Payload[o+140:o+500], make([]byte, 360)) {
			t.Fatal("foreign profile leaked")
		}
	}
	after, err := store.RoleManager().Snapshot(observer.UID)
	if err != nil {
		t.Fatal(err)
	}
	if after.Gold != before.Gold || after.Tickets != before.Tickets || !bytes.Equal(after.Profile, before.Profile) {
		t.Fatal("observer earned reward")
	}
	for _, s := range players {
		if err = h.settleReport(s, report); err != nil {
			t.Fatal(err)
		}
	}
	roomOutputs(t, observer)
	if r.Stage != "settlement" {
		t.Fatal("round did not settle")
	}
}
