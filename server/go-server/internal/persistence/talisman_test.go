package persistence

import (
	"fmt"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"sync"
	"testing"
	"time"
)

func TestTalismanEquipmentLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, e := mysql.ParseDSN(dsn)
	if e != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug DB")
	}
	s, e := Open(dsn)
	if e != nil {
		t.Fatal(e)
	}
	defer s.DB.Close()
	uid := uint64(time.Now().UnixMicro())
	a, e := NewAccount(uid, fmt.Sprintf("te%d", uid), "test123456")
	if e != nil {
		t.Fatal(e)
	}
	a.Inventory = nil
	for i, id := range []uint32{303002, 303110} {
		p := make([]byte, 68)
		p[4] = 30
		protocol.WriteUint32(p, 0, uint32(i+1))
		protocol.WriteUint32(p, 5, id)
		protocol.WriteUint32(p, 13, 8760)
		a.Inventory = append(a.Inventory, p)
	}
	if e = s.Create(a); e != nil {
		t.Fatal(e)
	}
	defer func() {
		for _, table := range []string{"talisman_uses", "talisman_repairs", "inventory_expirations", "inventory", "accounts"} {
			if _, e := s.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); e != nil {
				t.Error(e)
			}
		}
	}()
	for _, slot := range []uint16{0, 8, 36, 39, 42} {
		if _, e = s.EquipmentManager().EquipDefault(uid, 1, slot); e != ErrDenied {
			t.Fatalf("unverified slot %d accepted: %v", slot, e)
		}
	}
	if _, e = s.EquipmentManager().EquipDefault(uid+1, 1, 37); e == nil {
		t.Fatal("foreign equip accepted")
	}
	for _, instance := range []uint32{1, 2} {
		p, e := s.EquipmentManager().EquipDefault(uid, instance, 37)
		if e != nil || protocol.ReadUint16(p, 17) != 37 {
			t.Fatal("talisman equip", e)
		}
	}
	state, e := s.RoleManager().Snapshot(uid)
	if e != nil {
		t.Fatal(e)
	}
	for _, p := range state.Inventory {
		want := uint16(0)
		if protocol.ReadUint32(p, 0) == 2 {
			want = 37
		}
		if protocol.ReadUint16(p, 17) != want {
			t.Fatal("replaced talisman retained slot")
		}
	}
	if _, e = s.EquipmentManager().EquipDefault(uid, 1, 38); e != nil {
		t.Fatal("second talisman slot", e)
	}
	state, e = s.RoleManager().Snapshot(uid)
	if e != nil {
		t.Fatal(e)
	}
	for _, item := range state.Inventory {
		want := uint16(37)
		if protocol.ReadUint32(item, 0) == 1 {
			want = 38
		}
		if protocol.ReadUint16(item, 17) != want {
			t.Fatal("second slot replaced first")
		}
	}
	p, e := s.EquipmentManager().Equip(uid, 2, 0)
	if e != nil || protocol.ReadUint16(p, 17) != 0 {
		t.Fatal("unequip", e)
	}
	// Repair consumes material across stacks and fills inventory's native quota.
	for i, count := range []uint16{2, 3} {
		m := make([]byte, 68)
		m[4] = 60
		protocol.WriteUint32(m, 0, uint32(i+3))
		protocol.WriteUint32(m, 5, 603001)
		protocol.WriteUint16(m, 23, count)
		if _, e = s.DB.Exec(`INSERT INTO inventory(uid,instance,record) VALUES(?,?,?)`, uid, i+3, m); e != nil {
			t.Fatal(e)
		}
	}
	rule := TalismanRepairRule{Item: 303110, Material: 603001, Quantity: 4, Capacity: 10000}
	for i := 0; i < 2; i++ {
		item, e := s.ItemManager().RepairTalisman(uid, "repair-once", 2, rule)
		if e != nil || protocol.ReadUint16(item, 23) != 10000 {
			t.Fatal("repair/replay", e)
		}
	}
	state, e = s.RoleManager().Snapshot(uid)
	if e != nil {
		t.Fatal(e)
	}
	var remaining uint16
	for _, item := range state.Inventory {
		if item[4] == 60 {
			remaining += protocol.ReadUint16(item, 23)
		}
	}
	if remaining != 1 {
		t.Fatal("wrong material consumption", remaining)
	}
	// Simulate subsequent use. Retrying the old operation must not restore quota.
	for _, item := range state.Inventory {
		if protocol.ReadUint32(item, 0) == 2 {
			protocol.WriteUint16(item, 23, 5)
			if _, e = s.DB.Exec(`UPDATE inventory SET record=? WHERE uid=? AND instance=2`, item, uid); e != nil {
				t.Fatal(e)
			}
		}
	}
	item, e := s.ItemManager().RepairTalisman(uid, "repair-once", 2, rule)
	if e != nil || protocol.ReadUint16(item, 23) != 5 {
		t.Fatal("replay refilled quota", e)
	}
	if _, e = s.ItemManager().RepairTalisman(uid, "insufficient", 2, rule); e != ErrDenied {
		t.Fatal("insufficient materials", e)
	}
	bad := rule
	bad.Quantity = 1
	if _, e = s.ItemManager().RepairTalisman(uid, "repair-once", 2, bad); e != ErrDenied {
		t.Fatal("mutated operation admitted", e)
	}
	if _, e = s.ItemManager().RepairTalisman(uid+1, "foreign", 2, rule); e == nil {
		t.Fatal("foreign repair")
	}
	use := TalismanUse{Instance: 2, Item: 303110, Kind: 8292, Slot: 37, Cost: 2}
	if _, _, e = s.ItemManager().UseTalisman(uid, "unequipped", use); e != ErrDenied {
		t.Fatal("unequipped use", e)
	}
	if _, e = s.EquipmentManager().EquipDefault(uid, 2, 37); e != nil {
		t.Fatal(e)
	}
	// Two simultaneous deliveries of one event must commit only one debit.
	type result struct {
		applied bool
		err     error
	}
	results := make(chan result, 2)
	var wg sync.WaitGroup
	for i := 0; i < 2; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			_, applied, err := s.ItemManager().UseTalisman(uid, "use-once", use)
			results <- result{applied, err}
		}()
	}
	wg.Wait()
	close(results)
	commits := 0
	for r := range results {
		if r.err != nil {
			t.Fatal(r.err)
		}
		if r.applied {
			commits++
		}
	}
	if commits != 1 {
		t.Fatal("duplicate debit", commits)
	}
	item, applied, e := s.ItemManager().UseTalisman(uid, "use-next", use)
	if e != nil || !applied || protocol.ReadUint16(item, 23) != 1 {
		t.Fatal("wrong quota", e)
	}
	item, applied, e = s.ItemManager().UseTalisman(uid, "use-once", use)
	if e != nil || applied || protocol.ReadUint16(item, 23) != 1 {
		t.Fatal("replay restored quota", e)
	}
	if _, _, e = s.ItemManager().UseTalisman(uid, "insufficient-use", use); e != ErrTalismanQuota {
		t.Fatal("quota underflow", e)
	}
	changed := use
	changed.Cost = 1
	item, applied, e = s.ItemManager().UseTalisman(uid, "use-once", changed)
	if e != nil || applied || protocol.ReadUint16(item, 23) != 1 {
		t.Fatal("repriced replay changed quota", e)
	}
	changed.Kind = 8291
	if _, _, e = s.ItemManager().UseTalisman(uid, "use-once", changed); e != ErrDenied {
		t.Fatal("event kind substitution accepted", e)
	}
	changed = use
	if _, _, e = s.ItemManager().UseTalisman(uid+1, "foreign-use", use); e == nil {
		t.Fatal("foreign use")
	}
	changed.Slot = 38
	if _, _, e = s.ItemManager().UseTalisman(uid, "wrong-slot", changed); e != ErrDenied {
		t.Fatal("wrong slot", e)
	}
	changed = use
	changed.Cost = 0
	changed.Kind = 8291
	item, applied, e = s.ItemManager().UseTalisman(uid, "free-passive", changed)
	if e != nil || !applied || protocol.ReadUint16(item, 23) != 1 {
		t.Fatal("zero-cost passive", e)
	}
	if _, e = s.DB.Exec(`INSERT INTO inventory_expirations(uid,instance,expires_at) VALUES(?,?,?)`, uid, 2, time.Now().Unix()-1); e != nil {
		t.Fatal(e)
	}
	if _, _, e = s.ItemManager().UseTalisman(uid, "free-passive", changed); e != ErrDenied {
		t.Fatal("expired passive replay", e)
	}

}
