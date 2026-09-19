package persistence

import (
	"database/sql"
	"encoding/json"
	"github.com/go-sql-driver/mysql"
	"os"
	"strings"
	"testing"
)

func TestStagePlayerUnlocksLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	c, e := mysql.ParseDSN(dsn)
	if e != nil || !strings.HasPrefix(c.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug DB")
	}
	db, e := sql.Open("mysql", dsn)
	if e != nil {
		t.Fatal(e)
	}
	defer db.Close()
	db.SetMaxOpenConns(1)
	db.SetMaxIdleConns(1)
	exec := func(q string, args ...any) {
		t.Helper()
		if _, e := db.Exec(q, args...); e != nil {
			t.Fatal(e)
		}
	}
	exec(`CREATE TEMPORARY TABLE accounts(uid BIGINT PRIMARY KEY,profile BLOB) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE stage_access(id INT PRIMARY KEY,revision BIGINT,rules BLOB) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE stage_player_unlocks(uid BIGINT,client_hash CHAR(64),revision BIGINT,maps BLOB,PRIMARY KEY(uid,client_hash)) ENGINE=InnoDB`)
	exec(`CREATE TEMPORARY TABLE stage_player_unlock_audit(uid BIGINT,client_hash CHAR(64),revision BIGINT,before_data BLOB,after_data BLOB,PRIMARY KEY(uid,client_hash,revision)) ENGINE=InnoDB`)
	exec("INSERT INTO accounts VALUES(1,?),(2,?)", make([]byte, 360), make([]byte, 360))
	hash := strings.Repeat("a", 64)
	required := true
	config, _ := json.Marshal(StageAccess{ClientHash: hash, RequirementsEnabled: true, PVEMaps: []uint32{8110}, Requirements: []StageTitleRequirement{{MapID: 8110, Name: "stage", UnlockRequired: &required}}})
	exec("INSERT INTO stage_access VALUES(1,1,?)", config)
	s := &Store{DB: db}
	view, e := s.StagePlayerView(1, hash)
	if e != nil || !view.Configured || len(view.Maps) != 0 {
		t.Fatal("ungranted projection", view, e)
	}
	p, e := s.StagePlayerUnlocks(1, hash)
	if e != nil || p.Revision != 0 || len(p.Maps) != 0 {
		t.Fatal(p, e)
	}
	p.Maps = []uint32{8110}
	saved, e := s.SaveStagePlayerUnlocks(p)
	if e != nil || saved.Revision != 1 {
		t.Fatal(saved, e)
	}
	view, e = s.StagePlayerView(1, hash)
	if e != nil || !view.Configured || view.RuleRevision != 1 || view.UnlockRevision != 1 || len(view.Maps) != 1 || view.Maps[0] != 8110 {
		t.Fatal("granted projection", view, e)
	}
	if _, e = s.StagePlayerView(1, strings.Repeat("b", 64)); e == nil {
		t.Fatal("wrong catalogue accepted")
	}
	if _, e = s.SaveStagePlayerUnlocks(p); e == nil {
		t.Fatal("stale write accepted")
	}
	peer, e := s.StagePlayerUnlocks(2, hash)
	if e != nil || len(peer.Maps) != 0 {
		t.Fatal("cross-account grant", peer, e)
	}
	for _, bad := range []StagePlayerUnlocks{{UID: 1, ClientHash: strings.Repeat("b", 64), Maps: []uint32{8110}}, {UID: 1, ClientHash: hash, Revision: 1, Maps: []uint32{8111}}, {UID: 1, ClientHash: hash, Revision: 1, Maps: []uint32{8110, 8110}}, {UID: 3, ClientHash: hash, Maps: []uint32{8110}}} {
		if _, e = s.SaveStagePlayerUnlocks(bad); e == nil {
			t.Fatal("invalid grant accepted", bad)
		}
	}
	exec("INSERT INTO stage_player_unlock_audit VALUES(?,?,2,'[]','[]')", 1, hash)
	saved.Maps = nil
	if _, e = s.SaveStagePlayerUnlocks(saved); e == nil {
		t.Fatal("audit failure committed")
	}
	loaded, e := s.StagePlayerUnlocks(1, hash)
	if e != nil || loaded.Revision != 1 || len(loaded.Maps) != 1 {
		t.Fatal("rollback lost grant", loaded, e)
	}
	exec("DELETE FROM stage_player_unlock_audit WHERE revision=2")
	saved, e = s.SaveStagePlayerUnlocks(saved)
	if e != nil || saved.Revision != 2 || len(saved.Maps) != 0 {
		t.Fatal(saved, e)
	}
	view, e = s.StagePlayerView(1, hash)
	if e != nil || view.UnlockRevision != 2 || len(view.Maps) != 0 {
		t.Fatal("revoked projection", view, e)
	}
	old, e := s.StagePlayerUnlocks(1, strings.Repeat("b", 64))
	if e != nil || len(old.Maps) != 0 {
		t.Fatal("cross-version grant", old, e)
	}
	forced, _ := json.Marshal(StageAccess{ClientHash: hash, RequirementsEnabled: true, ForceOpenAll: true, PVEMaps: []uint32{8110}, Requirements: []StageTitleRequirement{{MapID: 8110, Name: "stage", TitleLevel: 20, UnlockRequired: &required}}})
	exec("UPDATE stage_access SET revision=2,rules=? WHERE id=1", forced)
	view, e = s.StagePlayerView(1, hash)
	if e != nil || view.RuleRevision != 2 || len(view.ForcedMaps) != 1 || view.ForcedMaps[0] != 8110 || len(view.Maps) != 1 {
		t.Fatal("force policy not in same snapshot", view, e)
	}
}
