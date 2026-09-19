package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"io"
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
	cleanup, err := prepareLocalConsole()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Local server startup failed:", err)
		return
	}
	defer cleanup()
	address := flag.String("listen", "127.0.0.1:19090", "HTTP origin address")
	tlsAddress := flag.String("tls-listen", "", "optional direct TLS game address")
	configPath := flag.String("config", "config.json", "admitted client configuration")
	certificateDirectory := flag.String("cert-dir", "certificates", "private server certificate directory")
	operation := flag.String("operation", "serve", "serve, import, create-account, reset-password, wallet, snapshot")
	traceProtocol := flag.Bool("trace-protocol", false, "print every decoded protocol packet (sensitive login fields redacted)")
	protocolLog := flag.String("protocol-log", "", "append console and protocol logs to this file")
	flag.Parse()
	log.SetFlags(log.Ldate | log.Ltime | log.Lmicroseconds)
	log.SetOutput(os.Stdout)
	if *protocolLog != "" {
		file, err := os.OpenFile(*protocolLog, os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0600)
		if err != nil {
			log.Fatal(err)
		}
		defer file.Close()
		// Persist first: a detached/closed Windows console can reject stdout
		// writes. That must not prevent the diagnostic file from being written.
		log.SetOutput(io.MultiWriter(file, os.Stdout))
	}
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
	case "create-account", "reset-password":
		var request struct {
			UID               uint64
			Account, Password string
			CreateCharacter   bool `json:"create_character"`
		}
		if err = input.Decode(&request); err == nil {
			if *operation == "reset-password" {
				err = store.ResetPassword(request.UID, request.Account, request.Password)
				break
			}
			var account persistence.Account
			account, err = persistence.NewAccount(request.UID, request.Account, request.Password)
			if err == nil {
				if request.CreateCharacter {
					account.Profile = make([]byte, 360)
					account.Inventory = nil
				}
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
			before, after, err = store.WalletManager().AdjustTickets(request.UID, request.Mode, request.Amount, request.OperationID)
			if err == nil {
				json.NewEncoder(os.Stdout).Encode(map[string]uint32{"before": before, "after": after})
			}
		}
	case "snapshot":
		var request struct{ UID uint64 }
		if err = input.Decode(&request); err == nil {
			var account persistence.Account
			account, err = store.RoleManager().Snapshot(request.UID)
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
		if err = config.ValidateLobbies(); err != nil {
			log.Fatal(err)
		}
		if err = config.ValidateWeaponLevels(); err != nil {
			log.Fatal(err)
		}
		if err = config.ValidateHonour(); err != nil {
			log.Fatal(err)
		}
		if err = config.ValidateTalismanUses(); err != nil {
			log.Fatal(err)
		}
		if err = config.ValidateTalismanRepairs(); err != nil {
			log.Fatal(err)
		}
		if err = store.RewardManager().SeedBattleRewards(config.Settlement); err != nil {
			log.Fatal(err)
		}
		if err = store.SeedHonourSettings(persistence.HonourRules(config.Honour)); err != nil {
			log.Fatal(err)
		}
		if err = store.ItemManager().SeedTalismanSettings(persistence.TalismanRules{Enabled: len(config.TalismanUses)+len(config.TalismanRepairs) > 0, Uses: config.TalismanUses, Repairs: config.TalismanRepairs}); err != nil {
			log.Fatal(err)
		}
		if err = store.ItemManager().SeedWeaponSettings(persistence.WeaponRules{Enabled: config.WeaponUpgradeMode != "", Levels: config.WeaponLevels}); err != nil {
			log.Fatal(err)
		}
		certificate, certErr := tunnel.Certificate(*certificateDirectory)
		if certErr != nil {
			log.Fatal(certErr)
		}
		hub := game.NewHub(store, config)
		if *traceProtocol {
			hub.Trace = log.New(log.Writer(), "", 0)
		}
		gameServer := game.NewServer(hub, certificate)
		server := &http.Server{Addr: *address, Handler: gameServer.Handler(), ReadHeaderTimeout: 5 * time.Second, IdleTimeout: 90 * time.Second, MaxHeaderBytes: 8192}
		ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
		defer stop()
		watchLocalMonitor(stop)
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
