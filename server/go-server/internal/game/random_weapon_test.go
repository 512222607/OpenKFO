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

func TestRandomWeaponCancelImmediatelyRefreshesUI(t *testing.T) {
	_, s, _, _ := waitingRoomFixture()
	s.sendRandomWeaponOff()
	out := roomOutputs(t, s, protocol.MsgRandomWeaponCancelled, protocol.MsgRandomWeaponResult)
	if len(out[0].Payload) == 0 || len(out[1].Payload) != 68 || protocol.ReadUint32(out[1].Payload, 9) != 0 {
		t.Fatal("native cancel order/layout")
	}
}
func TestRandomWeaponTransitionAckDoesNotCancel(t *testing.T) {
	h, s, _, _ := waitingRoomFixture()
	s.RandomWeaponMode = 8
	for _, id := range []uint32{protocol.MsgRandomWeaponCancelAck, protocol.MsgRandomWeaponEquipmentQuery} {
		if e := h.randomWeapon(s, protocol.Message{ID: id}); e != nil {
			t.Fatal(e)
		}
	}
	if s.RandomWeaponMode != 8 {
		t.Fatal("UI transition cancelled saved mode")
	}
	roomOutputs(t, s)
}

func TestRandomWeaponRoomMySQL(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, e := mysql.ParseDSN(dsn)
	if e != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("independent DB required")
	}
	store, e := persistence.Open(dsn)
	if e != nil {
		t.Fatal(e)
	}
	defer store.DB.Close()
	h, s, peer, _ := waitingRoomFixture()
	h.Store = store
	a, e := persistence.NewAccountWithStarterCharacter(s.UID, fmt.Sprintf("rw%d", time.Now().UnixMicro()), "test123456")
	if e != nil {
		t.Fatal(e)
	}
	r := make([]byte, 68)
	protocol.WriteUint32(r, 0, 1)
	r[4] = 25
	protocol.WriteUint32(r, 5, 253002)
	protocol.WriteUint32(r, 13, 8760)
	a.Inventory = [][]byte{r}
	if e = store.Create(a); e != nil {
		t.Fatal(e)
	}
	defer func() {
		store.DB.Exec(`DELETE FROM inventory WHERE uid=?`, s.UID)
		store.DB.Exec(`DELETE FROM accounts WHERE uid=?`, s.UID)
	}()
	s.rememberInventory(a.Inventory)
	h.Config.RandomWeaponTypes = map[uint32]uint32{253002: 1}
	if e = h.selectRandomWeapon(s, 8, true); e != nil {
		t.Fatal(e)
	}
	replies := roomOutputs(t, s, 2161, 1158, 21422, protocol.MsgRoomRoster)
	if protocol.ReadUint32(replies[2].Payload, 9) != 25300200 || s.RandomWeaponMode != 8 {
		t.Fatal("random result")
	}
	roomOutputs(t, peer, protocol.MsgRoomRoster)
	if e = h.selectRandomWeapon(s, 8, false); e != nil {
		t.Fatal(e)
	}
	roomOutputs(t, s, 1158, 21422)
	roomOutputs(t, peer)
	request := make([]byte, 16)
	protocol.WriteUint32(request, 0, 1)
	protocol.WriteUint32(request, 4, 8)
	if e = h.route(s, s.game(), protocol.Message{ID: protocol.MsgEquipItem, Payload: request}); e != nil {
		t.Fatal(e)
	}
	roomOutputs(t, s, protocol.MsgEquipmentChanged, 21425, 21422, protocol.MsgRoomRoster)
	roomOutputs(t, peer, protocol.MsgRoomRoster)
	state, e := store.RandomWeapon(s.UID)
	if e != nil || state.Mode != 0 || s.RandomWeaponMode != 0 {
		t.Fatal("manual cancellation", e)
	}

	// Regression: package conversion grants real instances exactly once; no
	// 1531 visual expansion or duplicate 2160 entries.
	suit := make([]byte, protocol.InventoryRecordSize)
	protocol.WriteUint32(suit, 0, 2)
	suit[4] = protocol.ItemSuit
	protocol.WriteUint32(suit, 5, 180021)
	protocol.WriteUint16(suit, 23, 0)
	if _, e = store.DB.Exec(`INSERT INTO inventory(uid,instance,record) VALUES(?,?,?)`, s.UID, 2, suit); e != nil {
		t.Fatal(e)
	}
	s.Inventory[2] = suit
	h.Config.SuitBundles = map[uint32][]uint32{180021: {121158, 141158, 151158, 161158}}
	use := make([]byte, 16)
	protocol.WriteUint32(use, 0, 2)
	protocol.WriteUint32(use, 4, 4)
	if e = h.route(s, s.game(), protocol.Message{ID: protocol.MsgEquipItem, Payload: use}); e != nil {
		t.Fatal(e)
	}
	out := roomOutputs(t, s, 2160, 2160, 2160, 2160, 2090, 2162, 2090, 2090, 2090, protocol.MsgRoomRoster)
	ids := map[uint32]bool{}
	for _, m := range out {
		if m.ID == 2160 {
			id := protocol.ReadUint32(m.Payload, 0)
			if ids[id] {
				t.Fatal("duplicate grant")
			}
			ids[id] = true
		}
	}
	if len(ids) != 4 {
		t.Fatal("missing parts")
	}
	roomOutputs(t, peer, protocol.MsgRoomRoster)
	if _, e = store.EquipmentManager().OpenSuit(s.UID, 2, h.Config.SuitBundles); e == nil {
		t.Fatal("replayed package")
	}
	a, e = store.RoleManager().Snapshot(s.UID)
	if e != nil || len(a.Inventory) != 5 {
		t.Fatal("package not replaced atomically", e)
	}

}

func TestRandomWeaponTemporarilyDisabled(t *testing.T) {
	h, s, _, _ := waitingRoomFixture()
	s.RandomWeaponMode = protocol.RandomWeaponAll
	if err := h.randomWeapon(s, protocol.Message{ID: protocol.MsgRandomWeaponSet, Payload: protocol.Uint32Bytes(protocol.RandomWeaponAll)}); err != nil {
		t.Fatal(err)
	}
	if s.RandomWeaponMode != protocol.RandomWeaponOff {
		t.Fatal("random mode remains active")
	}
	out := roomOutputs(t, s, protocol.MsgRandomWeaponCancelled, protocol.MsgRandomWeaponResult, notice("").ID)
	if string(out[2].Payload) != string(notice("暂不支持随机武器").Payload) {
		t.Fatal("missing disabled notice")
	}
}
