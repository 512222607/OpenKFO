package persistence

import (
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"github.com/go-sql-driver/mysql"
	"os"
	"strings"
	"testing"
	"time"
)

func TestAccountBanExpirationAndValidation(t *testing.T) {
	for _, tt := range []struct {
		b      AccountBan
		active bool
	}{
		{AccountBan{}, false}, {AccountBan{Enabled: true}, true},
		{AccountBan{Enabled: true, ExpiresAt: 100}, false}, {AccountBan{Enabled: true, ExpiresAt: 101}, true},
		{AccountBan{ExpiresAt: 101}, false},
	} {
		if tt.b.Active(100) != tt.active {
			t.Fatal(tt)
		}
	}
	expiry := int64(101)
	r := AdminRequest{UID: 1, ID: "test", Reason: "test", Enabled: true, ExpiresAt: &expiry}
	if err := validateAccountBan(r, 100); err != nil {
		t.Fatal(err)
	}
	expiry = 100
	if validateAccountBan(r, 100) == nil {
		t.Fatal("accepted past deadline")
	}
	expiry = 0
	r.Reason = "  "
	if validateAccountBan(r, 100) == nil {
		t.Fatal("accepted blank reason")
	}
}

func TestAccountBanLocalDatabase(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("independent debug DB required")
	}
	st, err := Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer st.DB.Close()
	uid := uint64(time.Now().UnixMicro())
	a, err := NewAccount(uid, fmt.Sprintf("bn%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	if err = st.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		st.DB.Exec("DELETE FROM account_ban_audit WHERE uid=?", uid)
		st.DB.Exec("DELETE FROM account_bans WHERE uid=?", uid)
		st.DB.Exec("DELETE FROM accounts WHERE uid=?", uid)
	}()
	expiry := int64(0)
	r := AdminRequest{UID: uid, ID: fmt.Sprintf("ban-%d", uid), Reason: "test", Enabled: true, ExpiresAt: &expiry}
	if _, err = st.SaveAccountBan(r); err != nil {
		t.Fatal(err)
	}
	if _, err = st.SaveAccountBan(r); err != nil {
		t.Fatal("retry", err)
	}
	ban, err := st.AccountBan(uid)
	if err != nil || !ban.Active(time.Now().Unix()) || ban.Generation != 1 {
		t.Fatal(ban, err)
	}
	r.Reason = "changed"
	if _, err = st.SaveAccountBan(r); err == nil {
		t.Fatal("accepted reused id")
	}
	r.Reason = "test"
	r.UID = uid + 1
	r.ID += "missing"
	if _, err = st.SaveAccountBan(r); err == nil {
		t.Fatal("accepted missing user")
	}
	// The public login path must reject a correctly authenticated banned account.
	digest := sha256.Sum256([]byte("xfmRn9z7K1wTfvBYhpCwZmE8yLWN1oLvtest123456"))
	legacy := hex.EncodeToString(digest[:])
	if _, err = st.Authenticate(a.Account, legacy); !errors.Is(err, ErrAccountBanned) {
		t.Fatal("login was not blocked", err)
	}
	r.UID = uid
	r.ID += "unban"
	r.Enabled = false
	if _, err = st.SaveAccountBan(r); err != nil {
		t.Fatal(err)
	}
	if _, err = st.Authenticate(a.Account, legacy); err != nil {
		t.Fatal("unban login", err)
	}
	ban, err = st.AccountBan(uid)
	if err != nil || ban.Active(time.Now().Unix()) || ban.Generation != 1 {
		t.Fatal(ban, err)
	}
}
