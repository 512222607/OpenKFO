package game

import (
	"bufio"
	"crypto/sha256"
	"crypto/tls"
	"crypto/x509"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"github.com/go-sql-driver/mysql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/tunnel"
	"net"
	"os"
	"strings"
	"testing"
	"time"
)

func TestAccountBanDisconnectTLS(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("independent debug DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("independent DB required")
	}
	st, err := persistence.Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer st.DB.Close()
	uid := uint64(time.Now().UnixMicro())
	account, err := persistence.NewAccount(uid, fmt.Sprintf("kt%d", uid), "test123456")
	if err != nil {
		t.Fatal(err)
	}
	if err = st.Create(account); err != nil {
		t.Fatal(err)
	}
	cert, err := tunnel.Certificate(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	hub := NewHub(st, Config{ConfigHash: strings.Repeat("a", 64)})
	server := NewServer(hub, cert)
	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	defer listener.Close()
	go server.ServeTLS(listener)
	roots := x509.NewCertPool()
	parsed, err := x509.ParseCertificate(cert.Certificate[0])
	if err != nil {
		t.Fatal(err)
	}
	roots.AddCert(parsed)
	password := sha256.Sum256([]byte("xfmRn9z7K1wTfvBYhpCwZmE8yLWN1oLvtest123456"))
	connect := func() (*tls.Conn, *bufio.Reader, tunnel.Frame) {
		t.Helper()
		c, err := tls.Dial("tcp", listener.Addr().String(), &tls.Config{RootCAs: roots, ServerName: "kk-origin", MinVersion: tls.VersionTLS12})
		if err != nil {
			t.Fatal(err)
		}
		c.SetDeadline(time.Now().Add(5 * time.Second))
		r := bufio.NewReader(c)
		if err = json.NewEncoder(c).Encode(tunnel.Frame{Op: "auth", Account: account.Account, Password: hex.EncodeToString(password[:]), ConfigHash: hub.Config.ConfigHash, Port: 18001}); err != nil {
			t.Fatal(err)
		}
		data, err := tunnel.ReadFrame(r, 8192)
		if err != nil {
			t.Fatal(err)
		}
		var f tunnel.Frame
		if err = json.Unmarshal(data, &f); err != nil {
			t.Fatal(err)
		}
		return c, r, f
	}
	conn, reader, reply := connect()
	defer conn.Close()
	if reply.Error != "" || reply.UID != uid {
		t.Fatal(reply.Error)
	}
	expiry := int64(0)
	request := persistence.AdminRequest{UID: uid, ID: fmt.Sprintf("tls-ban-%d", uid), Enabled: true, ExpiresAt: &expiry, Reason: "TLS integration test"}
	if _, err = st.SaveAccountBan(request); err != nil {
		t.Fatal(err)
	}
	if _, err = tunnel.ReadFrame(reader, 8192); err == nil {
		t.Fatal("connection remained open")
	} else if n, ok := err.(net.Error); ok && n.Timeout() {
		t.Fatal("ban did not disconnect within deadline")
	}
	conn2, _, reply := connect()
	conn2.Close()
	if reply.Error != "account_banned" {
		t.Fatal("relogin not blocked", reply.Error)
	}
	request.ID += "-unban"
	request.Enabled = false
	if _, err = st.SaveAccountBan(request); err != nil {
		t.Fatal(err)
	}
	conn3, _, reply := connect()
	conn3.Close()
	if reply.Error != "" {
		t.Fatal("unban failed", reply.Error)
	}
}
