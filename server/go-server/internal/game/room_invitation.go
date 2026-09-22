package game

import (
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"time"
)

const roomInvitationLifetime = time.Minute

type roomInvitation struct {
	inviter, recipient               *Session
	inviterChannel, recipientChannel *Channel
	room                             *Room
	serial                           uint32
	expires                          time.Time
}

func (h *Hub) clearInvitations(s *Session) {
	for uid, invite := range h.Invites {
		if invite.inviter == s || invite.recipient == s || !time.Now().Before(invite.expires) {
			delete(h.Invites, uid)
		}
	}
}

func (h *Hub) invitationLive(i roomInvitation) bool {
	r, a, b := i.room, i.inviter, i.recipient
	if r == nil || a == nil || b == nil || !time.Now().Before(i.expires) {
		return false
	}
	return h.Rooms[r.ID] == r && r.Serial == i.serial && r.Stage == "room" &&
		h.Sessions[a.UID] == a && h.Sessions[b.UID] == b && a.game() == i.inviterChannel && b.game() == i.recipientChannel &&
		a.Room == r && r.Members[a.UID] != nil && r.Members[a.UID].Session == a && b.Room == nil &&
		a.game() != nil && b.game() != nil && a.game().Phase == "room" && b.game().Phase == "lobby" && a.LobbyID == b.LobbyID
}

func (h *Hub) roomInvitation(s *Session, c *Channel, m protocol.Message) error {
	size := protocol.RoomInviteSize
	switch m.ID {
	case protocol.MsgRoomInviteAccept:
		size = protocol.RoomInviteAcceptSize
	case protocol.MsgRoomInviteDecline:
		size = protocol.RoomInviteDeclineSize
	}
	p := m.Payload
	if len(p) != size {
		return protocol.ErrFrame
	}
	if c != s.game() || h.Sessions[s.UID] != s {
		return nil
	}
	// Bound by current online recipients; reclaim expired or reconnected peers
	// before looking up an invite. A reused room ID cannot revive consent.
	for uid, i := range h.Invites {
		if !h.invitationLive(i) {
			delete(h.Invites, uid)
		}
	}
	fail := func(reason string) error { s.sendGame(notice(reason)); return nil }
	if m.ID == protocol.MsgRoomInvite {
		if protocol.ReadUint64(p, 0) != s.UID {
			return protocol.ErrFrame
		}
		r := s.Room
		target := protocol.ReadUint64(p, protocol.RoomInviteTargetOffset)
		b := h.Sessions[target]
		if r == nil || tutorialRoom(r) || r.ID != protocol.ReadUint16(p, protocol.RoomInviteRoomOffset) || b == nil || target == s.UID {
			return fail("当前不能邀请该玩家进入房间。")
		}
		i := roomInvitation{s, b, c, b.game(), r, r.Serial, time.Now().Add(roomInvitationLifetime)}
		if !h.invitationLive(i) || r.fighterCount() >= int(r.Request[protocol.RoomCapacityOffset]) {
			return fail("房间已满或对方不在同一大厅。")
		}
		if old, ok := h.Invites[target]; ok {
			if old.inviter == s && old.room == r {
				return nil
			}
			return fail("对方正在处理另一份房间邀请。")
		}
		body := make([]byte, protocol.RoomInviteSize)
		protocol.WriteUint64(body, 0, s.UID)
		copy(body[protocol.RoomInviteNameOffset:protocol.RoomInviteTargetOffset-1], persistence.GBK(s.Nickname))
		protocol.WriteUint64(body, protocol.RoomInviteTargetOffset, target)
		protocol.WriteUint16(body, protocol.RoomInviteRoomOffset, r.ID)
		if h.Invites == nil {
			h.Invites = map[uint64]roomInvitation{}
		}
		h.Invites[target] = i
		b.sendGame(protocol.Message{ID: protocol.MsgRoomInvite, Payload: body})
		return nil
	}
	targetOffset := protocol.RoomInviteNameOffset
	if m.ID == protocol.MsgRoomInviteDecline {
		targetOffset = protocol.RoomInviteTargetOffset
	}
	if protocol.ReadUint64(p, targetOffset) != s.UID {
		return protocol.ErrFrame
	}
	i, ok := h.Invites[s.UID]
	if !ok || i.inviter.UID != protocol.ReadUint64(p, 0) {
		return fail("房间邀请已失效，请重新邀请。")
	}
	if m.ID == protocol.MsgRoomInviteDecline {
		delete(h.Invites, s.UID)
		body := make([]byte, protocol.RoomInviteDeclineSize)
		protocol.WriteUint64(body, 0, i.inviter.UID)
		copy(body[protocol.RoomInviteNameOffset:protocol.RoomInviteTargetOffset-1], persistence.GBK(s.Nickname))
		protocol.WriteUint64(body, protocol.RoomInviteTargetOffset, s.UID)
		i.inviter.sendGame(protocol.Message{ID: protocol.MsgRoomInviteDecline, Payload: body})
		return nil
	}
	r := i.room
	if protocol.ReadUint16(p, 16) != r.ID {
		return fail("邀请房间不匹配。")
	}
	if r.fighterCount() >= int(r.Request[protocol.RoomCapacityOffset]) {
		delete(h.Invites, s.UID)
		return fail("房间已满。")
	}
	players := append(roomPlayers(r), s)
	for _, player := range players {
		if !player.Bound || !time.Now().Before(player.P2PUntil) {
			delete(h.Invites, s.UID)
			return fail("玩家连接尚未就绪，请重新邀请。")
		}
	}
	allows, err := h.stageGate(players...)
	if err != nil {
		return fail("地图条件读取失败，请稍后重试。")
	}
	if !allows(protocol.ReadUint32(r.Request, protocol.RoomMapOffset)) {
		delete(h.Invites, s.UID)
		return fail("地图已关闭或玩家不满足进入条件。")
	}
	// Consent is a one-use grant for this exact room, including its password.
	// installAs prepares descriptors before committing room membership.
	if err := h.installAs(r, s, false); err != nil {
		return err
	}
	h.clearInvitations(s)
	return nil
}
