package game

import (
	"bytes"
	"encoding/hex"
	"encoding/json"
	"time"

	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"kungfu.local/server/internal/tunnel"
)

// Trace is opt-in. Each line is one complete decoded packet, never sampled or
// truncated. Queued output is distinguished from a successful socket write.
func (s *Session) tracePacket(direction string, channel uint32, transport string, opcode uint32, payload []byte, redact bool) {
	if s.Trace == nil {
		return
	}
	entry := map[string]any{"time": time.Now().Format(time.RFC3339Nano), "direction": direction, "account": s.Account, "player": s.Nickname, "uid": s.UID, "channel": channel, "transport": transport, "protocol": opcode, "length": len(payload)}
	if c := s.Channels[channel]; c != nil {
		entry["phase"] = c.Phase
	}
	if s.Room != nil {
		entry["room"] = s.Room.ID
	}
	if redact {
		entry["content"] = "[authentication credentials redacted]"
	} else {
		entry["hex"] = hex.EncodeToString(payload)
		if text, err := persistence.DecodeGBK(payload); err == nil {
			entry["text_gbk"] = text
		}
		if opcode == 8071 && len(payload) >= 4 {
			entry["subprotocol"] = protocol.ReadUint32(payload, 0)
		}
	}
	var encoded bytes.Buffer
	encoder := json.NewEncoder(&encoded)
	encoder.SetEscapeHTML(false)
	if encoder.Encode(entry) == nil {
		s.Trace.Print(string(bytes.TrimSuffix(encoded.Bytes(), []byte("\n"))))
	}
}

func (s *Session) traceFrame(direction string, frame tunnel.Frame) {
	if s.Trace == nil {
		return
	}
	switch frame.Op {
	case "data":
		c := s.Channels[frame.Channel]
		if c != nil && c.Kind == "sdk" {
			flags, body, err := protocol.ReadLogin(bytes.NewReader(frame.Data))
			if err == nil {
				id := uint32(protocol.ReadUint16(body, 0))
				s.tracePacket(direction, frame.Channel, "sdk", id, body[2:], flags == 1 || id == 1002)
			}
			return
		}
		decoder := protocol.Decoder{}
		messages, err := decoder.Feed(frame.Data)
		if err != nil {
			s.tracePacket(direction, frame.Channel, "invalid-game-frame", 0, frame.Data, false)
			return
		}
		for _, m := range messages {
			s.tracePacket(direction, frame.Channel, "game", m.ID, m.Payload, false)
		}
	case "udp":
		var id uint32
		if len(frame.Data) >= 4 {
			id = uint32(protocol.ReadUint16(frame.Data, 2))
		}
		s.tracePacket(direction, frame.Channel, "udp", id, frame.Data, false)
	default:
		// Do not marshal arbitrary tunnel envelopes: they may contain credentials.
		payload, _ := json.Marshal(map[string]any{"op": frame.Op, "kind": frame.Kind, "port": frame.Port, "value": frame.Value, "uid": frame.UID, "error": frame.Error})
		s.tracePacket(direction, frame.Channel, "tunnel:"+frame.Op, 0, payload, false)
	}
}
