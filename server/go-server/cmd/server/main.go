package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"kungfu.local/server/internal/game"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/tunnel"
)

func main() {
	address := flag.String("listen", "127.0.0.1:19090", "HTTP origin address")
	tlsAddress := flag.String("tls-listen", "", "optional direct TLS game address")
	configPath := flag.String("config", "config.json", "admitted client configuration")
	certificateDirectory := flag.String("cert-dir", "certificates", "private server certificate directory")
	operation := flag.String("operation", "serve", "serve, import, create-account, wallet, snapshot")
	flag.Parse()
	store, err := persistence.Open(os.Getenv("KK_MYSQL_DSN"))
	if err != nil {
		log.Fatal("cannot open game database: ", err)
	}
	defer store.DB.Close()
	input := json.NewDecoder(os.Stdin)
	switch *operation {
	case "import":
		var exported persistence.Export
		if err = input.Decode(&exported); err == nil {
			err = store.Import(exported)
		}
	case "create-account":
		var request struct {
			UID               uint64
			Account, Password string
		}
		if err = input.Decode(&request); err == nil {
			var account persistence.Account
			account, err = persistence.NewAccount(request.UID, request.Account, request.Password)
			if err == nil {
				err = store.Create(account)
			}
		}
	case "wallet":
		var request struct {
			UID         uint64
			Mode        string
			Amount      uint32
			OperationID string
		}
		if err = input.Decode(&request); err == nil {
			var before, after uint32
			before, after, err = store.Wallet(request.UID, request.Mode, request.Amount, request.OperationID)
			if err == nil {
				json.NewEncoder(os.Stdout).Encode(map[string]uint32{"before": before, "after": after})
			}
		}
	case "snapshot":
		var request struct{ UID uint64 }
		if err = input.Decode(&request); err == nil {
			var account persistence.Account
			account, err = store.Snapshot(request.UID)
			if err == nil {
				json.NewEncoder(os.Stdout).Encode(account)
			}
		}
	case "serve":
		var config game.Config
		encoded, readErr := os.ReadFile(*configPath)
		if readErr != nil {
			log.Fatal(readErr)
		}
		if err = json.Unmarshal(encoded, &config); err != nil || len(config.ConfigHash) != 64 || len(config.Pools) == 0 {
			log.Fatal("invalid game configuration")
		}
		certificate, certErr := tunnel.Certificate(*certificateDirectory)
		if certErr != nil {
			log.Fatal(certErr)
		}
		hub := game.NewHub(store, config)
		gameServer := game.NewServer(hub, certificate)
		server := &http.Server{Addr: *address, Handler: gameServer.Handler(), ReadHeaderTimeout: 5 * time.Second, IdleTimeout: 90 * time.Second, MaxHeaderBytes: 8192}
		ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
		defer stop()
		if *tlsAddress != "" {
			listener, listenErr := net.Listen("tcp", *tlsAddress)
			if listenErr != nil {
				log.Fatal(listenErr)
			}
			go func() { <-ctx.Done(); listener.Close() }()
			go func() {
				if serveErr := gameServer.ServeTLS(listener); serveErr != nil && ctx.Err() == nil {
					log.Printf("direct TLS listener failed: %v", serveErr)
					stop()
				}
			}()
			log.Printf("kungfu-go direct TLS listening on %s", *tlsAddress)
		}
		go func() {
			<-ctx.Done()
			hub.Mutex.Lock()
			for _, session := range hub.Sessions {
				session.Close()
			}
			hub.Mutex.Unlock()
			shutdown, cancel := context.WithTimeout(context.Background(), 10*time.Second)
			defer cancel()
			server.Shutdown(shutdown)
		}()
		log.Printf("kungfu-go listening on %s", *address)
		err = server.ListenAndServe()
		if err == http.ErrServerClosed {
			err = nil
		}
	default:
		err = fmt.Errorf("unknown operation")
	}
	if err != nil {
		log.Fatal(err)
	}
}
