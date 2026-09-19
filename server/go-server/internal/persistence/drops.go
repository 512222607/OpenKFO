package persistence

import (
	"crypto/rand"
	"database/sql"
	"fmt"
	"kungfu.local/server/internal/protocol"
	"math/big"
)

// Emulator rules, disabled when empty. Each matching rule rolls once per player
// per committed battle; the settlement result persists the exact awarded items.
type DropRule struct {
	CatalogKey uint32 `json:"catalog_key"`
	Outcome    string `json:"outcome"`
	MinLevel   uint16 `json:"min_level"`
	MaxLevel   uint16 `json:"max_level"`
	Chance     uint32 `json:"chance_per_10000"`
}

func validateDrops(rules []DropRule) error {
	if len(rules) > 32 {
		return fmt.Errorf("掉落规则最多32条")
	}
	for _, r := range rules {
		if r.CatalogKey == 0 || (r.Outcome != "win" && r.Outcome != "loss" && r.Outcome != "draw") || r.MinLevel < 1 || r.MaxLevel > 150 || r.MinLevel > r.MaxLevel || r.Chance > 10000 {
			return fmt.Errorf("掉落规则需有效商品编号、win/loss/draw、1–150级范围及0–10000概率")
		}
	}
	return nil
}

func validDropItem(r []byte) bool {
	return len(r) == 68 && r[4] == 25 && protocol.ReadUint32(r, 5) != 0 && protocol.ReadUint16(r, 17) == 0 && protocol.ReadUint32(r, 19) != 0xffffffff && (protocol.ReadUint32(r, 13) != 0 || protocol.ReadUint16(r, 23) != 0)
}

func awardDrops(tx *sql.Tx, reward *BattleReward, level uint16, rules []DropRule) error {
	for _, rule := range rules {
		if reward.Outcome != rule.Outcome || level < rule.MinLevel || level > rule.MaxLevel || rule.Chance == 0 {
			continue
		}
		roll, err := rand.Int(rand.Reader, big.NewInt(10000))
		if err != nil {
			return err
		}
		if uint32(roll.Uint64()) >= rule.Chance {
			continue
		}
		var item []byte
		if err = tx.QueryRow("SELECT grant_record FROM offers WHERE catalog_key=?", rule.CatalogKey).Scan(&item); err != nil {
			return err
		}
		if !validDropItem(item) {
			return ErrDenied
		}
		var instance uint64
		if err = tx.QueryRow("SELECT COALESCE(MAX(instance),1048575)+1 FROM inventory WHERE uid=?", reward.UID).Scan(&instance); err != nil {
			return err
		}
		if instance > 0xffffffff {
			return ErrDenied
		}
		protocol.WriteUint32(item, 0, uint32(instance))
		if _, err = tx.Exec("INSERT INTO inventory(uid,instance,record) VALUES(?,?,?)", reward.UID, instance, item); err != nil {
			return err
		}
		reward.Items = append(reward.Items, item)
	}
	return nil
}
