package game

import (
	"bytes"
	"fmt"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"log"
	"sort"
	"strconv"
	"time"
)

type Config struct {
	ConfigHash string              `json:"config_hash"`
	Pools      map[string][]uint32 `json:"pools"`
	Groups     map[string][]uint32 `json:"groups"`
}
type Member struct {
	Session              *Session
	Slot, Team           byte
	Ready, Loaded, Input bool
	BattleEvents         map[uint32]battleSequence
}
type Room struct {
	ID      uint16
	Owner   uint64
	Request []byte
	Stage   string
	Serial  uint32
	Members map[uint64]*Member
}

func (hub *Hub) resolve(request []byte) ([]byte, error) {
	if len(request) != 81 {
		return nil, protocol.ErrFrame
	}
	mode, capacity := request[46], request[37]
	if (mode > 3 && mode != 5) || (capacity != 2 && capacity != 4 && capacity != 6 && capacity != 8) {
		return nil, protocol.ErrFrame
	}
	chosen, suggested := protocol.ReadUint32(request, 38), protocol.ReadUint32(request, 42)
	pool := hub.Config.Pools[fmt.Sprintf("%d:%d", mode, capacity)]
	group, isGroup := hub.Config.Groups[strconv.FormatUint(uint64(chosen), 10)]
	contains := func(values []uint32, needle uint32) bool {
		for _, value := range values {
			if value == needle {
				return true
			}
		}
		return false
	}
	var target uint32
	if chosen == 0 || chosen == 0xffffffff || isGroup {
		for _, mapID := range pool {
			if isGroup && !contains(group, mapID) {
				continue
			}
			if target == 0 {
				target = mapID
			}
			if suggested == mapID {
				target = mapID
				break
			}
		}
	} else if contains(pool, chosen) && (suggested == 0 || suggested == 0xffffffff || suggested == chosen) {
		target = chosen
	}
	if target == 0 {
		return nil, protocol.ErrFrame
	}
	resolvedRequest := bytes.Clone(request)
	protocol.WriteUint32(resolvedRequest, 38, target)
	protocol.WriteUint32(resolvedRequest, 42, target)
	return resolvedRequest, nil
}
func roomEntry(room *Room, uid uint64) []byte {
	request := room.Request
	entry := make([]byte, 245)
	protocol.WriteUint16(entry, 0, room.ID)
	protocol.WriteUint64(entry, 2, uid)
	copy(entry[12:20], request[38:46])
	copy(entry[24:45], request[:21])
	copy(entry[45:56], request[21:32])
	copy(entry[56:61], request[32:37])
	if request[21] != 0 {
		entry[61] = 1
	}
	entry[62] = request[37]
	entry[65] = request[46]
	copy(entry[67:69], request[47:49])
	copy(entry[69:73], request[50:54])
	entry[73] = request[49]
	copy(entry[78:82], request[59:63])
	protocol.WriteUint64(entry, 96, uid)
	return entry
}
func fighter(account persistence.Account, member *Member, update bool) []byte {
	record := make([]byte, 149)
	protocol.WriteUint64(record, 0, account.UID)
	record[8] = member.Slot
	record[9] = member.Team
	record[10] = member.Slot
	copy(record[11:32], persistence.GBK(account.Nickname))
	if member.Ready {
		record[53] = 1
	}
	copy(record[54:57], account.Profile[122:125])
	protocol.WriteUint32(record, 67, member.Session.P2P)
	if update {
		record[76] = 1
	}
	for _, item := range account.Inventory {
		if protocol.ReadUint16(item, 17) != 0 {
			record[64]++
			record = append(record, item...)
		}
	}
	return record
}
func roomList(room *Room) []byte {
	entry := roomEntry(room, room.Owner)
	record := make([]byte, 259)
	protocol.WriteUint16(record, 0, room.ID)
	copy(record[2:23], entry[24:45])
	copy(record[23:31], entry[12:20])
	record[31] = entry[61]
	record[33] = entry[57]
	record[39] = entry[62]
	record[40] = byte(len(room.Members))
	if room.Stage == "room" {
		record[41] = 1
	}
	record[42] = entry[59]
	record[43] = entry[60]
	record[44] = entry[65]
	return record
}
func (hub *Hub) broadcast(room *Room, message protocol.Message, exclude uint64) {
	for uid, member := range room.Members {
		if uid != exclude {
			member.Session.sendGame(message)
		}
	}
}
func (hub *Hub) install(room *Room, session *Session) error {
	if room.Stage != "room" || len(room.Members) >= int(room.Request[37]) || !session.Bound || time.Now().After(session.P2PUntil) {
		return protocol.ErrFrame
	}
	slot := byte(0)
	for {
		used := false
		for _, member := range room.Members {
			used = used || member.Slot == slot
		}
		if !used {
			break
		}
		slot++
	}
	account, err := hub.Store.Snapshot(session.UID)
	if err != nil {
		return err
	}
	member := &Member{Session: session, Slot: slot, Team: slot % 2}
	own := fighter(account, member, false)
	type peer struct {
		member *Member
		raw    []byte
	}
	var peers []peer
	for _, member := range room.Members {
		account, err := hub.Store.Snapshot(member.Session.UID)
		if err != nil {
			return err
		}
		peers = append(peers, peer{member, fighter(account, member, false)})
	}
	room.Members[session.UID] = member
	session.Room = room
	session.game().Phase = "room"
	entry := roomEntry(room, room.Owner)
	entry[10] = slot
	entry[11] = member.Team
	// Practice uses the established single-player entry. Competitive rooms
	// install the actual fighter record; this preserves original native layout.
	if room.Request[46] != 5 || len(room.Members) > 1 {
		copy(entry[96:], own[:149])
	}
	session.sendGame(protocol.Message{ID: 3100, Payload: entry})
	session.sendGame(protocol.Message{ID: 3160, Payload: protocol.Uint64Bytes(room.Owner)})
	for _, peer := range peers {
		session.sendGame(protocol.Message{ID: 3090, Payload: peer.raw})
		peer.member.Session.sendGame(protocol.Message{ID: 3090, Payload: own})
		if peer.member.Ready {
			peer.member.Ready = false
			hub.broadcast(room, protocol.Message{ID: 4070, Payload: protocol.Uint64Bytes(peer.member.Session.UID)}, 0)
		}
	}
	return nil
}
func (hub *Hub) leave(session *Session, acknowledge bool) {
	room := session.Room
	if room == nil {
		return
	}
	delete(room.Members, session.UID)
	session.Room = nil
	session.ConsumeIntents = nil
	if channel := session.game(); channel != nil {
		channel.Phase = "lobby"
	}
	if acknowledge {
		session.sendGame(protocol.Message{ID: 3115})
	}
	if len(room.Members) == 0 {
		delete(hub.Rooms, room.ID)
		return
	}
	if room.Stage != "room" {
		log.Printf("battle_aborted room=%d serial=%d stage=%s leaving_uid=%d remaining=%d", room.ID, room.Serial, room.Stage, session.UID, len(room.Members))
		for _, member := range room.Members {
			member.Session.Room = nil
			member.Session.ConsumeIntents = nil
			if channel := member.Session.game(); channel != nil {
				channel.Phase = "lobby"
			}
			member.Session.sendGame(protocol.Message{ID: 3115})
			member.Session.sendGame(notice("有玩家离开，本局已结束，请重新创建房间。"))
		}
		clear(room.Members)
		delete(hub.Rooms, room.ID)
		return
	}
	hub.broadcast(room, protocol.Message{ID: 3130, Payload: protocol.Uint64Bytes(session.UID)}, 0)
	if room.Owner == session.UID {
		var first *Member
		for _, member := range room.Members {
			if first == nil || member.Slot < first.Slot {
				first = member
			}
		}
		room.Owner = first.Session.UID
		hub.broadcast(room, protocol.Message{ID: 3160, Payload: protocol.Uint64Bytes(room.Owner)}, 0)
	}
	for uid, member := range room.Members {
		if member.Ready {
			member.Ready = false
			hub.broadcast(room, protocol.Message{ID: 4070, Payload: protocol.Uint64Bytes(uid)}, 0)
		}
	}
}
func (hub *Hub) equipmentChanged(session *Session) {
	if session.Room == nil {
		return
	}
	account, err := hub.Store.Snapshot(session.UID)
	if err != nil {
		return
	}
	hub.broadcast(session.Room, protocol.Message{ID: 3090, Payload: fighter(account, session.Room.Members[session.UID], true)}, session.UID)
}
func (hub *Hub) roomMessage(session *Session, channel *Channel, message protocol.Message) (bool, error) {
	payload := message.Payload
	room := session.Room
	uid := session.UID
	switch message.ID {
	case 2260:
		if channel.Phase != "lobby" || len(payload) != 3 {
			return true, protocol.ErrFrame
		}
		// Native 92DD40 sends page, refresh option, mode (0x88 = all).
		// The old adapter mistook the page for a mode and hid mode-0 rooms.
		ids := []int{}
		for id, room := range hub.Rooms {
			if payload[2] == 0x88 || payload[2] == room.Request[46] {
				ids = append(ids, int(id))
			}
		}
		sort.Ints(ids)
		page := int(payload[0])
		if page < 1 {
			page = 1
		}
		start := (page - 1) * 9
		response := make([]byte, 8)
		protocol.WriteUint32(response, 0, 1)
		count := 0
		for index := start; index < len(ids) && index < start+9; index++ {
			response = append(response, roomList(hub.Rooms[uint16(ids[index])])...)
			count++
		}
		protocol.WriteUint32(response, 4, uint32(count))
		session.send(channel.ID, protocol.Message{ID: 2280, Payload: response})
		log.Printf("room_directory uid=%d page=%d option=%d mode=%d rooms=%d returned=%d", uid, page, payload[1], payload[2], len(hub.Rooms), count)
	case 3010:
		if room != nil && channel.Phase == "room" && bytes.Equal(payload, room.Request) {
			return true, nil
		}
		if channel.Phase != "lobby" || room != nil || !session.Bound {
			return true, protocol.ErrFrame
		}
		resolvedRequest, err := hub.resolve(payload)
		if err != nil {
			session.send(channel.ID, protocol.Message{ID: 3030, Payload: []byte{44, 0}})
			return true, nil
		}
		id := uint16(1)
		for hub.Rooms[id] != nil && id < 256 {
			id++
		}
		if id >= 256 {
			return true, protocol.ErrFrame
		}
		newRoom := &Room{ID: id, Owner: uid, Request: resolvedRequest, Stage: "room", Members: map[uint64]*Member{}}
		if err = hub.install(newRoom, session); err != nil {
			return true, err
		}
		hub.Rooms[id] = newRoom
		log.Printf("room_created uid=%d room=%d mode=%d rooms=%d", uid, id, resolvedRequest[46], len(hub.Rooms))
	case 3070:
		if len(payload) != 14 {
			return true, protocol.ErrFrame
		}
		id := protocol.ReadUint16(payload, 0)
		if room != nil && room.ID == id && channel.Phase == "room" {
			return true, nil
		}
		if channel.Phase != "lobby" || room != nil {
			return true, protocol.ErrFrame
		}
		target := hub.Rooms[id]
		code := uint32(0)
		switch {
		case payload[2] != 0:
			code = 130
		case target == nil:
			code = 29
		case target.Stage != "room":
			code = 30
		case len(target.Members) >= int(target.Request[37]):
			code = 32
		case !bytes.Equal(bytes.SplitN(payload[3:14], []byte{0}, 2)[0], bytes.SplitN(target.Request[21:32], []byte{0}, 2)[0]):
			code = 31
		}
		if code != 0 {
			session.send(channel.ID, protocol.Message{ID: 3080, Payload: append(bytes.Clone(payload), protocol.Uint32Bytes(code)...)})
			return true, nil
		}
		return true, hub.install(target, session)
	case 3075:
		if len(payload) != 1 || channel.Phase != "lobby" || room != nil {
			return true, protocol.ErrFrame
		}
		ids := []int{}
		for id := range hub.Rooms {
			ids = append(ids, int(id))
		}
		sort.Ints(ids)
		for _, id := range ids {
			target := hub.Rooms[uint16(id)]
			if target.Stage == "room" && target.Request[21] == 0 && len(target.Members) < int(target.Request[37]) && (payload[0] == 0 || payload[0] == target.Request[46]) {
				return true, hub.install(target, session)
			}
		}
	case 3110:
		if len(payload) != 0 {
			return true, protocol.ErrFrame
		}
		hub.leave(session, true)
	case 3230:
		if len(payload) != 1 || payload[0] > 1 || room == nil || room.Stage != "room" {
			return true, protocol.ErrFrame
		}
		member := room.Members[uid]
		member.Team = payload[0]
		member.Ready = false
		response := append(protocol.Uint64Bytes(uid), member.Team, member.Slot)
		hub.broadcast(room, protocol.Message{ID: 3250, Payload: response}, 0)
		hub.broadcast(room, protocol.Message{ID: 4070, Payload: protocol.Uint64Bytes(uid)}, 0)
		for peerUID, peer := range room.Members {
			if peer.Ready {
				peer.Ready = false
				hub.broadcast(room, protocol.Message{ID: 4070, Payload: protocol.Uint64Bytes(peerUID)}, 0)
			}
		}
	case 3140:
		if len(payload) != 9 {
			return true, protocol.ErrFrame
		}
		if room == nil || room.Stage != "room" || room.Owner != uid || payload[8] != 0 {
			return true, nil
		}
		targetUID := protocol.ReadUint64(payload, 0)
		if targetUID == uid || room.Members[targetUID] == nil {
			return true, nil
		}
		removed := room.Members[targetUID].Session
		hub.broadcast(room, protocol.Message{ID: 3150, Payload: payload}, 0)
		hub.leave(removed, false)
	case 3200:
		if len(payload) != 48 {
			return true, protocol.ErrFrame
		}
		if room == nil || room.Stage != "room" || room.Owner != uid {
			return true, nil
		}
		if payload[8] != 0 || payload[11] != 0 || payload[9] > 1 || payload[10] > 1 || payload[12] > 1 || payload[13] > 1 || payload[14] == 0 {
			return true, nil
		}
		duration := protocol.ReadUint16(payload, 46)
		if duration != 120 && duration != 180 && duration != 240 && duration != 300 {
			return true, nil
		}
		for _, field := range [][]byte{payload[14:35], payload[35:46]} {
			terminator := bytes.IndexByte(field, 0)
			if terminator < 0 || !bytes.Equal(field[terminator:], make([]byte, len(field)-terminator)) {
				return true, nil
			}
		}
		candidate := bytes.Clone(room.Request)
		copy(candidate[:21], payload[14:35])
		copy(candidate[21:32], payload[35:46])
		copy(candidate[32:35], payload[8:11])
		copy(candidate[35:37], payload[12:14])
		copy(candidate[38:46], payload[:8])
		copy(candidate[47:49], payload[46:48])
		resolved, err := hub.resolve(candidate)
		if err != nil {
			session.sendGame(notice("房间设置或地图不可用。"))
			return true, nil
		}
		room.Request = resolved
		reply := bytes.Clone(payload)
		copy(reply[:8], resolved[38:46])
		hub.broadcast(room, protocol.Message{ID: 3220, Payload: reply}, 0)
		for peerUID, peer := range room.Members {
			if peer.Ready {
				peer.Ready = false
				hub.broadcast(room, protocol.Message{ID: 4070, Payload: protocol.Uint64Bytes(peerUID)}, 0)
			}
		}
	case 4030, 4060:
		if len(payload) != 0 || room == nil {
			return true, protocol.ErrFrame
		}
		if room.Stage != "room" {
			return true, nil
		}
		member := room.Members[uid]
		if time.Now().After(session.P2PUntil) {
			return true, protocol.ErrFrame
		}
		if message.ID == 4060 {
			member.Ready = false
			hub.broadcast(room, protocol.Message{ID: 4070, Payload: protocol.Uint64Bytes(uid)}, 0)
			return true, nil
		}
		if uid == room.Owner && room.Request[46] != 5 {
			if len(room.Members) < 2 {
				return true, nil
			}
			if room.Request[46] == 1 || room.Request[46] == 3 {
				teams := map[byte]bool{}
				for _, member := range room.Members {
					teams[member.Team] = true
				}
				if len(teams) < 2 {
					return true, nil
				}
			}
		}
		if uid == room.Owner {
			for other, member := range room.Members {
				if other != uid && !member.Ready {
					return true, nil
				}
			}
		}
		member.Ready = true
		hub.broadcast(room, protocol.Message{ID: 4050, Payload: protocol.Uint64Bytes(uid)}, 0)
		if uid == room.Owner {
			for _, member := range room.Members {
				if !member.Ready || time.Now().After(member.Session.P2PUntil) {
					return true, nil
				}
			}
			serial, err := hub.Store.NextBattle()
			if err != nil {
				return true, err
			}
			room.Serial = serial
			room.Stage = "loading"
			for _, member := range room.Members {
				member.Session.ConsumeIntents = nil
				response := make([]byte, 53)
				protocol.WriteUint32(response, 0, uint32(room.ID))
				protocol.WriteUint32(response, 5, serial)
				protocol.WriteUint16(response, 11, uint16(member.Slot))
				for _, peer := range room.Members {
					protocol.WriteUint32(response, 13+int(peer.Slot)*4, peer.Session.P2P)
				}
				protocol.WriteUint32(response, 45, uint32(room.ID))
				protocol.WriteUint32(response, 49, serial)
				member.Session.game().Phase = "loading"
				member.Session.sendGame(protocol.Message{ID: 4080, Payload: response})
			}
		}
	case 4160:
		if len(payload) != 0 || room == nil {
			return true, protocol.ErrFrame
		}
		if room.Members[uid].Loaded {
			return true, nil
		}
		if room.Stage != "loading" {
			return true, protocol.ErrFrame
		}
		room.Members[uid].Loaded = true
		hub.broadcast(room, protocol.Message{ID: 4170, Payload: protocol.Uint64Bytes(uid)}, 0)
		for _, member := range room.Members {
			if !member.Loaded {
				return true, nil
			}
		}
		room.Stage = "wait_ready"
		for _, member := range room.Members {
			member.Session.game().Phase = "wait_ready"
		}
		hub.broadcast(room, protocol.Message{ID: 4180}, 0)
	case 8040:
		if len(payload) != 14 || room == nil || protocol.ReadUint16(payload, 0) != room.ID || protocol.ReadUint64(payload, 2) != uid {
			return true, protocol.ErrFrame
		}
		if room.Members[uid].Input {
			return true, nil
		}
		if room.Stage != "wait_ready" {
			return true, protocol.ErrFrame
		}
		room.Members[uid].Input = true
		for _, member := range room.Members {
			if !member.Input {
				return true, nil
			}
		}
		room.Stage = "battle"
		for _, member := range room.Members {
			member.Session.game().Phase = "battle"
		}
		response := append(protocol.Uint32Bytes(uint32(room.ID)), protocol.Uint32Bytes(uint32(room.ID))...)
		response = append(response, protocol.Uint32Bytes(room.Serial)...)
		hub.broadcast(room, protocol.Message{ID: 8070, Payload: response}, 0)
	case 8071:
		return true, hub.battleMessage(session, channel, message)
	default:
		return false, nil
	}
	return true, nil
}
