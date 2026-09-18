//go:build windows

package bridge

import (
	"bufio"
	"context"
	"crypto/rand"
	"crypto/sha256"
	"crypto/tls"
	"crypto/x509"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"net"
	"net/url"
	"os"
	"os/exec"
	"path/filepath"
	"sync"
	"time"

	"github.com/gorilla/websocket"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
)

type Config struct {
	TraceProtocol     bool   `json:"trace_protocol"`
	LoginPort         int    `json:"login_port"`
	SDKPort           int    `json:"sdk_port"`
	GamePort          int    `json:"game_port"`
	URL               string `json:"url"`
	ClientDirectory   string `json:"client_directory"`
	ClientSHA256      string `json:"client_sha256"`
	ConfigHash        string `json:"config_hash"`
	ServerCertificate string `json:"server_certificate"`
	LoginCertificate  string `json:"login_certificate"`
	LoginKey          string `json:"login_key"`
}
type Bridge struct {
	Config Config
	Image  string
	mutex  sync.Mutex
	active *remoteSession
	udp    *net.UDPConn
}
type remoteSession struct {
	account     string
	uid         uint64
	traces      map[uint32]*packetTrace
	identity    Identity
	connection  net.Conn
	reader      *bufio.Reader
	encoder     *json.Encoder
	writeMutex  sync.Mutex
	mutex       sync.Mutex
	channels    map[uint32]net.Conn
	udpPorts    map[int]bool
	nextChannel uint32
	done        chan struct{}
	closeOnce   sync.Once
}

func (session *remoteSession) send(frame tunnel.Frame) error {
	session.writeMutex.Lock()
	defer session.writeMutex.Unlock()
	session.connection.SetWriteDeadline(time.Now().Add(10 * time.Second))
	return session.encoder.Encode(frame)
}
func (session *remoteSession) close() {
	session.closeOnce.Do(func() {
		close(session.done)
		session.connection.Close()
		session.mutex.Lock()
		defer session.mutex.Unlock()
		for _, connection := range session.channels {
			connection.Close()
		}
	})
}

func LoadConfig(path string) (Config, error) {
	var config Config
	encoded, err := os.ReadFile(path)
	if err != nil {
		return config, err
	}
	if err = json.Unmarshal(encoded, &config); err != nil {
		return config, err
	}
	if config.LoginPort == 0 {
		config.LoginPort = 18084
	}
	if config.SDKPort == 0 {
		config.SDKPort = 18000
	}
	if config.GamePort == 0 {
		config.GamePort = 18001
	}
	ports := map[int]bool{}
	for _, port := range []int{config.LoginPort, config.SDKPort, config.GamePort} {
		if port < 1 || port > 65535 || ports[port] {
			return config, fmt.Errorf("invalid or duplicate bridge port: %d", port)
		}
		ports[port] = true
	}
	root, err := filepath.Abs(filepath.Dir(path))
	if err != nil {
		return config, err
	}
	for _, value := range []*string{&config.ClientDirectory, &config.ServerCertificate, &config.LoginCertificate, &config.LoginKey} {
		if !filepath.IsAbs(*value) {
			*value = filepath.Join(root, *value)
		}
	}
	return config, nil
}

func Run(ctx context.Context, config Config, launch bool) error {
	image := filepath.Join(config.ClientDirectory, "gfld.dat")
	for path, expected := range map[string]string{image: config.ClientSHA256, filepath.Join(config.ClientDirectory, "Data", "config.spf2"): config.ConfigHash} {
		file, err := os.Open(path)
		if err != nil {
			return err
		}
		digest := sha256.New()
		_, err = io.Copy(digest, file)
		file.Close()
		if err != nil {
			return err
		}
		if hex.EncodeToString(digest.Sum(nil)) != expected {
			return fmt.Errorf("client file mismatch: %s", filepath.Base(path))
		}
	}
	certificate, err := tls.LoadX509KeyPair(config.LoginCertificate, config.LoginKey)
	if err != nil {
		return err
	}
	bridge := &Bridge{Config: config, Image: image}
	var listeners []net.Listener
	defer func() {
		for _, listener := range listeners {
			listener.Close()
		}
	}()
	for _, port := range []int{config.LoginPort, config.SDKPort, config.GamePort} {
		listener, err := net.Listen("tcp4", fmt.Sprintf("127.0.0.1:%d", port))
		if err != nil {
			return err
		}
		listeners = append(listeners, listener)
		go func(port int, listener net.Listener) {
			for {
				connection, err := listener.Accept()
				if err != nil {
					return
				}
				go func() {
					defer connection.Close()
					if port == config.LoginPort {
						bridge.login(connection, certificate)
					} else {
						kind := "game"
						if port == config.SDKPort {
							kind = "sdk"
						}
						bridge.forward(connection, kind)
					}
				}()
			}
		}(port, listener)
	}
	bridge.udp, err = net.ListenUDP("udp4", &net.UDPAddr{IP: net.IPv4(127, 0, 0, 1), Port: config.GamePort})
	if err != nil {
		return err
	}
	defer bridge.udp.Close()
	go bridge.datagrams()
	log.Printf("online bridge ready: %s", config.URL)
	var process *exec.Cmd
	clientExited := make(chan struct{})
	if launch {
		process = exec.Command(image)
		process.Dir = config.ClientDirectory
		if err = process.Start(); err != nil {
			return err
		}
		go func() { process.Wait(); log.Print("client exited"); close(clientExited) }()
	}
	select {
	case <-ctx.Done():
	case <-clientExited:
	}
	bridge.mutex.Lock()
	if bridge.active != nil {
		bridge.active.close()
	}
	bridge.mutex.Unlock()
	return nil
}

func (bridge *Bridge) connect(account, password string, identity Identity) (*remoteSession, error) {
	publicCertificate, err := os.ReadFile(bridge.Config.ServerCertificate)
	if err != nil {
		return nil, err
	}
	roots := x509.NewCertPool()
	if !roots.AppendCertsFromPEM(publicCertificate) {
		return nil, errors.New("invalid origin certificate")
	}
	endpoint, err := url.Parse(bridge.Config.URL)
	if err != nil {
		return nil, err
	}
	var raw net.Conn
	if endpoint.Scheme == "tls" {
		raw, err = net.DialTimeout("tcp", endpoint.Host, 15*time.Second)
	} else if endpoint.Scheme == "wss" {
		dialer := websocket.Dialer{HandshakeTimeout: 15 * time.Second, Proxy: nil}
		var socket *websocket.Conn
		socket, _, err = dialer.Dial(bridge.Config.URL, nil)
		if err == nil {
			socket.SetReadLimit(2 * 1024 * 1024)
			raw = &tunnel.Conn{WS: socket}
		}
	} else {
		return nil, errors.New("unsupported secure game transport")
	}
	if err != nil {
		return nil, err
	}
	connection := tls.Client(raw, &tls.Config{RootCAs: roots, ServerName: "kk-origin", MinVersion: tls.VersionTLS12})
	connection.SetDeadline(time.Now().Add(20 * time.Second))
	if err = connection.Handshake(); err != nil {
		raw.Close()
		return nil, err
	}
	session := &remoteSession{account: account, traces: map[uint32]*packetTrace{}, identity: identity, connection: connection, reader: bufio.NewReaderSize(connection, 65536), encoder: json.NewEncoder(connection), channels: map[uint32]net.Conn{}, udpPorts: map[int]bool{}, done: make(chan struct{})}
	if err = session.send(tunnel.Frame{Op: "auth", Account: account, Password: password, ConfigHash: bridge.Config.ConfigHash, Port: uint16(bridge.Config.GamePort)}); err != nil {
		session.close()
		return nil, err
	}
	encoded, err := tunnel.ReadFrame(session.reader, 8192)
	if err != nil {
		session.close()
		return nil, err
	}
	var response tunnel.Frame
	if err = json.Unmarshal(encoded, &response); err != nil || response.Op != "auth" || response.Error != "" || response.UID == 0 {
		session.close()
		return nil, fmt.Errorf("login rejected: %s", response.Error)
	}
	session.uid = response.UID
	connection.SetDeadline(time.Time{})
	return session, nil
}

func (bridge *Bridge) login(raw net.Conn, certificate tls.Certificate) {
	identity, err := tcpIdentity(raw, bridge.Image)
	if err != nil {
		log.Print("login identity rejected")
		return
	}
	connection := tls.Server(raw, &tls.Config{Certificates: []tls.Certificate{certificate}, MinVersion: tls.VersionTLS12})
	defer connection.Close()
	connection.SetDeadline(time.Now().Add(45 * time.Second))
	var request struct {
		Type     string `json:"type"`
		Username string `json:"username"`
		Password string `json:"password"`
	}
	decoder := json.NewDecoder(io.LimitReader(connection, 8192))
	if err = decoder.Decode(&request); err != nil || request.Type != "login" {
		return
	}
	// Serialize login replacement, while existing forwarding continues.
	bridge.mutex.Lock()
	defer bridge.mutex.Unlock()
	if bridge.active != nil {
		select {
		case <-bridge.active.done:
			bridge.active = nil
		default:
			current, identityErr := processIdentity(bridge.active.identity.PID, bridge.Image)
			if identityErr == nil && current == bridge.active.identity {
				json.NewEncoder(connection).Encode(map[string]any{"code": 403, "msg": "Client already connected"})
				return
			}
			bridge.active.close()
			bridge.active = nil
		}
	}
	if err = tablesReady(identity); err != nil {
		log.Print("client tables not ready")
		return
	}
	session, err := bridge.connect(request.Username, request.Password, identity)
	request.Password = ""
	if err != nil {
		log.Printf("online login failed: %v", err)
		json.NewEncoder(connection).Encode(map[string]any{"code": 403, "msg": "Online login failed"})
		return
	}
	if err = session.send(tunnel.Frame{Op: "ready"}); err != nil {
		session.close()
		return
	}
	bridge.active = session
	token := make([]byte, 16)
	if _, err = rand.Read(token); err != nil {
		session.close()
		return
	}
	response, err := protocol.LegacyLoginSuccess(hex.EncodeToString(token))
	if err != nil {
		session.close()
		return
	}
	if _, err = connection.Write(response); err != nil {
		session.close()
		return
	}
	go bridge.receive(session)
	go func() {
		ticker := time.NewTicker(15 * time.Second)
		defer ticker.Stop()
		for {
			select {
			case <-session.done:
				return
			case <-ticker.C:
				current, err := processIdentity(identity.PID, bridge.Image)
				if err != nil || current != identity || session.send(tunnel.Frame{Op: "ping"}) != nil {
					session.close()
					return
				}
			}
		}
	}()
	log.Print("online login accepted")
}

func (bridge *Bridge) current(identity Identity) *remoteSession {
	bridge.mutex.Lock()
	defer bridge.mutex.Unlock()
	session := bridge.active
	if session == nil || session.identity != identity {
		return nil
	}
	select {
	case <-session.done:
		return nil
	default:
		return session
	}
}
func (bridge *Bridge) forward(connection net.Conn, kind string) {
	identity, err := tcpIdentity(connection, bridge.Image)
	if err != nil {
		log.Printf("native %s connection identity rejected", kind)
		return
	}
	session := bridge.current(identity)
	if session == nil {
		log.Printf("native %s connection has no authenticated session", kind)
		return
	}
	session.mutex.Lock()
	if len(session.channels) >= 8 {
		session.mutex.Unlock()
		return
	}
	session.nextChannel++
	channelID := session.nextChannel
	session.channels[channelID] = connection
	var upstream *packetTrace
	if bridge.Config.TraceProtocol && kind == "game" {
		upstream = &packetTrace{account: session.account, uid: session.uid, channel: channelID}
		session.traces[channelID] = &packetTrace{account: session.account, uid: session.uid, channel: channelID}
	}
	session.mutex.Unlock()
	log.Printf("native channel opened kind=%s channel=%d", kind, channelID)
	defer func() {
		session.mutex.Lock()
		delete(session.channels, channelID)
		delete(session.traces, channelID)
		session.mutex.Unlock()
		session.send(tunnel.Frame{Op: "close", Channel: channelID})
	}()
	if session.send(tunnel.Frame{Op: "open", Channel: channelID, Kind: kind}) != nil {
		return
	}
	buffer := make([]byte, 32768)
	for {
		count, err := connection.Read(buffer)
		readAt := time.Now()
		if count > 0 {
			packets := upstream.decode(buffer[:count])
			upstream.record("native_read", readAt, packets, nil)
			sendErr := session.send(tunnel.Frame{Op: "data", Channel: channelID, Data: buffer[:count]})
			event := "server_write_complete"
			if sendErr != nil {
				event = "server_write_failed"
			}
			upstream.record(event, time.Now(), packets, sendErr)
			if sendErr != nil {
				log.Printf("bridge_server_write_failed account=%q uid=%d channel=%d error=%v", session.account, session.uid, channelID, sendErr)
				session.close()
				return
			}
		}
		if err != nil {
			log.Printf("native_read_closed account=%q uid=%d channel=%d error=%v", session.account, session.uid, channelID, err)
			return
		}
	}
}
func (bridge *Bridge) receive(session *remoteSession) {
	defer session.close()
	for {
		session.connection.SetReadDeadline(time.Now().Add(75 * time.Second))
		encoded, err := tunnel.ReadFrame(session.reader, 2*1024*1024)
		readAt := time.Now()
		if err != nil {
			log.Printf("bridge_server_read_closed account=%q uid=%d error=%v", session.account, session.uid, err)
			return
		}
		var frame tunnel.Frame
		if json.Unmarshal(encoded, &frame) != nil {
			return
		}
		switch frame.Op {
		case "data":
			session.mutex.Lock()
			connection := session.channels[frame.Channel]
			trace := session.traces[frame.Channel]
			session.mutex.Unlock()
			packets := trace.decode(frame.Data)
			trace.record("server_read", readAt, packets, nil)
			if connection != nil {
				connection.SetWriteDeadline(time.Now().Add(5 * time.Second))
				var written int
				written, err = connection.Write(frame.Data)
				if err == nil && written != len(frame.Data) {
					err = io.ErrShortWrite
				}
				event := "native_write_complete"
				if err != nil {
					event = "native_write_failed"
				}
				trace.record(event, time.Now(), packets, err)
				if err != nil {
					log.Printf("native_write_failed account=%q uid=%d channel=%d bytes=%d error=%v", session.account, session.uid, frame.Channel, written, err)
					return
				}
			}
		case "udp":
			session.mutex.Lock()
			allowed := session.udpPorts[int(frame.Port)]
			session.mutex.Unlock()
			if !allowed {
				return
			}
			bridge.udp.WriteToUDP(frame.Data, &net.UDPAddr{IP: net.IPv4(127, 0, 0, 1), Port: int(frame.Port)})
		case "pong":
		default:
			return
		}
	}
}
func (bridge *Bridge) datagrams() {
	buffer := make([]byte, 32769)
	for {
		count, peer, err := bridge.udp.ReadFromUDP(buffer)
		if err != nil {
			return
		}
		if count > 32768 {
			continue
		}
		identity, err := udpIdentity(peer, bridge.Image)
		if err != nil {
			continue
		}
		session := bridge.current(identity)
		if session == nil {
			continue
		}
		session.mutex.Lock()
		session.udpPorts[peer.Port] = true
		session.mutex.Unlock()
		if session.send(tunnel.Frame{Op: "udp", Port: uint16(peer.Port), Data: buffer[:count]}) != nil {
			session.close()
		}
	}
}
