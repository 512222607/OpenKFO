package game

import (
	"bytes"
	"crypto/rand"
	"encoding/hex"
	"fmt"
	"log"
	"sync"
	"sync/atomic"
	"time"
	"unicode"

	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
)

// Hub serializes room transitions. Network writes run outside this lock so a
// slow player cannot block the other players. Split by room if scale requires it.
type Hub struct {
	Trace      *log.Logger
	Mutex      sync.Mutex
	Store      *persistence.Store
	Config     Config
	Rooms      map[uint16]*Room
	Sessions   map[uint64]*Session
	NextPlayer uint32
}

type Channel struct {
	ID          uint32
	Kind        string
	Phase       string
	Decoder     protocol.Decoder
	LoginBuffer []byte
	Sequence    uint64
}

type Session struct {
	Trace            *log.Logger
	UID              uint64
	Account          string
	Nickname         string
	Namespace        string
	Channels         map[uint32]*Channel
	Output           chan tunnel.Frame
	Done             chan struct{}
	closeOnce        sync.Once
	queuedBytes      atomic.Int64
	GameChannel      uint32
	BootstrapChannel uint32
	HandoffUntil     time.Time
	GrantUntil       time.Time
	TablesReady      bool
	Room             *Room
	P2P              uint32
	P2PUntil         time.Time
	Bound            bool
	Port             uint16
	LastChat         time.Time
	ConsumeIntents   map[uint32]bool
	LastBattleNotice time.Time
	UDPPort          uint16
	LastUDPNotice    time.Time
	UDPRelayed       uint64
}

func NewHub(store *persistence.Store, config Config) *Hub {
	return &Hub{Store: store, Config: config, Rooms: map[uint16]*Room{}, Sessions: map[uint64]*Session{}, NextPlayer: 1001}
}

func (hub *Hub) Attach(account persistence.Account, port uint16) (*Session, error) {
	hub.Mutex.Lock()
	defer hub.Mutex.Unlock()
	if hub.Sessions[account.UID] != nil || len(hub.Sessions) >= 64 || port == 0 {
		return nil, persistence.ErrDenied
	}
	nonce := make([]byte, 16)
	if _, err := rand.Read(nonce); err != nil {
		return nil, err
	}
	session := &Session{Trace: hub.Trace, UID: account.UID, Account: account.Account, Nickname: account.Nickname,
		Namespace: hex.EncodeToString(nonce), Channels: map[uint32]*Channel{}, Output: make(chan tunnel.Frame, 128),
		Done: make(chan struct{}), Port: port, GrantUntil: time.Now().Add(2 * time.Minute)}
	hub.Sessions[session.UID] = session
	return session, nil
}

func (session *Session) Close() { session.closeOnce.Do(func() { close(session.Done) }) }
func (session *Session) emit(frame tunnel.Frame) {
	select {
	case <-session.Done:
		return
	default:
	}
	if session.queuedBytes.Add(int64(len(frame.Data)+128)) > 2*1024*1024 {
		session.Close()
		return
	}
	select {
	case session.Output <- frame:
		session.traceFrame("S->C queued", frame)
	default:
		session.Close()
	}
}
func (session *Session) game() *Channel { return session.Channels[session.GameChannel] }
func (session *Session) send(channelID uint32, message protocol.Message) {
	encoded, err := protocol.Encode(message)
	if err != nil {
		session.Close()
		return
	}
	session.emit(tunnel.Frame{Op: "data", Channel: channelID, Data: encoded})
}
func (session *Session) sendGame(message protocol.Message) {
	if session.game() != nil {
		session.send(session.GameChannel, message)
	}
}
func (hub *Hub) Detach(session *Session) {
	hub.Mutex.Lock()
	defer hub.Mutex.Unlock()
	if hub.Sessions[session.UID] != session {
		return
	}
	hub.leave(session, false)
	delete(hub.Sessions, session.UID)
	session.Close()
}
func (hub *Hub) profileReady(session *Session) error {
	channel := session.Channels[session.BootstrapChannel]
	if !session.TablesReady || channel == nil || channel.Phase != "bootstrap" {
		return nil
	}
	account, err := hub.Store.Snapshot(session.UID)
	if err != nil {
		return err
	}
	channel.Phase = "profile_sent"
	session.send(channel.ID, protocol.Message{ID: 1151, Payload: append(account.Profile, account.InventoryBytes()...)})
	return nil
}

// Handle accepts authenticated tunnel operations. UID is bound by Attach;
// native packet fields can only confirm it, never select another account.
func (hub *Hub) Handle(session *Session, frame tunnel.Frame) error {
	hub.Mutex.Lock()
	defer hub.Mutex.Unlock()
	if hub.Sessions[session.UID] != session {
		return persistence.ErrDenied
	}
	if frame.Op != "data" {
		session.traceFrame("C->S", frame)
	}
	switch frame.Op {
	case "ping":
		session.emit(tunnel.Frame{Op: "pong"})
		return nil
	case "ready":
		session.TablesReady = true
		return hub.profileReady(session)
	case "open":
		if frame.Channel == 0 || len(session.Channels) >= 8 || session.Channels[frame.Channel] != nil || (frame.Kind != "sdk" && frame.Kind != "game") {
			return protocol.ErrFrame
		}
		session.Channels[frame.Channel] = &Channel{ID: frame.Channel, Kind: frame.Kind, Phase: "connected"}
	case "close":
		if frame.Channel == session.GameChannel {
			hub.leave(session, false)
			session.GameChannel = 0
			session.Bound = false
		}
		if frame.Channel == session.BootstrapChannel {
			session.BootstrapChannel = 0
		}
		delete(session.Channels, frame.Channel)
	case "udp":
		return hub.datagram(session, frame)
	case "data":
		channel := session.Channels[frame.Channel]
		if channel == nil || len(frame.Data) > 65536 {
			return protocol.ErrFrame
		}
		if channel.Kind == "sdk" {
			return hub.sdk(session, channel, frame.Data)
		}
		messages, err := channel.Decoder.Feed(frame.Data)
		if err != nil {
			session.tracePacket("C->S", channel.ID, "invalid-game-frame", 0, frame.Data, false)
			return err
		}
		for _, message := range messages {
			session.tracePacket("C->S", channel.ID, "game", message.ID, message.Payload, false)
			channel.Sequence++
			if err = hub.route(session, channel, message); err != nil {
				log.Printf("packet_rejected uid=%d channel=%d phase=%s message=%d reason=%v", session.UID, channel.ID, channel.Phase, message.ID, err)
				return err
			}
		}
	default:
		return protocol.ErrFrame
	}
	return nil
}

func (hub *Hub) sdk(session *Session, channel *Channel, data []byte) error {
	channel.LoginBuffer = append(channel.LoginBuffer, data...)
	if len(channel.LoginBuffer) > 8192 {
		return protocol.ErrFrame
	}
	for len(channel.LoginBuffer) >= 8 {
		buffer := channel.LoginBuffer
		length := int(protocol.ReadUint16(buffer, 4)) + int(buffer[7]) + 8
		if length > 4104 {
			return protocol.ErrFrame
		}
		if len(buffer) < length {
			return nil
		}
		flags, body, err := protocol.ReadLogin(bytes.NewReader(buffer[:length]))
		if err != nil {
			return err
		}
		session.tracePacket("C->S", channel.ID, "sdk", uint32(protocol.ReadUint16(body, 0)), body[2:], flags == 1)
		channel.LoginBuffer = buffer[length:]
		var reply protocol.Message
		if flags == 1 && channel.Phase == "connected" {
			channel.Phase = "authenticated"
			session.GrantUntil = time.Now().Add(2 * time.Minute)
			reply = protocol.LoginAck(session.Account, session.UID)
		} else if flags == 0 && channel.Phase == "authenticated" && protocol.ReadUint16(body, 0) == 1011 {
			reply = protocol.LoginDirectory(session.Port)
		} else {
			return protocol.ErrFrame
		}
		session.emit(tunnel.Frame{Op: "data", Channel: channel.ID, Data: protocol.LoginEncode(reply)})
	}
	return nil
}

func (hub *Hub) route(session *Session, channel *Channel, message protocol.Message) error {
	payload := message.Payload
	if message.ID == 0 {
		if len(payload) != 0 {
			return protocol.ErrFrame
		}
		return nil
	}
	if message.ID == 1010 || message.ID == 2010 {
		if channel.Phase != "connected" || len(payload) != 96 || protocol.ReadUint64(payload, 0) != session.UID || protocol.ReadUint32(payload, 49) != 594 {
			return protocol.ErrFrame
		}
		if message.ID == 1010 {
			if time.Now().After(session.GrantUntil) || session.BootstrapChannel != 0 || session.GameChannel != 0 {
				return persistence.ErrDenied
			}
			session.BootstrapChannel = channel.ID
			channel.Phase = "bootstrap"
			account, err := hub.Store.Snapshot(session.UID)
			if err != nil {
				return err
			}
			for _, reply := range protocol.Bootstrap(account.InventoryBytes(), session.Port, account.Gold, account.Tickets) {
				session.send(channel.ID, reply)
			}
			return hub.profileReady(session)
		}
		if time.Now().After(session.HandoffUntil) || session.GameChannel != 0 {
			return persistence.ErrDenied
		}
		session.HandoffUntil = time.Time{}
		session.GameChannel = channel.ID
		channel.Phase = "lobby"
		session.send(channel.ID, protocol.Lobby(session.Port))
		log.Printf("lobby uid=%d", session.UID)
		return nil
	}
	if channel.Phase == "connected" {
		return protocol.ErrFrame
	}
	if message.ID == 3320 {
		if channel.ID != session.BootstrapChannel || (channel.Phase != "profile_sent" && channel.Phase != "handoff") || !bytes.Equal(payload, protocol.Uint32Bytes(1)) {
			return protocol.ErrFrame
		}
		session.send(channel.ID, protocol.Message{ID: 3330, Payload: payload})
		if channel.Phase != "handoff" {
			channel.Phase = "handoff"
			session.HandoffUntil = time.Now().Add(2 * time.Minute)
			session.send(channel.ID, protocol.Message{ID: 1201, Payload: protocol.Uint32Bytes(1)})
		}
		return nil
	}
	if message.ID == 1157 {
		if len(payload) != 0 {
			return protocol.ErrFrame
		}
		for _, reply := range protocol.Catalog(session.Port) {
			session.send(channel.ID, reply)
		}
		return nil
	}
	if channel.ID != session.GameChannel {
		return nil
	}
	if message.ID == 1156 {
		if len(payload) != 12 || time.Now().After(session.P2PUntil) || protocol.ReadUint64(payload, 0) != session.UID || protocol.ReadUint32(payload, 8) != session.P2P {
			return protocol.ErrFrame
		}
		session.Bound = true
		return nil
	}
	if message.ID == 4200 || (message.ID == 8071 && len(payload) >= 4 && protocol.ReadUint32(payload, 0) == 8289) {
		return hub.consume(session, channel, message)
	}
	if handled, err := hub.roomMessage(session, channel, message); handled {

		return err
	}
	if message.ID == 5000 || message.ID == 5002 {
		if err := hub.chat(session, message); err != nil {
			session.sendGame(notice("消息格式不正确，请重新输入。"))
		}
		return nil
	}
	if channel.Phase != "lobby" && channel.Phase != "room" {
		return nil
	}
	switch message.ID {
	case 2540, 2560:
		if (message.ID == 2540 && len(payload) != 1) || (message.ID == 2560 && len(payload) != 9) {
			return protocol.ErrFrame
		}
		directory, own, err := hub.Store.Rankings(session.UID, payload[0])
		if err != nil {
			return err
		}
		if message.ID == 2540 {
			session.sendGame(protocol.Message{ID: 2550, Payload: directory})
		} else {
			session.sendGame(protocol.Message{ID: 2570, Payload: own})
		}
	case 9006:
		if len(payload) != 29 {
			return protocol.ErrFrame
		}
		nameField := payload[8:]
		terminator := bytes.IndexByte(nameField, 0)
		if channel.Phase != "lobby" || protocol.ReadUint64(payload, 0) != session.UID || terminator < 1 || !bytes.Equal(nameField[terminator:], make([]byte, len(nameField)-terminator)) {
			return protocol.ErrFrame
		}
		nickname, err := persistence.DecodeGBK(nameField[:terminator])
		if err != nil {
			return err
		}
		oldName, err := hub.Store.Rename(session.UID, nickname)
		if err != nil {
			rejected := make([]byte, 54)
			protocol.WriteUint32(rejected, 0, 130)
			session.sendGame(protocol.Message{ID: 9008, Payload: rejected})
			return nil
		}
		reply := make([]byte, 54)
		copy(reply[4:25], persistence.GBK(oldName))
		protocol.WriteUint64(reply, 25, session.UID)
		copy(reply[33:], nameField)
		session.Nickname = nickname
		session.sendGame(protocol.Message{ID: 9007, Payload: reply})
	case 20561:
		if len(payload) != 4 || protocol.ReadUint32(payload, 0) > 10 {
			return protocol.ErrFrame
		}
		reply := make([]byte, 878)
		copy(reply, payload)
		copy(reply[4:68], "Local wealth event not configured")
		session.sendGame(protocol.Message{ID: 20562, Payload: reply})
	case 20563, 20565:
		if len(payload) != 0 {
			return protocol.ErrFrame
		}
		if message.ID == 20563 {
			reply := make([]byte, 68)
			protocol.WriteUint32(reply, 0, 0xffffffff)
			session.sendGame(protocol.Message{ID: 20564, Payload: reply})
		} else {
			session.sendGame(protocol.Message{ID: 20566, Payload: make([]byte, 48)})
		}
	case 9070, 1540, 1500:
		category, variant := -1, 0
		if message.ID == 9070 {
			if len(payload) != 2 {
				return protocol.ErrFrame
			}
			category, variant = int(payload[0]), int(payload[1])
		}
		if message.ID == 1540 && len(payload) != 0 {
			return protocol.ErrFrame
		}
		if message.ID == 1500 && len(payload) != 9 {
			return protocol.ErrFrame
		}
		offers, err := hub.Store.Offers(category, variant)
		if err != nil {
			return err
		}
		var records []byte
		for _, offer := range offers {
			if message.ID == 1500 && (protocol.ReadUint32(payload, 5) != 0 || offer.Record[4] != payload[0] || protocol.ReadUint32(offer.Record, 5) != protocol.ReadUint32(payload, 1)) {
				continue
			}
			records = append(records, offer.Record...)
		}
		if message.ID == 9070 {
			header := append([]byte{byte(category), byte(variant)}, protocol.Uint32Bytes(uint32(len(records)/108))...)
			records = append(header, records...)
		}
		session.sendGame(protocol.Message{ID: message.ID + 10, Payload: records})
	case 9040, 9041:
		if len(payload) != 169 {
			return protocol.ErrFrame
		}
		if message.ID == 9041 {
			session.sendGame(protocol.Message{ID: 9060, Payload: []byte{130, 0}})
			return nil
		}
		operationID := fmt.Sprintf("%s:%d:%d", session.Namespace, channel.ID, channel.Sequence)
		balance, item, catalog, err := hub.Store.Purchase(session.UID, operationID, payload)
		if err != nil {
			session.sendGame(protocol.Message{ID: 9060, Payload: []byte{130, 0}})
			log.Printf("purchase_rejected uid=%d", session.UID)
			return nil
		}
		balanceMessage := uint32(1230)
		if protocol.ReadUint32(catalog, 30) > 0 {
			balanceMessage = 1240
		}
		session.sendGame(protocol.Message{ID: balanceMessage, Payload: protocol.Uint32Bytes(balance)})
		if len(item) == 68 {
			session.sendGame(protocol.Message{ID: 2160, Payload: item})
		}
		session.sendGame(protocol.Message{ID: 9050, Payload: catalog})
		log.Printf("purchase uid=%d instance=%d", session.UID, protocol.ReadUint32(item, 0))
	case 2080, 2300:
		if (message.ID == 2080 && len(payload) != 16) || (message.ID == 2300 && len(payload) != 4) {
			return protocol.ErrFrame
		}
		if session.Room != nil && session.Room.Members[session.UID].Ready {
			return nil
		}
		slot := uint32(0)
		if message.ID == 2080 {
			slot = protocol.ReadUint32(payload, 4)
			if slot == 0 || slot > 65535 {
				return protocol.ErrFrame
			}
		}
		changed, err := hub.Store.Equip(session.UID, protocol.ReadUint32(payload, 0), uint16(slot))
		if err != nil {
			session.sendGame(notice("装备失败，请检查道具及栏位。"))
			return nil
		}
		if changed == nil {
			return nil
		}
		account, err := hub.Store.Snapshot(session.UID)
		if err != nil {
			return err
		}
		ack := protocol.Message{ID: message.ID + 10, Payload: append(bytes.Clone(payload), changed...)}
		if message.ID == 2300 {
			session.sendGame(ack)
		}
		session.sendGame(protocol.Message{ID: 1120, Payload: account.InventoryBytes()})
		if message.ID == 2080 {
			session.sendGame(ack)
		}
		hub.equipmentChanged(session)
	case 1232, 20546:
		if len(payload) != 0 {
			return protocol.ErrFrame
		}
		account, err := hub.Store.Snapshot(session.UID)
		if err != nil {
			return err
		}
		if message.ID == 1232 {
			session.sendGame(protocol.Message{ID: 1230, Payload: protocol.Uint32Bytes(account.Tickets)})
		} else {
			session.sendGame(protocol.Message{ID: 20547, Payload: account.Profile[352:356]})
		}
	case 1300, 1400:
		if len(payload) != 0 {
			return protocol.ErrFrame
		}
		session.sendGame(protocol.Message{ID: message.ID + 10})
	case 20360:
		if len(payload) != 12 || protocol.ReadUint64(payload, 0) != session.UID {
			return protocol.ErrFrame
		}
		session.sendGame(protocol.Message{ID: 20370, Payload: append(make([]byte, 36), []byte("No ranked season configured.\x00")...)})
	case 21000, 21002:
		if (message.ID == 21000 && (len(payload) != 8 || protocol.ReadUint64(payload, 0) != session.UID)) || (message.ID == 21002 && len(payload) != 0) {
			return protocol.ErrFrame
		}
		minutes, active, err := hub.Store.Training(session.UID, message.ID == 21002)
		if err != nil {
			return err
		}
		status := make([]byte, 56)
		protocol.WriteUint64(status, 0, session.UID)
		protocol.WriteUint32(status, 20, minutes)
		if active {
			protocol.WriteUint32(status, 28, 1)
		}
		replyID := uint32(21001)
		if message.ID == 21002 {
			replyID = 21005
		}
		session.sendGame(protocol.Message{ID: replyID, Payload: status})
	default:
		log.Printf("unhandled uid=%d phase=%s message=%d length=%d", session.UID, channel.Phase, message.ID, len(payload))
	}
	return nil
}

func (hub *Hub) datagram(session *Session, frame tunnel.Frame) error {
	payload := frame.Data
	if len(payload) < 24 || len(payload) > 32768 || protocol.ReadUint16(payload, 0) != 1 || 24+int(payload[23]) > len(payload) || session.game() == nil {
		return protocol.ErrFrame
	}
	messageID := protocol.ReadUint16(payload, 2)
	body := payload[24+int(payload[23]):]
	if messageID == 1008 {
		return hub.relayDatagram(session, frame)
	}
	if messageID == 1001 {
		if payload[23] != 0 || len(body) < 141 {
			return protocol.ErrFrame
		}
		nameLength := int(protocol.BigEndian.Uint16(body))
		if nameLength > 20 || len(body) != 141+nameLength {
			return protocol.ErrFrame
		}
		if session.P2P == 0 {
			session.P2P = hub.NextPlayer
			hub.NextPlayer++
		}
	} else if messageID == 1013 {
		if len(body) != 4 || session.P2P == 0 || protocol.ReadUint32(payload, 4) != session.P2P || protocol.ReadUint32(payload, 12) != session.P2P {
			return protocol.ErrFrame
		}
	} else {
		if time.Since(session.LastUDPNotice) >= 5*time.Second {
			log.Printf("udp_unhandled uid=%d id=%d bytes=%d extra=%d source=%d target=%d", session.UID, messageID, len(payload), payload[23], protocol.ReadUint32(payload, 12), protocol.ReadUint32(payload, 16))
			session.LastUDPNotice = time.Now()
		}
		return nil
	}
	if session.UDPPort != 0 && session.UDPPort != frame.Port {
		return protocol.ErrFrame
	}
	session.UDPPort = frame.Port
	session.P2PUntil = time.Now().Add(time.Minute)
	reply := make([]byte, 24)
	protocol.WriteUint16(reply, 0, 1)
	protocol.WriteUint16(reply, 2, messageID+1)
	protocol.WriteUint32(reply, 4, session.P2P)
	protocol.WriteUint32(reply, 16, session.P2P)
	if messageID == 1001 {
		body := make([]byte, 18)
		protocol.BigEndian.PutUint32(body[4:], session.P2P)
		protocol.BigEndian.PutUint32(body[8:], session.P2P)
		copy(body[12:], []byte{127, 0, 0, 1})
		protocol.BigEndian.PutUint16(body[16:], frame.Port)
		reply = append(reply, body...)
	} else {
		reply = append(reply, 0, 0, 0, 0)
	}
	session.emit(tunnel.Frame{Op: "udp", Port: frame.Port, Data: reply})
	return nil
}

// SDP2P.dll sends 1008 to its relay server when a direct peer connection is
// unavailable (10003E70). Its peer receiver accepts 1009 with the recipient's
// session id and the original sender's P2P id (10003FC0/1000402F).
func (hub *Hub) relayDatagram(session *Session, frame tunnel.Frame) error {
	packet := frame.Data
	extra := int(packet[23])
	if session.P2P == 0 || !session.Bound || session.UDPPort != frame.Port || time.Now().After(session.P2PUntil) ||
		protocol.ReadUint32(packet, 4) != session.P2P || protocol.ReadUint32(packet, 12) != session.P2P ||
		extra == 0 || extra%4 != 0 || extra > 128 || len(packet) <= 24+extra {
		return protocol.ErrFrame
	}
	room := session.Room
	if room == nil {
		return nil
	}
	seen := map[uint32]bool{}
	for offset := 24; offset < 24+extra; offset += 4 {
		targetID := protocol.ReadUint32(packet, offset)
		if targetID == session.P2P || seen[targetID] {
			continue
		}
		seen[targetID] = true
		for _, member := range room.Members {
			peer := member.Session
			if peer.P2P != targetID || peer.UDPPort == 0 || !peer.Bound || time.Now().After(peer.P2PUntil) {
				continue
			}
			reply := make([]byte, 24, len(packet)-extra)
			copy(reply, packet[:24])
			protocol.WriteUint16(reply, 2, 1009)
			protocol.WriteUint32(reply, 4, peer.P2P)
			protocol.WriteUint32(reply, 16, peer.P2P)
			reply[23] = 0
			reply = append(reply, packet[24+extra:]...)
			peer.emit(tunnel.Frame{Op: "udp", Port: peer.UDPPort, Data: reply})
			session.UDPRelayed++
		}
	}
	if time.Since(session.LastUDPNotice) >= 5*time.Second {
		log.Printf("udp_relay uid=%d room=%d stage=%s bytes=%d recipients=%d forwarded_total=%d", session.UID, room.ID, room.Stage, len(packet), extra/4, session.UDPRelayed)
		session.LastUDPNotice = time.Now()
	}
	return nil
}

func notice(text string) protocol.Message {
	encoded := persistence.GBK(text)
	if len(encoded) > 199 {
		encoded = []byte("Request unavailable.")
	}
	payload := make([]byte, 215)
	payload[12] = byte(len(encoded) + 1)
	copy(payload[13:], encoded)
	return protocol.Message{ID: 20150, Payload: payload}
}

func (hub *Hub) chat(session *Session, message protocol.Message) error {
	if time.Since(session.LastChat) < time.Second {
		session.sendGame(notice("发送太快，请稍后再试。"))
		return nil
	}
	payload := message.Payload
	lengthOffset, textOffset := 12, 13
	if message.ID == 5000 {
		lengthOffset, textOffset = 50, 55
	}
	if (message.ID == 5002 && len(payload) != 215) || (message.ID == 5000 && len(payload) != 256) {
		return protocol.ErrFrame
	}
	length := int(payload[lengthOffset])
	if length < 2 || length > 200 || textOffset+length > len(payload) || payload[textOffset+length-1] != 0 {
		return protocol.ErrFrame
	}
	text := payload[textOffset : textOffset+length-1]
	decoded, err := persistence.DecodeGBK(text)
	if err != nil {
		return protocol.ErrFrame
	}
	if bytes.IndexByte(text, 0) >= 0 {
		return protocol.ErrFrame
	}
	for _, character := range decoded {
		if unicode.IsControl(character) {
			return protocol.ErrFrame
		}
	}
	for _, padding := range payload[textOffset+length:] {
		if padding != 0 {
			return protocol.ErrFrame
		}
	}
	reply := make([]byte, 256)
	protocol.WriteUint64(reply, 0, session.UID)
	copy(reply[8:29], persistence.GBK(session.Nickname))
	reply[50] = byte(length)
	copy(reply[55:], text)
	session.LastChat = time.Now()
	if message.ID == 5000 {
		recipientField := payload[29:50]
		terminator := bytes.IndexByte(recipientField, 0)
		if terminator < 1 {
			return protocol.ErrFrame
		}
		for _, padding := range recipientField[terminator:] {
			if padding != 0 {
				return protocol.ErrFrame
			}
		}
		recipient := recipientField[:terminator]
		if _, err := persistence.DecodeGBK(recipient); err != nil {
			return protocol.ErrFrame
		}
		var target *Session
		for _, peer := range hub.Sessions {
			if peer != session && peer.game() != nil && bytes.Equal(persistence.GBK(peer.Nickname), recipient) {
				if target != nil {
					return nil
				}
				target = peer
			}
		}
		if target == nil {
			session.sendGame(notice("对方当前不在线。"))
			return nil
		}
		copy(reply[29:50], recipient)
		message = protocol.Message{ID: 5001, Payload: reply}
		target.sendGame(message)
		session.sendGame(message)
	} else {
		message = protocol.Message{ID: 5003, Payload: reply}
		if session.Room != nil {
			hub.broadcast(session.Room, message, 0)
		} else {
			for _, peer := range hub.Sessions {
				if peer.game() != nil && peer.game().Phase == "lobby" {
					peer.sendGame(message)
				}
			}
		}
	}
	return nil
}
