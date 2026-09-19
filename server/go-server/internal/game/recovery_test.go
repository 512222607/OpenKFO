package game

import (
	"context"
	"database/sql"
	"database/sql/driver"
	"io"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"strings"
	"testing"
	"time"
)

// Snapshot reads including the no-expiry fast path; unexpected writes fail.
type snapshotDriver struct{}
type snapshotConn struct{ expired bool }
type snapshotRows struct {
	columns []string
	row     []driver.Value
}

func (snapshotDriver) Open(name string) (driver.Conn, error) {
	return snapshotConn{expired: name == "expired"}, nil
}
func (snapshotConn) Prepare(string) (driver.Stmt, error) { return nil, driver.ErrSkip }
func (snapshotConn) Close() error                        { return nil }
func (snapshotConn) Begin() (driver.Tx, error)           { return nil, driver.ErrSkip }
func (c snapshotConn) QueryContext(_ context.Context, q string, args []driver.NamedValue) (driver.Rows, error) {
	if q == "SELECT revision,rules FROM training_rules WHERE id=1" {
		return &snapshotRows{columns: []string{"revision", "rules"}}, nil
	}
	if strings.HasPrefix(q, "SELECT COALESCE(t.training_rank,0)") {
		return &snapshotRows{[]string{"training_rank"}, []driver.Value{int64(0)}}, nil
	}
	if q == "SELECT revision,rules FROM stage_access WHERE id=1" || q == "SELECT revision,rules FROM honour_rules WHERE id=1" {
		return &snapshotRows{columns: []string{"revision", "rules"}}, nil
	}
	if strings.HasPrefix(q, "SELECT EXISTS(SELECT 1 FROM inventory_expirations") {
		return &snapshotRows{[]string{"due"}, []driver.Value{false}}, nil
	}
	if strings.HasPrefix(q, "SELECT t.started FROM accounts a LEFT JOIN training") {
		uid := args[0].Value.(int64)
		if uid == 0 || uid == 999999 {
			return &snapshotRows{columns: []string{"started"}}, nil
		}
		return &snapshotRows{[]string{"started"}, []driver.Value{time.Now().Unix() - uid*60}}, nil
	}
	if q == "SELECT profile FROM accounts WHERE uid=?" {
		return &snapshotRows{[]string{"profile"}, []driver.Value{make([]byte, 360)}}, nil
	}
	if strings.HasPrefix(q, "SELECT account,nickname,profile,gold,tickets") {
		profile := make([]byte, 360)
		profile[122], profile[124] = 1, 1
		return &snapshotRows{[]string{"account", "nickname", "profile", "gold", "tickets"}, []driver.Value{"test", "test", profile, int64(0), int64(0)}}, nil
	}
	if strings.HasPrefix(q, "SELECT record FROM inventory") {
		if c.expired {
			r := make([]byte, 68)
			protocol.WriteUint32(r, 0, 7)
			r[4] = 25
			protocol.WriteUint32(r, 5, 253002)
			protocol.WriteUint32(r, 19, 2)
			return &snapshotRows{[]string{"record"}, []driver.Value{r}}, nil
		}
		return &snapshotRows{columns: []string{"record"}}, nil
	}
	return nil, driver.ErrSkip
}
func (r *snapshotRows) Columns() []string { return r.columns }
func (r *snapshotRows) Close() error      { return nil }
func (r *snapshotRows) Next(out []driver.Value) error {
	if r.row == nil {
		return io.EOF
	}
	copy(out, r.row)
	r.row = nil
	return nil
}
func init() { sql.Register("recovery-snapshot", snapshotDriver{}) }
func recoveryStore(t *testing.T) *persistence.Store {
	db, err := sql.Open("recovery-snapshot", "")
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { db.Close() })
	return &persistence.Store{DB: db}
}

func TestInventoryUpdateDoesNotEquip(t *testing.T) {
	_, s, _, _ := waitingRoomFixture()
	r := make([]byte, 68)
	protocol.WriteUint32(r, 0, 7)
	r[4] = 25
	s.rememberInventory([][]byte{r})
	protocol.WriteUint16(r, 23, 2)
	s.syncInventory([][]byte{r})
	p := roomOutputs(t, s, 2161)[0].Payload
	if protocol.ReadUint16(p, 17) != 0 {
		t.Fatal("update equipped item")
	}
	s.syncInventory([][]byte{r})
	roomOutputs(t, s)
}

func TestReloginClearsOnlyThisSession(t *testing.T) {
	hub, s, peer, _ := waitingRoomFixture()
	s.Channels[3] = &Channel{ID: 3, Kind: "sdk", Phase: "authenticated"}
	s.Bound = true
	s.P2P = 33
	s.TitleOffer, peer.TitleOffer = 1, 2
	s.ConsumeIntents = map[uint32]bool{9: true}
	hub.resetNativeSession(s, 3)
	if s.TitleOffer != 0 || peer.TitleOffer != 2 {
		t.Fatal("relogin failed to isolate title binding")
	}
	if s.Room != nil || s.GameChannel != 0 || s.P2P != 33 || s.Bound || s.ConsumeIntents != nil || hub.Sessions[peer.UID] != peer {
		t.Fatal("relogin leaked state or affected another session")
	}
	if err := hub.Handle(s, tunnel.Frame{Op: "data", Channel: 1, Data: []byte{1}}); err != nil {
		t.Fatal("old in-flight bytes broke relogin", err)
	}
	if err := hub.Handle(s, tunnel.Frame{Op: "close", Channel: 1}); err != nil {
		t.Fatal(err)
	}
}

func TestWeaponCollectionTargetAndDedup(t *testing.T) {
	r := make([]byte, 68)
	r[4] = 25
	protocol.WriteUint32(r, 5, 253030)
	p := weaponCollection(persistence.Account{UID: 42, Inventory: [][]byte{r, r}}).Payload
	if len(p) != 29 || protocol.ReadUint64(p, 8) != 42 || protocol.ReadUint32(p, 16) != 1 || protocol.ReadUint32(p, 20) != 253030 || p[28] != 1 {
		t.Fatal("wrong target or record layout")
	}
}

func TestLogoutAcknowledgesAfterAccountReleased(t *testing.T) {
	hub, s, peer, _ := waitingRoomFixture()
	if err := hub.Handle(s, tunnel.Frame{Op: "logout"}); err != nil {
		t.Fatal(err)
	}
	if hub.Sessions[s.UID] != nil || peer.Room == nil {
		t.Fatal("logout did not release account or destroyed waiting room")
	}
	frame := <-s.Output
	if frame.Op != "logged_out" {
		t.Fatal("missing logout completion")
	}
	newSession, err := hub.Attach(persistence.Account{UID: s.UID, Account: "test"}, 18001)
	if err != nil {
		t.Fatal("immediate relogin rejected", err)
	}
	if err := hub.Handle(s, tunnel.Frame{Op: "data", Channel: 1, Data: []byte{1}}); err != nil {
		t.Fatal("old in-flight data interrupted logout ack", err)
	}
	hub.Detach(s)
	select {
	case <-s.Done:
	default:
		t.Fatal("old output worker was not stopped")
	}
	if hub.Sessions[s.UID] != newSession {
		t.Fatal("old socket cleanup removed new session")
	}
}

func TestLoadingTimeoutAndStaleTimer(t *testing.T) {
	hub, s, peer, _ := waitingRoomFixture()
	hub.Store = recoveryStore(t)
	room := s.Room
	room.Stage = "loading"
	for _, m := range room.Members {
		m.Ready = true
		m.Loaded = true
		m.Input = true
		m.Session.game().Phase = "loading"
	}
	hub.expireLoading(room, room.Serial-1)
	roomOutputs(t, s)
	roomOutputs(t, peer)
	hub.expireLoading(room, room.Serial)
	for _, p := range []*Session{s, peer} {
		packets := roomOutputs(t, p, 3115, 3100, 3160, 3105, 20150)
		if p.Room != room || p.game().Phase != "room" || packets[1].Payload[96+53] != 0 || packets[3].Payload[53] != 0 {
			t.Fatal("stale ready or room state")
		}
	}
	room.Stage = "battle"
	hub.expireLoading(room, room.Serial)
	roomOutputs(t, s)
	roomOutputs(t, peer)
}

func TestNativeReloginButtonAcknowledgesAndClearsRoom(t *testing.T) {
	hub, s, peer, _ := waitingRoomFixture()
	channel := s.game()
	if err := hub.route(s, channel, protocol.Message{ID: 2060}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 2070)
	if s.Room != nil || s.GameChannel != 0 || s.BootstrapChannel != 0 || s.Bound || channel.Phase != "closed" {
		t.Fatal("native relogin retained gameplay state")
	}
	if hub.Sessions[s.UID] != s || s.LoggedOut || hub.Sessions[peer.UID] != peer || peer.Room == nil || peer.Room.Owner != peer.UID {
		t.Fatal("channel leave released account or affected another player")
	}
	if err := hub.route(s, channel, protocol.Message{ID: 2060}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s)
	if err := hub.Handle(s, tunnel.Frame{Op: "logout"}); err != nil {
		t.Fatal(err)
	}
	if frame := <-s.Output; frame.Op != "logged_out" {
		t.Fatalf("same-process reauthentication logout not acknowledged: %q", frame.Op)
	}
	newSession, err := hub.Attach(persistence.Account{UID: s.UID, Account: "test"}, 18001)
	if err != nil {
		t.Fatal(err)
	}
	if err := hub.Handle(s, tunnel.Frame{Op: "data", Channel: 1, Data: []byte{1}}); err != nil {
		t.Fatal(err)
	}
	hub.Detach(s)
	if hub.Sessions[s.UID] != newSession {
		t.Fatal("old cleanup removed new login")
	}
}
