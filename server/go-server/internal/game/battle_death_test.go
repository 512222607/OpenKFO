package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestDeathNoticeRoutingAndReplay(t *testing.T) {
	h, a, b, c := combatFixture()
	r := a.Room
	c.Room = r
	r.Members[c.UID] = &Member{Session: c, Slot: 2}
	m := extendedPacket(8278, 55, a.UID, b.UID, 0)
	protocol.WriteUint32(m.Payload, 47, 1)
	protocol.WriteUint32(m.Payload, 51, 5)
	if err := h.battleMessage(a, a.game(), m); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b, 8071)
	roomOutputs(t, c)
	roomOutputs(t, a)
	if err := h.battleMessage(a, a.game(), m); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, b)
	m = extendedPacket(8286, 55, b.UID, b.UID, 0)
	protocol.WriteUint64(m.Payload, 47, b.UID)
	if err := h.battleMessage(b, b.game(), m); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, a, 8071)
	roomOutputs(t, c, 8071)
	roomOutputs(t, b)
}
func TestDeathNoticeRejectsForeignOrObserver(t *testing.T) {
	for _, variant := range []string{"foreign", "outside", "observer", "countdown-peer", "countdown-self", "sender", "truncated"} {
		t.Run(variant, func(t *testing.T) {
			h, a, b, c := combatFixture()
			sender := a
			m := extendedPacket(8286, 55, a.UID, a.UID, 0)
			protocol.WriteUint64(m.Payload, 47, b.UID)
			switch variant {
			case "foreign":
				sender = b
				protocol.WriteUint64(m.Payload, 4, b.UID)
				protocol.WriteUint64(m.Payload, 39, b.UID)
				protocol.WriteUint64(m.Payload, 47, a.UID)
			case "outside":
				protocol.WriteUint64(m.Payload, 47, c.UID)
			case "observer":
				a.Room.Members[b.UID].Spectator = true
			case "sender":
				protocol.WriteUint64(m.Payload, 4, b.UID)
			case "truncated":
				m.Payload = m.Payload[:54]
			case "countdown-peer":
				sender = b
				m = extendedPacket(8278, 55, b.UID, a.UID, 0)
			case "countdown-self":
				m = extendedPacket(8278, 55, a.UID, a.UID, 0)
			}
			if err := h.battleMessage(sender, sender.game(), m); err == nil {
				t.Fatal("invalid death notice accepted")
			}
			roomOutputs(t, a)
			roomOutputs(t, b)
		})
	}
}
