package persistence

import (
	"database/sql"
	"math"
)

// RewardBundle is shared by tutorial and level rewards. Decorative titles are
// inventory items, not progression-title levels.
type RewardBundle struct {
	Items   []uint32 `json:"items"`
	Gold    uint32   `json:"gold"`
	Tickets uint32   `json:"tickets"`
}

func (b RewardBundle) Validate() error {
	if len(b.Items) > MaxItemsPerLevelGift || b.Gold > 1000000 || b.Tickets > 1000000 {
		return ErrDenied
	}
	for _, k := range b.Items {
		if k == 0 {
			return ErrDenied
		}
	}
	return nil
}
func (m WalletManager) AddTickets(tx *sql.Tx, uid uint64, amount uint32) error {
	if amount == 0 {
		return nil
	}
	var balance uint64
	if err := tx.QueryRow("SELECT tickets FROM accounts WHERE uid=? FOR UPDATE", uid).Scan(&balance); err != nil {
		return err
	}
	if balance+uint64(amount) > math.MaxInt32 {
		return ErrDenied
	}
	_, err := tx.Exec("UPDATE accounts SET tickets=? WHERE uid=?", balance+uint64(amount), uid)
	return err
}
func (m *WalletManager) Balances(uid uint64) (gold, tickets uint32, err error) {
	err = m.store.DB.QueryRow("SELECT gold,tickets FROM accounts WHERE uid=?", uid).Scan(&gold, &tickets)
	return
}
func (m RewardManager) GrantBundle(tx *sql.Tx, uid uint64, balance uint64, b RewardBundle) (uint32, [][]byte, error) {
	if err := b.Validate(); err != nil {
		return 0, nil, err
	}
	next, err := (WalletManager{}).CreditBalance(balance, b.Gold)
	if err != nil {
		return 0, nil, err
	}
	items := [][]byte{}
	for _, key := range b.Items {
		item, e := m.GrantItem(tx, uid, key)
		if e != nil {
			return 0, nil, e
		}
		items = append(items, item)
	}
	if err = (WalletManager{}).AddTickets(tx, uid, b.Tickets); err != nil {
		return 0, nil, err
	}
	return next, items, nil
}

// Validate item references when saving configuration, before any player earns it.
func (m *RewardManager) validateBundleItems(b RewardBundle) error {
	if err := b.Validate(); err != nil {
		return err
	}
	for _, key := range b.Items {
		d := ItemDefinition{Key: key}
		if err := m.store.DB.QueryRow("SELECT record,days FROM item_definitions WHERE definition_key=?", key).Scan(&d.Record, &d.Days); err != nil {
			return err
		}
		if !validDefinition(d) {
			return ErrDenied
		}
	}
	return nil
}
