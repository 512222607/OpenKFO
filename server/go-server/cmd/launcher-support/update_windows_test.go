//go:build windows

package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"os"
	"path/filepath"
	"testing"
)

func TestUpdaterAppliesVerifiedStagedFile(t *testing.T) {
	root := t.TempDir()
	stage := t.TempDir()
	launcher := filepath.Join(root, "launcher.exe")
	exe, err := os.ReadFile(filepath.Join(os.Getenv("WINDIR"), "System32", "whoami.exe"))
	if err != nil {
		t.Fatal(err)
	}
	if err = os.WriteFile(launcher, exe, 0700); err != nil {
		t.Fatal(err)
	}
	name := "data/app.so"
	old := []byte("old-logic")
	next := []byte("new-logic")
	dest := filepath.Join(root, filepath.FromSlash(name))
	if err = atomic(dest, old); err != nil {
		t.Fatal(err)
	}
	if err = atomic(filepath.Join(stage, filepath.FromSlash(name)), next); err != nil {
		t.Fatal(err)
	}
	sum := sha256.Sum256(next)
	plan := updatePlan{Target: root, Stage: stage, Launcher: launcher, Files: []updateFile{{Name: name, SHA256: hex.EncodeToString(sum[:]), Size: int64(len(next))}}}
	path := filepath.Join(stage, "plan.json")
	raw, _ := json.Marshal(plan)
	os.WriteFile(path, raw, 0600)
	os.WriteFile(filepath.Join(root, ".flutter-update-pending"), []byte(path), 0600)
	if err = applyPlan(path); err != nil {
		t.Fatal(err)
	}
	got, _ := os.ReadFile(dest)
	if string(got) != string(next) {
		t.Fatal("logic file not replaced")
	}
	if _, err = os.Stat(filepath.Join(root, ".flutter-update-pending")); !os.IsNotExist(err) {
		t.Fatal("pending update marker not removed")
	}
	// Reject corrupt staged bytes before any replacement.
	atomic(dest, old)
	atomic(filepath.Join(stage, filepath.FromSlash(name)), []byte("corrupt"))
	if err = applyPlan(path); err == nil {
		t.Fatal("corrupt stage accepted")
	}
	got, _ = os.ReadFile(dest)
	if string(got) != string(old) {
		t.Fatal("live file changed on failed verification")
	}
}
