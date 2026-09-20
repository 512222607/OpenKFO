package persistence

import (
	"fmt"
	"github.com/go-sql-driver/mysql"
	"os"
	"strings"
	"sync"
	"testing"
	"time"
)

func TestFriendsIndependentDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug database required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug database")
	}
	s, err := Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer s.DB.Close()
	base := uint64(time.Now().UnixMicro())
	var ids []uint64
	defer func() {
		for _, id := range ids {
			if _, err := s.DB.Exec("DELETE FROM accounts WHERE uid=?", id); err != nil {
				t.Error(err)
			}
		}
	}()
	for i := 0; i < 103; i++ {
		id := base + uint64(i)
		name := fmt.Sprintf("f%d", id)
		p := make([]byte, 360)
		p[122] = 1
		_, err = s.DB.Exec(`INSERT INTO accounts(uid,account,nickname,profile,salt,digest,legacy_salt,legacy_digest) VALUES(?,?,?,?,?,?,?,?)`, id, name, name, p, make([]byte, 16), make([]byte, 32), make([]byte, 16), make([]byte, 32))
		if err != nil {
			t.Fatal(err)
		}
		ids = append(ids, id)
	}
	m := s.FriendManager()
	name := fmt.Sprintf("f%d", base+1)
	var wg sync.WaitGroup
	errs := make(chan error, 8)
	for i := 0; i < 8; i++ {
		wg.Add(1)
		go func() { defer wg.Done(); _, err := m.Change(base, name, true); errs <- err }()
	}
	wg.Wait()
	close(errs)
	for err := range errs {
		if err != nil {
			t.Fatal(err)
		}
	}
	list, err := m.List(base)
	if err != nil || len(list) != 1 || list[0].UID != base+1 {
		t.Fatalf("duplicate %v %v", list, err)
	}
	// Reopening the manager/database must recover persistence.
	s2, err := Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer s2.DB.Close()
	list, err = s2.FriendManager().List(base)
	if err != nil || len(list) != 1 {
		t.Fatal("not persistent", err)
	}
	if _, err = m.Change(base, fmt.Sprintf("f%d", base), true); err != ErrDenied {
		t.Fatal("self accepted")
	}
	if _, err = m.Change(base, "missing-friend", true); err != ErrDenied {
		t.Fatal("missing accepted")
	}
	if _, err = m.Change(base+2, name, false); err != nil {
		t.Fatal(err)
	}
	list, _ = m.List(base)
	if len(list) != 1 {
		t.Fatal("another owner deleted friend")
	}
	list, _ = m.List(base + 1)
	if len(list) != 0 {
		t.Fatal("unexpected reciprocal relationship")
	}
	for i := 2; i <= 100; i++ {
		if _, err = m.Change(base, fmt.Sprintf("f%d", base+uint64(i)), true); err != nil {
			t.Fatal(err)
		}
	}
	if _, err = m.Change(base, fmt.Sprintf("f%d", base+101), true); err != ErrDenied {
		t.Fatal("capacity overflow")
	}
	if _, err = m.Change(base, name, true); err != nil {
		t.Fatal("existing friend rejected at capacity", err)
	}
	for i := 0; i < 2; i++ {
		if _, err = m.Change(base, name, false); err != nil {
			t.Fatal(err)
		}
	}
	list, err = m.List(base)
	if err != nil || len(list) != 99 {
		t.Fatal("delete not idempotent", len(list), err)
	}
}
