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

func TestTalismanRepairProtocolLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug DB")
	}
	store, err := persistence.Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	store.DB.SetMaxOpenConns(1)
	store.DB.SetMaxIdleConns(1)
	if _, err = store.DB.Exec("CREATE TEMPORARY TABLE talisman_rules(id TINYINT PRIMARY KEY,revision BIGINT UNSIGNED NOT NULL,rules MEDIUMBLOB NOT NULL) ENGINE=InnoDB"); err != nil {
		t.Fatal(err)
	}
	uid := uint64(time.Now().UnixMicro())
	a, err := persistence.NewAccount(uid, fmt.Sprintf("tr%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	a.Inventory = nil
	for i, kind := range []byte{30, 60} {
		p := make([]byte, 68)
		p[4] = kind
		protocol.WriteUint32(p, 0, uint32(i+1))
		protocol.WriteUint32(p, 5, []uint32{303002, 603001}[i])
		protocol.WriteUint32(p, 13, 8760)
		protocol.WriteUint16(p, 23, []uint16{5, 3}[i])
		a.Inventory = append(a.Inventory, p)
	}
	if err = store.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"talisman_uses", "talisman_repairs", "inventory", "accounts"} {
			if _, e := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); e != nil {
				t.Error(e)
			}
		}
	}()
	h := NewHub(store, Config{TalismanRepairs: []persistence.TalismanRepairRule{{Item: 303002, Material: 603001, Quantity: 3, Capacity: 10000}}})
	rules := persistence.TalismanRules{Enabled: true, Repairs: h.Config.TalismanRepairs, Uses: []persistence.TalismanUseRule{{Item: 303002, ActiveCost: 4000, PassiveCost: 1000}}}
	if err = store.SeedTalismanSettings(rules); err != nil {
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
	send := func(id uint32, p []byte) {
		t.Helper()
		if e := h.route(s, s.game(), protocol.Message{ID: id, Payload: p}); e != nil {
			t.Fatal(e)
		}
	}
	unquoted := make([]byte, 12)
	protocol.WriteUint32(unquoted, 0, 1)
	protocol.WriteUint32(unquoted, 4, 603001)
	send(4204, unquoted)
	roomOutputs(t, s, 20150)

	send(4202, protocol.Uint32Bytes(999))
	roomOutputs(t, s, 20150)
	send(4202, protocol.Uint32Bytes(1))
	q := roomOutputs(t, s, 4203)[0].Payload
	if len(q) != 32 || protocol.ReadUint32(q, 0) != 1 || protocol.ReadUint32(q, 4) != 303002 || protocol.ReadUint32(q, 8) != 603001 || protocol.ReadUint32(q, 16) != 3 || protocol.ReadUint32(q, 20) != 5 || protocol.ReadUint32(q, 24) != 10000 {
		t.Fatal("invalid quote")
	}
	p := make([]byte, 12)
	protocol.WriteUint32(p, 0, 1)
	protocol.WriteUint32(p, 4, 603002)
	send(4204, p)
	roomOutputs(t, s, 20150)
	protocol.WriteUint32(p, 4, 603001)
	if _, err = store.DB.Exec("UPDATE talisman_rules SET revision=2"); err != nil {
		t.Fatal(err)
	}
	send(4204, p)
	roomOutputs(t, s, 20150)
	if _, err = store.RepairTalismanConfigured(uid, "stale", 1, rules.Repairs[0], 1); err == nil {
		t.Fatal("stale transactional quote accepted")
	}
	badRule := rules.Repairs[0]
	badRule.Quantity = 1
	if _, err = store.RepairTalismanConfigured(uid, "tampered", 1, badRule, 2); err == nil {
		t.Fatal("altered price accepted")
	}
	before, e := store.Snapshot(uid)
	if e != nil || len(before.Inventory) != 2 || protocol.ReadUint16(before.Inventory[0], 23) != 5 || protocol.ReadUint16(before.Inventory[1], 23) != 3 {
		t.Fatal("rejected quote changed inventory", e)
	}
	send(4202, protocol.Uint32Bytes(1))
	roomOutputs(t, s, 4203)

	send(4204, p)
	out := roomOutputs(t, s, 2161, 2162, 4205)
	if protocol.ReadUint16(out[0].Payload, 23) != 10000 || protocol.ReadUint32(out[1].Payload, 0) != 2 || protocol.ReadUint32(out[2].Payload, 4) != 0 {
		t.Fatal("repair synchronization")
	}
	send(4204, p)
	roomOutputs(t, s, 4205)
	s.game().Sequence++
	send(4204, p)
	roomOutputs(t, s, 20150)
	state, e := store.Snapshot(uid)
	if e != nil || len(state.Inventory) != 1 || protocol.ReadUint16(state.Inventory[0], 23) != 10000 {
		t.Fatal("repair was not atomic", e)
	}
	var count int
	if e = store.DB.QueryRow("SELECT COUNT(*) FROM talisman_repairs WHERE uid=?", uid).Scan(&count); e != nil || count != 1 {
		t.Fatal("duplicate receipt", e)
	}
	// Continue through real Hub battle routing with a receiver in the same room.
	if _, e = store.EquipDefault(uid, 1, 37); e != nil {
		t.Fatal(e)
	}
	_, _, peer, outsider := combatFixture()
	room := &Room{ID: 1, Serial: 7, Stage: "battle", Members: map[uint64]*Member{}}
	room.Members[uid] = &Member{Session: s, Slot: 0}
	room.Members[peer.UID] = &Member{Session: peer, Slot: 1}
	s.Room = room
	peer.Room = room
	s.game().Phase = "battle"
	h.Config.TalismanUses = []TalismanUseRule{{Item: 303002, ActiveCost: 4000, PassiveCost: 1000}}
	confirm := make([]byte, 8)
	protocol.WriteUint32(confirm, 0, 1)
	protocol.WriteUint32(confirm, 4, 0xffffffff) // Never trust the reported cost.
	send(4201, confirm)
	roomOutputs(t, s)
	roomOutputs(t, peer)
	event := make([]byte, 75)
	protocol.WriteUint32(event, 0, 8292)
	protocol.WriteUint64(event, 4, uid)
	protocol.WriteUint32(event, 19, 1)
	protocol.WriteUint32(event, 39, 37)
	protocol.WriteUint64(event, 59, uid)
	protocol.WriteUint32(event, 67, 1)
	protocol.WriteUint32(event, 71, 7)
	use := func(want uint32, relay bool) {
		t.Helper()
		send(8071, event)
		roomOutputs(t, s)
		roomOutputs(t, peer)
		send(4201, confirm)
		r := roomOutputs(t, s, 4206)[0].Payload
		if len(r) != 12 || protocol.ReadUint32(r, 0) != 1 || protocol.ReadUint32(r, 4) != want {
			t.Fatal("wrong quota response")
		}
		if relay {
			roomOutputs(t, peer, 8071)
		} else {
			roomOutputs(t, peer)
		}
		roomOutputs(t, outsider)
	}
	use(6000, true)
	use(6000, false)
	protocol.WriteUint32(event, 19, 2)
	use(2000, true)
	protocol.WriteUint32(event, 0, 8291)
	protocol.WriteUint32(event, 19, 3)
	use(1000, true)
	protocol.WriteUint32(event, 19, 4)
	use(1000, true)  // New passive application, no second charge.
	use(1000, false) // Exact duplicate has neither debit nor relay.
	protocol.WriteUint32(event, 19, 3)
	send(8071, event)
	send(4201, confirm)
	roomOutputs(t, s)
	roomOutputs(t, peer)
	protocol.WriteUint32(event, 0, 8292)
	protocol.WriteUint32(event, 19, 5)
	send(8071, event)
	send(4201, confirm)
	refused := roomOutputs(t, s, 4207)[0].Payload
	if protocol.ReadUint32(refused, 0) != 1 || protocol.ReadUint32(refused, 4) != 303002 {
		t.Fatal("wrong insufficient notification")
	}
	roomOutputs(t, peer)
	state, e = store.Snapshot(uid)
	if e != nil || protocol.ReadUint16(state.Inventory[0], 23) != 1000 {
		t.Fatal("battle debit", e)
	}
	// Pending events cannot cross a battle serial transition.
	send(8071, event)
	room.Serial++
	send(4201, confirm)
	roomOutputs(t, s)
	roomOutputs(t, peer)
	s.Room = nil

}
