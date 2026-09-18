package main

import (
	"encoding/json"
	"flag"
	"kungfu.local/server/internal/adminhttp"
	"kungfu.local/server/internal/desktop"
	"kungfu.local/server/internal/persistence"
	"log"
	"net"
	"net/http"
	"os"
	"time"
)

func main() {
	listen := flag.String("listen", "127.0.0.1:19092", "management listener")
	root := flag.String("root", ".", "directory containing runtime-local/client")
	cert := flag.String("tls-cert", "", "HTTPS certificate; omit only behind a local HTTPS proxy")
	key := flag.String("tls-key", "", "HTTPS private key")
	flag.Parse()
	token := os.Getenv("KK_GM_TOKEN")
	if len(token) < 32 {
		log.Fatal("KK_GM_TOKEN must contain at least 32 bytes")
	}
	host, _, err := net.SplitHostPort(*listen)
	if err != nil {
		log.Fatal(err)
	}
	if *cert == "" || *key == "" {
		ip := net.ParseIP(host)
		if *cert != "" || *key != "" || ip == nil || !ip.IsLoopback() {
			log.Fatal("plain HTTP is allowed only on a literal loopback address behind an HTTPS proxy")
		}
	}
	store, err := persistence.OpenExisting(os.Getenv("KK_MYSQL_DSN"))
	if err != nil {
		log.Fatal("cannot connect management database")
	}
	defer store.DB.Close()
	admin := desktop.New(*root)
	admin.Remote = func(req persistence.AdminRequest) (json.RawMessage, error) {
		result, err := store.Admin(req)
		if err != nil {
			return nil, err
		}
		return json.Marshal(result)
	}
	server := &http.Server{Addr: *listen, Handler: adminhttp.New(token, admin.Call), ReadHeaderTimeout: 5 * time.Second, ReadTimeout: 20 * time.Second, WriteTimeout: 90 * time.Second, IdleTimeout: 30 * time.Second, MaxHeaderBytes: 16 << 10}
	log.Printf("GM API listening on %s", *listen)
	if *cert != "" {
		log.Fatal(server.ListenAndServeTLS(*cert, *key))
	}
	log.Fatal(server.ListenAndServe())
}
