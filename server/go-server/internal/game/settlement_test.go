package game

import (
	"bytes"
	"encoding/hex"
	"fmt"
	"os"
	"strings"
	"testing"
	"time"

	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
)

func settlementReport(room *Room) []byte {
	p := make([]byte, 696)
	for uid, m := range room.Members {
		r := p[int(m.Slot)*87 : int(m.Slot+1)*87]
		protocol.WriteUint64(r, 29, uid)
		protocol.WriteUint32(r, 67, uint32(room.ID))
		protocol.WriteUint32(r, 71, room.Serial)
		if m.Slot == 0 {
			protocol.WriteUint16(r, 2, 100)
		}
	}
	return p
}

func TestSettlementWireValidation(t *testing.T) {
	_, host, _, _ := combatFixture()
	room := host.Room
	valid := settlementReport(room)
	if _, err := validateBattleReport(room, valid); err != nil {
		t.Fatal(err)
	}
	for _, mutate := range []func([]byte) []byte{
		func(p []byte) []byte { return p[:695] },
		func(p []byte) []byte { protocol.WriteUint64(p, 29, 999999); return p },
		func(p []byte) []byte { protocol.WriteUint32(p, 67, uint32(room.ID)+1); return p },
		func(p []byte) []byte { protocol.WriteUint32(p, 71, room.Serial+1); return p },
		func(p []byte) []byte { protocol.WriteUint64(p, 87+29, host.UID); return p },
		func(p []byte) []byte {
			first := bytes.Clone(p[:87])
			copy(p[:87], p[87:174])
			copy(p[87:174], first)
			return p
		},
		func(p []byte) []byte { p[7*87+65] = 1; return p },
	} {
		if _, err := validateBattleReport(room, mutate(bytes.Clone(valid))); err == nil {
			t.Fatal("malformed or stale report accepted")
		}
	}
	var rewards []persistence.BattleReward
	for uid := range room.Members {
		rewards = append(rewards, persistence.BattleReward{UID: uid, Outcome: "win", Gold: 20, Experience: 10, Profile: bytes.Repeat([]byte{7}, 360)})
	}
	p := settlementPacket(room, rewards, host.UID)
	if p.ID != 4120 || len(p.Payload) != 1000 {
		t.Fatal("wrong result packet")
	}
	if protocol.ReadUint64(p.Payload, len(p.Payload)-500) != host.UID {
		t.Fatal("recipient profile must be last")
	}
	for _, r := range rewards {
		var record []byte
		for j := 0; j < len(p.Payload); j += 500 {
			if protocol.ReadUint64(p.Payload, j) == r.UID {
				record = p.Payload[j : j+500]
			}
		}
		if record == nil {
			t.Fatal("missing player result")
		}
		if protocol.ReadUint64(record, 0) != r.UID || record[10] != 1 || protocol.ReadUint32(record, 34) != 10 || protocol.ReadUint32(record, 63) != 20 || !bytes.Equal(record[140:], r.Profile) || protocol.ReadUint32(record, 21) != 0 {
			t.Fatal("result record layout")
		}
	}
}

// Captured native C4110 that disconnected localtest1 on 2026-09-18 12:53:52.
// Keep independent of settlementReport: room 1 and battle 5 must not be confused.
func TestSettlementCapturedReport(t *testing.T) {
	data, err := os.ReadFile("testdata/settlement-room1-battle5.hex")
	if err != nil {
		t.Fatal(err)
	}
	payload, err := hex.DecodeString(strings.TrimSpace(string(data)))
	if err != nil {
		t.Fatal(err)
	}
	room := &Room{ID: 1, Serial: 5, Members: map[uint64]*Member{10001: {Slot: 0}, 10002: {Slot: 1}}}
	health, err := validateBattleReport(room, payload)
	if err != nil || len(health) != 2 || health[10001] != 0 || health[10002] != 100 {
		t.Fatalf("native report rejected or misread: health=%v err=%v", health, err)
	}
	room.Serial++
	if _, err := validateBattleReport(room, payload); err == nil {
		t.Fatal("previous battle report accepted")
	}
}

func TestSettlementReportUsesActualNoncontiguousSlots(t *testing.T) {
	h, owner, peer, _ := combatFixture()
	r := owner.Room
	r.Members[owner.UID].Slot, r.Members[peer.UID].Slot = 3, 7
	p := settlementReport(r)
	if health, err := validateBattleReport(r, p); err != nil || len(health) != 2 {
		t.Fatal("valid sparse roster rejected", health, err)
	}
	// Compacting records is not the native format, even with matching identities.
	bad := make([]byte, protocol.BattleReportSize)
	copy(bad[:87], p[3*87:4*87])
	copy(bad[87:174], p[7*87:8*87])
	if err := h.settleReport(owner, bad); err == nil {
		t.Fatal("compacted report accepted")
	}
	if r.Stage != "battle" || len(r.Reports) != 0 {
		t.Fatal("invalid report began settlement")
	}
	roomOutputs(t, owner)
	roomOutputs(t, peer)
}

func TestSettlementReturnStatus(t *testing.T) {
	hub, host, peer, _ := combatFixture()
	hub.Store = recoveryStore(t)
	room := host.Room
	room.Stage = "settlement"
	host.game().Phase, peer.game().Phase = "settlement", "settlement"
	for _, p := range []*Session{host, peer} {
		payload := make([]byte, 12)
		protocol.WriteUint64(payload, 0, p.UID)
		roomRequest(t, hub, p, 3550, payload)
		for _, receiver := range []*Session{host, peer} {
			messages := roomOutputs(t, receiver, 3550)
			if !bytes.Equal(messages[0].Payload, payload) {
				t.Fatal("return status not broadcast to every member")
			}
		}
		if p.game().Phase != "room" || p.Room != room || room.Stage != "room" {
			t.Fatal("native return did not preserve room and restore phase")
		}
		if p == host && peer.game().Phase != "settlement" {
			t.Fatal("return must not confirm another player's result")
		}
		// Delayed result acknowledgments must not restore 'viewing results'.
		protocol.WriteUint32(payload, 8, 3)
		roomRequest(t, hub, p, 3550, payload)
		roomOutputs(t, host)
		roomOutputs(t, peer)
	}
}

func TestSettlementMySQLLifecycle(t *testing.T) {
	dsn := os.Getenv("KK_TEST_MYSQL_DSN")
	if dsn == "" {
		t.Skip("isolated MySQL required")
	}
	store, err := persistence.Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	var database string
	if err = store.DB.QueryRow("SELECT DATABASE()").Scan(&database); err != nil || (!strings.HasPrefix(database, "openkfo_debug_") && database != "kungfu_game_test") {
		t.Fatal("isolated database required")
	}
	hub := NewHub(store, Config{Settlement: SettlementRewards{WinGold: 5, LossGold: 2, WinExperience: 10, LossExperience: 5}})
	settings, err := store.RewardManager().BattleRewards(hub.Config.Settlement)
	if err != nil {
		t.Fatal(err)
	}
	rules := settings.Rules.AtLevel(1)
	serial, err := store.BattleManager().NextBattle()
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Exec("DELETE FROM battle_settlements WHERE serial=?", serial)
	room := &Room{ID: 1, Serial: serial, Stage: "battle", Request: make([]byte, 81), Members: map[uint64]*Member{}}
	room.Request[37] = 4
	room.Request[46] = 1
	hub.Rooms[1] = room
	var players []*Session
	for i := 0; i < 2; i++ {
		uid := uint64(time.Now().UnixMilli()) + uint64(i)
		a, err := persistence.NewAccountWithStarterCharacter(uid, fmt.Sprintf("st%d", uid), "test123456")
		if err != nil {
			t.Fatal(err)
		}
		protocol.WriteUint32(a.Profile, persistence.ExperienceOffset, 40)
		protocol.WriteUint32(a.Profile, persistence.ExperienceOffset+4, 123)
		if err = store.Create(a); err != nil {
			t.Fatal(err)
		}
		defer func(id uint64) {
			store.DB.Exec("DELETE FROM inventory WHERE uid=?", id)
			store.DB.Exec("DELETE FROM accounts WHERE uid=?", id)
		}(uid)
		s := &Session{UID: uid, Room: room, Bound: true, GameChannel: 1, Channels: map[uint32]*Channel{1: {ID: 1, Kind: "game", Phase: "battle"}}, Output: make(chan tunnel.Frame, 64), Done: make(chan struct{})}
		s.Inventory = map[uint32][]byte{}
		for _, item := range a.Inventory {
			s.Inventory[protocol.ReadUint32(item, 0)] = bytes.Clone(item)
		}
		room.Members[uid] = &Member{Session: s, Slot: byte(i), Spawn: byte(i), Team: byte(i), Ready: true}
		players = append(players, s)
	}
	room.Owner = players[0].UID
	report := settlementReport(room)
	if err = hub.settleReport(players[1], report); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, players[0], 4100)
	roomOutputs(t, players[1])
	if err = hub.settleReport(players[0], report); err != nil {
		t.Fatal(err)
	}
	for _, p := range players {
		messages := roomOutputs(t, p, 4300, 1240, 4120)
		wantXP, wantGold := 40+rules.WinExperience, rules.WinGold
		if p == players[1] {
			wantXP, wantGold = 40+rules.LossExperience, rules.LossGold
		}
		if protocol.ReadUint32(messages[0].Payload, 0) != wantXP || protocol.ReadUint32(messages[0].Payload, 4) != 123+(wantXP-40) || protocol.ReadUint32(messages[1].Payload, 0) != wantGold {
			t.Fatal("absolute experience or balance update incorrect")
		}
	}
	if room.Stage != "settlement" {
		t.Fatal("settlement stage missing")
	}
	if err = hub.settleReport(players[0], report); err != nil {
		t.Fatal(err)
	}
	for _, p := range players {
		roomOutputs(t, p)
	}
	// A persistence retry after a process restart also cannot grant twice.
	if _, err = store.BattleManager().SettleBattle(serial, nil, []persistence.BattleReward{{UID: players[0].UID, Gold: 999}}); err != nil {
		t.Fatal(err)
	}
	for i, p := range players {
		a, err := store.RoleManager().Snapshot(p.UID)
		if err != nil {
			t.Fatal(err)
		}
		want := rules.WinGold
		if i == 1 {
			want = rules.LossGold
		}
		if a.Gold != want {
			t.Fatalf("duplicate reward: gold=%d want=%d", a.Gold, want)
		}
		wantXP := 40 + rules.WinExperience
		if i == 1 {
			wantXP = 40 + rules.LossExperience
		}
		if protocol.ReadUint32(a.Profile, persistence.ExperienceOffset) != wantXP || protocol.ReadUint32(a.Profile, persistence.ExperienceOffset+4) != 123+(wantXP-40) {
			t.Fatal("experience duplicated or adjacent field overwritten")
		}
	}
	if err = hub.returnFromSettlement(players[0]); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, players[0], 3115, 3100, 3160, 3105)
	roomOutputs(t, players[1], 3090)
	if err = hub.returnFromSettlement(players[1]); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, players[1], 3115, 3100, 3160, 3105)
	roomOutputs(t, players[0], 3090)
	for _, p := range players {
		if p.Room != room || p.game().Phase != "room" || room.Members[p.UID].Ready {
			t.Fatal("return lost membership/readiness")
		}
	}
}
