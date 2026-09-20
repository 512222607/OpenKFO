package persistence

import (
	"database/sql"
	"kungfu.local/server/internal/protocol"
)

// ExtendItem keeps the existing instance and its upgrades. The caller must
// hold the account row lock, validate the offer and charge/record the renewal
// in this same transaction. days is server policy, never a client duration.
// This path handles weapons; active instances use minutes, unused ones hours.
// Permanent ownership has no expiration row and cannot be renewed this way.
func (m InventoryManager) ExtendItem(tx *sql.Tx, uid uint64, instance uint32, days uint32, now int64) ([]byte, error) {
	if uid == 0 || instance == 0 || days == 0 || days > 3650 || now <= 0 {
		return nil, ErrDenied
	}
	var item []byte
	var deadline int64
	if err := tx.QueryRow(`SELECT i.record,e.expires_at FROM inventory i JOIN inventory_expirations e ON e.uid=i.uid AND e.instance=i.instance WHERE i.uid=? AND i.instance=? FOR UPDATE`, uid, instance).Scan(&item, &deadline); err != nil {
		return nil, err
	}
	if len(item) != protocol.InventoryRecordSize || item[4] != protocol.ItemWeapon || protocol.ReadUint32(item, 0) != instance || protocol.ReadUint32(item, 19) == 0xffffffff || deadline <= 0 {
		return nil, ErrDenied
	}
	// Limit the total remaining term as well as this extension, before adding,
	// so corrupt deadlines cannot overflow and accidentally become permanent.
	const maximumTerm = int64(3650 * 86400)
	base := max(deadline, now)
	extension := int64(days) * 86400
	if base-now > maximumTerm-extension || now > (1<<63-1)-maximumTerm {
		return nil, ErrDenied
	}
	if deadline <= now || protocol.ReadUint32(item, 19) == 2 {
		// Expiry already unequipped the item; renewal does not auto-equip it.
		protocol.WriteUint16(item, 17, 0)
		protocol.WriteUint32(item, 19, 0)
	}
	deadline = base + extension
	protocol.WriteUint32(item, 13, uint32((deadline-now+3599)/3600))
	if protocol.ReadUint32(item, inventoryStateOffset) == inventoryActive {
		projectItemMinutes(item, sql.NullInt64{Int64: deadline, Valid: true}, now)
	}
	if _, err := tx.Exec(`UPDATE inventory SET record=? WHERE uid=? AND instance=?`, item, uid, instance); err != nil {
		return nil, err
	}
	if _, err := tx.Exec(`UPDATE inventory_expirations SET expires_at=?,processed=FALSE WHERE uid=? AND instance=?`, deadline, uid, instance); err != nil {
		return nil, err
	}
	return item, nil
}
