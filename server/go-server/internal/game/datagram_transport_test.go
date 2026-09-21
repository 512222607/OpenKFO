package game

import (
	"crypto/tls"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
	"net"
	"testing"
	"time"
)

func TestAuthenticatedUDPRelayAndFallback(t *testing.T) {
	h := NewHub(nil, Config{})
	server := NewServer(h, tls.Certificate{})
	closeUDP, e := server.ListenDatagrams("127.0.0.1:0")
	if e != nil {
		t.Fatal(e)
	}
	defer closeUDP()
	room := &Room{ID: 1, Stage: "battle", Members: map[uint64]*Member{}}
	var sessions []*Session
	var peers []*serverDatagramPeer
	var sockets []*net.UDPConn
	var codecs []*tunnel.DatagramCodec
	for i := 0; i < 2; i++ {
		s := &Session{UID: uint64(i + 1), Account: "udp-test", P2P: uint32(2001 + i), UDPPort: uint16(40001 + i), Bound: true, P2PUntil: time.Now().Add(time.Minute), Room: room, Channels: map[uint32]*Channel{}, Output: make(chan tunnel.Frame, 8), Done: make(chan struct{})}
		h.Mutex.Lock()
		h.Sessions[s.UID] = s
		room.Members[s.UID] = &Member{Session: s}
		h.Mutex.Unlock()
		grant, p := server.registerDatagramPeer(s)
		defer server.unregisterDatagramPeer(p)
		c, _ := tunnel.NewDatagramCodec(grant, false)
		sock, e := net.DialUDP("udp", nil, server.udp.LocalAddr().(*net.UDPAddr))
		if e != nil {
			t.Fatal(e)
		}
		defer sock.Close()
		sock.SetDeadline(time.Now().Add(3 * time.Second))
		if p.send(tunnel.Frame{Op: "udp", Port: s.UDPPort, Data: []byte("before-ready")}) {
			t.Fatal("used unconfirmed UDP")
		}
		hello, _ := c.Seal(0, []byte{1})
		sock.Write(hello)
		buf := make([]byte, 1200)
		n, e := sock.Read(buf)
		if e != nil {
			t.Fatal(e)
		}
		port, data, e := c.Open(buf[:n])
		if e != nil || port != 0 || len(data) != 1 {
			t.Fatal("handshake", e)
		}
		sessions = append(sessions, s)
		peers = append(peers, p)
		sockets = append(sockets, sock)
		codecs = append(codecs, c)
	}
	a, b := sessions[0], sessions[1]
	packet := make([]byte, 29)
	protocol.WriteUint16(packet, 0, 1)
	protocol.WriteUint16(packet, 2, 1008)
	protocol.WriteUint32(packet, 4, a.P2P)
	protocol.WriteUint32(packet, 12, a.P2P)
	packet[23] = 4
	protocol.WriteUint32(packet, 24, b.P2P)
	packet[28] = 99
	encoded, _ := codecs[0].Seal(a.UDPPort, packet)
	sockets[0].Write(encoded)
	select {
	case f := <-b.Output:
		if f.Data[24] != 99 || !peers[1].send(f) {
			t.Fatal("relay failed")
		}
	case <-time.After(2 * time.Second):
		t.Fatal("relay timeout")
	}
	buf := make([]byte, 1200)
	n, e := sockets[1].Read(buf)
	if e != nil {
		t.Fatal(e)
	}
	port, data, e := codecs[1].Open(buf[:n])
	if e != nil || port != b.UDPPort || protocol.ReadUint16(data, 2) != 1009 || data[24] != 99 {
		t.Fatal("reply", e)
	}
	sockets[0].Write(encoded) // replay must not reach the room again
	select {
	case <-b.Output:
		t.Fatal("replay forwarded")
	case <-time.After(50 * time.Millisecond):
	}
	peers[1].mu.Lock()
	peers[1].ready = time.Now().Add(-4 * time.Second)
	peers[1].mu.Unlock()
	if peers[1].send(tunnel.Frame{Op: "udp", Port: b.UDPPort, Data: packet}) {
		t.Fatal("stale path should fall back")
	}
}
