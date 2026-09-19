package game

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
)

// Native 8A0F00/921430 creates this private introduction room before P2P
// registration. It is not mode 5 practice or the titlemission skill exercises.
func tutorialRequest(p []byte) bool {
	return len(p) == protocol.RoomRequestSize && protocol.RoomTypeFromRequest(p) == protocol.NewPlayerGuide && p[protocol.RoomCapacityOffset] == 1 &&
		protocol.ReadUint32(p, protocol.RoomMapOffset) == protocol.TutorialMapID && protocol.ReadUint32(p, protocol.RoomSuggestedMapOffset) == protocol.TutorialMapID
}

func tutorialRoom(r *Room) bool { return r != nil && tutorialRequest(r.Request) }

func (h *Hub) acknowledgeTutorialJoin(s *Session, r *Room) error {
	a, err := h.Store.RoleManager().Snapshot(s.UID)
	if err != nil {
		return err
	}
	m := r.Members[s.UID]
	s.sendGame(protocol.Message{ID: protocol.MsgRoomEntered, Payload: roomEntryForMember(r, m, fighter(a, m, false))})
	s.sendGame(protocol.Message{ID: protocol.MsgRoomOwner, Payload: protocol.Uint64Bytes(r.Owner)})
	r.TutorialPending = false
	return nil
}

// 829B50 writes profile+123 synchronously; 3115 then invokes the native
// lobby guide gate. Persisting this field alone does not update that gate.
// Keep the complete 64-byte payload required by the native selector consumer.
func syncTutorialTitle(s *Session, level byte) {
	p := make([]byte, 64)
	p[0] = level
	s.sendGame(protocol.Message{ID: protocol.MsgTitleAward, Payload: p})
}

// 4124/0 is emitted by the native guide at completion (96A2B0), not 6220.
func (h *Hub) completeTutorial(s *Session, ch *Channel, payload []byte) error {
	if len(payload) != 0 {
		return protocol.ErrFrame
	}
	r := s.Room
	if !tutorialRoom(r) || r.Stage != "battle" || ch.Phase != "battle" ||
		r.Owner != s.UID || len(r.Members) != 1 || r.Members[s.UID] == nil ||
		r.Members[s.UID].Session != s || !r.Members[s.UID].Input {
		return nil
	}
	result, err := h.Store.RewardManager().CompleteTutorial(s.UID)
	if err != nil {
		return err
	}
	// Synchronize BEFORE leaving: otherwise 924010 sees the old title and
	// immediately sends another 3010 despite the committed completion receipt.
	announced, err := h.announceTutorialReward(s)
	if err != nil {
		return err
	}
	if !announced {
		syncTutorialTitle(s, result.Profile[123])
	}
	for _, item := range result.Items {
		s.sendGame(protocol.Message{ID: protocol.MsgItemAdded, Payload: bytes.Clone(item)})
		if s.Inventory == nil {
			s.Inventory = map[uint32][]byte{}
		}
		s.Inventory[protocol.ReadUint32(item, 0)] = bytes.Clone(item)
	}
	s.sendGame(protocol.Message{ID: 1240, Payload: protocol.Uint32Bytes(result.Gold)})
	s.sendGame(protocol.Message{ID: 1230, Payload: protocol.Uint32Bytes(result.Tickets)})
	h.leave(s, true)
	if announced {
		s.sendGame(notice("新手引导已完成，请选择一件武器并确认领取；其他奖励已发放。"))
	} else {
		s.sendGame(notice("新手引导已完成，已按配置发放奖励，请查看背包和余额。"))
	}
	return nil
}

func (h *Hub) announceTutorialReward(s *Session) (bool, error) {
	if s.TitleOffer != 0 && s.TitleOffer != 2 {
		return false, nil
	}
	choices, catalog, err := h.Store.RewardManager().TutorialChoices(s.UID)
	if err != nil || len(choices) == 0 {
		return false, err
	}
	p, err := protocol.EncodeTitleAward(2, choices)
	if err != nil {
		return false, err
	}
	s.sendGame(protocol.Message{ID: 1550, Payload: catalog})
	s.TitleOffer = 2
	s.sendGame(protocol.Message{ID: protocol.MsgTitleAward, Payload: p})
	return true, nil
}
