package persistence

import (
	"kungfu.local/server/internal/protocol"
	"time"
)

// Native warehouse 8B3919/8B3924 selects slot 37 for type 30 before 2080.
var Slots = map[byte][]uint16{12: {4}, 13: {3}, 14: {7}, 15: {2}, 16: {6}, 17: {5}, 18: {4}, 20: {10}, 21: {11}, protocol.ItemWeapon: {protocol.SlotPrimaryWeapon, protocol.SlotSecondaryWeapon}, protocol.ItemTalisman: {protocol.SlotPrimaryTalisman, protocol.SlotSecondaryTalisman}, protocol.ItemConsumable: {protocol.SlotPrimaryConsumable, protocol.SlotSecondaryConsumable}}

// Current native 660CE0 default-slot switch. Only include types whose explicit
// equipment paths are already supported here; suits and consumables differ.
func defaultEquipmentSlot(kind byte) uint16 {
	switch kind {
	case 12:
		return 4
	case 13:
		return 3
	case 14:
		return 7
	case 15:
		return 2
	case 16:
		return 6
	case 17:
		return 5
	case 20:
		return 10
	case 21:
		return 11
	case protocol.ItemWeapon:
		return protocol.SlotPrimaryWeapon
	}
	return 0
}

func (m *EquipmentManager) Equip(uid uint64, instance uint32, slot uint16) ([]byte, error) {
	return m.store.EquipmentManager().equip(uid, instance, slot, false)
}

// EquipDefault resolves the warehouse's zero slot inside the ownership transaction.
// Zero still means unequip for Equip callers (2300).
func (m *EquipmentManager) EquipDefault(uid uint64, instance uint32, slot uint16) ([]byte, error) {
	return m.store.EquipmentManager().equip(uid, instance, slot, true)
}

func (m *EquipmentManager) equip(uid uint64, instance uint32, slot uint16, automatic bool) ([]byte, error) {
	transaction, err := m.store.DB.Begin()
	if err != nil {
		return nil, err
	}
	defer transaction.Rollback()
	var owner uint64
	if err = transaction.QueryRow(`SELECT uid FROM accounts WHERE uid=? FOR UPDATE`, uid).Scan(&owner); err != nil {
		return nil, err
	}
	if err = expireInventory(transaction, uid, time.Now().Unix()); err != nil {
		return nil, err
	}
	var record []byte
	if err = transaction.QueryRow(`SELECT record FROM inventory WHERE uid=? AND instance=?`, uid, instance).Scan(&record); err != nil || len(record) != protocol.InventoryRecordSize {
		return nil, ErrDenied
	}
	if (automatic || slot != protocol.SlotUnequipped) && !usableItem(record) {
		return nil, ErrDenied
	}
	if automatic && slot == protocol.SlotUnequipped {
		slot = defaultEquipmentSlot(record[4])
		if slot == protocol.SlotUnequipped {
			return nil, ErrDenied
		}
	}
	if slot == protocol.SlotUnequipped && protocol.ReadUint16(record, 17) == 0 {
		return nil, nil
	}
	if slot != protocol.SlotUnequipped {
		allowed := false
		for _, allowedSlot := range Slots[record[4]] {
			allowed = allowed || allowedSlot == slot
		}
		if !allowed {
			return nil, ErrDenied
		}
		rows, err := transaction.Query(`SELECT instance,record FROM inventory WHERE uid=?`, uid)
		if err != nil {
			return nil, err
		}
		type change struct {
			instance uint32
			record   []byte
		}
		var edits []change
		for rows.Next() {
			var change change
			if err = rows.Scan(&change.instance, &change.record); err != nil {
				rows.Close()
				return nil, err
			}
			if len(change.record) == protocol.InventoryRecordSize && protocol.ReadUint16(change.record, 17) == slot {
				protocol.WriteUint16(change.record, 17, 0)
				edits = append(edits, change)
			}
		}
		err = rows.Err()
		rows.Close()
		if err != nil {
			return nil, err
		}
		for _, change := range edits {
			if _, err = transaction.Exec(`UPDATE inventory SET record=? WHERE uid=? AND instance=?`, change.record, uid, change.instance); err != nil {
				return nil, err
			}
		}
	}
	protocol.WriteUint16(record, 17, slot)
	if _, err = transaction.Exec(`UPDATE inventory SET record=? WHERE uid=? AND instance=?`, record, uid, instance); err != nil {
		return nil, err
	}
	return record, transaction.Commit()
}
