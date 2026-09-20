package game

import (
	"bytes"
	"testing"

	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

func waitingRoomFixture() (*Hub, *Session, *Session, *Session) {
	hub, host, peer, newcomer := combatFixture()
	room := host.Room
	room.Stage = "room"
	copy(room.Request, []byte("test room"))
	room.Request[37], room.Request[46] = 4, 1
	protocol.WriteUint32(room.Request, 38, 804)
	protocol.WriteUint32(room.Request, 42, 804)
	protocol.WriteUint16(room.Request, 47, 180)
	hub.Config.Pools = map[string][]uint32{"1:4": {804, 805}}
	for _, member := range room.Members {
		member.Session.game().Phase = "room"
		member.Team, member.Spawn = member.Slot%2, member.Slot
	}
	newcomer.game().Phase = "lobby"
	return hub, host, peer, newcomer
}

func roomOutputs(t *testing.T, session *Session, ids ...uint32) []protocol.Message {
	t.Helper()
	var messages []protocol.Message
	decoder := protocol.Decoder{}
	for len(session.Output) > 0 {
		decoded, err := decoder.Feed((<-session.Output).Data)
		if err != nil {
			t.Fatal(err)
		}
		messages = append(messages, decoded...)
	}
	if len(messages) != len(ids) {
		t.Fatalf("uid %d: got %v, want IDs %v", session.UID, messages, ids)
	}
	for i, id := range ids {
		if messages[i].ID != id {
			t.Fatalf("message %d: got %d, want %d", i, messages[i].ID, id)
		}
	}
	return messages
}

func roomRequest(t *testing.T, hub *Hub, session *Session, id uint32, payload []byte) {
	t.Helper()
	handled, err := hub.roomMessage(session, session.game(), protocol.Message{ID: id, Payload: payload})
	if !handled || err != nil {
		t.Fatalf("request %d: handled=%v err=%v", id, handled, err)
	}
}

func TestRoomThirdMemberRosterAndNativeFields(t *testing.T) {
	hub, host, peer, newcomer := waitingRoomFixture()
	room := host.Room
	account := func(session *Session, equipped bool) persistence.Account {
		a := persistence.Account{UID: session.UID, Nickname: "player", Profile: make([]byte, 125)}
		if equipped {
			item := make([]byte, 68)
			protocol.WriteUint16(item, 17, 1)
			a.Inventory = [][]byte{item}
		}
		return a
	}
	room.Members[peer.UID].Ready = true
	peers := []roomPeer{
		{room.Members[peer.UID], fighter(account(peer, true), room.Members[peer.UID])},
		{room.Members[host.UID], fighter(account(host, false), room.Members[host.UID])},
	}
	// Deliberately distinct values catch mixing the three native fields.
	member := &Member{Session: newcomer, Slot: 2, Spawn: 3, Team: 1}
	own := fighter(account(newcomer, true), member)
	hub.completeRoomJoin(room, member, own, peers)
	if newcomer.Room != room || newcomer.game().Phase != "room" || len(room.Members) != 3 {
		t.Fatal("join did not commit membership")
	}
	outputs := roomOutputs(t, newcomer, 3100, 3160, 3105, 4070)
	entry := outputs[0].Payload
	if len(entry) != 245 || entry[10] != 2 || entry[11] != 3 || entry[66] != 1 || !bytes.Equal(entry[96:], own[:149]) {
		t.Fatal("native 3100 member fields incorrect")
	}
	roster := outputs[2].Payload
	if len(roster) != 149+149+68 || protocol.ReadUint64(roster, 0) != host.UID || protocol.ReadUint64(roster, 149) != peer.UID || roster[149+64] != 1 {
		t.Fatal("3105 variable record stride or slot ordering incorrect")
	}
	for _, existing := range []*Session{host, peer} {
		messages := roomOutputs(t, existing, 3090, 4070)
		record := messages[0].Payload
		if len(record) != 217 || record[8] != 2 || record[9] != 3 || record[10] != 1 || record[64] != 1 {
			t.Fatal("3090 slot/spawn/team or equipment tail incorrect")
		}
	}
	if room.Members[peer.UID].Ready {
		t.Fatal("join must invalidate existing readiness")
	}
}

func TestRoomTeamRetryPreservesReadiness(t *testing.T) {
	hub, host, peer, _ := waitingRoomFixture()
	member := host.Room.Members[peer.UID]
	member.Spawn = 3
	roomRequest(t, hub, peer, 3230, []byte{0})
	for _, player := range []*Session{host, peer} {
		p := roomOutputs(t, player, 3250)[0].Payload
		if len(p) != 10 || protocol.ReadUint64(p, 0) != peer.UID || p[8] != 0 || p[9] != 1 {
			t.Fatal("3250 native layout incorrect")
		}
	}
	member.Ready = true
	roomRequest(t, hub, peer, 3230, []byte{0})
	roomOutputs(t, peer, 3250)
	roomOutputs(t, host)
	if !member.Ready {
		t.Fatal("same-team retry cleared readiness")
	}
	roomRequest(t, hub, peer, 3230, []byte{1})
	roomOutputs(t, host, 3250, 4070)
	roomOutputs(t, peer, 3250, 4070)
	if member.Ready || member.Spawn != 4 {
		t.Fatal("team change did not allocate the opposite side and reset readiness")
	}
}

func TestRoomSettingsPermissionsValidationAndRetry(t *testing.T) {
	hub, host, peer, _ := waitingRoomFixture()
	room := host.Room
	original := bytes.Clone(room.Request)
	payload := roomSettings(original)
	protocol.WriteUint32(payload, 0, 805)
	protocol.WriteUint32(payload, 4, 805)
	roomRequest(t, hub, peer, 3200, payload)
	if !bytes.Equal(original, room.Request) {
		t.Fatal("non-owner changed settings")
	}
	for _, bad := range []func([]byte){
		func(p []byte) { p[9] = 2 },
		func(p []byte) { p[11] = 1 },
		func(p []byte) { p[14] = 0 },
		func(p []byte) { p[34] = 1 },
		func(p []byte) { protocol.WriteUint16(p, 46, 1) },
	} {
		invalid := bytes.Clone(payload)
		bad(invalid)
		roomRequest(t, hub, host, 3200, invalid)
		if !bytes.Equal(original, room.Request) {
			t.Fatal("invalid settings mutated room")
		}
	}
	roomOutputs(t, host)
	roomOutputs(t, peer)
	room.Members[peer.UID].Ready = true
	roomRequest(t, hub, host, 3200, payload)
	for _, player := range []*Session{host, peer} {
		if !bytes.Equal(roomOutputs(t, player, 3220, 4070)[0].Payload, payload) {
			t.Fatal("settings reply differs from committed fields")
		}
	}
	room.Members[peer.UID].Ready = true
	roomRequest(t, hub, host, 3200, payload)
	roomOutputs(t, host, 3220)
	roomOutputs(t, peer)
	if !room.Members[peer.UID].Ready {
		t.Fatal("settings retry cleared readiness")
	}
	invalidMap := bytes.Clone(payload)
	protocol.WriteUint32(invalidMap, 0, 9999)
	roomRequest(t, hub, host, 3200, invalidMap)
	roomOutputs(t, host, 20150)
	if !bytes.Equal(roomSettings(room.Request), payload) || !room.Members[peer.UID].Ready {
		t.Fatal("rejected map affected state")
	}
}

func TestRoomOwnerDepartureAndLeaveRetry(t *testing.T) {
	hub, host, peer, _ := waitingRoomFixture()
	room := host.Room
	room.Members[peer.UID].Ready = true
	roomRequest(t, hub, host, 3110, nil)
	roomOutputs(t, host, 3115)
	messages := roomOutputs(t, peer, 3130, 3160, 4070)
	if room.Owner != peer.UID || protocol.ReadUint64(messages[1].Payload, 0) != peer.UID || host.Room != nil || host.game().Phase != "lobby" {
		t.Fatal("owner transfer or departure incorrect")
	}
	roomRequest(t, hub, host, 3110, nil)
	roomOutputs(t, host, 3115)
	roomOutputs(t, peer)
	roomRequest(t, hub, peer, 3110, nil)
	roomOutputs(t, peer, 3115)
	if len(hub.Rooms) != 0 {
		t.Fatal("empty room retained")
	}
}

func TestRoomResolvedCreateRetry(t *testing.T) {
	hub, host, peer, _ := waitingRoomFixture()
	request := bytes.Clone(host.Room.Request)
	protocol.WriteUint32(request, 38, 0xffffffff)
	protocol.WriteUint32(request, 42, 0)
	roomRequest(t, hub, host, 3010, request)
	roomOutputs(t, host)
	roomOutputs(t, peer)
	if len(hub.Rooms) != 1 {
		t.Fatal("create retry added a room")
	}
}

func TestRoomKickRequiresOwnerAndRemovesOnlyTarget(t *testing.T) {
	hub, host, peer, newcomer := waitingRoomFixture()
	room := host.Room
	newcomer.Room = room
	newcomer.game().Phase = "room"
	room.Members[newcomer.UID] = &Member{Session: newcomer, Slot: 2, Spawn: 2, Ready: true}
	payload := append(protocol.Uint64Bytes(newcomer.UID), 0)
	roomRequest(t, hub, peer, 3140, payload)
	if len(room.Members) != 3 {
		t.Fatal("non-owner kicked a player")
	}
	roomOutputs(t, host)
	roomOutputs(t, peer, 20150)
	roomOutputs(t, newcomer)
	payload = append(protocol.Uint64Bytes(peer.UID), 0)
	roomRequest(t, hub, host, 3140, payload)
	roomOutputs(t, peer, 3150)
	roomOutputs(t, host, 3150, 3130, 4070)
	roomOutputs(t, newcomer, 3150, 3130, 4070)
	if len(room.Members) != 2 || room.Owner != host.UID || peer.Room != nil || peer.game().Phase != "lobby" || room.Members[newcomer.UID].Ready {
		t.Fatal("kick did not isolate target and reset remaining readiness")
	}
}

func TestRoomFirstMemberReceivesNoEmptyRoster(t *testing.T) {
	hub, host, _, _ := waitingRoomFixture()
	room := host.Room
	member := room.Members[host.UID]
	clear(room.Members)
	account := persistence.Account{UID: host.UID, Profile: make([]byte, 125)}
	hub.completeRoomJoin(room, member, fighter(account, member), nil)
	roomOutputs(t, host, 3100, 3160)
}
