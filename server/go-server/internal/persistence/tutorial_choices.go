package persistence

import (
	"bytes"
	"database/sql"
	"encoding/json"

	"kungfu.local/server/internal/protocol"
)

// TutorialChoices is separate from automatic title advancement: title 2 is
// earned by completing the guide, even when ordinary title rules are disabled.
func (m *RewardManager) TutorialChoices(uid uint64) (choices []uint32, catalog []byte, err error) {
	tx, err := m.store.DB.Begin()
	if err != nil {
		return nil, nil, err
	}
	defer tx.Rollback()
	var data []byte
	err = tx.QueryRow(`SELECT t.choices FROM title_rewards t JOIN tutorial_rewards r ON r.uid=t.uid WHERE t.uid=? AND t.title_level=2 AND t.claimed_key IS NULL`, uid).Scan(&data)
	if err == sql.ErrNoRows {
		return nil, nil, nil
	}
	if err != nil {
		return nil, nil, err
	}
	if json.Unmarshal(data, &choices) != nil || len(choices) == 0 || len(choices) > 7 {
		return nil, nil, ErrDenied
	}
	// 1550 is a complete catalogue. Preserve normal shop entries while adding
	// display-only reward definitions; this does not create purchasable offers.
	rows, err := tx.Query("SELECT record FROM offers WHERE enabled=TRUE ORDER BY catalog_key LIMIT 4000")
	if err != nil {
		return nil, nil, err
	}
	records := map[uint32][]byte{}
	order := []uint32{}
	for rows.Next() {
		var record []byte
		if err = rows.Scan(&record); err != nil {
			break
		}
		if len(record) != 108 {
			err = ErrDenied
			break
		}
		key := protocol.ReadUint32(record, 0)
		records[key] = record
		order = append(order, key)
	}
	rowErr := rows.Err()
	rows.Close()
	if err != nil {
		return nil, nil, err
	}
	if rowErr != nil {
		return nil, nil, rowErr
	}
	seen := map[uint32]bool{}
	for _, key := range choices {
		if seen[key] {
			return nil, nil, ErrDenied
		}
		seen[key] = true
		d, e := readDefinition(tx, key)
		if e != nil {
			return nil, nil, e
		}
		if d.Record[4] != protocol.ItemWeapon {
			return nil, nil, ErrDenied
		}
		existing, ok := records[key]
		if ok {
			if existing[4] != d.Record[4] || !bytes.Equal(existing[5:9], d.Record[5:9]) {
				return nil, nil, ErrDenied
			}
			continue
		}
		record := make([]byte, 108)
		protocol.WriteUint32(record, 0, key)
		copy(record[4:9], d.Record[4:9])
		protocol.WriteUint32(record, 9, key)
		protocol.WriteUint32(record, 22, d.Days*24)
		record[48], record[83] = 1, 1
		records[key] = record
		order = append(order, key)
	}
	for _, key := range order {
		catalog = append(catalog, records[key]...)
	}
	return choices, catalog, tx.Commit()
}
