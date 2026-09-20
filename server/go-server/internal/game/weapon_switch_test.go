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

func TestWeaponSwitchGuards(t *testing.T) {
	h, s, peer, _ := combatFixture()
	if h.switchWeapon(s, s.game(), []byte{1}) == nil {
		t.Fatal("malformed request accepted")
	}
	s.game().Phase = "room"
	if err := h.switchWeapon(s, s.game(), nil); err != nil {
		t.Fatal(err)
	}
	if len(s.Output) != 0 || len(peer.Output) != 0 {
		t.Fatal("non-battle response")
	}
	s.game().Phase = "battle"
	s.Room.Members[s.UID].WeaponSwitch = weaponSwitchAttempt{s.Room.Serial, time.Now()}
	if err := h.switchWeapon(s, s.game(), nil); err != nil {
		t.Fatal(err)
	}
	out := roomOutputs(t, s, protocol.MsgWeaponSwitchResult)[0]
	if len(out.Payload) != 20 || protocol.ReadUint64(out.Payload, 0) != s.UID || protocol.ReadUint32(out.Payload, 12) != 0 || len(peer.Output) != 0 {
		t.Fatal("repeat must only release requester's waiting gate")
	}
}

func TestWeaponSwitchIndependentDatabase(t *testing.T) {
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
	defer store.DB.Close()
	h, s, peer, outsider := combatFixture()
	h.Store = store
	uid := uint64(time.Now().UnixMicro())
	a, err := persistence.NewAccountWithStarterCharacter(uid, fmt.Sprintf("ws%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	a.Inventory = nil
	for i, kind := range []byte{protocol.ItemWeapon, protocol.ItemWeapon, protocol.ItemWeaponSwitchCard} {
		p := make([]byte, 68)
		p[4] = kind
		protocol.WriteUint32(p, 0, uint32(i+1))
		protocol.WriteUint32(p, 5, uint32(253001+i))
		if i < 2 {
			protocol.WriteUint16(p, 17, uint16(8+i))
		} else {
			protocol.WriteUint32(p, 5, 743001)
			protocol.WriteUint16(p, 23, 2)
		}
		a.Inventory = append(a.Inventory, p)
	}
	if err = store.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		store.DB.Exec("DELETE FROM inventory WHERE uid=?", uid)
		store.DB.Exec("DELETE FROM accounts WHERE uid=?", uid)
	}()
	r := s.Room
	m := r.Members[s.UID]
	delete(r.Members, s.UID)
	s.UID = uid
	r.Members[uid] = m
	request := func(success uint32, remaining uint32) {
		t.Helper()
		if err := h.route(s, s.game(), protocol.Message{ID: protocol.MsgWeaponSwitchRequest}); err != nil {
			t.Fatal(err)
		}
		p := roomOutputs(t, s, protocol.MsgWeaponSwitchResult)[0].Payload
		if protocol.ReadUint64(p, 0) != uid || protocol.ReadUint32(p, 12) != success || protocol.ReadUint32(p, 16) != remaining {
			t.Fatalf("bad reply %x", p)
		}
		if success != 0 {
			roomOutputs(t, peer, protocol.MsgWeaponSwitchResult)
		} else if len(peer.Output) != 0 {
			t.Fatal("rejection broadcast")
		}
		if len(outsider.Output) != 0 {
			t.Fatal("cross room broadcast")
		}
	}
	request(1, 1)
	request(0, 0) // Rapid duplicate: release the gate without another debit/toggle.
	m.WeaponSwitch.at = time.Time{}
	request(1, 0) // Last card must still switch successfully.
	m.WeaponSwitch.at = time.Time{}
	request(0, 0)
	after, err := store.RoleManager().Snapshot(uid)
	if err != nil {
		t.Fatal(err)
	}
	for _, p := range after.Inventory {
		if p[4] == protocol.ItemWeaponSwitchCard && protocol.ReadUint16(p, 23) != 0 {
			t.Fatal("wrong balance")
		}
		if p[4] == protocol.ItemWeapon && protocol.ReadUint16(p, 17) != uint16(protocol.ReadUint32(p, 0)+7) {
			t.Fatal("equipment slots mutated")
		}
	}
	// Owning a card without both equipped weapons cannot spend it.
	card := a.Inventory[2]
	protocol.WriteUint16(card, 23, 2)
	if _, err = store.DB.Exec("UPDATE inventory SET record=? WHERE uid=? AND instance=3", card, uid); err != nil {
		t.Fatal(err)
	}
	if _, err = store.DB.Exec("DELETE FROM inventory WHERE uid=? AND instance=2", uid); err != nil {
		t.Fatal(err)
	}
	m.WeaponSwitch.at = time.Time{}
	request(0, 0)
	if _, err = store.InventoryManager().ConsumeWeaponSwitchCard(uid + 1); err == nil {
		t.Fatal("unknown owner accepted")
	}
}
