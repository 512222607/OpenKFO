package game

import "kungfu.local/server/internal/protocol"

func (h *Hub) changeRoomOwner(s *Session, p []byte) error {
	request, err := protocol.ParseRoomOwnerRequest(p)
	r := s.Room
	reason := ""
	switch {
	case err != nil:
		reason = "移交房主请求格式不正确。"
	case r == nil || uint32(r.ID) != request.RoomID || r.Members[s.UID] == nil || r.Members[s.UID].Session != s:
		reason = "你当前不在请求的房间。"
	case r.Owner != s.UID:
		reason = "只有当前房主可以移交房主。"
	case r.Stage != "room" || s.game() == nil || s.game().Phase != "room":
		reason = "只能在房间等待阶段移交房主。"
	case request.TargetUID == s.UID:
		reason = "请选择其他房间玩家接任房主。"
	case r.Members[request.TargetUID] == nil || r.Members[request.TargetUID].Session == nil || r.Members[request.TargetUID].Session.Room != r:
		reason = "目标玩家已离开房间。"
	case r.Members[request.TargetUID].Spectator:
		reason = "观战者不能担任房主。"
	case r.Members[request.TargetUID].Session.game() == nil || r.Members[request.TargetUID].Session.game().Phase != "room":
		reason = "目标玩家尚未返回等待房间，请稍后再移交房主。"
	}
	if reason != "" {
		s.sendGame(notice(reason))
		return nil
	}
	r.Owner = request.TargetUID
	h.broadcast(r, protocol.Message{ID: protocol.MsgRoomOwner, Payload: protocol.Uint64Bytes(r.Owner)}, 0)
	h.clearRoomReady(r)
	// 81FC30 reads a WORD; zero shows the native transfer-success notice.
	// Nonzero values index an error-string array, so do not invent an enum.
	s.sendGame(protocol.Message{ID: protocol.MsgChangeRoomOwnerResult, Payload: []byte{0, 0}})
	return nil
}
