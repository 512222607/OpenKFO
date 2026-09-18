// legacy-relay keeps old WSS clients working after the game database moves.
// It forwards the encrypted origin TLS stream; it has no database or passwords.
package main

import (
	"bufio"
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"flag"
	"io"
	"log"
	"net"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/websocket"
	"kungfu.local/server/internal/tunnel"
)

func relay(destination, source net.Conn) {
	buffer := make([]byte, 32768)
	for {
		source.SetReadDeadline(time.Now().Add(75 * time.Second))
		count, err := source.Read(buffer)
		if count > 0 {
			destination.SetWriteDeadline(time.Now().Add(10 * time.Second))
			if _, writeErr := destination.Write(buffer[:count]); writeErr != nil {
				return
			}
		}
		if err != nil {
			return
		}
	}
}
func main() {
	address := flag.String("listen", "127.0.0.1:19090", "legacy HTTP origin")
	upstream := flag.String("upstream", "", "direct TLS game endpoint")
	certificatePath := flag.String("cert", "", "pinned public certificate")
	flag.Parse()
	certificate, err := os.ReadFile(*certificatePath)
	if err != nil {
		log.Fatal(err)
	}
	roots := x509.NewCertPool()
	if !roots.AppendCertsFromPEM(certificate) {
		log.Fatal("invalid pinned certificate")
	}
	slots := make(chan struct{}, 80)
	mux := http.NewServeMux()
	mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
		connection, err := tls.DialWithDialer(&net.Dialer{Timeout: 5 * time.Second}, "tcp", *upstream, &tls.Config{RootCAs: roots, ServerName: "kk-origin", MinVersion: tls.VersionTLS12})
		if err != nil {
			http.Error(w, "unavailable", 503)
			return
		}
		defer connection.Close()
		connection.SetDeadline(time.Now().Add(5 * time.Second))
		if err = json.NewEncoder(connection).Encode(tunnel.Frame{Op: "health"}); err != nil {
			http.Error(w, "unavailable", 503)
			return
		}
		encoded, err := tunnel.ReadFrame(bufio.NewReader(connection), 8192)
		var response tunnel.Frame
		if err != nil || json.Unmarshal(encoded, &response) != nil || response.Op != "health" || response.Value != 1 {
			http.Error(w, "unavailable", 503)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		io.WriteString(w, `{"service":"kungfu-go","status":"ok"}`)
	})
	mux.HandleFunc("GET /kk/tunnel", func(w http.ResponseWriter, r *http.Request) {
		select {
		case slots <- struct{}{}:
			defer func() { <-slots }()
		default:
			http.Error(w, "busy", 503)
			return
		}
		raw, err := net.DialTimeout("tcp", *upstream, 5*time.Second)
		if err != nil {
			http.Error(w, "unavailable", 503)
			return
		}
		defer raw.Close()
		upgrader := websocket.Upgrader{HandshakeTimeout: 10 * time.Second, CheckOrigin: func(r *http.Request) bool { return r.Header.Get("Origin") == "" }}
		socket, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			return
		}
		defer socket.Close()
		socket.SetReadLimit(2 << 20)
		client := &tunnel.Conn{WS: socket}
		done := make(chan struct{})
		go func() { relay(raw, client); raw.Close(); client.Close(); close(done) }()
		relay(client, raw)
		raw.Close()
		client.Close()
		<-done
	})
	server := http.Server{Addr: *address, Handler: mux, ReadHeaderTimeout: 5 * time.Second, IdleTimeout: 90 * time.Second, MaxHeaderBytes: 8192}
	log.Fatal(server.ListenAndServe())
}
