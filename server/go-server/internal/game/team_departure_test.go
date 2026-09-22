package game

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestTeamBattleDepartureContinues(t *testing.T) {
	for _, ownerLeaves := range []bool{false, true} {
		for _, acknowledge := range []bool{false, true} {
			hub, host, peer, third := waitingRoomFixture()
			room := host.Room
			room.Stage = "battle"
			room.Members[third.UID] = &Member{Session: third, Slot: 2, Team: 0}
			third.Room = room
			for _, m := range room.Members {
				m.Session.game().Phase = "battle"
			}
			leaving := third
			if ownerLeaves {
				leaving = host
			}
			report := settlementReport(room)
			hub.leave(leaving, acknowledge)
			if room.Stage != "battle" || len(room.Members) != 2 || leaving.Room != nil {
				t.Fatal("departure interrupted battle")
			}
			if acknowledge {
				roomOutputs(t, leaving, protocol.MsgRoomLeft)
			} else {
				roomOutputs(t, leaving)
			}
			for _, m := range room.Members {
				ids := []uint32{protocol.MsgPlayerLeftRoom}
				if ownerLeaves {
					ids = append(ids, protocol.MsgRoomOwner)
				}
				roomOutputs(t, m.Session, ids...)
				if m.Session.game().Phase != "battle" {
					t.Fatal("survivor left battle")
				}
			}
			if ownerLeaves && room.Owner != peer.UID {
				t.Fatal("owner not transferred to lowest remaining slot")
			}
			health, err := validateBattleReport(room, report)
			if err != nil || len(health) != 2 {
				t.Fatalf("retained departing actor: %v %v", health, err)
			}
			slot := int(room.DepartedSlots[leaving.UID])
			cleared := bytes.Clone(report)
			clear(cleared[slot*protocol.BattleReportRecordSize : (slot+1)*protocol.BattleReportRecordSize])
			if _, err := validateBattleReport(room, cleared); err != nil {
				t.Fatal(err)
			}
			protocol.WriteUint32(report, slot*protocol.BattleReportRecordSize+71, room.Serial+1)
			if _, err := validateBattleReport(room, report); err == nil {
				t.Fatal("stale departed actor accepted")
			}
		}
	}
}

func TestTeamLastOpponentDepartureRequestsSettlement(t *testing.T) {
	hub, host, peer, _ := waitingRoomFixture()
	room := host.Room
	room.Stage = "battle"
	hub.leave(peer, true)
	if room.Stage != "finishing" {
		t.Fatal("empty team must finish normally")
	}
	roomOutputs(t, host, protocol.MsgPlayerLeftRoom, protocol.MsgBattleReportRequest)
	roomOutputs(t, peer, protocol.MsgRoomLeft)
	hub.leave(host, false)
	if hub.Rooms[room.ID] != nil {
		t.Fatal("empty room retained")
	}
}

func TestTeamSettlementDepartureDoesNotAbort(t *testing.T) {
	hub, host, peer, _ := waitingRoomFixture()
	room := host.Room
	room.Stage = "settlement"
	room.Reports = map[uint64][]byte{peer.UID: settlementReport(room)}
	hub.leave(peer, true)
	if room.Stage != "settlement" || len(room.Reports) != 0 {
		t.Fatal("settled battle changed or stale quorum retained")
	}
	roomOutputs(t, host, protocol.MsgPlayerLeftRoom)
}
