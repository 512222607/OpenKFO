package persistence

import (
	"bytes"
	"database/sql"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestEquippedLifetimeActivation(t *testing.T) {
	for _, tc := range []struct {
		name     string
		deadline sql.NullInt64
		minutes  uint32
		state    uint32
	}{
		{"permanent", sql.NullInt64{}, permanentDisplayMinutes, inventoryActive},
		{"finite", sql.NullInt64{Int64: 1121, Valid: true}, 3, inventoryActive},
		{"expired", sql.NullInt64{Int64: 999, Valid: true}, 0, inventoryExpired},
	} {
		t.Run(tc.name, func(t *testing.T) {
			r := make([]byte, protocol.InventoryRecordSize)
			r[4] = protocol.ItemTalisman
			protocol.WriteUint32(r, 9, 123)
			protocol.WriteUint16(r, 17, protocol.SlotPrimaryTalisman)
			protocol.WriteUint16(r, 23, 10000)
			protocol.WriteUint32(r, 13, 8760)
			if !activateEquippedItem(r, tc.deadline, 1000) {
				t.Fatal("not activated")
			}
			if protocol.ReadUint32(r, 13) != tc.minutes || protocol.ReadUint32(r, 19) != tc.state {
				t.Fatal("wrong native duration/state")
			}
			if protocol.ReadUint32(r, 9) != 123 || protocol.ReadUint16(r, 23) != 10000 {
				t.Fatal("catalog lookup or durability corrupted")
			}
			before := bytes.Clone(r)
			if activateEquippedItem(r, tc.deadline, 1001) || !bytes.Equal(before, r) {
				t.Fatal("activation is not idempotent")
			}
			if tc.state == inventoryActive {
				protocol.WriteUint16(r, 17, 0)
				projectItemMinutes(r, tc.deadline, 1061)
				want := permanentDisplayMinutes
				if tc.deadline.Valid {
					want = 1
				}
				if protocol.ReadUint32(r, 13) != want || protocol.ReadUint16(r, 23) != 10000 {
					t.Fatal("unequipped talisman lost duration or real quota")
				}
				if tc.deadline.Valid {
					projectItemMinutes(r, tc.deadline, 1121)
					if protocol.ReadUint32(r, 19) != inventoryExpired {
						t.Fatal("quota display bypassed real expiry")
					}
				}
			}
		})
	}
	r := make([]byte, 68)
	protocol.WriteUint32(r, 13, 8760)
	if activateEquippedItem(r, sql.NullInt64{}, 1000) {
		t.Fatal("unequipped item was activated")
	}
	for _, state := range []uint32{inventoryExpired, 0xffffffff} {
		protocol.WriteUint16(r, 17, 1)
		protocol.WriteUint32(r, 19, state)
		if activateEquippedItem(r, sql.NullInt64{}, 1000) {
			t.Fatal("invalid item revived")
		}
	}
}

func TestEquipmentTimeDisplayRemainsForNonTalisman(t *testing.T) {
	r := make([]byte, protocol.InventoryRecordSize)
	r[4] = protocol.ItemWeapon
	protocol.WriteUint32(r, 19, inventoryActive)
	projectItemMinutes(r, sql.NullInt64{}, 1000)
	if protocol.ReadUint32(r, 13) != permanentDisplayMinutes {
		t.Fatal("permanent weapon time changed")
	}
	projectItemMinutes(r, sql.NullInt64{Int64: 1121, Valid: true}, 1000)
	if protocol.ReadUint32(r, 13) != 3 {
		t.Fatal("finite weapon countdown changed")
	}
}
