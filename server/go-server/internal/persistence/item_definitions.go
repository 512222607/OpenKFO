package persistence

import (
	"database/sql"
	"fmt"
	"kungfu.local/server/internal/protocol"
)

// ItemDefinition is a grant specification, never a player inventory instance.
// Legacy catalogue keys remain valid for saved task snapshots.
type ItemDefinition struct {
	Key      uint32 `json:"key"`
	Revision uint64 `json:"revision"`
	Record   []byte `json:"record"`
	Days     uint32 `json:"days"`
}

const seedDefinitionsSQL = `INSERT IGNORE INTO item_definitions(definition_key,revision,record,days)
 SELECT o.catalog_key,1,o.grant_record,COALESCE(l.days,0)
 FROM offers o LEFT JOIN offer_lifetimes l ON l.catalog_key=o.catalog_key`

func validDefinition(d ItemDefinition) bool {
	return d.Key != 0 && d.Days <= 3650 && usableItem(d.Record) && d.Record[4] != 0 && protocol.ReadUint32(d.Record, 5) != 0 && protocol.ReadUint16(d.Record, 17) == protocol.SlotUnequipped
}
func readDefinition(tx *sql.Tx, key uint32) (ItemDefinition, error) {
	d := ItemDefinition{Key: key}
	err := tx.QueryRow("SELECT revision,record,days FROM item_definitions WHERE definition_key=?", key).Scan(&d.Revision, &d.Record, &d.Days)
	if err == nil && !validDefinition(d) {
		err = ErrDenied
	}
	return d, err
}
func (m *ItemManager) Definitions() ([]ItemDefinition, error) {
	rows, err := m.store.DB.Query("SELECT definition_key,revision,record,days FROM item_definitions ORDER BY definition_key")
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	result := []ItemDefinition{}
	for rows.Next() {
		var d ItemDefinition
		if err = rows.Scan(&d.Key, &d.Revision, &d.Record, &d.Days); err != nil {
			return nil, err
		}
		result = append(result, d)
	}
	return result, rows.Err()
}

// SaveDefinition is explicit: shop edits never overwrite existing definitions.
func (m *ItemManager) SaveDefinition(d ItemDefinition) (ItemDefinition, error) {
	if !validDefinition(d) {
		return d, ErrDenied
	}
	var r sql.Result
	var err error
	if d.Revision == 0 {
		r, err = m.store.DB.Exec("INSERT IGNORE INTO item_definitions(definition_key,revision,record,days) VALUES(?,1,?,?)", d.Key, d.Record, d.Days)
	} else {
		r, err = m.store.DB.Exec("UPDATE item_definitions SET record=?,days=?,revision=revision+1 WHERE definition_key=? AND revision=?", d.Record, d.Days, d.Key, d.Revision)
	}
	if err != nil {
		return d, err
	}
	n, err := r.RowsAffected()
	if err != nil {
		return d, err
	}
	if n != 1 {
		return d, fmt.Errorf("物品定义已被修改，请重新读取")
	}
	d.Revision++
	return d, nil
}
