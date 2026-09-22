package game

import (
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"testing"
	"time"
)

func peerHeartbeat(id uint32) tunnel.Frame {
	p := make([]byte, 28)
	protocol.WriteUint16(p, 0, 1)
	protocol.WriteUint16(p, 2, 1013)
	protocol.WriteUint32(p, 4, id)
	protocol.WriteUint32(p, 12, id)
	return tunnel.Frame{Op: "udp", Port: 18020, Data: p}
}

func TestNativePeerReloginLifecycle(t *testing.T) {
	for _, kind := range []string{"immediate", "delayed", "other-account", "udp-before-sdk", "udp-after-sdk", "no-udp-before-bind"} {
		t.Run(kind, func(t *testing.T) {
			hub, old, _, _ := waitingRoomFixture()
			if err := hub.initPeerKey(); err != nil {
				t.Fatal(err)
			}
			old.P2P = 1001
			receipt := hub.peerReceipt(old.P2P)
			old.P2PUntil = time.Now().Add(-5 * time.Minute) // native object survives transport lease
			if err := hub.route(old, old.game(), protocol.Message{ID: 2060}); err != nil {
				t.Fatal(err)
			}
			if err := hub.Handle(old, tunnel.Frame{Op: "logout"}); err != nil {
				t.Fatal(err)
			}
			uid := old.UID
			if kind == "other-account" {
				uid = 9999
			}
			s, err := hub.Attach(persistence.Account{UID: uid}, 18001, receipt)
			if err != nil {
				t.Fatal(err)
			}
			if s.Bound || s.Room != nil || s.UDPPort != 0 {
				t.Fatal("restored game state")
			}
			heartbeat := func() {
				if err := hub.Handle(s, peerHeartbeat(1001)); err != nil {
					t.Fatal(err)
				}
			}
			if kind == "udp-before-sdk" {
				heartbeat()
			}
			s.Channels[1] = &Channel{ID: 1, Kind: "sdk", Phase: "connected"}
			login := protocol.LoginEncode(protocol.Message{ID: 1001})
			login[6] = 1
			if err := hub.Handle(s, tunnel.Frame{Op: "data", Channel: 1, Data: login}); err != nil {
				t.Fatal(err)
			}
			if s.P2P != 1001 || s.Bound {
				t.Fatal("SDK reset lost registration or retained binding")
			}
			if kind == "udp-after-sdk" {
				heartbeat()
			}
			if kind == "delayed" {
				s.P2PUntil = time.Now().Add(-5 * time.Minute)
			}
			s.Channels[2] = &Channel{ID: 2, Kind: "game", Phase: "lobby"}
			s.GameChannel = 2
			payload := append(protocol.Uint64Bytes(uid), protocol.Uint32Bytes(1001)...)
			if err := hub.route(s, s.game(), protocol.Message{ID: 1156, Payload: payload}); err != nil {
				t.Fatal(err)
			}
			if !s.Bound || time.Now().After(s.P2PUntil) {
				t.Fatal("binding not renewed")
			}
			heartbeat()
			hub.Detach(old)
			if hub.Sessions[uid] != s {
				t.Fatal("old connection deleted new session")
			}
		})
	}
}

func TestPeerReceiptIsolation(t *testing.T) {
	hub := NewHub(nil, Config{})
	first, err := hub.Attach(persistence.Account{UID: 1}, 18001)
	if err != nil {
		t.Fatal(err)
	}
	first.P2P = 1001
	receipt := hub.peerReceipt(1001)
	if _, err := hub.Attach(persistence.Account{UID: 2}, 18001, receipt); err == nil {
		t.Fatal("active peer stolen")
	}
	hub.Detach(first)
	for _, bad := range []string{"bad", receipt[:70] + "zz", hub.peerReceipt(0)} {
		if _, err := hub.Attach(persistence.Account{UID: 2}, 18001, bad); err == nil {
			t.Fatal("invalid receipt accepted")
		}
	}
	restarted := NewHub(nil, Config{})
	if _, err := restarted.Attach(persistence.Account{UID: 2}, 18001, receipt); err == nil {
		t.Fatal("receipt survived server restart")
	}
	s, err := hub.Attach(persistence.Account{UID: 2}, 18001)
	if err != nil {
		t.Fatal(err)
	}
	if err := hub.Handle(s, peerHeartbeat(1001)); err == nil {
		t.Fatal("unregistered heartbeat accepted")
	}
	s.Channels[1] = &Channel{ID: 1, Kind: "game", Phase: "lobby"}
	s.GameChannel = 1
	p := append(protocol.Uint64Bytes(s.UID), protocol.Uint32Bytes(1001)...)
	if err := hub.route(s, s.game(), protocol.Message{ID: 1156, Payload: p}); err == nil {
		t.Fatal("unregistered bind accepted")
	}
}

func TestPeerReceiptSurvivesServerRestartWithSameCertificate(t *testing.T) {
	certificate, err := tunnel.Certificate(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	old := NewHub(nil, Config{})
	NewServer(old, certificate)
	receipt := old.peerReceipt(1042)
	restarted := NewHub(nil, Config{})
	NewServer(restarted, certificate)
	s, err := restarted.Attach(persistence.Account{UID: 123}, 18001, receipt)
	if err != nil || s.P2P != 1042 || restarted.NextPlayer != 1043 {
		t.Fatal("server restart invalidated transport identity", err)
	}
	if _, err = restarted.Attach(persistence.Account{UID: 124}, 18001, receipt); err == nil {
		t.Fatal("occupied peer was stolen")
	}
	otherCertificate, err := tunnel.Certificate(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	other := NewHub(nil, Config{})
	NewServer(other, otherCertificate)
	if _, err = other.Attach(persistence.Account{UID: 123}, 18001, receipt); err == nil {
		t.Fatal("another server accepted receipt")
	}
}

func TestPeerRegistrationBeforeGameChannel(t *testing.T) {
	hub := NewHub(nil, Config{})
	s, err := hub.Attach(persistence.Account{UID: 1}, 18001)
	if err != nil {
		t.Fatal(err)
	}
	p := make([]byte, 24+141)
	protocol.WriteUint16(p, 0, 1)
	protocol.WriteUint16(p, 2, 1001)
	if err := hub.Handle(s, tunnel.Frame{Op: "udp", Port: 18020, Data: p}); err != nil {
		t.Fatal(err)
	}
	reply := <-s.Output
	if reply.PeerReceipt == "" || protocol.ReadUint16(reply.Data, 2) != 1002 {
		t.Fatal("missing registration reply")
	}
	if s.Bound {
		t.Fatal("UDP registration granted game binding")
	}
}

func TestClosedPeerRecoveredBeforeDetach(t *testing.T) {
	for _, uid := range []uint64{1, 2} {
		hub := NewHub(nil, Config{})
		old, err := hub.Attach(persistence.Account{UID: 1}, 18001)
		if err != nil {
			t.Fatal(err)
		}
		old.P2P = 1001
		receipt := hub.peerReceipt(old.P2P)
		old.Close()
		replacement, err := hub.Attach(persistence.Account{UID: uid}, 18001, receipt)
		if err != nil || replacement.P2P != 1001 {
			t.Fatalf("closed peer not recovered: %v", err)
		}
		hub.Detach(old)
		if hub.Sessions[uid] != replacement {
			t.Fatal("late detach removed replacement")
		}
	}
}
