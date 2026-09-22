//go:build windows

package main

import (
	"encoding/json"
	"os"
	"path/filepath"
	"testing"
)

func TestCredentialCompatibilityAndTamper(t *testing.T) {
	path := filepath.Join(t.TempDir(), "credentials.bin")
	r := request{Path: path, Account: "test-user", Password: "test-password", Key: defaultKey}
	if err := save(r); err != nil {
		t.Fatal(err)
	}
	value, err := load(path)
	if err != nil || value.Account != r.Account || value.Password != r.Password {
		t.Fatalf("round trip failed: %v", err)
	}
	b, _ := os.ReadFile(path)
	var e envelope
	if err = json.Unmarshal(b, &e); err != nil {
		t.Fatal(err)
	}
	if len(e.Tag) != 16 || len(e.Nonce) != 12 || len(e.WrappedKey) == 0 {
		t.Fatal("incompatible AES envelope")
	}
	e.Ciphertext[0] ^= 1
	b, _ = json.Marshal(e)
	os.WriteFile(path, b, 0600)
	if _, err = load(path); err == nil {
		t.Fatal("tampered ciphertext accepted")
	}
	plain, _ := json.Marshal(credentials{r.Account, r.Password})
	legacy, err := protect(plain, false)
	if err != nil {
		t.Fatal(err)
	}
	os.WriteFile(path, legacy, 0600)
	value, err = load(path)
	if err != nil || value.Account != r.Account {
		t.Fatal("legacy DPAPI load failed")
	}
}
func TestAtomicReplace(t *testing.T) {
	path := filepath.Join(t.TempDir(), "nested", "file")
	if err := atomic(path, []byte("old")); err != nil {
		t.Fatal(err)
	}
	if err := atomic(path, []byte("new")); err != nil {
		t.Fatal(err)
	}
	b, _ := os.ReadFile(path)
	if string(b) != "new" {
		t.Fatal("replace failed")
	}
}
func TestUpdatePaths(t *testing.T) {
	for _, n := range []string{"../file", "/root", "a\\b", "C:/file", ""} {
		if safeName(n) {
			t.Fatal("accepted unsafe path", n)
		}
	}
}
