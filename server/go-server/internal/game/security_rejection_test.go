package game

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestRemoteBuffOwnershipAuditedAndForwarded(t *testing.T) {
	for _, effect := range []uint32{186, 243, 266} {
		hub, sender, peer, outsider := combatFixture()
		hub.SecurityLogDirectory = t.TempDir()
		sender.Account = "wq1023"
		packet := combatPacket(protocol.BattleEventBuff, 87, sender.UID, peer.UID, 79)
		protocol.WriteUint64(packet.Payload, 47, peer.UID)
		protocol.WriteUint32(packet.Payload, 55, effect)
		protocol.WriteUint32(packet.Payload, 59, 3)
		protocol.WriteUint32(packet.Payload, 63, 2000)
		protocol.WriteUint32(packet.Payload, 75, 1)
		raw, _ := protocol.Encode(packet)
		if err := hub.Handle(sender, tunnel.Frame{Op: "data", Channel: 1, Data: raw}); err != nil {
			t.Fatal(err)
		}
		if len(peer.Output) != 1 || len(outsider.Output) != 0 || len(sender.Output) != 0 {
			t.Fatal("BUFF not isolated to room recipients")
		}
		if !bytes.Equal((<-peer.Output).Data, raw) {
			t.Fatal("BUFF payload changed")
		}
		path := filepath.Join(hub.SecurityLogDirectory, "wq1023_offline.log")
		before, err := os.ReadFile(path)
		if err != nil {
			t.Fatal(err)
		}
		if !strings.Contains(string(before), "已放行转发") || !strings.Contains(string(before), "battle effect ownership") {
			t.Fatal("allowance audit missing")
		}
		if err := hub.Handle(sender, tunnel.Frame{Op: "data", Channel: 1, Data: raw}); err != nil {
			t.Fatal(err)
		}
		after, _ := os.ReadFile(path)
		if len(peer.Output) != 0 || !bytes.Equal(before, after) {
			t.Fatal("duplicate BUFF forwarded or logged again")
		}
		if err := hub.Handle(sender, tunnel.Frame{Op: "ping"}); err != nil {
			t.Fatal(err)
		}
		if (<-sender.Output).Op != "pong" {
			t.Fatal("connection not retained")
		}
	}
}

func TestSecurityRejectionKeepsSessionAndFollowingPacket(t *testing.T) {
	hub, sender, peer, _ := combatFixture()
	hub.SecurityLogDirectory = t.TempDir()
	sender.Account = "test002"
	bad := combatPacket(protocol.BattleEventBuff, 87, sender.UID, peer.UID, 79)
	protocol.WriteUint64(bad.Payload, 47, 99999)
	protocol.WriteUint32(bad.Payload, 55, 266)
	protocol.WriteUint32(bad.Payload, 63, 999000)
	protocol.WriteUint32(bad.Payload, 75, 1)
	encoded, err := protocol.Encode(bad)
	if err != nil {
		t.Fatal(err)
	}
	if err = hub.Handle(sender, tunnel.Frame{Op: "data", Channel: 1, Data: encoded}); err != nil {
		t.Fatal(err)
	}
	if len(peer.Output) != 0 || hub.Sessions[sender.UID] != sender || len(sender.Room.Members[sender.UID].BattleEvents) != 0 {
		t.Fatal("rejection mutated battle or relayed packet")
	}
	data, err := os.ReadFile(filepath.Join(hub.SecurityLogDirectory, "test002_offline.log"))
	if err != nil {
		t.Fatal(err)
	}
	for _, value := range []string{"test002", "8150", "battle unknown effect source", "保留连接", "payload_hex_prefix"} {
		if !strings.Contains(string(data), value) {
			t.Fatalf("audit missing %s", value)
		}
	}
	good := combatPacket(protocol.BattleEventState, 51, sender.UID, sender.UID, 0)
	valid, _ := protocol.Encode(good)
	// Both packets may be decoded from one TCP read. A rejection must not
	// discard an already decoded valid sibling packet.
	if err = hub.Handle(sender, tunnel.Frame{Op: "data", Channel: 1, Data: append(encoded, valid...)}); err != nil {
		t.Fatal(err)
	}
	if len(peer.Output) != 1 {
		t.Fatal("following valid packet not relayed")
	}
	if err = hub.Handle(sender, tunnel.Frame{Op: "ping"}); err != nil {
		t.Fatal(err)
	}
	if (<-sender.Output).Op != "pong" {
		t.Fatal("connection no longer responds")
	}
}

func TestSecurityAuditSafeNameAndRotation(t *testing.T) {
	for _, account := range []string{"../test", "a/b", "a\\b", "a\r\nb", strings.Repeat("a", 200)} {
		if securityLogName(account, 42) != "uid-42_offline.log" {
			t.Fatal("unsafe audit filename")
		}
	}
	hub, sender, _, _ := combatFixture()
	hub.SecurityLogDirectory = t.TempDir()
	sender.Account = "玩家A"
	path := filepath.Join(hub.SecurityLogDirectory, "玩家A_offline.log")
	if err := os.WriteFile(path, make([]byte, securityLogLimit), 0600); err != nil {
		t.Fatal(err)
	}
	hub.recordSecurityRejection(sender, sender.game(), protocol.Message{}, rejectBattle("test"))
	if _, err := os.Stat(path + ".1"); err != nil {
		t.Fatal(err)
	}
	info, err := os.Stat(path)
	if err != nil || info.Size() >= securityLogLimit {
		t.Fatal("audit not rotated", err)
	}
}
