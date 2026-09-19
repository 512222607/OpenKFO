package game

import (
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
	a, err := hub.Store.Snapshot(s.UID)
	if err != nil {
		return err
	}
	changedEquipment := s.syncUnequippedInventory(a.Inventory)
	if changedEquipment && s.Room != nil {
		hub.clearRoomReady(s.Room)
		hub.broadcast(s.Room, protocol.Message{ID: 3090, Payload: fighter(a, s.Room.Members[s.UID], true)}, s.UID)
	}
	return nil
}
