package persistence

import (
	"bytes"
	"database/sql"
	"kungfu.local/server/internal/protocol"
	"math"
	"time"
)

// deliverInventoryItem inserts a server-validated item snapshot. Callers MUST
// hold the account row lock and record their durable entitlement in the SAME
// transaction. It does not commit or notify the client. Do not pass wire data.
// Separate instances remain separate; this refactor does not change stacking.
func deliverInventoryItem(tx *sql.Tx, uid uint64, template []byte, days uint32) ([]byte, error) {
	if uid == 0 || len(template) != 68 || protocol.ReadUint16(template, 17) != 0 || days > 3650 {
		return nil, ErrDenied
	}
	var next uint64
	if err := tx.QueryRow("SELECT COALESCE(MAX(instance),1048575)+1 FROM inventory WHERE uid=?", uid).Scan(&next); err != nil {
		return nil, err
	}
	if next == 0 || next > math.MaxUint32 {
		return nil, ErrDenied
	}
	item := bytes.Clone(template)
	protocol.WriteUint32(item, 0, uint32(next))
	if _, err := tx.Exec("INSERT INTO inventory(uid,instance,record) VALUES(?,?,?)", uid, next, item); err != nil {
		return nil, err
	}
	if days > 0 {
		if _, err := tx.Exec("INSERT INTO inventory_expirations(uid,instance,expires_at) VALUES(?,?,?)", uid, next, time.Now().Unix()+int64(days)*86400); err != nil {
			return nil, err
		}
	}
	return item, nil
}
