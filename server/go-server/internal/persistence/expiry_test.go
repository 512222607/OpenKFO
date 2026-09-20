package persistence

import (
	"bytes"
	"fmt"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
	"time"
)

func TestExpiryOwnershipAndEquipmentLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("not independent debug DB")
	}
	s, err := Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer s.DB.Close()
	uid := uint64(time.Now().UnixMicro())
	a, err := NewAccountWithStarterCharacter(uid, fmt.Sprintf("ex%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	a.Inventory = nil
	for id := uint32(1); id <= 3; id++ {
		p := make([]byte, 68)
		protocol.WriteUint32(p, 0, id)
		p[4] = 25
		protocol.WriteUint32(p, 5, 253002)
		protocol.WriteUint32(p, 13, 8760)
		if id == 1 {
			protocol.WriteUint16(p, 17, 8)
		}
		a.Inventory = append(a.Inventory, p)
	}
	if err = s.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"inventory", "accounts"} {
			if _, err := s.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); err != nil {
				t.Error(err)
			}
		}
	}()
	if _, err = s.DB.Exec("INSERT INTO inventory_expirations(uid,instance,expires_at) VALUES(?,?,?),(?,?,?)", uid, 1, time.Now().Unix()-1, uid, 2, time.Now().Unix()+3600); err != nil {
		t.Fatal(err)
	}
	if _, err = s.EquipmentManager().EquipDefault(uid, 1, 0); err != ErrDenied {
		t.Fatalf("expired weapon equipped: %v", err)
	}
	first, err := s.RoleManager().Snapshot(uid)
	if err != nil {
		t.Fatal(err)
	}
	if len(first.Inventory) != 3 || protocol.ReadUint32(first.Inventory[0], 19) != 2 || protocol.ReadUint16(first.Inventory[0], 17) != 0 {
		t.Fatal("expiry must persist inactive ownership and unequip")
	}
	if !bytes.Equal(first.Inventory[1], a.Inventory[1]) || !bytes.Equal(first.Inventory[2], a.Inventory[2]) {
		t.Fatal("future/permanent items changed")
	}
	second, err := s.RoleManager().Snapshot(uid)
	if err != nil || !bytes.Equal(first.InventoryBytes(), second.InventoryBytes()) {
		t.Fatal("expiry not idempotent", err)
	}
	if _, err = s.EquipmentManager().EquipDefault(uid, 2, 0); err != nil {
		t.Fatal("future item denied", err)
	}
	if _, err = s.EquipmentManager().EquipDefault(uid, 3, 0); err != nil {
		t.Fatal("permanent item denied", err)
	}
	id := fmt.Sprintf("expiry-test-%d", uid)
	defer func() {
		if _, err := s.DB.Exec("DELETE FROM desktop_admin_operations WHERE id IN (?,?)", id, id+"-clear"); err != nil {
			t.Error(err)
		}
	}()
	deadline := time.Now().Unix() + 3600
	req := AdminRequest{Operation: "inventory_expiry", ID: id, UID: uid, Instance: 3, ExpiresAt: &deadline}
	if _, err = s.Admin(req); err != nil {
		t.Fatal(err)
	}
	if _, err = s.Admin(req); err != nil {
		t.Fatal("idempotent retry", err)
	}
	var count int
	if err = s.DB.QueryRow("SELECT COUNT(*) FROM desktop_admin_operations WHERE id=?", id).Scan(&count); err != nil || count != 1 {
		t.Fatal("audit count", err)
	}
	changed := deadline + 1
	req.ExpiresAt = &changed
	if _, err = s.Admin(req); err != ErrDenied {
		t.Fatal("reused operation accepted different request", err)
	}
	zero := int64(0)
	req.ID = id + "-clear"
	req.ExpiresAt = &zero
	if _, err = s.Admin(req); err != nil {
		t.Fatal("clear unexpired deadline", err)
	}
	if err = s.DB.QueryRow("SELECT COUNT(*) FROM inventory_expirations WHERE uid=? AND instance=3", uid).Scan(&count); err != nil || count != 0 {
		t.Fatal("not permanent", err)
	}
	for _, instance := range []uint32{1, 99} {
		req.ID = id + "-reject"
		req.Instance = instance
		req.ExpiresAt = &deadline
		if _, err = s.Admin(req); err == nil {
			t.Fatal("expired or unowned instance accepted")
		}
	}
}

func TestExpiredConsumableCannotBeSelected(t *testing.T) {
	p := make([]byte, 68)
	p[4] = 64
	protocol.WriteUint32(p, 0, 1)
	protocol.WriteUint16(p, 17, 27)
	protocol.WriteUint16(p, 23, 3)
	for _, state := range []uint32{2, 0xffffffff} {
		protocol.WriteUint32(p, 19, state)
		if _, err := (Account{Inventory: [][]byte{p}}).Consumable(1, 27); err != ErrDenied {
			t.Fatal("inactive item usable")
		}
	}
}
