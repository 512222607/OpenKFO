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

func TestInventoryOwnershipIndependentDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug database required")
	}
	c, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(c.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug DB")
	}
	store, err := persistence.Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { store.DB.Close() })
	h := NewHub(store, Config{})
	base := uint64(time.Now().UnixMicro())
	var sessions []*Session
	for i := 0; i < 2; i++ {
		a, err := persistence.NewAccountWithStarterCharacter(base+uint64(i), fmt.Sprintf("iv%d", base+uint64(i)), "test123456")
		if err != nil {
			t.Fatal(err)
		}
		a.Inventory = nil
		if err = store.Create(a); err != nil {
			t.Fatal(err)
		}
		t.Cleanup(func() {
			for _, table := range []string{"consumption_events", "inventory"} {
				if _, err := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", a.UID); err != nil {
					t.Error(err)
				}
			}
			if _, err := store.DB.Exec("DELETE FROM accounts WHERE uid=?", a.UID); err != nil {
				t.Error(err)
			}
		})
		s, err := h.Attach(a, 19091)
		if err != nil {
			t.Fatal(err)
		}
		s.GameChannel = 1
		s.Channels[1] = &Channel{ID: 1, Kind: "game", Phase: "room"}
		sessions = append(sessions, s)
	}
	s, peer := sessions[0], sessions[1]
	r := &Room{ID: 1, Serial: 1, Stage: "room", Members: map[uint64]*Member{s.UID: {Session: s}, peer.UID: {Session: peer}}}
	s.Room, peer.Room = r, r
	insert := func(uid uint64, instance uint32, kind byte, slot uint16) {
		p := make([]byte, protocol.InventoryRecordSize)
		protocol.WriteUint32(p, 0, instance)
		p[4] = kind
		protocol.WriteUint16(p, 17, slot)
		protocol.WriteUint16(p, 23, 1)
		if _, err := store.DB.Exec("INSERT INTO inventory VALUES(?,?,?)", uid, instance, p); err != nil {
			t.Fatal(err)
		}
	}
	insert(peer.UID, 743001, protocol.ItemWeapon, 0)
	for _, instance := range []uint32{743001, 743002} {
		p := make([]byte, 16)
		protocol.WriteUint32(p, 0, instance)
		protocol.WriteUint32(p, 4, uint32(protocol.SlotPrimaryWeapon))
		if err := h.route(s, s.game(), protocol.Message{ID: protocol.MsgEquipItem, Payload: p}); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, s)
		roomOutputs(t, peer)
	}
	r.Stage, s.game().Phase, peer.game().Phase = "battle", "battle", "battle"
	insert(peer.UID, 743003, protocol.ItemConsumable, protocol.SlotPrimaryConsumable)
	for _, instance := range []uint32{743003, 743004} {
		if err := h.consume(s, s.game(), protocol.Message{ID: 4200, Payload: protocol.Uint32Bytes(instance)}); err != nil {
			t.Fatal(err)
		}
		if s.ConsumeIntents[instance] {
			t.Fatal("foreign or missing item admitted")
		}
	}
	use := make([]byte, 75)
	protocol.WriteUint32(use, 0, 8289)
	protocol.WriteUint64(use, 4, s.UID)
	use[12], use[13] = 1, 1
	protocol.WriteUint32(use, 19, 1)
	protocol.WriteUint32(use, 39, uint32(protocol.SlotPrimaryConsumable))
	protocol.WriteUint64(use, 59, s.UID)
	protocol.WriteUint32(use, 67, uint32(r.ID))
	protocol.WriteUint32(use, 71, r.Serial)
	consume := func() {
		if err := h.consume(s, s.game(), protocol.Message{ID: 8289, Payload: use}); err != nil {
			t.Fatal(err)
		}
	}
	consume() // Empty slot cannot use the peer's consumable.
	roomOutputs(t, s)
	roomOutputs(t, peer)
	insert(s.UID, 743005, protocol.ItemConsumable, protocol.SlotPrimaryConsumable)
	consume() // Owned item still requires a valid use intent.
	roomOutputs(t, s)
	roomOutputs(t, peer)
	if err := h.consume(s, s.game(), protocol.Message{ID: 4200, Payload: protocol.Uint32Bytes(743005)}); err != nil {
		t.Fatal(err)
	}
	consume()
	roomOutputs(t, s, 4210)
	roomOutputs(t, peer, 8289)
	consume() // Receipt retry must not apply or deduct twice.
	roomOutputs(t, s, 4210)
	roomOutputs(t, peer)
	var record []byte
	if err := store.DB.QueryRow("SELECT record FROM inventory WHERE uid=? AND instance=?", s.UID, 743005).Scan(&record); err != nil {
		t.Fatal(err)
	}
	if protocol.ReadUint16(record, 23) != 0 {
		t.Fatal("incorrect debit")
	}
}
