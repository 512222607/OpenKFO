package game

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
)

func (h *Hub) stageSelection(s *Session, payload []byte) error {
	if len(payload) != 0 {
		s.sendGame(notice("关卡查询格式不正确。"))
		return nil
	}
	view, err := h.Store.StagePlayerView(s.UID, h.Config.ConfigHash)
	if err != nil {
		s.sendGame(notice("关卡信息读取失败，请稍后重试。"))
		return nil
	}
	if !view.Configured {
		s.sendGame(notice("尚未配置当前客户端的PVE地图目录。"))
		return nil
	}
	supported := map[uint32]bool{}
	// Match resolveWithAllowed's implemented modes/capacities, not arbitrary
	// pool keys. This must not implicitly open unimplemented PVE game logic.
	for _, mode := range []int{0, 1, 2, 3, 5} {
		for _, size := range []int{2, 4, 6, 8} {
			for _, id := range h.Config.Pools[fmt.Sprintf("%d:%d", mode, size)] {
				supported[id] = true
			}
		}
	}
	ids := []uint32{}
	for _, id := range view.Maps {
		if supported[id] {
			ids = append(ids, id)
		}
	}
	p, err := protocol.EncodeStageSelection(ids)
	if err != nil {
		return err
	}
	// RoomSet 7F876D returns before disabling its action button if the
	// selected map has no 21372 record. Seed all catalogue keys first.
	// This server has no inferred prerequisite/clearance counters: unknown
	// fields stay zero. The prerequisite uses a nonmatching sentinel:
	// MapInfo includes random map 0, which must not become a fake prerequisite.
	records := make([]protocol.StageRecord, len(view.Catalogue))
	for i, id := range view.Catalogue {
		records[i].MapID = id
		records[i].RequiredMapID = 0xffffffff
	}
	recordPayload, err := protocol.EncodeStageRecords(records)
	if err != nil {
		return err
	}
	s.sendGame(protocol.Message{ID: 21372, Payload: recordPayload})
	s.sendGame(protocol.Message{ID: 21373, Payload: p})
	return nil
}
