// latency measures the real bridge transport without logging in or changing game state.
package main

import (
	"bufio"
	"crypto/tls"
	"crypto/x509"
	"encoding/json"
	"flag"
	"fmt"
	"net"
	"net/http"
	"net/url"
	"os"
	"sort"
	"strings"
	"time"

	"github.com/gorilla/websocket"
	"kungfu.local/server/internal/tunnel"
)

type Sample struct {
	Endpoint          string  `json:"endpoint"`
	WebSocketMS       float64 `json:"websocket_connect_ms"`
	InnerTLSMS        float64 `json:"inner_tls_ms"`
	OriginRoundTripMS float64 `json:"origin_round_trip_ms"`
	Error             string  `json:"error,omitempty"`
}

func measure(endpoint, certPath string) (sample Sample) {
	sample.Endpoint = endpoint
	started := time.Now()
	parsed, err := url.Parse(endpoint)
	if err != nil {
		sample.Error = err.Error()
		return
	}
	var raw net.Conn
	if parsed.Scheme == "tls" {
		raw, err = net.DialTimeout("tcp", parsed.Host, 10*time.Second)
	} else {
		dialer := websocket.Dialer{HandshakeTimeout: 10 * time.Second, Proxy: nil}
		headers := http.Header{}
		if strings.HasPrefix(endpoint, "ws://18.") {
			headers.Set("Host", "ebmqxj.sbs")
		}
		var socket *websocket.Conn
		socket, _, err = dialer.Dial(endpoint, headers)
		if err == nil {
			raw = &tunnel.Conn{WS: socket}
		}
	}
	sample.WebSocketMS = float64(time.Since(started).Microseconds()) / 1000
	if err != nil {
		sample.Error = err.Error()
		return
	}
	defer raw.Close()
	certificate, err := os.ReadFile(certPath)
	if err != nil {
		sample.Error = err.Error()
		return
	}
	roots := x509.NewCertPool()
	if !roots.AppendCertsFromPEM(certificate) {
		sample.Error = "invalid certificate"
		return
	}
	connection := tls.Client(raw, &tls.Config{RootCAs: roots, ServerName: "kk-origin", MinVersion: tls.VersionTLS12})
	connection.SetDeadline(time.Now().Add(10 * time.Second))
	started = time.Now()
	if err = connection.Handshake(); err != nil {
		sample.Error = err.Error()
		return
	}
	sample.InnerTLSMS = float64(time.Since(started).Microseconds()) / 1000
	// The backend checks config hash before account lookup/password hashing.
	// A deliberately invalid hash elicits a bounded, encrypted origin response.
	started = time.Now()
	err = json.NewEncoder(connection).Encode(tunnel.Frame{Op: "auth", Account: "latency_probe", Password: strings.Repeat("0", 64), ConfigHash: "latency_probe"})
	if err != nil {
		sample.Error = err.Error()
		return
	}
	encoded, err := tunnel.ReadFrame(bufio.NewReader(connection), 8192)
	sample.OriginRoundTripMS = float64(time.Since(started).Microseconds()) / 1000
	if err != nil {
		sample.Error = err.Error()
		return
	}
	var response tunnel.Frame
	if json.Unmarshal(encoded, &response) != nil || response.Error != "client_config_mismatch" {
		sample.Error = "unexpected origin response"
	}
	return
}

func main() {
	cert := flag.String("cert", "runtime-local/go-online/origin.crt", "pinned certificate")
	count := flag.Int("count", 15, "samples per endpoint")
	direct := flag.Bool("direct", true, "also measure origin with pinned inner TLS")
	customEndpoint := flag.String("endpoint", "", "measure only this TLS or WSS endpoint")
	output := flag.String("output", "latency-report.json", "report path")
	flag.Parse()
	endpoints := []string{"wss://ebmqxj.sbs/kk/tunnel"}
	if *direct {
		endpoints = append(endpoints, "ws://18.231.44.177/kk/tunnel")
	}
	if *customEndpoint != "" {
		endpoints = []string{*customEndpoint}
	}
	var samples []Sample
	for index := 0; index < *count; index++ {
		for _, endpoint := range endpoints {
			sample := measure(endpoint, *cert)
			samples = append(samples, sample)
			encoded, _ := json.Marshal(sample)
			fmt.Println(string(encoded))
		}
		time.Sleep(150 * time.Millisecond)
	}
	summaries := map[string]any{}
	for _, endpoint := range endpoints {
		var values []float64
		for _, sample := range samples {
			if sample.Endpoint == endpoint && sample.Error == "" {
				values = append(values, sample.OriginRoundTripMS)
			}
		}
		sort.Float64s(values)
		if len(values) > 0 {
			var sum float64
			for _, value := range values {
				sum += value
			}
			summaries[endpoint] = map[string]any{"successful": len(values), "failures": *count - len(values), "min_ms": values[0], "median_ms": values[len(values)/2], "p95_ms": values[(len(values)-1)*95/100], "max_ms": values[len(values)-1], "mean_ms": sum / float64(len(values))}
		}
	}
	report := map[string]any{"time": time.Now().Format(time.RFC3339), "method": "pinned inner TLS origin rejection round trip; no account login or DB operation", "samples": samples, "summary": summaries}
	encoded, _ := json.MarshalIndent(report, "", "  ")
	if err := os.WriteFile(*output, encoded, 0600); err != nil {
		panic(err)
	}
	encoded, _ = json.Marshal(summaries)
	fmt.Println("SUMMARY", string(encoded))
}
