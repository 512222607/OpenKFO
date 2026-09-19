package persistence

import (
	"database/sql"
	"encoding/json"
	"kungfu.local/server/internal/protocol"
)

// A nil list means this server has no extended catalogue configured. An empty
// non-nil list means it is configured but no tasks are currently available.
func (s *TaskManager) ExtendedTasks(uid uint64, hash string) ([]ExtendedTaskState, error) {
	if uid == 0 {
		return nil, ErrDenied
	}
	tx, err := s.store.DB.Begin()
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()
	result, err := extendedTasksTx(tx, uid, hash)
	if err != nil {
		return nil, err
	}
	return result, tx.Commit()
}

// Reused by settlement so counts and battle rewards commit together.
func extendedTasksTx(tx *sql.Tx, uid uint64, hash string) ([]ExtendedTaskState, error) {
	var err error
	var owner uint64
	if err = tx.QueryRow("SELECT uid FROM accounts WHERE uid=? FOR UPDATE", uid).Scan(&owner); err != nil {
		return nil, err
	}
	var settings TaskSettings
	var data []byte
	err = tx.QueryRow("SELECT revision,rules FROM task_rules WHERE id=1 FOR UPDATE").Scan(&settings.Revision, &data)
	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	if err = json.Unmarshal(data, &settings.Rules); err != nil {
		return nil, err
	}
	if err = settings.Validate(); err != nil {
		return nil, err
	}
	rules := settings.Rules.Extended
	if rules == nil {
		return nil, nil
	}
	if hash == "" || rules.ClientHash != hash {
		return nil, ErrDenied
	}
	var today string
	if err = tx.QueryRow("SELECT DATE_FORMAT(UTC_DATE(),'%Y-%m-%d')").Scan(&today); err != nil {
		return nil, err
	}
	rows, err := tx.Query("SELECT task_key,cycle,state,rule_revision,rule_data,counts FROM extended_task_progress WHERE uid=? AND cycle IN ('',?)", uid, today)
	if err != nil {
		return nil, err
	}
	states := map[uint16]ExtendedTaskState{}
	for rows.Next() {
		var r ExtendedTaskState
		var snapshot, counts []byte
		if err = rows.Scan(&r.Key, &r.Cycle, &r.State, &r.Revision, &snapshot, &counts); err != nil {
			rows.Close()
			return nil, err
		}
		if len(counts) != 12 || r.State < 1 || r.State > 4 {
			rows.Close()
			return nil, ErrDenied
		}
		if err = json.Unmarshal(snapshot, &r.Snapshot); err != nil {
			rows.Close()
			return nil, err
		}
		kind := "newbie"
		if r.Cycle != "" {
			kind = "daily"
		}
		frozen := ExtendedTaskRules{ClientHash: r.Snapshot.ClientHash, Catalogue: []ExtendedTaskCatalogueEntry{r.Snapshot.Template}, Tasks: []ExtendedTaskRule{r.Snapshot.Rule}}
		if frozen.Validate() != nil || frozen.ClientHash != hash || r.Snapshot.Rule.ID != r.Key || r.Snapshot.Rule.Kind != kind || r.Snapshot.Template.ID != r.Key || states[r.Key].Key != 0 {
			rows.Close()
			return nil, ErrDenied
		}
		for i := range r.Counts {
			r.Counts[i] = protocol.ReadUint32(counts, i*4)
		}
		states[r.Key] = r
	}
	err = rows.Err()
	rows.Close()
	if err != nil {
		return nil, err
	}
	catalogue := map[uint16]ExtendedTaskCatalogueEntry{}
	for _, r := range rules.Catalogue {
		catalogue[r.ID] = r
	}
	result := []ExtendedTaskState{}
	for _, rule := range rules.Tasks {
		if !rule.Enabled {
			continue
		}
		r, ok := states[rule.ID]
		if !ok {
			cycle := ""
			if rule.Kind == "daily" {
				cycle = today
			}
			r = ExtendedTaskState{Key: rule.ID, Cycle: cycle, State: 1, Revision: settings.Revision, Snapshot: ExtendedTaskSnapshot{ClientHash: hash, Rule: rule, Template: catalogue[rule.ID]}}
		}
		if rule.Kind == "newbie" && r.State == 3 {
			continue
		}
		result = append(result, r)
	}
	return result, nil
}
