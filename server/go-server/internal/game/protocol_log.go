package game

import (
	"bytes"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"strings"
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
		if transport == "game" {
			if opcode == protocol.MsgBattleInputReady && strings.HasPrefix(direction, "C->S") {
				if r, err := protocol.ParseBattleInputReady(payload); err == nil {
					entry["content"] = fmt.Sprintf("输入就绪请求：房间=%d，申报UID=%d，客户端尾值=%d（语义未确认，不作为授权）", r.RoomID, r.UID, r.ClientValue)
				}
			}
			if (opcode == 3090 || opcode == 3105) && strings.HasPrefix(direction, "S->C") {
				if rows, err := protocol.ParseRoomMembers(payload); err == nil && (opcode != 3090 || len(rows) == 1) {
					var detail strings.Builder
					fmt.Fprintf(&detail, "房间成员：%d条", len(rows))
					for _, r := range rows {
						kind := "参战"
						if r.Spectator() {
							kind = "观战"
						}
						fmt.Fprintf(&detail, "；UID=%d %s 槽位=%d 装备=%d", r.UID(), kind, r.Slot(), r.EquipmentCount())
					}
					entry["content"] = detail.String()
				}
			}
			if opcode == protocol.MsgPlayerLeftRoom && len(payload) == 8 && strings.HasPrefix(direction, "S->C") {
				entry["content"] = fmt.Sprintf("玩家离开房间：UID=%d", protocol.ReadUint64(payload, 0))
			}
			if opcode == protocol.MsgJoinRoom && strings.HasPrefix(direction, "C->S") {
				if r, err := protocol.ParseRoomJoinRequest(payload); err == nil {
					mode := fmt.Sprintf("未确认模式%d", r.Mode)
					if r.Mode == protocol.JoinAsPlayer {
						mode = "参战"
					}
					if r.Mode == protocol.JoinAsSpectator {
						mode = "观战（尚未接入完整业务）"
					}
					entry["content"] = fmt.Sprintf("请求进入房间=%d，方式=%s", r.RoomID, mode)
				}
			}
			if opcode == protocol.MsgWatchGameRequest && strings.HasPrefix(direction, "C->S") {
				entry["content"] = "观战请求（A_WATCH_GAME_REQ）；字段尚未确认，请查看原始数据"
			}
			if opcode == protocol.MsgWatchGameAck && strings.HasPrefix(direction, "S->C") {
				entry["content"] = "观战应答（A_WATCH_GAME_ACK）；结果字段尚未确认，不能据此判断成功"
			}
			if opcode == protocol.MsgRenewItemResult && strings.HasPrefix(direction, "S->C") {
				if r, err := protocol.ParseRenewalResult(payload); err == nil {
					if r.Succeeded {
						entry["content"] = fmt.Sprintf("续费成功回执：库存实例=%d", r.InventoryInstance)
					} else {
						entry["content"] = "续费失败回执"
					}
				}
			}
			if opcode == protocol.MsgRenewItem && strings.HasPrefix(direction, "C->S") {
				if r, err := protocol.ParseRenewalRequest(payload); err == nil {
					entry["content"] = fmt.Sprintf("请求续费：库存实例=%d，商品目录键=%d，申报金额=%d（不代表已扣款），操作原值=%d，发起UID=%d，目标UID=%d", r.InventoryInstance(), r.CatalogKey(), r.QuotedAmount(), r.Operation(), r.SenderUID(), r.RecipientUID())
				}
			}
			if opcode == protocol.MsgKickRoomPlayer {
				if r, err := protocol.ParseRoomKickRequest(payload); err == nil {
					entry["content"] = fmt.Sprintf("请求踢出玩家 UID=%d；客户端标志=%d（不代表房主权限）", r.TargetUID, r.ClientFlag)
				}
			}
			// Our own notice format includes the terminating NUL in its length.
			if opcode == 20150 && strings.HasPrefix(direction, "S->C") && len(payload) == 215 {
				n := int(payload[12])
				if n > 0 && n <= 200 && payload[12+n] == 0 {
					if text, err := persistence.DecodeGBK(payload[13 : 12+n]); err == nil {
						entry["content"] = text
					}
				}
			}
		}
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
				s.tracePacket(direction, frame.Channel, "sdk", id, body[2:], flags == 1 || id == protocol.MsgSDKLoginResponse)
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
