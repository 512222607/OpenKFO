package game

import (
	"bufio"
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"net"
	"strings"
	"testing"
	"time"

	"kungfu.local/server/internal/tunnel"
)

// A different resource revision must reach normal login admission. Saturating
// password workers keeps this transport regression independent of a database.
func TestConfigHashMismatchReachesLoginAdmission(t *testing.T) {
	cert, err := tunnel.Certificate(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	s := NewServer(NewHub(nil, Config{ConfigHash: strings.Repeat("a", 64)}), cert)
	s.hashing <- struct{}{}
	s.hashing <- struct{}{}
	l, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	defer l.Close()
	go s.ServeTLS(l)
	parsed, err := x509.ParseCertificate(cert.Certificate[0])
	if err != nil {
		t.Fatal(err)
	}
	roots := x509.NewCertPool()
	roots.AddCert(parsed)
	for _, hash := range []string{strings.Repeat("a", 64), strings.Repeat("b", 64), ""} {
		c, err := tls.Dial("tcp", l.Addr().String(), &tls.Config{RootCAs: roots, ServerName: "kk-origin", MinVersion: tls.VersionTLS12})
		if err != nil {
			t.Fatal(err)
		}
		c.SetDeadline(time.Now().Add(5 * time.Second))
		if err := json.NewEncoder(c).Encode(tunnel.Frame{Op: "auth", Account: "hashcheck", Password: strings.Repeat("0", 64), ConfigHash: hash}); err != nil {
			t.Fatal(err)
		}
		data, err := tunnel.ReadFrame(bufio.NewReader(c), 8192)
		c.Close()
		if err != nil {
			t.Fatal(err)
		}
		var reply tunnel.Frame
		if err := json.Unmarshal(data, &reply); err != nil {
			t.Fatal(err)
		}
		if reply.Error != "busy" {
			t.Fatalf("hash %q: wanted normal admission busy, got %q", hash, reply.Error)
		}
	}
}
