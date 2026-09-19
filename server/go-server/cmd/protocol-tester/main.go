// Protocol tester speaks the existing TLS/game protocol; no server-side debug bypass.
package main

import (
	"bufio"
	"crypto/sha256"
	"crypto/tls"
	"crypto/x509"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"net"
	"net/url"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"

	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
)

type command struct {
	CharacterName string `json:"character_name"`
	Config        string `json:"config"`
	Account       string `json:"account"`
	Password      string `json:"password"`
	ID            uint32 `json:"id"`
	Hex           string `json:"hex"`
}
type output struct {
	Time   string `json:"time"`
	Kind   string `json:"kind"`
	Text   string `json:"text"`
	ID     uint32 `json:"id,omitempty"`
	Hex    string `json:"hex,omitempty"`
	Length int    `json:"length,omitempty"`
	UID    uint64 `json:"uid,omitempty"`
	Fatal  bool   `json:"fatal,omitempty"`
}

var outputLock sync.Mutex

func emit(o output) {
	outputLock.Lock()
	defer outputLock.Unlock()
	o.Time = time.Now().Format(time.RFC3339Nano)
	json.NewEncoder(os.Stdout).Encode(o)
}

type client struct {
	conn     net.Conn
	reader   *bufio.Reader
	encoder  *json.Encoder
	mutex    sync.Mutex
	decoders map[uint32]*protocol.Decoder
	uid      uint64
	p2p      uint32
}

func (c *client) send(f tunnel.Frame) error {
	c.mutex.Lock()
	defer c.mutex.Unlock()
	c.conn.SetWriteDeadline(time.Now().Add(8 * time.Second))
	return c.encoder.Encode(f)
}
func (c *client) game(ch, id uint32, p []byte) error {
	data, err := protocol.Encode(protocol.Message{ID: id, Payload: p})
	if err != nil {
		return err
	}
	err = c.send(tunnel.Frame{Op: "data", Channel: ch, Data: data})
	if err == nil {
		emit(output{Kind: "send", ID: id, Hex: hex.EncodeToString(p), Length: len(p), Text: fmt.Sprintf("通道 %d", ch)})
	}
	return err
}
func (c *client) read() (tunnel.Frame, []protocol.Message, error) {
	c.conn.SetReadDeadline(time.Now().Add(45 * time.Second))
	data, err := tunnel.ReadFrame(c.reader, 2*1024*1024)
	if err != nil {
		return tunnel.Frame{}, nil, err
	}
	var f tunnel.Frame
	if err = json.Unmarshal(data, &f); err != nil {
		return f, nil, err
	}
	if f.Op == "relogin" || f.Op == "logged_out" {
		return f, nil, fmt.Errorf("服务器释放了会话")
	}
	if f.Error != "" {
		return f, nil, fmt.Errorf("服务器拒绝：%s", f.Error)
	}
	if f.Op != "data" || f.Channel == 1 {
		return f, nil, nil
	}
	decoder := c.decoders[f.Channel]
	if decoder == nil {
		decoder = &protocol.Decoder{}
		c.decoders[f.Channel] = decoder
	}
	messages, err := decoder.Feed(f.Data)
	for _, m := range messages {
		emit(output{Kind: "receive", ID: m.ID, Hex: hex.EncodeToString(m.Payload), Length: len(m.Payload), Text: describe(m)})
	}
	return f, messages, err
}
func describe(m protocol.Message) string {
	if m.ID == 2421 {
		if len(m.Payload) < 377 {
			return "资料回包过短"
		}
		count := int(m.Payload[16])
		if len(m.Payload) != 377+68*count {
			return "资料回包长度与装备数不一致"
		}
		return fmt.Sprintf("玩家 UID=%d；角色类型=%d；已装备 %d 件；资料长度正确", protocol.ReadUint64(m.Payload, 8), m.Payload[139], count)
	}
	if m.ID == 2431 && len(m.Payload) >= 20 {
		return fmt.Sprintf("兵器库 UID=%d；记录 %d 条", protocol.ReadUint64(m.Payload, 8), protocol.ReadUint32(m.Payload, 16))
	}
	return fmt.Sprintf("收到 %d 字节", len(m.Payload))
}
func (c *client) wait(ch, id uint32) error {
	for n := 0; n < 64; n++ {
		f, m, err := c.read()
		if err != nil {
			return err
		}
		if f.Channel == ch {
			for _, p := range m {
				if p.ID == id {
					return nil
				}
			}
		}
	}
	return fmt.Errorf("未收到预期协议 %d", id)
}
func connect(cmd command) (*client, error) {
	data, err := os.ReadFile(cmd.Config)
	if err != nil {
		return nil, err
	}
	var cfg struct {
		URL         string `json:"url"`
		Certificate string `json:"server_certificate"`
		Hash        string `json:"config_hash"`
	}
	if err = json.Unmarshal(data, &cfg); err != nil {
		return nil, err
	}
	endpoint, err := url.Parse(cfg.URL)
	if err != nil {
		return nil, err
	}
	ip := net.ParseIP(endpoint.Hostname())
	if endpoint.Scheme != "tls" || (endpoint.Hostname() != "localhost" && (ip == nil || !ip.IsLoopback())) {
		return nil, fmt.Errorf("本版本仅允许连接本地 TLS 测试服")
	}
	cert := cfg.Certificate
	if !filepath.IsAbs(cert) {
		cert = filepath.Join(filepath.Dir(cmd.Config), cert)
	}
	pem, err := os.ReadFile(cert)
	if err != nil {
		return nil, err
	}
	roots := x509.NewCertPool()
	if !roots.AppendCertsFromPEM(pem) {
		return nil, fmt.Errorf("证书无效")
	}
	conn, err := tls.DialWithDialer(&net.Dialer{Timeout: 8 * time.Second}, "tcp", endpoint.Host, &tls.Config{RootCAs: roots, ServerName: "kk-origin", MinVersion: tls.VersionTLS12})
	if err != nil {
		return nil, err
	}
	c := &client{conn: conn, reader: bufio.NewReader(conn), encoder: json.NewEncoder(conn), decoders: map[uint32]*protocol.Decoder{}}
	ok := false
	defer func() {
		if !ok {
			conn.Close()
		}
	}()
	digest := sha256.Sum256([]byte("xfmRn9z7K1wTfvBYhpCwZmE8yLWN1oLv" + cmd.Password))
	cmd.Password = ""
	if err = c.send(tunnel.Frame{Op: "auth", Account: cmd.Account, Password: hex.EncodeToString(digest[:]), ConfigHash: cfg.Hash, Port: 18001}); err != nil {
		return nil, err
	}
	f, _, err := c.read()
	if err != nil {
		return nil, err
	}
	if f.Op != "auth" || f.UID == 0 {
		return nil, fmt.Errorf("无效认证响应")
	}
	c.uid = f.UID
	if err = c.send(tunnel.Frame{Op: "ready"}); err != nil {
		return nil, err
	}
	if err = c.send(tunnel.Frame{Op: "open", Channel: 1, Kind: "sdk"}); err != nil {
		return nil, err
	}
	sdk := protocol.LoginEncode(protocol.Message{ID: 1001})
	sdk[6] = 1
	if err = c.send(tunnel.Frame{Op: "data", Channel: 1, Data: sdk}); err != nil {
		return nil, err
	}
	f, _, err = c.read()
	if err != nil {
		return nil, err
	}
	if f.Channel != 1 || len(f.Data) < 10 || protocol.ReadUint16(f.Data, 8) != 1002 {
		return nil, fmt.Errorf("SDK 认证未完成")
	}
	hello := make([]byte, 96)
	protocol.WriteUint64(hello, 0, c.uid)
	protocol.WriteUint32(hello, 49, 594)
	if err = c.send(tunnel.Frame{Op: "open", Channel: 2, Kind: "game"}); err != nil {
		return nil, err
	}
	if err = c.game(2, 1010, hello); err != nil {
		return nil, err
	}
	if err = c.prepareCharacter(cmd.CharacterName); err != nil {
		return nil, err
	}
	if err = c.game(2, 3320, protocol.Uint32Bytes(1)); err != nil {
		return nil, err
	}
	if err = c.wait(2, 1201); err != nil {
		return nil, err
	}
	if err = c.send(tunnel.Frame{Op: "open", Channel: 3, Kind: "game"}); err != nil {
		return nil, err
	}
	if err = c.game(3, 2010, hello); err != nil {
		return nil, err
	}
	if err = c.wait(3, 2030); err != nil {
		return nil, err
	}
	// Use the same authenticated UDP tunnel as the launcher, without binding a
	// local game port. Rooms require this registration and 1156 identity bind.
	if err = c.registerP2P(); err != nil {
		return nil, err
	}
	ok = true
	return c, nil
}
func run() error {
	input := bufio.NewScanner(os.Stdin)
	input.Buffer(make([]byte, 4096), 140000)
	if !input.Scan() {
		return fmt.Errorf("缺少连接参数")
	}
	var cmd command
	if err := json.Unmarshal(input.Bytes(), &cmd); err != nil {
		return err
	}
	c, err := connect(cmd)
	cmd.Password = ""
	if err != nil {
		return err
	}
	defer c.conn.Close()
	emit(output{Kind: "ready", Text: "已连接，资料查询就绪", UID: c.uid})
	failures := make(chan error, 3)
	go func() {
		for {
			_, _, err := c.read()
			if err != nil {
				failures <- err
				return
			}
		}
	}()
	go func() {
		for input.Scan() {
			var q command
			if err := json.Unmarshal(input.Bytes(), &q); err != nil {
				emit(output{Kind: "error", Text: "请求 JSON 无效"})
				continue
			}
			p, err := hex.DecodeString(strings.Join(strings.Fields(q.Hex), ""))
			if err != nil || len(p) > 32768 {
				emit(output{Kind: "error", Text: "十六进制内容无效或超过32768字节"})
				continue
			}
			if err = c.game(3, q.ID, p); err != nil {
				failures <- err
				return
			}
		}
		failures <- fmt.Errorf("测试器已关闭输入")
	}()
	ticker := time.NewTicker(15 * time.Second)
	defer ticker.Stop()
	for {
		select {
		case err := <-failures:
			return err
		case <-ticker.C:
			if err = c.send(tunnel.Frame{Op: "ping"}); err != nil {
				return err
			}
			if err = c.keepP2P(); err != nil {
				return err
			}
		}
	}
}
func main() {
	if err := run(); err != nil {
		msg := err.Error()
		fatal := strings.Contains(msg, "invalid_credentials") || strings.Contains(msg, "client_config_mismatch") || strings.Contains(msg, "仅允许") || strings.Contains(msg, "证书无效")
		emit(output{Kind: "disconnected", Text: msg, Fatal: fatal})
		os.Exit(1)
	}
}
