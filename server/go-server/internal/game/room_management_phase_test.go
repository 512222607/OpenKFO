package game

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestRoomConfigurationWaitsForEverySettlementReturn(t *testing.T) {
	for _, operation := range []uint32{3230, 3200, 3260, protocol.MsgReady} {
		for _, phase := range []string{"loading", "wait_ready", "battle", "settlement"} {
			h, owner, peer, _ := waitingRoomFixture()
			r := owner.Room
			peer.game().Phase = phase
			original := bytes.Clone(r.Request)
			payload := []byte{1}
			want := []uint32{20150}
			switch operation {
			case 3200:
				payload = roomSettings(r.Request)
			case 3260:
				payload = make([]byte, 24)
				protocol.WriteUint64(payload, 0, owner.UID)
				protocol.WriteUint64(payload, 8, peer.UID)
				protocol.WriteUint32(payload, 20, 1)
				want = []uint32{3264}
			case protocol.MsgReady:
				payload, want = nil, nil
			}
			roomRequest(t, h, owner, operation, payload)
			roomOutputs(t, owner, want...)
			roomOutputs(t, peer)
			if !bytes.Equal(r.Request, original) || r.Members[owner.UID].Team != 0 || r.Members[owner.UID].Slot != 0 || r.Exchange != nil || r.Members[owner.UID].Ready || peer.game().Phase != phase {
				t.Fatalf("operation %d changed room while peer in %s", operation, phase)
			}
			peer.game().Phase = "room"
			if !r.canConfigure(owner) {
				t.Fatal("room remained locked after all players returned")
			}
		}
	}
}

func TestRoomConfigurationRejectsStaleMembership(t *testing.T) {
	for _, broken := range []string{"member", "session", "room", "channel", "identity", "actor"} {
		_, owner, peer, _ := waitingRoomFixture()
		r := owner.Room
		switch broken {
		case "member":
			r.Members[peer.UID] = nil
		case "session":
			r.Members[peer.UID].Session = nil
		case "room":
			peer.Room = nil
		case "channel":
			peer.game().Phase = "lobby"
		case "identity":
			r.Members[peer.UID] = r.Members[owner.UID]
		case "actor":
			delete(r.Members, owner.UID)
		}
		if r.canConfigure(owner) {
			t.Fatal("accepted stale membership", broken)
		}
	}
}

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
