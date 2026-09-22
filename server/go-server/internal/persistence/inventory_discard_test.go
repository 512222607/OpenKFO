package persistence

import (
	"bytes"
	"errors"
	"fmt"
	"os"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/protocol"
)

func TestDiscardIndependentDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug database required")
	}
	c, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(c.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug DB")
	}
	s, err := Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer s.DB.Close()
	uid := uint64(time.Now().UnixMicro())
	a, err := NewAccountWithStarterCharacter(uid, fmt.Sprintf("ds%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	a.Inventory = nil
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
	makeItem := func(id uint32, kind byte, slot uint16) []byte {
		r := make([]byte, 68)
		protocol.WriteUint32(r, 0, id)
		r[4] = kind
		protocol.WriteUint32(r, 5, 303118)
		protocol.WriteUint16(r, 17, slot)
		protocol.WriteUint16(r, 23, 10000)
		return r
	}
	insert := func(r []byte) {
		if _, err := s.DB.Exec("INSERT INTO inventory VALUES(?,?,?)", uid, protocol.ReadUint32(r, 0), r); err != nil {
			t.Fatal(err)
		}
	}
	pet := makeItem(100, 30, 0)
	insert(pet)
	insert(makeItem(101, 30, 37))
	insert(makeItem(102, 25, 0))
	insert(makeItem(103, 73, 0))
	bad := makeItem(104, 30, 0)
	protocol.WriteUint32(bad, 19, 99)
	insert(bad)
	for _, id := range []uint32{0, 99, 101, 102, 103, 104} {
		if err := s.InventoryManager().Discard(uid, id); !errors.Is(err, ErrDenied) {
			t.Fatalf("accepted invalid %d: %v", id, err)
		}
	}
	other, err := NewAccountWithStarterCharacter(uid+1, fmt.Sprintf("ds%d", uid+1), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	other.Inventory = nil
	if err = s.Create(other); err != nil {
		t.Fatal(err)
	}
	defer s.DB.Exec("DELETE FROM accounts WHERE uid=?", uid+1)
	if err = s.InventoryManager().Discard(uid+1, 100); !errors.Is(err, ErrDenied) {
		t.Fatal("cross-owner discard", err)
	}
	var before []byte
	if err = s.DB.QueryRow("SELECT record FROM inventory WHERE uid=? AND instance=100", uid).Scan(&before); err != nil || !bytes.Equal(before, pet) {
		t.Fatal("foreign request mutated item", err)
	}
	if _, err = s.DB.Exec("INSERT INTO inventory_expirations(uid,instance,expires_at) VALUES(?,?,?)", uid, 100, time.Now().Unix()+3600); err != nil {
		t.Fatal(err)
	}
	var wg sync.WaitGroup
	results := make(chan error, 2)
	for i := 0; i < 2; i++ {
		wg.Add(1)
		go func() { defer wg.Done(); results <- s.InventoryManager().Discard(uid, 100) }()
	}
	wg.Wait()
	close(results)
	accepted := 0
	for err := range results {
		if err == nil {
			accepted++
		} else if !errors.Is(err, ErrDenied) {
			t.Fatal(err)
		}
	}
	if accepted != 1 {
		t.Fatalf("concurrent requests accepted %d times", accepted)
	}
	var r []byte
	if err = s.DB.QueryRow("SELECT record FROM inventory WHERE uid=? AND instance=100", uid).Scan(&r); err != nil || protocol.ReadUint32(r, 19) != 0xffffffff {
		t.Fatal("missing tombstone", err)
	}
	var n int
	if err = s.DB.QueryRow("SELECT COUNT(*) FROM inventory_expirations WHERE uid=? AND instance=100", uid).Scan(&n); err != nil || n != 0 {
		t.Fatal("expiry survived", err)
	}
	if _, err = s.EquipmentManager().EquipDefault(uid, 100, 37); !errors.Is(err, ErrDenied) {
		t.Fatal("discarded pet revived", err)
	}
	snapshot, err := s.RoleManager().Snapshot(uid)
	if err != nil {
		t.Fatal(err)
	}
	for _, r := range snapshot.Inventory {
		if protocol.ReadUint32(r, 0) == 100 {
			t.Fatal("discarded instance survives reconnect")
		}
	}
	// Same template, distinct instances: discard must match owner + instance.
	suitA, suitB := makeItem(150, protocol.ItemSuit, 0), makeItem(151, protocol.ItemSuit, 0)
	protocol.WriteUint32(suitA, 5, 180021)
	protocol.WriteUint32(suitB, 5, 180021)
	insert(suitA)
	insert(suitB)
	if err = s.InventoryManager().Discard(uid+1, 150); !errors.Is(err, ErrDenied) {
		t.Fatal("foreign suit discard", err)
	}
	if err = s.InventoryManager().Discard(uid, 150); err != nil {
		t.Fatal("suit discard", err)
	}
	var remaining []byte
	if err = s.DB.QueryRow("SELECT record FROM inventory WHERE uid=? AND instance=151", uid).Scan(&remaining); err != nil || !bytes.Equal(remaining, suitB) {
		t.Fatal("other identical suit changed", err)
	}
	if err = s.InventoryManager().Discard(uid, 150); !errors.Is(err, ErrDenied) {
		t.Fatal("duplicate suit discard", err)
	}
	// Highest ID retirement cannot reduce the allocator's high-water mark.
	high := makeItem(200, 30, 0)
	insert(high)
	if err = s.InventoryManager().Discard(uid, 200); err != nil {
		t.Fatal(err)
	}
	var next uint32
	if err = s.DB.QueryRow("SELECT COALESCE(MAX(instance),1048575)+1 FROM inventory WHERE uid=?", uid).Scan(&next); err != nil || next != 201 {
		t.Fatal("instance reuse", next, err)
	}
}

func TestDiscardRecordValidation(t *testing.T) {
	r := make([]byte, 68)
	r[4] = 30
	protocol.WriteUint32(r, 0, 1)
	protocol.WriteUint32(r, 5, 303118)
	if !discardableItem(r, 1) {
		t.Fatal("valid pet rejected")
	}
	for _, id := range []uint32{0, 2} {
		if discardableItem(r, id) {
			t.Fatal("instance mismatch")
		}
	}
	if discardableItem(r[:67], 1) {
		t.Fatal("short record")
	}
	protocol.WriteUint16(r, 17, 37)
	if discardableItem(r, 1) {
		t.Fatal("equipped pet")
	}
}

func TestDiscardSuitPackageDoesNotDependOnEquipmentSlots(t *testing.T) {
	r := make([]byte, protocol.InventoryRecordSize)
	protocol.WriteUint32(r, 0, 1048590)
	r[4] = protocol.ItemSuit
	protocol.WriteUint32(r, 5, 180021)
	if !discardableItem(r, 1048590) {
		t.Fatal("unopened suit rejected")
	}
	protocol.WriteUint32(r, 19, 0xffffffff)
	if discardableItem(r, 1048590) {
		t.Fatal("consumed suit accepted")
	}
	protocol.WriteUint32(r, 19, 0)
	protocol.WriteUint16(r, 17, 4)
	if discardableItem(r, 1048590) {
		t.Fatal("equipped item accepted")
	}
}
