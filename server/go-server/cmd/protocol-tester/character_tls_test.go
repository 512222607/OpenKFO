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

	"github.com/go-sql-driver/mysql"
)

func TestCharacterCreationTLS(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug database required")
	}
	dbConfig, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(dbConfig.DBName, "openkfo_debug_") {
		t.Fatal("independent debug database required before opening store")
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
	// Do not seed an account: the actual TLS login must register it and then
	// enter the native naming flow in this same connection.
	defer func() {
		var owned uint64
		if err := store.DB.QueryRow("SELECT uid FROM accounts WHERE account=?", name).Scan(&owned); err != nil {
			return
		}
		for _, table := range []string{"character_creations", "inventory", "accounts"} {
			if _, err := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", owned); err != nil {
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
	cfg := game.Config{ConfigHash: strings.Repeat("a", 64), CharacterChoices: choices, LobbyIDs: []uint32{1, 2}, LobbyNames: map[uint32]string{2: "测试二频道"}}
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
	if err := store.DB.QueryRow("SELECT uid FROM accounts WHERE account=?", name).Scan(&uid); err != nil {
		t.Fatal(err)
	}
	// A ping round-trip confirms the previous 1156 was accepted, not just sent.
	if err := c.send(tunnel.Frame{Op: "ping"}); err != nil {
		t.Fatal(err)
	}
	f, _, err := c.read()
	if err != nil || f.Op != "pong" {
		t.Fatal("new character lobby/P2P", err)
	}
	before, err := store.RoleManager().Snapshot(uid)
	if err != nil {
		t.Fatal(err)
	}
	if before.Nickname != cmd.CharacterName || len(before.Inventory) != 7 || before.Profile[122] != 2 {
		t.Fatal("persisted character differs")
	}
	// Exercise the actual 2250 route and DB summaries with a second TLS player.
	peerAccount, err := persistence.NewAccountWithStarterCharacter(uid+1, fmt.Sprintf("cp%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	if err = store.Create(peerAccount); err != nil {
		t.Fatal(err)
	}
	defer func() {
		for _, table := range []string{"inventory", "accounts"} {
			if _, err := store.DB.Exec("DELETE FROM "+table+" WHERE uid=?", uid+1); err != nil {
				t.Error(err)
			}
		}
	}()
	peerCmd := cmd
	peerCmd.Account = peerAccount.Account
	peerCmd.CharacterName = ""
	peerCmd.LobbyID = 2
	peer, err := connect(peerCmd)
	if err != nil {
		t.Fatal(err)
	}
	defer peer.conn.Close()
	checkList := func(want int) {
		t.Helper()
		if err := c.game(3, 2250, append(protocol.Uint32Bytes(1), protocol.Uint32Bytes(7)...)); err != nil {
			t.Fatal(err)
		}
		f, messages, err := c.read()
		if err != nil || f.Channel != 3 || len(messages) != 1 || messages[0].ID != 2270 {
			t.Fatal("player list reply", err)
		}
		p := messages[0].Payload
		if len(p) != 8+68*want || protocol.ReadUint32(p, 4) != 1 || protocol.ReadUint64(p, 8) != uid || p[8+29] != 2 {
			t.Fatalf("incorrect directory size=%d", len(p))
		}
		if want == 2 && protocol.ReadUint64(p, 76) != uid+1 {
			t.Fatal("missing peer")
		}
	}
	checkList(1) // A second authenticated player in another lobby is invisible.
	if err = peer.game(3, 2060, nil); err != nil {
		t.Fatal(err)
	}
	if err = peer.wait(3, 2070); err != nil {
		t.Fatal(err)
	}
	if err = peer.send(tunnel.Frame{Op: "open", Channel: 4, Kind: "game"}); err != nil {
		t.Fatal(err)
	}
	hello := make([]byte, 96)
	protocol.WriteUint64(hello, 0, uid+1)
	protocol.WriteUint32(hello, 8, 1)
	protocol.WriteUint32(hello, 49, 594)
	if err = peer.game(4, 2010, hello); err != nil {
		t.Fatal(err)
	}
	if err = peer.wait(4, 2030); err != nil {
		t.Fatal(err)
	}
	if err = peer.game(4, 1156, append(protocol.Uint64Bytes(uid+1), protocol.Uint32Bytes(peer.p2p)...)); err != nil {
		t.Fatal(err)
	}
	if err = peer.send(tunnel.Frame{Op: "ping"}); err != nil {
		t.Fatal(err)
	}
	if f, _, err := peer.read(); err != nil || f.Op != "pong" {
		t.Fatal("switched peer binding failed", err)
	}
	checkList(2)
	if err := peer.send(tunnel.Frame{Op: "logout"}); err != nil {
		t.Fatal(err)
	}
	peerRaw, err := tunnel.ReadFrame(peer.reader, 8192)
	if err != nil {
		t.Fatal(err)
	}
	var peerAck tunnel.Frame
	if json.Unmarshal(peerRaw, &peerAck) != nil || peerAck.Op != "logged_out" {
		t.Fatal("peer logout")
	}
	checkList(1)
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
	after, err := store.RoleManager().Snapshot(uid)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(before.Profile, after.Profile) || !bytes.Equal(before.InventoryBytes(), after.InventoryBytes()) {
		t.Fatal("reconnect duplicated or changed character")
	}
	// Only this temporary account is changed. A self-inventory query must
	// delete the vanished instance incrementally, then remain idempotent.
	removed := protocol.ReadUint32(after.Inventory[0], 0)
	if _, err := store.DB.Exec("INSERT INTO inventory_expirations(uid,instance,expires_at) VALUES(?,?,?)", uid, removed, time.Now().Unix()-1); err != nil {
		t.Fatal(err)
	}
	// No query or ping: the live server's periodic refresher must notify an
	// idle player and unequip the expired starter item on its own.
	for _, want := range []uint32{2310, 2161, 2121} {
		_, messages, err := again.read()
		if err != nil || len(messages) != 1 || messages[0].ID != want {
			t.Fatalf("expiry expected %d: %v %v", want, messages, err)
		}
		p := messages[0].Payload
		if want == 2310 && (len(p) != 72 || protocol.ReadUint32(p, 0) != removed || protocol.ReadUint16(p, 21) != 0) {
			t.Fatal("automatic unequip layout")
		}
		if want == 2161 && (len(p) != 68 || protocol.ReadUint32(p, 19) != 2 || protocol.ReadUint16(p, 17) != 0) {
			t.Fatal("expiry not persisted/unequipped")
		}
		if want == 2121 && (len(p) != 8 || protocol.ReadUint32(p, 0) != 1 || protocol.ReadUint32(p, 4) != removed) {
			t.Fatal("expiry notification")
		}
	}
	if _, err := store.DB.Exec("DELETE FROM inventory WHERE uid=? AND instance=?", uid, removed); err != nil {
		t.Fatal(err)
	}
	for attempt := 0; attempt < 2; attempt++ {
		if err := again.game(3, 2430, protocol.Uint64Bytes(uid)); err != nil {
			t.Fatal(err)
		}
		deletes, finished := 0, false
		for n := 0; n < 10 && !finished; n++ {
			_, messages, err := again.read()
			if err != nil {
				t.Fatal(err)
			}
			for _, m := range messages {
				switch m.ID {
				case 2162:
					if len(m.Payload) != 4 || protocol.ReadUint32(m.Payload, 0) != removed {
						t.Fatal("wrong deletion")
					}
					deletes++
				case 1120:
					t.Fatal("unexpected full inventory reset")
				case 2431:
					finished = true
				}
			}
		}
		if !finished || deletes != 1-attempt {
			t.Fatalf("delete sync attempt %d: deletes=%d finished=%v", attempt, deletes, finished)
		}
	}
}
