package persistence

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"os"
	"strings"
	"sync"
	"testing"
	"time"
)

func TestAutoRegistration(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug database required")
	}
	store, err := Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	var db string
	if err = store.DB.QueryRow("SELECT DATABASE()").Scan(&db); err != nil || !strings.HasPrefix(db, "openkfo_debug_") {
		t.Fatal("not debug database")
	}
	name := fmt.Sprintf("ar%d", time.Now().UnixMicro())
	defer store.DB.Exec("DELETE FROM accounts WHERE account=?", name)
	legacy := func(p string) string {
		h := sha256.Sum256([]byte("xfmRn9z7K1wTfvBYhpCwZmE8yLWN1oLv" + p))
		return hex.EncodeToString(h[:])
	}
	passwords := []string{"123456", "654321", "123456", "654321"}
	results := make([]Account, len(passwords))
	errs := make([]error, len(passwords))
	var wg sync.WaitGroup
	for i, p := range passwords {
		wg.Add(1)
		go func(i int, p string) {
			defer wg.Done()
			results[i], errs[i] = store.AuthenticateOrRegister(strings.ToUpper(name), legacy(p))
		}(i, p)
	}
	wg.Wait()
	var winner Account
	winnerPassword := ""
	for i, a := range results {
		if errs[i] == nil {
			if winner.UID != 0 && winner.UID != a.UID {
				t.Fatal("multiple identities")
			}
			winner = a
			winnerPassword = passwords[i]
		}
	}
	if winner.UID == 0 {
		t.Fatal("no registration succeeded", errs)
	}
	for i, p := range passwords {
		if (errs[i] == nil) != (p == winnerPassword) {
			t.Fatal("wrong password accepted or matching concurrent login rejected", errs)
		}
	}
	if winner.Nickname != "" || len(winner.Inventory) != 0 || !bytes.Equal(winner.Profile, make([]byte, 360)) {
		t.Fatal("auto-created character")
	}
	var count int
	store.DB.QueryRow("SELECT COUNT(*) FROM accounts WHERE account=?", name).Scan(&count)
	if count != 1 {
		t.Fatal("duplicate account")
	}
	var before []byte
	store.DB.QueryRow("SELECT legacy_digest FROM accounts WHERE account=?", name).Scan(&before)
	if _, err = store.AuthenticateOrRegister(name, legacy("wrong-password")); err == nil {
		t.Fatal("wrong password authenticated")
	}
	var after []byte
	store.DB.QueryRow("SELECT legacy_digest FROM accounts WHERE account=?", name).Scan(&after)
	if !bytes.Equal(before, after) {
		t.Fatal("password overwritten")
	}
	if _, err = store.AuthenticateOrRegister("invalid-name", legacy("123456")); err == nil {
		t.Fatal("invalid name registered")
	}
	if _, err = store.AuthenticateOrRegister(name, "not-a-hash"); err == nil {
		t.Fatal("invalid verifier accepted")
	}
}
