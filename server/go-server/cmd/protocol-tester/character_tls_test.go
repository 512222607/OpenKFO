package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"kungfu.local/server/internal/game"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"net"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func TestCharacterCreationTLS(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug database required")
	}
	store, err := persistence.Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer store.DB.Close()
	var db string
	if err := store.DB.QueryRow("SELECT DATABASE()").Scan(&db); err != nil || !strings.HasPrefix(db, "openkfo_debug_") {
		t.Fatal("not debug database")
	}
	uid := uint64(time.Now().UnixMicro())
	name := fmt.Sprintf("ct%d", uid)
	a, err := persistence.NewAccount(uid, name, "test123456")
	if err != nil {
		t.Fatal(err)
	}
	a.Profile = make([]byte, 360)
	a.Inventory = nil
	if err := store.Create(a); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"character_creations", "inventory", "accounts"} {
			if _, err := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid); err != nil {
				t.Error(err)
			}
		}
	}()
	var choices []persistence.CharacterChoice
	for i, id := range []uint32{152002, 132002, 122001, 172002, 162003, 142002, 253002} {
		choices = append(choices, persistence.CharacterChoice{Gender: 2, Slot: uint32(i), Choice: uint32(900 + i), Item: id})
	}
	root := t.TempDir()
	cert, err := tunnel.Certificate(root)
	if err != nil {
		t.Fatal(err)
	}
	cfg := game.Config{ConfigHash: strings.Repeat("a", 64), CharacterChoices: choices}
	hub := game.NewHub(store, cfg)
	server := game.NewServer(hub, cert)
	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	defer listener.Close()
	go server.ServeTLS(listener)
	bridgeConfig := filepath.Join(root, "bridge.json")
	encoded, _ := json.Marshal(map[string]string{"url": "tls://" + listener.Addr().String(), "server_certificate": filepath.Join(root, "origin.crt"), "config_hash": cfg.ConfigHash})
	if err := os.WriteFile(bridgeConfig, encoded, 0600); err != nil {
		t.Fatal(err)
	}
	cmd := command{Config: bridgeConfig, Account: name, Password: "test123456", CharacterName: fmt.Sprintf("n%d", uid)}
	c, err := connect(cmd)
	if err != nil {
		t.Fatal(err)
	}
	defer c.conn.Close()
	// A ping round-trip confirms the previous 1156 was accepted, not just sent.
	if err := c.send(tunnel.Frame{Op: "ping"}); err != nil {
		t.Fatal(err)
	}
	f, _, err := c.read()
	if err != nil || f.Op != "pong" {
		t.Fatal("new character lobby/P2P", err)
	}
	before, err := store.Snapshot(uid)
	if err != nil {
		t.Fatal(err)
	}
	if before.Nickname != cmd.CharacterName || len(before.Inventory) != 7 || before.Profile[122] != 2 {
		t.Fatal("persisted character differs")
	}
	if err := c.send(tunnel.Frame{Op: "logout"}); err != nil {
		t.Fatal(err)
	}
	raw, err := tunnel.ReadFrame(c.reader, 8192)
	if err != nil {
		t.Fatal(err)
	}
	var ack tunnel.Frame
	if json.Unmarshal(raw, &ack) != nil || ack.Op != "logged_out" {
		t.Fatal("logout")
	}
	c.conn.Close()
	cmd.CharacterName = ""
	again, err := connect(cmd)
	if err != nil {
		t.Fatal("existing character reconnect", err)
	}
	defer again.conn.Close()
	if err := again.game(3, 2420, protocol.Uint64Bytes(uid)); err != nil {
		t.Fatal(err)
	}
	if err := again.wait(3, 2421); err != nil {
		t.Fatal(err)
	}
	after, err := store.Snapshot(uid)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(before.Profile, after.Profile) || !bytes.Equal(before.InventoryBytes(), after.InventoryBytes()) {
		t.Fatal("reconnect duplicated or changed character")
	}
}
