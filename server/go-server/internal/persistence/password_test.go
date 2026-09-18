package persistence

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"os"
	"reflect"
	"testing"
	"time"
)

func TestSixCharacterPassword(t *testing.T) {
	if _, err := NewAccount(1, "passwordtest", "12345"); err == nil {
		t.Fatal("five characters accepted")
	}
	if _, err := NewAccount(1, "passwordtest", "123456"); err != nil {
		t.Fatal(err)
	}
}

func TestPasswordResetPreservesAccount(t *testing.T) {
	dsn := os.Getenv("KK_TEST_MYSQL_DSN")
	if dsn == "" {
		t.Skip("isolated MySQL required")
	}
	store, err := Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	var database string
	if store.DB.QueryRow("SELECT DATABASE()").Scan(&database) != nil || database != "kungfu_game_test" {
		t.Fatal("isolated database required")
	}
	uid := uint64(time.Now().UnixMicro())
	name := fmt.Sprintf("pwd%d", uid%10000000000000)
	account, err := NewAccount(uid, name, "old-password")
	if err != nil {
		t.Fatal(err)
	}
	if err = store.Create(account); err != nil {
		t.Fatal(err)
	}
	defer func() {
		store.DB.Exec("DELETE FROM inventory WHERE uid=?", uid)
		store.DB.Exec("DELETE FROM accounts WHERE uid=?", uid)
	}()
	before, err := store.Snapshot(uid)
	if err != nil {
		t.Fatal(err)
	}
	if err = store.ResetPassword(uid, "wrongaccount", "123456"); err == nil {
		t.Fatal("mismatched identity allowed")
	}
	if err = store.ResetPassword(uid, name, "12345"); err == nil {
		t.Fatal("short reset allowed")
	}
	if err = store.ResetPassword(uid, name, "123456"); err != nil {
		t.Fatal(err)
	}
	legacy := func(password string) string {
		h := sha256.Sum256([]byte("xfmRn9z7K1wTfvBYhpCwZmE8yLWN1oLv" + password))
		return hex.EncodeToString(h[:])
	}
	if _, err = store.Authenticate(name, legacy("old-password")); err == nil {
		t.Fatal("old password remains valid")
	}
	if _, err = store.Authenticate(name, legacy("123456")); err != nil {
		t.Fatal(err)
	}
	after, err := store.Snapshot(uid)
	if err != nil {
		t.Fatal(err)
	}
	if before.Nickname != after.Nickname || before.Gold != after.Gold || before.Tickets != after.Tickets || !reflect.DeepEqual(before.Profile, after.Profile) || !reflect.DeepEqual(before.Inventory, after.Inventory) {
		t.Fatal("reset changed character data")
	}
}
