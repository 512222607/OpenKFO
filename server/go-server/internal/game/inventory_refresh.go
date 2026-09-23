package game

import (
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"log"
	"time"
)

// Refresh only at a safe lobby/waiting-room boundary. Native battle equipment
// is a start-of-round snapshot; never replace its model mid-frame.
func (hub *Hub) RefreshExpiredInventory(s *Session) error {
	hub.Mutex.Lock()
	defer hub.Mutex.Unlock()
	if hub.Sessions[s.UID] != s || s.LoggedOut || hub.Store == nil {
		return nil
	}
	ch := s.game()
	if ch == nil || (ch.Phase != "lobby" && ch.Phase != "room") || (s.Room != nil && s.Room.Stage != "room") {
		return nil
	}
	if err := hub.refreshStageSelection(s); err != nil {
		log.Printf("stage_refresh_failed uid=%d", s.UID)
	}
	if err := hub.refreshMail(s); err != nil {
		log.Printf("mail_refresh_failed uid=%d", s.UID)
	}
	rows, err := hub.Store.DB.Query(`SELECT instance FROM inventory_expirations WHERE uid=? AND expires_at<=? ORDER BY instance`, s.UID, time.Now().Unix())
	if err != nil {
		return err
	}
	refresh := false
	for rows.Next() {
		var id uint32
		if err = rows.Scan(&id); err != nil {
			rows.Close()
			return err
		}
		if old := s.Inventory[id]; len(old) == 68 && protocol.ReadUint32(old, 19) != 2 {
			refresh = true
		}
	}
	err = rows.Err()
	rows.Close()
	if err != nil {
		return err
	}
	if !refresh {
		return nil
	}
	a, err := hub.Store.RoleManager().Snapshot(s.UID)
	if err != nil {
		return err
	}
	changedEquipment := s.syncUnequippedInventory(a.Inventory)
	if changedEquipment && s.Room != nil {
		hub.refreshExpiredEquipment(s, a)
	}
	return nil
}

// An expired loadout invalidates only its owner's ready confirmation.
func (hub *Hub) refreshExpiredEquipment(s *Session, account persistence.Account) {
	r := s.Room
	if r == nil || r.Stage != "room" || r.Members[s.UID] == nil {
		return
	}
	hub.cancelNetworkProbe(r)
	hub.cancelSeatExchange(r)
	if r.Members[s.UID].Ready {
		r.Members[s.UID].Ready = false
		hub.broadcast(r, protocol.Message{ID: protocol.MsgPlayerNotReady, Payload: protocol.Uint64Bytes(s.UID)}, 0)
	}
	hub.broadcastEquipment(s, account)
}
