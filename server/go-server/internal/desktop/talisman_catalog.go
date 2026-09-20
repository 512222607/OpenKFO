package desktop

import (
	"fmt"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"math/big"
	"path/filepath"
	"strconv"
)

// Quota is stored in hundredths, per native 99AB0E/4206. New shop grants
// start with 100 durability points; this is server policy, not an official price.
const initialTalismanQuota = 10000

func talismanCost(value string) (uint16, error) {
	r, ok := new(big.Rat).SetString(value)
	if !ok || r.Sign() < 0 {
		return 0, fmt.Errorf("invalid talisman cost %q", value)
	}
	r.Mul(r, big.NewRat(100, 1))
	if !r.IsInt() || !r.Num().IsUint64() || r.Num().Uint64() > 65535 {
		return 0, fmt.Errorf("talisman cost exceeds inventory precision/range")
	}
	return uint16(r.Num().Uint64()), nil
}

func clientTalismanRules(client string, items []Item) ([]persistence.TalismanUseRule, error) {
	a, err := loadArchive(filepath.Join(client, "Data", "config.spf2"))
	if err != nil {
		return nil, err
	}
	root, err := a.xml("talisman.xml")
	if err != nil {
		return nil, err
	}
	known := map[uint32]bool{}
	for _, item := range items {
		if item.Kind == protocol.ItemTalisman {
			known[item.ID] = true
		}
	}
	rules := []persistence.TalismanUseRule{}
	seen := map[uint32]persistence.TalismanUseRule{}
	for _, n := range root.children {
		if n.comment || n.tag != "Talisman" {
			continue
		}
		id, e := strconv.ParseUint(n.get("Id"), 10, 32)
		if e != nil || id == 0 {
			return nil, fmt.Errorf("invalid/duplicate talisman ID %q", n.get("Id"))
		}
		if !known[uint32(id)] {
			continue
		}
		active, e := talismanCost(n.get("ActiveCost"))
		if e != nil {
			return nil, e
		}
		passive, e := talismanCost(n.get("EquipCostPerBattle"))
		if e != nil {
			return nil, e
		}
		rule := persistence.TalismanUseRule{Item: uint32(id), ActiveCost: active, PassiveCost: passive}
		if previous, exists := seen[rule.Item]; exists {
			if previous != rule {
				return nil, fmt.Errorf("conflicting talisman costs for %d", rule.Item)
			}
			continue
		}
		seen[rule.Item] = rule
		rules = append(rules, rule)
	}
	if len(rules) != len(known) {
		return nil, fmt.Errorf("宠物/法宝配置不完整：物品 %d，使用规则 %d", len(known), len(rules))
	}
	return rules, nil
}
