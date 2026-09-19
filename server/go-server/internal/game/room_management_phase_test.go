package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestRoomManagementRequiresBothPlayersInWaitingPhase(t *testing.T) {
	for _, operation := range []uint32{protocol.MsgKickRoomPlayer, protocol.MsgChangeRoomOwner} {
		for _, target := range []bool{false, true} {
			for _, phase := range []string{"lobby", "loading", "wait_ready", "battle", "settlement"} {
				h, owner, peer, _ := waitingRoomFixture()
				r := owner.Room
				actor := owner
				if target {
					actor = peer
				}
				actor.game().Phase = phase // room.Stage is already "room" after a different member returned.
				r.Members[peer.UID].Ready = true
				p := append(protocol.Uint64Bytes(peer.UID), 0)
				if operation == protocol.MsgChangeRoomOwner {
					p = append(protocol.Uint32Bytes(uint32(r.ID)), protocol.Uint64Bytes(peer.UID)...)
				}
				roomRequest(t, h, owner, operation, p)
				roomOutputs(t, owner, 20150)
				roomOutputs(t, peer)
				if r.Owner != owner.UID || peer.Room != r || owner.Room != r || len(r.Members) != 2 || !r.Members[peer.UID].Ready || actor.game().Phase != phase {
					t.Fatalf("operation %d target=%v phase=%s changed waiting state", operation, target, phase)
				}
			}
		}
	}
}

func TestKickDoesNotFollowStaleTargetIntoAnotherRoom(t *testing.T) {
	for _, missing := range []bool{false, true} {
		h, owner, peer, _ := waitingRoomFixture()
		r := owner.Room
		other := &Room{ID: 2, Owner: peer.UID, Stage: "room", Members: map[uint64]*Member{peer.UID: r.Members[peer.UID]}}
		peer.Room = other
		h.Rooms[other.ID] = other
		if missing {
			r.Members[peer.UID].Session = nil
		}
		roomRequest(t, h, owner, protocol.MsgKickRoomPlayer, append(protocol.Uint64Bytes(peer.UID), 0))
		roomOutputs(t, owner, 20150)
		roomOutputs(t, peer)
		if peer.Room != other || len(other.Members) != 1 || len(r.Members) != 2 || h.Rooms[2] != other {
			t.Fatal("stale target affected another room")
		}
	}
}
