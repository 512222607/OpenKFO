package game

import (
	"bufio"
	"context"
	"crypto/tls"
	"encoding/json"
	"io"
	"log"
	"net"
	"net/http"
	"os"
	"strings"
	"sync"
	"time"

	"github.com/gorilla/websocket"
	"kungfu.local/server/internal/releases"
	"kungfu.local/server/internal/tunnel"
)

type loginLimit struct {
	Attempts int
	Since    time.Time
}
type Server struct {
	Hub         *Hub
	Certificate tls.Certificate
	connections chan struct{}
	hashing     chan struct{}
	limitMutex  sync.Mutex
	attempts    map[string]loginLimit
}

func NewServer(hub *Hub, certificate tls.Certificate) *Server {
	return &Server{Hub: hub, Certificate: certificate, connections: make(chan struct{}, 80), hashing: make(chan struct{}, 2), attempts: map[string]loginLimit{}}
}

func (server *Server) Handler() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /health", func(writer http.ResponseWriter, request *http.Request) {
		ctx, cancel := context.WithTimeout(request.Context(), 2*time.Second)
		defer cancel()
		if err := server.Hub.Store.DB.PingContext(ctx); err != nil {
			http.Error(writer, "unavailable", 503)
			return
		}
		writer.Header().Set("Content-Type", "application/json")
		io.WriteString(writer, `{"service":"kungfu-go","status":"ok"}`)
	})
	mux.HandleFunc("GET /kk/tunnel", server.accept)
	mux.Handle("GET /updates/", releases.Handler(os.Getenv("OPENKFO_UPDATES_DIR")))
	return mux
}

func (server *Server) allowLogin(account string) bool {
	server.limitMutex.Lock()
	defer server.limitMutex.Unlock()
	now := time.Now()
	for name, limit := range server.attempts {
		if now.Sub(limit.Since) > time.Minute {
			delete(server.attempts, name)
		}
	}
	account = strings.ToLower(account)
	limit := server.attempts[account]
	if limit.Attempts >= 5 || len(server.attempts) >= 4096 {
		return false
	}
	if limit.Since.IsZero() {
		limit.Since = now
	}
	limit.Attempts++
	server.attempts[account] = limit
	return true
}

func (server *Server) accept(writer http.ResponseWriter, request *http.Request) {
	select {
	case server.connections <- struct{}{}:
		defer func() { <-server.connections }()
	default:
		http.Error(writer, "busy", 503)
		return
	}
	// This endpoint is for the packaged bridge; do not admit web page origins.
	upgrader := websocket.Upgrader{HandshakeTimeout: 10 * time.Second, CheckOrigin: func(request *http.Request) bool { return request.Header.Get("Origin") == "" }}
	socket, err := upgrader.Upgrade(writer, request, nil)
	if err != nil {
		return
	}
	defer socket.Close()
	socket.SetReadLimit(2 * 1024 * 1024)
	connection := tls.Server(&tunnel.Conn{WS: socket}, &tls.Config{Certificates: []tls.Certificate{server.Certificate}, MinVersion: tls.VersionTLS12})
	server.serveConnection(connection)
}

// ServeTLS carries the same authenticated protocol directly, without HTTP.
func (server *Server) ServeTLS(listener net.Listener) error {
	for {
		raw, err := listener.Accept()
		if err != nil {
			return err
		}
		select {
		case server.connections <- struct{}{}:
			go func() {
				defer func() { <-server.connections }()
				defer raw.Close()
				connection := tls.Server(raw, &tls.Config{Certificates: []tls.Certificate{server.Certificate}, MinVersion: tls.VersionTLS12})
				server.serveConnection(connection)
			}()
		default:
			raw.Close()
		}
	}
}

func (server *Server) serveConnection(connection *tls.Conn) {
	defer connection.Close()
	connection.SetDeadline(time.Now().Add(20 * time.Second))
	if err := connection.Handshake(); err != nil {
		return
	}
	reader := bufio.NewReaderSize(connection, 65536)
	authBytes, err := tunnel.ReadFrame(reader, 8192)
	if err != nil {
		return
	}
	var auth tunnel.Frame
	if json.Unmarshal(authBytes, &auth) != nil {
		return
	}
	probe := &Session{Trace: server.Hub.Trace, Account: auth.Account}
	probe.tracePacket("C->S", 0, "tunnel:"+auth.Op, 0, nil, true)
	if auth.Op == "health" {
		ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
		defer cancel()
		response := tunnel.Frame{Op: "health", Value: 1}
		if server.Hub.Store.DB.PingContext(ctx) != nil {
			response.Value = 0
			response.Error = "unavailable"
		}
		probe.traceFrame("S->C", response)
		json.NewEncoder(connection).Encode(response)
		return
	}
	if auth.Op != "auth" || len(auth.Account) > 20 || len(auth.Password) != 64 || len(auth.PeerReceipt) > 72 {
		return
	}
	encoder := json.NewEncoder(connection)
	deny := func(reason string) {
		response := tunnel.Frame{Op: "auth", Error: reason}
		probe.traceFrame("S->C", response)
		encoder.Encode(response)
	}
	if auth.ConfigHash != server.Hub.Config.ConfigHash {
		deny("client_config_mismatch")
		return
	}
	if !server.allowLogin(auth.Account) {
		deny("rate_limited")
		return
	}
	select {
	case server.hashing <- struct{}{}:
	default:
		deny("busy")
		return
	}
	account, err := server.Hub.Store.AuthenticateOrRegister(auth.Account, auth.Password)
	<-server.hashing
	auth.Password = ""
	if err != nil {
		deny("invalid_credentials")
		return
	}
	session, err := server.Hub.Attach(account, auth.Port, auth.PeerReceipt)
	if err != nil {
		deny("account_already_online")
		return
	}
	defer server.Hub.Detach(session)
	if err = encoder.Encode(tunnel.Frame{Op: "auth", UID: session.UID}); err != nil {
		return
	}
	session.tracePacket("S->C", 0, "tunnel:auth-ok", 0, nil, false)
	log.Printf("authenticated uid=%d account=%q player=%q", session.UID, session.Account, session.Nickname)
	connection.SetDeadline(time.Time{})
	go func() {
		ticker := time.NewTicker(15 * time.Second)
		defer ticker.Stop()
		for {
			select {
			case <-session.Done:
				return
			case <-ticker.C:
				if err := server.Hub.RefreshExpiredInventory(session); err != nil {
					log.Printf("inventory_refresh_failed uid=%d", session.UID)
				}
			}
		}
	}()
	go func() {
		defer session.Close()
		defer connection.Close()
		for {
			select {
			case <-session.Done:
				return
			case frame := <-session.Output:
				session.queuedBytes.Add(-int64(len(frame.Data) + 128))
				connection.SetWriteDeadline(time.Now().Add(10 * time.Second))
				if encoder.Encode(frame) != nil {
					return
				}
			}
		}
	}()
	for {
		connection.SetReadDeadline(time.Now().Add(75 * time.Second))
		if session.LoggedOut {
			connection.SetReadDeadline(time.Now().Add(5 * time.Second))
		}
		encoded, err := tunnel.ReadFrame(reader, 100000)
		if err != nil {
			break
		}
		var frame tunnel.Frame
		if json.Unmarshal(encoded, &frame) != nil {
			break
		}
		if err = server.Hub.Handle(session, frame); err != nil {
			break
		}
	}
	log.Printf("disconnected uid=%d", session.UID)
}
