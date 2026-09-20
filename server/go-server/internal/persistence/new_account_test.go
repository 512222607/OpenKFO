package persistence

import (
	"bytes"
	"testing"
)

func TestNewAccountRequiresNativeCharacterCreation(t *testing.T) {
	account, err := NewAccount(123, "newplayer", "123456")
	if err != nil {
		t.Fatal(err)
	}
	if len(account.Profile) != 360 || !bytes.Equal(account.Profile, make([]byte, 360)) || account.Nickname != "" || len(account.Inventory) != 0 {
		t.Fatal("registration pre-created a character; client would skip naming")
	}
	if len(account.Digest) != 32 || len(account.LegacyDigest) != 32 {
		t.Fatal("missing login credentials")
	}
}
