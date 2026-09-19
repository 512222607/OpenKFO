package game

import "kungfu.local/server/internal/protocol"

func (h *Hub) kickRoomPlayer(s *Session, payload []byte) error {
	request, err := protocol.ParseRoomKickRequest(payload)
	reason := ""
	r := s.Room
	switch {
	case err != nil:
		reason = "踢人请求格式不正确，请重新打开房间列表。"
	case r == nil || r.Members[s.UID] == nil || r.Members[s.UID].Session != s:
		reason = "你当前不在该房间。"
	case r.Owner != s.UID:
		reason = "只有房主可以踢出玩家。"
	case r.Stage != "room":
		reason = "请在房间等待阶段踢出玩家。"
	case request.ClientFlag != 0:
		reason = "当前客户端的踢人标志尚不支持，未移除玩家。"
	case request.TargetUID == s.UID:
		reason = "不能踢出自己，请使用退出房间。"
	case r.Members[request.TargetUID] == nil:
		reason = "目标玩家已经离开房间。"
	}
	if reason != "" {
		s.sendGame(notice(reason))
		return nil
	}
	removed := r.Members[request.TargetUID].Session
	h.broadcast(r, protocol.Message{ID: protocol.MsgRoomPlayerKicked, Payload: payload}, 0)
	h.leave(removed, false)
	return nil
}
