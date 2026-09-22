package game

import (
	"bytes"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"testing"
	"time"
)

func invitationFixture(t *testing.T) (*Hub, *Session, *Session, *Session) {
	t.Helper()
	h, a, b, c := waitingRoomFixture()
	h.Store = recoveryStore(t)
	for _, s := range []*Session{a, b, c} {
		s.Bound = true
		s.P2PUntil = time.Now().Add(time.Minute)
	}
	return h, a, b, c
}
func invitePayload(a, b *Session) []byte {
	p := make([]byte, protocol.RoomInviteSize)
	protocol.WriteUint64(p, 0, a.UID)
	copy(p[8:29], []byte("spoofed name"))
	protocol.WriteUint64(p, 29, b.UID)
	protocol.WriteUint16(p, 37, a.Room.ID)
	return p
}
func acceptPayload(a, b *Session) []byte {
	p := make([]byte, protocol.RoomInviteAcceptSize)
	protocol.WriteUint64(p, 0, a.UID)
	protocol.WriteUint64(p, 8, b.UID)
	protocol.WriteUint16(p, 16, a.Room.ID)
	return p
}
func TestInvitationConsentAndIdentity(t *testing.T) {
	h, a, b, c := invitationFixture(t)
	a.Room.Request[21] = 'x' // Consent is scoped to this password-protected room.
	p := invitePayload(a, c)
	roomRequest(t, h, a, 3500, p)
	got := roomOutputs(t, c, 3500)[0].Payload
	if !bytes.Equal(bytes.TrimRight(got[8:29], "\x00"), persistence.GBK(a.Nickname)) {
		t.Fatal("untrusted invitation name")
	}
	roomRequest(t, h, a, 3500, p)
	roomOutputs(t, c)
	roomRequest(t, h, c, 3501, acceptPayload(a, c))
	roomOutputs(t, c, 3100, 3160, 3105)
	roomOutputs(t, a, 3090)
	roomOutputs(t, b, 3090)
	if c.Room != a.Room || len(h.Invites) != 0 {
		t.Fatal("consent did not join exactly once")
	}
	roomRequest(t, h, c, 3501, acceptPayload(a, c))
	roomOutputs(t, c, 20150)
	roomOutputs(t, a)
}
func TestInvitationStaleAndCapacity(t *testing.T) {
	for _, variant := range []string{"expiry", "room-reuse", "round", "reconnect", "inviter-reconnect", "full", "unbound", "lobby"} {
		t.Run(variant, func(t *testing.T) {
			h, a, b, c := invitationFixture(t)
			roomRequest(t, h, a, 3500, invitePayload(a, c))
			roomOutputs(t, c, 3500)
			p := acceptPayload(a, c)
			switch variant {
			case "expiry":
				i := h.Invites[c.UID]
				i.expires = time.Now().Add(-time.Second)
				h.Invites[c.UID] = i
			case "room-reuse":
				clone := *a.Room
				h.Rooms[a.Room.ID] = &clone
			case "round":
				a.Room.Serial++
			case "reconnect":
				old := c.game()
				replacement := *old
				c.Channels[c.GameChannel] = &replacement
			case "inviter-reconnect":
				old := a.game()
				replacement := *old
				a.Channels[a.GameChannel] = &replacement
			case "full":
				a.Room.Request[37] = 2
			case "unbound":
				b.Bound = false
			case "lobby":
				c.LobbyID++
			}
			roomRequest(t, h, c, 3501, p)
			roomOutputs(t, c, 20150)
			roomOutputs(t, a)
			roomOutputs(t, b)
			if c.Room != nil || len(h.Invites) != 0 {
				t.Fatal("stale invitation mutated room")
			}
		})
	}
}
func TestInvitationDeclineSpoofAndLeave(t *testing.T) {
	h, a, _, c := invitationFixture(t)
	bad := invitePayload(a, c)
	protocol.WriteUint64(bad, 0, c.UID)
	if err := h.roomInvitation(a, a.game(), protocol.Message{ID: 3500, Payload: bad}); err == nil {
		t.Fatal("spoof admitted")
	}
	roomRequest(t, h, a, 3500, invitePayload(a, c))
	roomOutputs(t, c, 3500)
	p := make([]byte, 37)
	protocol.WriteUint64(p, 0, a.UID)
	protocol.WriteUint64(p, 29, c.UID)
	roomRequest(t, h, c, 3502, p)
	got := roomOutputs(t, a, 3502)[0].Payload
	if !bytes.Equal(bytes.TrimRight(got[8:29], "\x00"), persistence.GBK(c.Nickname)) || len(h.Invites) != 0 {
		t.Fatal("decline identity/state")
	}
	roomRequest(t, h, a, 3500, invitePayload(a, c))
	roomOutputs(t, c, 3500)
	h.leave(c, false)
	if len(h.Invites) != 0 {
		t.Fatal("lobby disconnect kept invitation")
	}
}
func TestWaitingTimeoutCannotAbortBattle(t *testing.T) {
	h, a, b, _ := waitingRoomFixture()
	roomRequest(t, h, b, 4031, nil)
	roomOutputs(t, b, 4032)
	roomOutputs(t, a, 4032)
	if b.Room != nil || a.Room == nil || a.Room.Stage != "room" {
		t.Fatal("timeout removed wrong member")
	}
	h, a, b, _ = combatFixture()
	roomRequest(t, h, b, 4031, nil)
	roomOutputs(t, a)
	roomOutputs(t, b)
	if b.Room != a.Room || a.Room.Stage != "battle" {
		t.Fatal("stale timer aborted battle")
	}
}
