package persistence

import (
	"bytes"
	"crypto/sha256"
	"database/sql"
	"encoding/json"
	"fmt"

	"kungfu.local/server/internal/protocol"
)

type AdminOffer struct {
	Offer
	Enabled bool `json:"enabled"`
}
type AdminRequest struct {
	Operation string       `json:"operation"`
	ID        string       `json:"id"`
	UID       uint64       `json:"uid"`
	Mode      string       `json:"mode"`
	Amount    uint32       `json:"amount"`
	Records   [][]byte     `json:"records"`
	Offers    []AdminOffer `json:"offers"`
	Enabled   bool         `json:"enabled"`
	All       bool         `json:"all"`
	Preserve  bool         `json:"preserve"`
}

func itemKey(record []byte) string {
	return fmt.Sprintf("%d:%d", record[4], protocol.ReadUint32(record, 5))
}
func (store *Store) adminOffers() ([]AdminOffer, error) {
	rows, err := store.DB.Query(`SELECT catalog_key,category,variant,record,grant_record,enabled FROM offers ORDER BY catalog_key`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	result := []AdminOffer{}
	for rows.Next() {
		var offer AdminOffer
		if err = rows.Scan(&offer.Key, &offer.Category, &offer.Variant, &offer.Record, &offer.Grant, &offer.Enabled); err != nil {
			return nil, err
		}
		result = append(result, offer)
	}
	return result, rows.Err()
}
func (store *Store) Admin(request AdminRequest) (any, error) {
	switch request.Operation {
	case "accounts", "wallet_accounts":
		rows, err := store.DB.Query(`SELECT a.uid,a.account,a.nickname,a.gold,a.tickets,(SELECT COUNT(*) FROM inventory i WHERE i.uid=a.uid) FROM accounts a ORDER BY a.uid`)
		if err != nil {
			return nil, err
		}
		defer rows.Close()
		result := []map[string]any{}
		for rows.Next() {
			var uid uint64
			var account, nickname string
			var gold, tickets, count uint32
			if err = rows.Scan(&uid, &account, &nickname, &gold, &tickets, &count); err != nil {
				return nil, err
			}
			result = append(result, map[string]any{"uid": uid, "account": account, "nickname": nickname, "gold": gold, "tickets": tickets, "count": count})
		}
		return result, rows.Err()
	case "inventory":
		account, err := store.Snapshot(request.UID)
		if err != nil {
			return nil, err
		}
		result := []map[string]any{}
		for _, record := range account.Inventory {
			result = append(result, map[string]any{"instance": protocol.ReadUint32(record, 0), "key": itemKey(record), "slot": protocol.ReadUint16(record, 17), "quantity": protocol.ReadUint16(record, 23), "duration_hours": protocol.ReadUint32(record, 13), "duration_state": protocol.ReadUint32(record, 19)})
		}
		return result, nil
	case "shop_catalog":
		return store.adminOffers()
	case "wallet_update":
		before, after, err := store.Wallet(request.UID, request.Mode, request.Amount, request.ID)
		return map[string]any{"before": before, "after": after, "backup": "线上 wallet_operations 审计记录：" + request.ID, "message": fmt.Sprintf("线上点券：%d → %d；重新登录游戏刷新", before, after)}, err
	case "grant", "shop_save", "shop_batch":
	default:
		return nil, ErrDenied
	}
	if len(request.ID) < 1 || len(request.ID) > 100 || len(request.Records) > 4000 || len(request.Offers) > 4000 {
		return nil, ErrDenied
	}
	encoded, err := json.Marshal(request)
	if err != nil {
		return nil, err
	}
	digest := sha256.Sum256(encoded)
	// The audit is committed in the same transaction as the mutation. It keeps
	// before-images and the request hash, so retries never duplicate grants.
	if _, err = store.DB.Exec(`CREATE TABLE IF NOT EXISTS desktop_admin_operations(id VARCHAR(100) CHARACTER SET ascii PRIMARY KEY,request_hash BINARY(32) NOT NULL,before_data LONGBLOB NOT NULL,result_data LONGBLOB NOT NULL,created TIMESTAMP DEFAULT CURRENT_TIMESTAMP) ENGINE=InnoDB`); err != nil {
		return nil, err
	}
	if _, err = store.DB.Exec(`INSERT IGNORE INTO counters(name,value) VALUES('desktop_admin',0)`); err != nil {
		return nil, err
	}
	tx, err := store.DB.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()
	var lock uint64
	if err = tx.QueryRow(`SELECT value FROM counters WHERE name='desktop_admin' FOR UPDATE`).Scan(&lock); err != nil {
		return nil, err
	}
	var previousHash, previousResult []byte
	err = tx.QueryRow(`SELECT request_hash,result_data FROM desktop_admin_operations WHERE id=?`, request.ID).Scan(&previousHash, &previousResult)
	if err == nil {
		if !bytes.Equal(previousHash, digest[:]) {
			return nil, ErrDenied
		}
		var result any
		err = json.Unmarshal(previousResult, &result)
		return result, err
	}
	if err != sql.ErrNoRows {
		return nil, err
	}
	result := map[string]any{"backup": "线上事务前快照：desktop_admin_operations / " + request.ID}
	var before any
	if request.Operation == "grant" {
		if len(request.Records) == 0 {
			return nil, ErrDenied
		}
		var uid uint64
		if err = tx.QueryRow(`SELECT uid FROM accounts WHERE uid=? FOR UPDATE`, request.UID).Scan(&uid); err != nil {
			return nil, err
		}
		rows, readErr := tx.Query(`SELECT record FROM inventory WHERE uid=? ORDER BY instance`, uid)
		if readErr != nil {
			return nil, readErr
		}
		inventory := [][]byte{}
		byItem := map[string][]byte{}
		next := uint32(1048576)
		for rows.Next() {
			var record []byte
			if err = rows.Scan(&record); err != nil {
				rows.Close()
				return nil, err
			}
			if len(record) != 68 {
				rows.Close()
				return nil, ErrDenied
			}
			inventory = append(inventory, record)
			byItem[itemKey(record)] = record
			if instance := protocol.ReadUint32(record, 0); instance >= next {
				if instance == ^uint32(0) {
					rows.Close()
					return nil, ErrDenied
				}
				next = instance + 1
			}
		}
		err = rows.Err()
		rows.Close()
		if err != nil {
			return nil, err
		}
		before = inventory
		added, updated, skipped := 0, 0, 0
		seen := map[string]bool{}
		for _, template := range request.Records {
			if len(template) != 68 || template[4] == 0 || protocol.ReadUint32(template, 5) == 0 || protocol.ReadUint16(template, 17) != 0 {
				return nil, ErrDenied
			}
			key := itemKey(template)
			if seen[key] {
				return nil, ErrDenied
			}
			seen[key] = true
			stackable := template[4] == 64 || template[4] == 71 || template[4] == 74
			count := protocol.ReadUint16(template, 23)
			if stackable && (count == 0 || count > 999) {
				return nil, ErrDenied
			}
			record := bytes.Clone(template)
			if existing := byItem[key]; existing != nil {
				if !stackable {
					skipped++
					continue
				}
				record = bytes.Clone(existing)
				quantity := uint32(protocol.ReadUint16(record, 23)) + uint32(count)
				if quantity > 999 {
					return nil, fmt.Errorf("%s 添加后超过 999，整批未写入", key)
				}
				protocol.WriteUint16(record, 23, uint16(quantity))
				updated++
			} else {
				if next == ^uint32(0) {
					return nil, ErrDenied
				}
				protocol.WriteUint32(record, 0, next)
				next++
				added++
			}
			if _, err = tx.Exec(`INSERT INTO inventory(uid,instance,record) VALUES(?,?,?) ON DUPLICATE KEY UPDATE record=VALUES(record)`, uid, protocol.ReadUint32(record, 0), record); err != nil {
				return nil, err
			}
		}
		result["uid"], result["added"], result["updated"], result["skipped"] = uid, added, updated, skipped
	} else {
		rows, readErr := tx.Query(`SELECT catalog_key,category,variant,record,grant_record,enabled FROM offers ORDER BY catalog_key FOR UPDATE`)
		if readErr != nil {
			return nil, readErr
		}
		existing := []AdminOffer{}
		byItem := map[string][]AdminOffer{}
		byKey := map[uint32]AdminOffer{}
		for rows.Next() {
			var offer AdminOffer
			if err = rows.Scan(&offer.Key, &offer.Category, &offer.Variant, &offer.Record, &offer.Grant, &offer.Enabled); err != nil {
				rows.Close()
				return nil, err
			}
			if len(offer.Record) != 108 || len(offer.Grant) != 68 {
				rows.Close()
				return nil, ErrDenied
			}
			existing = append(existing, offer)
			byItem[itemKey(offer.Grant)] = append(byItem[itemKey(offer.Grant)], offer)
			byKey[offer.Key] = offer
		}
		err = rows.Err()
		rows.Close()
		if err != nil {
			return nil, err
		}
		before = existing
		changed := 0
		if request.All && !request.Enabled {
			update, updateErr := tx.Exec(`UPDATE offers SET enabled=FALSE WHERE enabled=TRUE`)
			if updateErr != nil {
				return nil, updateErr
			}
			count, _ := update.RowsAffected()
			changed = int(count)
		} else {
			if len(request.Offers) == 0 {
				return nil, ErrDenied
			}
			seen := map[string]bool{}
			for _, offer := range request.Offers {
				if err = validateAdminOffer(offer); err != nil {
					return nil, err
				}
				key := itemKey(offer.Grant)
				if seen[key] {
					return nil, ErrDenied
				}
				seen[key] = true
				matches := byItem[key]
				if request.Preserve && len(matches) > 0 {
					for _, old := range matches {
						if old.Enabled != request.Enabled {
							if _, err = tx.Exec(`UPDATE offers SET enabled=? WHERE catalog_key=?`, request.Enabled, old.Key); err != nil {
								return nil, err
							}
							changed++
						}
					}
					continue
				}
				if request.Preserve && !request.Enabled {
					continue
				}
				if len(matches) > 1 {
					return nil, fmt.Errorf("%s 有多条销售规格，请先单独处理", key)
				}
				if len(matches) == 1 {
					offer.Key = matches[0].Key
					offer.Category = matches[0].Category
					offer.Variant = matches[0].Variant
					protocol.WriteUint32(offer.Record, 0, offer.Key)
					protocol.WriteUint32(offer.Record, 9, offer.Key)
				} else if conflict, ok := byKey[offer.Key]; ok && itemKey(conflict.Grant) != key {
					return nil, fmt.Errorf("商品编号冲突：%s", key)
				}
				if _, err = tx.Exec(`INSERT INTO offers(catalog_key,category,variant,record,grant_record,enabled) VALUES(?,?,?,?,?,?) ON DUPLICATE KEY UPDATE record=VALUES(record),grant_record=VALUES(grant_record),enabled=VALUES(enabled)`, offer.Key, offer.Category, offer.Variant, offer.Record, offer.Grant, offer.Enabled); err != nil {
					return nil, err
				}
				changed++
			}
		}
		result["changed"] = changed
		result["message"] = fmt.Sprintf("线上商城已更新 %d 条；请重新登录游戏刷新商品缓存", changed)
	}
	beforeJSON, err := json.Marshal(before)
	if err != nil {
		return nil, err
	}
	resultJSON, err := json.Marshal(result)
	if err != nil {
		return nil, err
	}
	if _, err = tx.Exec(`INSERT INTO desktop_admin_operations(id,request_hash,before_data,result_data) VALUES(?,?,?,?)`, request.ID, digest[:], beforeJSON, resultJSON); err != nil {
		return nil, err
	}
	if err = tx.Commit(); err != nil {
		return nil, err
	}
	return result, nil
}

func validateAdminOffer(offer AdminOffer) error {
	if len(offer.Record) != 108 || len(offer.Grant) != 68 || offer.Key == 0 || offer.Category != 10 || offer.Variant != offer.Grant[4] || offer.Record[4] != offer.Grant[4] || protocol.ReadUint32(offer.Record, 5) != protocol.ReadUint32(offer.Grant, 5) || protocol.ReadUint32(offer.Record, 9) != offer.Key {
		return ErrDenied
	}
	gold, tickets := protocol.ReadUint32(offer.Record, 30), protocol.ReadUint32(offer.Record, 38)
	if (gold == 0) == (tickets == 0) || gold > 2147483647 || tickets > 2147483647 || offer.Record[83] != 1 {
		return ErrDenied
	}
	return nil
}
