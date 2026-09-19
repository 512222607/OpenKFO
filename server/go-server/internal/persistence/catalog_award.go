package persistence

import "database/sql"

// GrantItem uses independent definitions. Shop visibility and prices do not
// participate in gameplay reward eligibility. Caller owns account lock/receipt.
func (m RewardManager) GrantItem(tx *sql.Tx, uid uint64, key uint32) ([]byte, error) {
	d, err := readDefinition(tx, key)
	if err != nil {
		return nil, err
	}
	return (InventoryManager{}).AddItem(tx, uid, d.Record, d.Days)
}
