package game

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"os"
	"strings"
	"testing"
	"time"
)

func TestStageGateLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug DB")
	}
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		t.Fatal(err)
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
	h, host, peer, newcomer := waitingRoomFixture()
	h.Store = &persistence.Store{DB: db}
	h.Config.ConfigHash = strings.Repeat("a", 64)
	for i, s := range []*Session{host, peer, newcomer} {
		s.P2PUntil = time.Now().Add(time.Minute)
		s.Bound = true
		p := make([]byte, 360)
		if i == 0 {
			p[123] = 3
		} else {
			p[123] = 1
		}
		exec("INSERT INTO accounts VALUES(?,?)", s.UID, p)
	}
	a := persistence.StageAccess{ClientHash: h.Config.ConfigHash, RequirementsEnabled: true, Requirements: []persistence.StageTitleRequirement{{MapID: 804, Name: "High", TitleLevel: 3}, {MapID: 805, Name: "Low", TitleLevel: 1}}}
	save := func() {
		data, e := json.Marshal(a)
		if e != nil {
			t.Fatal(e)
		}
		exec("REPLACE INTO stage_access VALUES(1,1,?)", data)
	}
	save()
	p := bytes.Clone(host.Room.Request)
	protocol.WriteUint32(p, 38, 0)
	protocol.WriteUint32(p, 42, 804)
	r, e := h.resolveForPlayers(p, newcomer)
	if e != nil || protocol.ReadUint32(r, 38) != 805 {
		t.Fatal("random selection did not exclude inaccessible map", e)
	}
	protocol.WriteUint32(p, 38, 804)
	if _, e = h.resolveForPlayers(p, host); e != nil {
		t.Fatal("qualified owner rejected", e)
	}
	if _, e = h.resolveForPlayers(p, host, peer); e == nil {
		t.Fatal("owner bypassed peer requirement")
	}
	newcomer.Bound = true
	roomRequest(t, h, newcomer, 3010, p)
	roomOutputs(t, newcomer, 3030)
	join := make([]byte, 14)
	protocol.WriteUint16(join, 0, host.Room.ID)
	roomRequest(t, h, newcomer, 3070, join)
	roomOutputs(t, newcomer, 3080, 20150)
	roomRequest(t, h, newcomer, 3075, []byte{0})
	roomOutputs(t, newcomer, 20150)
	if newcomer.Room != nil || newcomer.game().Phase != "lobby" {
		t.Fatal("denied join changed player state")
	}
	original := bytes.Clone(host.Room.Request)
	roomRequest(t, h, host, 3200, roomSettings(original))
	roomOutputs(t, host, 20150)
	roomOutputs(t, peer)
	host.Room.Members[peer.UID].Ready = true
	roomRequest(t, h, host, 4030, nil)
	roomOutputs(t, host, 20150)
	roomOutputs(t, peer)
	if !bytes.Equal(original, host.Room.Request) || host.Room.Stage != "room" || host.Room.Members[host.UID].Ready {
		t.Fatal("denied action mutated room")
	}
	a.ClientHash = strings.Repeat("b", 64)
	save()
	if _, e = h.resolveForPlayers(p, host); e == nil {
		t.Fatal("wrong client version accepted")
	}
	a.ClientHash = h.Config.ConfigHash
	required := true
	a.Requirements[0].UnlockRequired = &required
	save()
	if _, e = h.resolveForPlayers(p, host); e == nil {
		t.Fatal("ungranted owner admitted")
	}
	exec("INSERT INTO stage_player_unlocks VALUES(?,?,1,'[804]')", host.UID, h.Config.ConfigHash)
	if _, e = h.resolveForPlayers(p, host); e != nil {
		t.Fatal("granted owner rejected", e)
	}
	// Give the peer the title, but no grant: every room member must qualify.
	profile := make([]byte, 360)
	profile[123] = 3
	exec("UPDATE accounts SET profile=? WHERE uid=?", profile, peer.UID)
	if _, e = h.resolveForPlayers(p, host, peer); e == nil {
		t.Fatal("owner grant bypassed peer")
	}
	exec("INSERT INTO stage_player_unlocks VALUES(?,?,1,'[804]')", peer.UID, h.Config.ConfigHash)
	if _, e = h.resolveForPlayers(p, host, peer); e != nil {
		t.Fatal("qualified members rejected", e)
	}
	exec("UPDATE stage_player_unlocks SET maps='[]' WHERE uid=?", peer.UID)
	if _, e = h.resolveForPlayers(p, host, peer); e == nil {
		t.Fatal("revoked grant remained active")
	}
	a.RequirementsEnabled = false
	save()
	if _, e = h.resolveForPlayers(p, host, peer); e != nil {
		t.Fatal("disabled requirements still block", e)
	}
	a.Disabled = []uint32{804}
	save()
	if _, e = h.resolveForPlayers(p, host); e == nil {
		t.Fatal("disabled map bypassed")
	}
	// Native 3010 from localtest1 at 23:13:32: newly created title 0 must
	// enter its compulsory tutorial even though mapmgr labels the map title 1.
	a.Disabled = nil
	a.RequirementsEnabled = true
	a.Requirements = []persistence.StageTitleRequirement{{MapID: protocol.TutorialMapID, Name: "训练山", TitleLevel: 1, UnlockRequired: &required}}
	save()
	exec("UPDATE accounts SET profile=? WHERE uid=?", make([]byte, 360), newcomer.UID)
	guide := make([]byte, protocol.RoomRequestSize)
	guide[protocol.RoomCapacityOffset] = 1
	guide[protocol.RoomTypeOffset] = byte(protocol.NewPlayerGuide)
	protocol.WriteUint32(guide, protocol.RoomMapOffset, protocol.TutorialMapID)
	protocol.WriteUint32(guide, protocol.RoomSuggestedMapOffset, protocol.TutorialMapID)
	if _, e = h.resolveForPlayers(guide, newcomer); e != nil {
		t.Fatal("title-zero tutorial rejected", e)
	}
	newcomer.Room = &Room{Request: guide}
	allows, e := h.stageGate(newcomer)
	if e != nil || !allows(protocol.TutorialMapID) {
		t.Fatal("tutorial start still gated", e)
	}
	newcomer.Room = nil
	allows, e = h.stageGate(newcomer)
	if e != nil || allows(protocol.TutorialMapID) {
		t.Fatal("ordinary request bypassed progression", e)
	}
	a.Disabled = []uint32{protocol.TutorialMapID}
	save()
	if _, e = h.resolveForPlayers(guide, newcomer); e == nil {
		t.Fatal("closed tutorial admitted")
	}
	a.Disabled = nil
	a.ClientHash = strings.Repeat("b", 64)
	save()
	if _, e = h.resolveForPlayers(guide, newcomer); e == nil {
		t.Fatal("wrong-version tutorial admitted")
	}

}
