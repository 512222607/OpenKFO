package game

import (
	"database/sql"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestExpiredEquipmentSynchronizesAtEachPlayersReturn(t *testing.T) {
	for _, legacy := range []bool{false, true} {
		t.Run(map[bool]string{false: "3550", true: "3110"}[legacy], func(t *testing.T) {
			hub, host, peer, _ := combatFixture()
			db, err := sql.Open("recovery-snapshot", "expired")
			if err != nil {
				t.Fatal(err)
			}
			defer db.Close()
			hub.Store = &persistence.Store{DB: db}
			room := host.Room
			room.Stage = "settlement"
			for _, s := range []*Session{host, peer} {
				s.game().Phase = "settlement"
				room.Members[s.UID].Ready = false
				r := make([]byte, 68)
				protocol.WriteUint32(r, 0, 7)
				r[4] = 25
				protocol.WriteUint32(r, 5, 253002)
				protocol.WriteUint16(r, 17, 8)
				s.rememberInventory([][]byte{r})
			}
			for _, s := range []*Session{host, peer} {
				other := peer
				if s == peer {
					other = host
				}
				if legacy {
					roomRequest(t, hub, s, 3110, nil)
					roomOutputs(t, s, 3115, 3100, 3160, 3105, 2310, 2161, 2121)
					assertPlayerRefresh(t, roomOutputs(t, other, 3090)[0], s.UID)
				} else {
					roomRequest(t, hub, s, 3550, append(protocol.Uint64Bytes(s.UID), make([]byte, 4)...))
					roomOutputs(t, s, 3550, 2310, 2161, 2121)
					assertPlayerRefresh(t, roomOutputs(t, other, 3550, 3090)[1], s.UID)
				}
				if s.game().Phase != "room" || protocol.ReadUint16(s.Inventory[7], 17) != 0 || protocol.ReadUint32(s.Inventory[7], 19) != 2 {
					t.Fatal("returned player retained expired equipment")
				}
				if s == host && (peer.game().Phase != "settlement" || protocol.ReadUint16(peer.Inventory[7], 17) != 8) {
					t.Fatal("peer inventory changed before their return")
				}
				roomRequest(t, hub, s, 3550, append(protocol.Uint64Bytes(s.UID), make([]byte, 4)...))
				roomOutputs(t, s, 3550)
				roomOutputs(t, other, 3550)
			}
		})
	}
}

func assertPlayerRefresh(t *testing.T, message protocol.Message, uid uint64) {
	t.Helper()
	p := message.Payload
	if message.ID != 3090 || len(p) < 149 || protocol.ReadUint64(p, 0) != uid || p[8] >= 8 || p[76] != 0 {
		t.Fatal("player equipment refresh entered native spectator branch", message)
	}
}

func TestEquipmentChangeRemainsPlayerRecord(t *testing.T) {
	hub, host, peer, _ := waitingRoomFixture()
	hub.Store = recoveryStore(t)
	hub.equipmentChanged(host)
	assertPlayerRefresh(t, roomOutputs(t, peer, 3090)[0], host.UID)
	roomOutputs(t, host)
}

func TestExpiryRefreshSkipsUnsafeSessionPhases(t *testing.T) {
	hub, s, _, _ := waitingRoomFixture()
	hub.Store = recoveryStore(t) // driver rejects queries other than normal snapshots
	for _, phase := range []string{"loading", "battle", "settlement", "connected", "closed"} {
		s.game().Phase = phase
		if err := hub.RefreshExpiredInventory(s); err != nil {
			t.Fatalf("phase %s unexpectedly queried DB: %v", phase, err)
		}
		roomOutputs(t, s)
	}
	s.game().Phase = "room"
	for _, stage := range []string{"loading", "battle", "settlement"} {
		s.Room.Stage = stage
		if err := hub.RefreshExpiredInventory(s); err != nil {
			t.Fatal(err)
		}
	}
	s.Room.Stage = "room"
	s.LoggedOut = true
	if err := hub.RefreshExpiredInventory(s); err != nil {
		t.Fatal(err)
	}
}
