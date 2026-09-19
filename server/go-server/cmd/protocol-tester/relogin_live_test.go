package main

import (
	"bufio"
	"crypto/sha256"
	"crypto/tls"
	"crypto/x509"
	"encoding/hex"
	"encoding/json"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"net"
	"net/url"
	"os"
	"path/filepath"
	"testing"
	"time"
)

// Opt-in real TLS regression. Uses only existing independent local test accounts.
func TestLiveNativeRelogin(t *testing.T) {
	config := os.Getenv("OPENKFO_RELOGIN_CONFIG")
	if config == "" {
		t.Skip("local debug server required")
	}
	password := os.Getenv("OPENKFO_TEST_PASSWORD")
	if password == "" {
		t.Fatal("test password required")
	}
	raw, err := os.ReadFile(config)
	if err != nil {
		t.Fatal(err)
	}
	var cfg struct {
		URL  string `json:"url"`
		Hash string `json:"config_hash"`
		Cert string `json:"server_certificate"`
	}
	if err = json.Unmarshal(raw, &cfg); err != nil {
		t.Fatal(err)
	}
	endpoint, err := url.Parse(cfg.URL)
	if err != nil {
		t.Fatal(err)
	}
	if endpoint.Scheme != "tls" || endpoint.Host != "127.0.0.1:19091" {
		t.Fatal("local endpoint required")
	}
	cert := cfg.Cert
	if !filepath.IsAbs(cert) {
		cert = filepath.Join(filepath.Dir(config), cert)
	}
	pem, err := os.ReadFile(cert)
	if err != nil {
		t.Fatal(err)
	}
	roots := x509.NewCertPool()
	if !roots.AppendCertsFromPEM(pem) {
		t.Fatal("certificate")
	}
	receipt := ""
	peer := uint32(0)
	for _, scenario := range []struct {
		name, account string
		before        bool
	}{{"initial", "localtest8", false}, {"immediate", "localtest8", false}, {"delayed_over_udp_lease", "localtest8", false}, {"other_account_udp_before_sdk", "localtest9", true}, {"udp_after_sdk", "localtest9", false}} {
		t.Run(scenario.name, func(t *testing.T) {
			if scenario.name == "delayed_over_udp_lease" {
				time.Sleep(65 * time.Second)
			}
			conn, err := tls.DialWithDialer(&net.Dialer{Timeout: 8 * time.Second}, "tcp", endpoint.Host, &tls.Config{RootCAs: roots, ServerName: "kk-origin", MinVersion: tls.VersionTLS12})
			if err != nil {
				t.Fatal(err)
			}
			defer conn.Close()
			c := &client{conn: conn, reader: bufio.NewReader(conn), encoder: json.NewEncoder(conn), decoders: map[uint32]*protocol.Decoder{}}
			send := func(f tunnel.Frame) {
				t.Helper()
				if err := c.send(f); err != nil {
					t.Fatal(err)
				}
			}
			read := func() tunnel.Frame {
				t.Helper()
				f, _, err := c.read()
				if err != nil {
					t.Fatal(err)
				}
				return f
			}
			game := func(ch, id uint32, p []byte) {
				t.Helper()
				if err := c.game(ch, id, p); err != nil {
					t.Fatal(err)
				}
			}
			wait := func(ch, id uint32) {
				t.Helper()
				if err := c.wait(ch, id); err != nil {
					t.Fatal(err)
				}
			}
			digest := sha256.Sum256([]byte("xfmRn9z7K1wTfvBYhpCwZmE8yLWN1oLv" + password))
			send(tunnel.Frame{Op: "auth", Account: scenario.account, Password: hex.EncodeToString(digest[:]), ConfigHash: cfg.Hash, Port: 18001, PeerReceipt: receipt})
			f := read()
			if f.UID == 0 {
				t.Fatal("auth")
			}
			c.uid = f.UID
			heartbeat := func() {
				p := make([]byte, 28)
				protocol.WriteUint16(p, 0, 1)
				protocol.WriteUint16(p, 2, 1013)
				protocol.WriteUint32(p, 4, peer)
				protocol.WriteUint32(p, 12, peer)
				send(tunnel.Frame{Op: "udp", Port: 18020, Data: p})
				if f := read(); f.Op != "udp" || protocol.ReadUint16(f.Data, 2) != 1014 {
					t.Fatal("heartbeat")
				}
			}
			if scenario.before {
				heartbeat()
			}
			send(tunnel.Frame{Op: "ready"})
			send(tunnel.Frame{Op: "open", Channel: 1, Kind: "sdk"})
			sdk := protocol.LoginEncode(protocol.Message{ID: 1001})
			sdk[6] = 1
			send(tunnel.Frame{Op: "data", Channel: 1, Data: sdk})
			if read().Channel != 1 {
				t.Fatal("sdk")
			}
			if peer != 0 && !scenario.before {
				heartbeat()
			}
			hello := make([]byte, 96)
			protocol.WriteUint64(hello, 0, c.uid)
			protocol.WriteUint32(hello, 49, 594)
			send(tunnel.Frame{Op: "open", Channel: 2, Kind: "game"})
			game(2, 1010, hello)
			wait(2, 1151)
			game(2, 3320, protocol.Uint32Bytes(1))
			wait(2, 1201)
			send(tunnel.Frame{Op: "open", Channel: 3, Kind: "game"})
			game(3, 2010, hello)
			wait(3, 2030)
			if peer == 0 {
				p := make([]byte, 165)
				protocol.WriteUint16(p, 0, 1)
				protocol.WriteUint16(p, 2, 1001)
				send(tunnel.Frame{Op: "udp", Port: 18020, Data: p})
				f := read()
				receipt = f.PeerReceipt
				peer = protocol.ReadUint32(f.Data, 4)
				if receipt == "" || peer == 0 {
					t.Fatal("receipt not delivered")
				}
			}
			game(3, 1156, append(protocol.Uint64Bytes(c.uid), protocol.Uint32Bytes(peer)...))
			send(tunnel.Frame{Op: "ping"})
			if read().Op != "pong" {
				t.Fatal("binding disconnected")
			}
			game(3, 2060, nil)
			wait(3, 2070)
			if scenario.name == "initial" {
				// Native switch keeps the authenticated tunnel, without SDK login.
				send(tunnel.Frame{Op: "open", Channel: 4, Kind: "game"})
				game(4, 2010, hello)
				wait(4, 2030)
				send(tunnel.Frame{Op: "close", Channel: 3})
				send(tunnel.Frame{Op: "close", Channel: 2})
				game(4, 1156, append(protocol.Uint64Bytes(c.uid), protocol.Uint32Bytes(peer)...))
				send(tunnel.Frame{Op: "ping"})
				if read().Op != "pong" {
					t.Fatal("switch disconnected")
				}
				game(4, 2060, nil)
				wait(4, 2070)
				// The alternate native path re-enters bootstrap first.
				send(tunnel.Frame{Op: "open", Channel: 5, Kind: "game"})
				game(5, 1010, hello)
				wait(5, 1151)
				game(5, 3320, protocol.Uint32Bytes(1))
				wait(5, 1201)
				send(tunnel.Frame{Op: "open", Channel: 6, Kind: "game"})
				game(6, 2010, hello)
				wait(6, 2030)
				send(tunnel.Frame{Op: "close", Channel: 4})
				game(6, 1156, append(protocol.Uint64Bytes(c.uid), protocol.Uint32Bytes(peer)...))
				send(tunnel.Frame{Op: "ping"})
				if read().Op != "pong" {
					t.Fatal("bootstrap switch disconnected")
				}
				game(6, 2060, nil)
				wait(6, 2070)
			}
			send(tunnel.Frame{Op: "logout"})
			data, err := tunnel.ReadFrame(c.reader, 8192)
			if err != nil {
				t.Fatal(err)
			}
			var ack tunnel.Frame
			if json.Unmarshal(data, &ack) != nil || ack.Op != "logged_out" {
				t.Fatal("logout ack")
			}
		})
		if t.Failed() {
			return
		}
	}
}
