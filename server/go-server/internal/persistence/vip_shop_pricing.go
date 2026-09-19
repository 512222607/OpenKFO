package persistence

import (
	"database/sql"
	"encoding/json"
	"time"
)

// Call with the account already locked, including both accounts for gifts.
// Membership comes from persisted cards and deadlines, never a client's kind.
func vipShopPercentTx(tx *sql.Tx, uid uint64) (uint32, error) {
	var settings VIPShopSettings
	var data []byte
	err := tx.QueryRow("SELECT revision,rules FROM vip_shop_rules WHERE id=1 FOR UPDATE").Scan(&settings.Revision, &data)
	if err == sql.ErrNoRows {
		return 0, nil
	}
	if err != nil {
		return 0, err
	}
	if err = json.Unmarshal(data, &settings.Rules); err != nil {
		return 0, err
	}
	if err = settings.Validate(); err != nil {
		return 0, err
	}
	if !settings.Rules.Enabled {
		return 0, nil
	}
	rows, err := tx.Query(`SELECT i.record,e.expires_at FROM inventory i LEFT JOIN inventory_expirations e ON e.uid=i.uid AND e.instance=i.instance WHERE i.uid=? ORDER BY i.instance`, uid)
	if err != nil {
		return 0, err
	}
	defer rows.Close()
	membership := VIPMembership{Kind: 1}
	now := time.Now().Unix()
	for rows.Next() {
		var record []byte
		var deadline sql.NullInt64
		if err = rows.Scan(&record, &deadline); err != nil {
			return 0, err
		}
		if err = membership.include(record, deadline, now); err != nil {
			return 0, err
		}
	}
	if err = rows.Err(); err != nil {
		return 0, err
	}
	return settings.Rules.Percent(membership.Kind), nil
}

// Display refresh is a separate snapshot. Purchase/Gift recalculate inside
// their own transaction and reject stale submitted prices without charging.
func (s *Store) VIPShopPercent(uid uint64) (uint32, error) {
	if uid == 0 {
		return 0, ErrDenied
	}
	tx, err := s.DB.Begin()
	if err != nil {
		return 0, err
	}
	defer tx.Rollback()
	var owner uint64
	if err = tx.QueryRow("SELECT uid FROM accounts WHERE uid=? FOR UPDATE", uid).Scan(&owner); err != nil {
		return 0, err
	}
	rate, err := vipShopPercentTx(tx, uid)
	if err != nil {
		return 0, err
	}
	return rate, tx.Commit()
}
