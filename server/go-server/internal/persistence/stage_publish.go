package persistence

import (
	"database/sql"
	"encoding/json"
	"fmt"
)

// BeginStageRebind holds the policy lock until the caller activates or rolls
// back the release. The caller must first verify both map catalogues/scripts.
// Raw JSON preserves fields introduced by newer administration tools.
func (s *Store) BeginStageRebind(oldHash, newHash string) (*sql.Tx, error) {
	tx, err := s.DB.Begin()
	if err != nil {
		return nil, err
	}
	if err = rebindStage(tx, oldHash, newHash); err != nil {
		tx.Rollback()
		return nil, err
	}
	return tx, nil
}

func rebindStage(tx *sql.Tx, oldHash, newHash string) error {
	var revision uint64
	var before []byte
	err := tx.QueryRow("SELECT revision,rules FROM stage_access WHERE id=1 FOR UPDATE").Scan(&revision, &before)
	if err == sql.ErrNoRows {
		return nil
	}
	if err != nil {
		return err
	}
	a, err := decodeStageAccess(before, revision)
	if err != nil {
		return err
	}
	if a.ClientHash == "" || oldHash == newHash {
		return nil
	}
	if a.ClientHash != oldHash {
		return fmt.Errorf("关卡绑定与当前发布版本不一致，拒绝发布；请先核对关卡配置")
	}
	var fields map[string]json.RawMessage
	if err = json.Unmarshal(before, &fields); err != nil {
		return err
	}
	fields["client_hash"], _ = json.Marshal(newHash)
	fields["revision"], _ = json.Marshal(revision + 1)
	after, err := json.Marshal(fields)
	if err != nil {
		return err
	}
	if _, err = decodeStageAccess(after, revision+1); err != nil {
		return err
	}
	if _, err = tx.Exec("UPDATE stage_access SET revision=revision+1,rules=? WHERE id=1", after); err != nil {
		return err
	}
	if _, err = tx.Exec("INSERT INTO stage_access_audit(revision,before_data,after_data) VALUES(?,?,?)", revision+1, before, after); err != nil {
		return err
	}
	// Carry forward explicit player unlocks too. A conflicting target-version
	// grant is rejected rather than silently overwriting an operator's changes.
	rows, err := tx.Query("SELECT uid,maps FROM stage_player_unlocks WHERE client_hash=?", oldHash)
	if err != nil {
		return err
	}
	type grant struct {
		uid  uint64
		maps []byte
	}
	var grants []grant
	for rows.Next() {
		var g grant
		if err = rows.Scan(&g.uid, &g.maps); err != nil {
			rows.Close()
			return err
		}
		grants = append(grants, g)
	}
	err = rows.Err()
	rows.Close()
	if err != nil {
		return err
	}
	for _, g := range grants {
		if _, err = tx.Exec("INSERT INTO stage_player_unlocks(uid,client_hash,revision,maps) VALUES(?,?,1,?)", g.uid, newHash, g.maps); err != nil {
			return err
		}
		if _, err = tx.Exec("INSERT INTO stage_player_unlock_audit(uid,client_hash,revision,before_data,after_data) VALUES(?,?,1,'[]',?)", g.uid, newHash, g.maps); err != nil {
			return err
		}
	}
	return nil
}
