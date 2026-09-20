package bridge

import (
	"net"
	"os"
	"path/filepath"
	"testing"
)

func TestTCPIdentityRecognizesFileAlias(t *testing.T) {
	image, err := os.Executable()
	if err != nil {
		t.Fatal(err)
	}
	alias := filepath.Join(t.TempDir(), "client-alias.exe")
	if err = os.Link(image, alias); err != nil {
		t.Fatal(err)
	}
	listener, err := net.Listen("tcp4", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	defer listener.Close()
	client, err := net.Dial("tcp4", listener.Addr().String())
	if err != nil {
		t.Fatal(err)
	}
	defer client.Close()
	server, err := listener.Accept()
	if err != nil {
		t.Fatal(err)
	}
	defer server.Close()
	for _, path := range []string{image, alias} {
		identity, err := tcpIdentity(server, path)
		if err != nil || identity.PID != uint32(os.Getpid()) || identity.Created == 0 {
			t.Fatalf("same process rejected: %v, %+v", err, identity)
		}
	}
	other := filepath.Join(t.TempDir(), "other.exe")
	if err = os.WriteFile(other, []byte("not the client"), 0600); err != nil {
		t.Fatal(err)
	}
	if _, err = tcpIdentity(server, other); err == nil {
		t.Fatal("unrelated executable accepted")
	}
}
