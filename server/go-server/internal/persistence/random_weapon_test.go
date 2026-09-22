package persistence

import (
	"fmt"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
	"time"
)

func randomTestRecord(instance, item uint32, slot uint16) []byte {
	r := make([]byte, protocol.InventoryRecordSize)
	protocol.WriteUint32(r, 0, instance)
	r[4] = protocol.ItemWeapon
	protocol.WriteUint32(r, 5, item)
	protocol.WriteUint16(r, 17, slot)
	protocol.WriteUint32(r, 13, 8760)
	return r
}
func TestRandomWeaponCandidates(t *testing.T) {
	types := map[uint32]uint32{253002: 1}
	for _, tc := range []struct {
		mode  uint32
		slot  uint16
		state uint32
		want  bool
	}{{1, 0, 0, true}, {2, 0, 0, false}, {8, 8, 1, true}, {8, 9, 1, false}, {8, 0, 2, false}, {8, 0, 0xffffffff, false}, {0, 0, 0, false}, {9, 0, 0, false}} {
		r := randomTestRecord(1, 253002, tc.slot)
		protocol.WriteUint32(r, 19, tc.state)
		if got := randomWeaponEligible(r, tc.mode, types); got != tc.want {
			t.Fatalf("%+v: %t", tc, got)
		}
	}
	if randomWeaponEligible(nil, 8, types) || randomWeaponEligible(randomTestRecord(1, 999999, 0), 8, types) {
		t.Fatal("unknown item admitted")
	}
}
func TestRandomWeaponLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, e := mysql.ParseDSN(dsn)
	if e != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("independent DB required")
	}
	s, e := Open(dsn)
	if e != nil {
		t.Fatal(e)
	}
	defer s.DB.Close()
	uid := uint64(time.Now().UnixMicro())
	a, e := NewAccountWithStarterCharacter(uid, fmt.Sprintf("rw%d", uid), "test123456")
	if e != nil {
		t.Fatal(e)
	}
	a.Inventory = [][]byte{randomTestRecord(1, 253002, 0), randomTestRecord(2, 253003, 9), randomTestRecord(3, 253004, 0)}
	protocol.WriteUint32(a.Inventory[2], 19, 2)
	if e = s.Create(a); e != nil {
		t.Fatal(e)
	}
	defer func() {
		s.DB.Exec(`DELETE FROM inventory WHERE uid=?`, uid)
		s.DB.Exec(`DELETE FROM accounts WHERE uid=?`, uid)
	}()
	types := map[uint32]uint32{253002: 1, 253003: 2, 253004: 3}
	r, e := s.SelectRandomWeapon(uid, 8, types, true)
	if e != nil || protocol.ReadUint32(r, 0) != 1 {
		t.Fatal("owned usable primary candidate", e)
	}
	other, e := OpenExisting(dsn)
	if e != nil {
		t.Fatal(e)
	}
	defer other.DB.Close()
	state, e := other.RandomWeapon(uid)
	if e != nil || state.Mode != 8 || state.Instance != 1 {
		t.Fatal("persisted mode", state, e)
	}
	if _, e = s.SelectRandomWeapon(uid, 2, types, true); e != ErrDenied {
		t.Fatal("secondary slot admitted", e)
	}
	state, _ = s.RandomWeapon(uid)
	if state.Mode != 8 {
		t.Fatal("rejected selection overwrote mode")
	}
	if _, e = s.EquipmentManager().EquipDefault(uid, 999999, 0); e != ErrDenied {
		t.Fatal("unowned equip", e)
	}
	state, _ = s.RandomWeapon(uid)
	if state.Mode != 8 {
		t.Fatal("failed equip cleared mode")
	}
	if _, e = s.EquipmentManager().EquipDefault(uid, 1, 0); e != nil {
		t.Fatal(e)
	}
	state, e = s.RandomWeapon(uid)
	if e != nil || state.Mode != 0 {
		t.Fatal("manual equip did not clear mode", e)
	}
}
