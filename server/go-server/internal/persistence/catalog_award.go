package persistence

import (
	"database/sql"
	"kungfu.local/server/internal/protocol"
)

// A validated reward entitlement selects a server catalogue key, never a client-supplied
// inventory record. Item specification and lifetime come from the current offer.
// The account lock and completion receipt serialize grants and retries.
func awardCatalogItem(tx *sql.Tx, uid uint64, key uint32) ([]byte, error) {
	var catalog, item []byte
	if err := tx.QueryRow("SELECT record,grant_record FROM offers WHERE catalog_key=? AND enabled=TRUE FOR UPDATE", key).Scan(&catalog, &item); err != nil {
		return nil, err
	}
	if len(catalog) != 108 || !usableItem(item) || item[4] == 0 || protocol.ReadUint32(item, 5) == 0 || protocol.ReadUint16(item, 17) != 0 || protocol.ReadUint32(catalog, 9) != key || catalog[4] != item[4] || protocol.ReadUint32(catalog, 5) != protocol.ReadUint32(item, 5) {
		return nil, ErrDenied
	}
	var days uint32
	err := tx.QueryRow("SELECT days FROM offer_lifetimes WHERE catalog_key=? FOR UPDATE", key).Scan(&days)
	if err != nil && err != sql.ErrNoRows {
		return nil, err
	}
	if days > 3650 {
		return nil, ErrDenied
	}
	return deliverInventoryItem(tx, uid, item, days)
}
