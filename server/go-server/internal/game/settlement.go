package game

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"sort"

	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

// Provisional emulator rules, not original game rewards. Zero disables awards.
// Growth uses the optional level table; item drops and titles remain separate.
type SettlementRewards = persistence.RewardRules

func validateBattleReport(room *Room, payload []byte) (map[uint64]uint16, error) {
	rows, err := protocol.ParseBattleReport(payload)
	if err != nil {
		return nil, err
	}
	health := map[uint64]uint16{}
	for slot, r := range rows {
		uid := r.UID
		if uid == 0 {
			// 987E40 zeroes the full report before filling occupied slots.
			if r.Raw != ([protocol.BattleReportRecordSize]byte{}) {
				return nil, fmt.Errorf("%w: battle report slot=%d has data without identity", protocol.ErrFrame, slot)
			}
			continue
		}
		member := room.Members[uid]
		if member == nil {
			return nil, fmt.Errorf("%w: battle report slot=%d unknown uid=%d", protocol.ErrFrame, slot, uid)
		}
		if int(member.Slot) != slot {
			return nil, fmt.Errorf("%w: battle report uid=%d slot=%d want=%d", protocol.ErrFrame, uid, slot, member.Slot)
		}
		// Native 987E40 copies the room context pair to +67/+71.
		if id := r.RoomID; id != uint32(room.ID) {
			return nil, fmt.Errorf("%w: battle report uid=%d room=%d want=%d", protocol.ErrFrame, uid, id, room.ID)
		}
		if serial := r.Serial; serial != room.Serial {
			return nil, fmt.Errorf("%w: battle report uid=%d serial=%d want=%d", protocol.ErrFrame, uid, serial, room.Serial)
		}
		if _, duplicate := health[uid]; duplicate {
			return nil, protocol.ErrFrame
		}
		health[uid] = r.Health
	}
	if len(health) != len(room.Members) {
		return nil, protocol.ErrFrame
	}
	return health, nil
}

func (hub *Hub) settleReport(session *Session, payload []byte) error {
	room := session.Room
	if room == nil || (room.Stage != "battle" && room.Stage != "finishing" && room.Stage != "settlement") {
		return nil
	}
	if room.Type() == protocol.StageAssault {
		return hub.stageFinishReport(session, payload)
	}
	if room.Type() == protocol.FosterMode {
		// PVE completion is not last-player/team-standing. Its native reason
		// and wave result must be handled by a separate settlement policy.
		return nil
	}
	if member := room.Members[session.UID]; member == nil || member.Session != session {
		return protocol.ErrFrame
	}
	if _, err := validateBattleReport(room, payload); err != nil {
		return err
	}
	if room.Stage == "settlement" {
		return nil
	}
	if room.Reports == nil {
		room.Reports = map[uint64][]byte{}
	}
	if previous, ok := room.Reports[session.UID]; ok && !bytes.Equal(previous, payload) {
		log.Printf("settlement_duplicate_changed uid=%d serial=%d", session.UID, room.Serial)
		return nil
	}
	room.Reports[session.UID] = bytes.Clone(payload)
	if room.Stage == "battle" {
		room.Stage = "finishing"
		// 4100 invokes the native report producer (987E40). Do not guess an
		// end-screen packet or wait indefinitely for a surviving player's timer.
		hub.broadcast(room, protocol.Message{ID: 4100}, session.UID)
	}
	if len(room.Reports) < len(room.Members) {
		return nil
	}
	base, _ := validateBattleReport(room, payload)
	agree := true
	for _, report := range room.Reports {
		other, _ := validateBattleReport(room, report)
		for uid, hp := range base {
			if (hp == 0) != (other[uid] == 0) {
				agree = false
			}
		}
	}
	alive := map[uint64]bool{}
	teamMode := room.Type() == protocol.TeamSurvival || room.Type() == protocol.TeamDeathmatch
	group := func(uid uint64) uint64 {
		if teamMode {
			return uint64(room.Members[uid].Team)
		}
		return uid
	}
	for uid, hp := range base {
		if hp > 0 {
			alive[group(uid)] = true
		}
	}
	var rewards []persistence.BattleReward
	settings, err := hub.Store.RewardManager().BattleRewards(hub.Config.Settlement)
	if err != nil {
		return fmt.Errorf("settlement rules: %w", err)
	}
	honour, err := hub.honourRules()
	if err != nil {
		return fmt.Errorf("honour rules: %w", err)
	}
	for uid, member := range room.Members {
		rules := settings.Rules.AtLevel(member.BattleLevel)
		outcome, gold := "draw", rules.DrawGold
		experience := rules.DrawExperience
		if agree && len(alive) == 1 {
			outcome, gold = "loss", rules.LossGold
			experience = rules.LossExperience
			if alive[group(uid)] {
				outcome, gold = "win", rules.WinGold
				experience = rules.WinExperience
			}
		}
		if !agree {
			outcome, gold = "unconfirmed", 0
			experience = 0
		}
		period, points := honour.Award(byte(room.Type()), outcome, len(room.Members))
		mode := byte(room.Type())
		rewards = append(rewards, persistence.BattleReward{TaskClientHash: hub.Config.ConfigHash, BattleMode: &mode, UID: uid, Outcome: outcome, Gold: gold, Experience: experience, StartLevel: member.BattleLevel, HonourPeriod: period, HonourPoints: points})
	}
	reports, err := json.Marshal(room.Reports)
	if err != nil {
		return err
	}
	rewards, err = hub.Store.BattleManager().SettleBattle(room.Serial, reports, rewards, settings.Rules)
	if err != nil {
		return fmt.Errorf("settlement persistence: %w", err)
	}
	room.Stage = "settlement"
	for _, member := range room.Members {
		member.Session.game().Phase = "settlement"
		member.Ready, member.Loaded, member.Input = false, false, false
		member.Session.ConsumeIntents = nil
	}
	for _, r := range rewards {
		s := room.Members[r.UID].Session
		// 4300 carries absolute profile values, not the per-match delta.
		s.sendGame(protocol.Message{ID: 4300, Payload: bytes.Clone(r.Profile[persistence.ExperienceOffset : persistence.ExperienceOffset+8])})
		s.sendGame(protocol.Message{ID: 1240, Payload: protocol.Uint32Bytes(r.GoldBalance)})
		for _, item := range r.Items {
			s.sendGame(protocol.Message{ID: protocol.MsgItemAdded, Payload: bytes.Clone(item)})
			if s.Inventory == nil {
				s.Inventory = map[uint32][]byte{}
			}
			s.Inventory[protocol.ReadUint32(item, 0)] = bytes.Clone(item)
		}
		if err := hub.rewardBalances(s, settings.Rules.LevelGifts); err != nil {
			return err
		}
		s.sendGame(settlementPacket(room, rewards, r.UID))
		log.Printf("battle_settled serial=%d room=%d uid=%d outcome=%s gold=%d experience=%d start_level=%d level=%d drops=%d titles=disabled", room.Serial, room.ID, r.UID, r.Outcome, r.Gold, r.Experience, room.Members[r.UID].BattleLevel, persistence.ProfileLevel(r.Profile), len(r.Items))
	}
	return nil
}

func settlementPacket(room *Room, rewards []persistence.BattleReward, recipient uint64) protocol.Message {
	rewards = append([]persistence.BattleReward(nil), rewards...)
	// 9CD2F0 compares only the profile character selector, shared by accounts.
	// Apply the recipient profile last so a peer cannot replace its local data.
	sort.Slice(rewards, func(i, j int) bool {
		if rewards[i].UID == recipient {
			return false
		}
		if rewards[j].UID == recipient {
			return true
		}
		return room.Members[rewards[i].UID].Slot < room.Members[rewards[j].UID].Slot
	})
	payload := make([]byte, 500*len(rewards))
	for i, r := range rewards {
		record := payload[i*500 : (i+1)*500]
		protocol.WriteUint64(record, 0, r.UID)
		// Native result renderer 812480 uses +10 for Win/Lose/Draw.
		switch r.Outcome {
		case "win":
			record[10] = 1
		case "loss":
			record[10] = 2
		}
		protocol.WriteUint16(record, 14, protocol.ReadUint16(r.Profile, persistence.LevelOffset))
		protocol.WriteUint32(record, 16, protocol.ReadUint32(r.Profile, persistence.ExperienceOffset))
		protocol.WriteUint32(record, 34, r.Experience) // txtScore0, native 812DAB
		protocol.WriteUint32(record, 63, r.Gold)       // txtGold0, native 812EA6
		// 82C970 reads a 140-byte header then a full 360-byte persisted profile.
		// Header +21 is an unverified counter delta, NOT a safe XP field.
		copy(record[140:], r.Profile)
	}
	return protocol.Message{ID: 4120, Payload: payload}
}

func (hub *Hub) returnFromSettlement(session *Session) error {
	room := session.Room
	account, err := hub.Store.RoleManager().Snapshot(session.UID)
	if err != nil {
		return err
	}
	var peers []roomPeer
	for uid, member := range room.Members {
		if uid == session.UID {
			continue
		}
		other, err := hub.Store.RoleManager().Snapshot(uid)
		if err != nil {
			return err
		}
		peers = append(peers, roomPeer{member, fighter(other, member)})
	}
	session.sendGame(protocol.Message{ID: protocol.MsgRoomLeft})
	room.Stage = "room"
	hub.completeRoomJoin(room, room.Members[session.UID], fighter(account, room.Members[session.UID]), peers)
	if err := hub.extendedTaskLists(session); err != nil {
		session.sendGame(notice("任务进度刷新失败，请稍后打开任务列表。"))
	}
	session.syncUnequippedInventory(account.Inventory)
	return nil
}
