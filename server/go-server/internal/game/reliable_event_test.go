package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestReliableBattleExchange(t *testing.T) {
	for _, family := range []uint32{9000, 9500} {
		h, owner, actor, outsider := combatFixture()
		size, ctx := 55, 0
		if family == 9000 {
			size, ctx = 63, 55
		}
		packet := func(kind uint32, s *Session, key, flag, seq uint32) protocol.Message {
			m := combatPacket(kind, size, s.UID, actor.UID, ctx)
			protocol.WriteUint32(m.Payload, 47, key)
			protocol.WriteUint32(m.Payload, 51, flag)
			protocol.WriteUint32(m.Payload, 19, seq)
			return m
		}
		send := func(s *Session, m protocol.Message, to *Session) {
			t.Helper()
			if err := h.battleMessage(s, s.game(), m); err != nil {
				t.Fatal(err)
			}
			if to != nil {
				roomOutputs(t, to, 8071)
			} else {
				roomOutputs(t, owner)
				roomOutputs(t, actor)
			}
			roomOutputs(t, outsider)
		}
		send(owner, packet(family+1, owner, 42, 1, 1), nil) // unsolicited reply
		req := packet(family, actor, 42, 1, 1)
		send(actor, req, owner)
		send(actor, req, nil)                               // exact replay
		send(actor, packet(family+1, actor, 42, 1, 1), nil) // fake controller
		send(owner, packet(family+1, owner, 43, 1, 1), nil) // wrong object
		send(actor, packet(family+2, actor, 42, 1, 1), nil) // before acceptance
		send(owner, packet(family+1, owner, 42, 1, 1), actor)
		send(actor, packet(family+2, actor, 42, 1, 1), owner)
		send(actor, packet(family+2, actor, 42, 1, 2), nil) // completed already
		send(actor, packet(family, actor, 43, 1, 2), owner)
		send(actor, packet(family, actor, 43, 0, 3), owner)
		send(owner, packet(family+1, owner, 43, 1, 2), nil) // cancelled
		send(actor, packet(family, actor, 44, 1, 4), owner)
		send(owner, packet(family+1, owner, 44, 0, 3), actor) // denied
		send(actor, packet(family+2, actor, 44, 1, 3), nil)
		if family == 9000 {
			bad := packet(family, actor, 45, 1, 5)
			protocol.WriteUint32(bad.Payload, 59, 999)
			send(actor, bad, nil)
		}
		bad := packet(family, actor, 45, 1, 5)
		protocol.WriteUint64(bad.Payload, 39, outsider.UID)
		send(actor, bad, nil)
		h.Rooms[1].Serial++ // prior requests cannot authorize a new battle
		send(owner, packet(family+1, owner, 44, 1, 4), nil)
	}
}

func TestPickupReservationIsolation(t *testing.T) {
	for _, family := range []uint32{9000, 9500} {
		h, host, a, b := combatFixture()
		b.Room = host.Room
		host.Room.Members[b.UID] = &Member{Session: b, Slot: 2}
		size, context := 55, 0
		if family == 9000 {
			size, context = 63, 55
		}
		packet := func(kind uint32, s, actor *Session, object, sequence uint32) protocol.Message {
			m := combatPacket(kind, size, s.UID, actor.UID, context)
			protocol.WriteUint32(m.Payload, 47, object)
			protocol.WriteUint32(m.Payload, 51, 1)
			protocol.WriteUint32(m.Payload, 19, sequence)
			return m
		}
		send := func(s *Session, m protocol.Message) {
			t.Helper()
			if err := h.battleMessage(s, s.game(), m); err != nil {
				t.Fatal(err)
			}
		}
		send(a, packet(family, a, a, 42, 1))
		roomOutputs(t, host, 8071)
		roomOutputs(t, b)
		send(a, packet(family, a, a, 43, 2))
		roomOutputs(t, host) // Cannot replace a pending request.
		send(b, packet(family, b, b, 42, 1))
		roomOutputs(t, host, 8071)
		roomOutputs(t, a)
		send(host, packet(family+1, host, a, 42, 1))
		roomOutputs(t, a, 8071)
		roomOutputs(t, b, 8071)
		send(host, packet(family+1, host, b, 42, 2))
		roomOutputs(t, a)
		roomOutputs(t, b)
		send(host, packet(family+2, host, host, 42, 1))
		roomOutputs(t, a)
		roomOutputs(t, b) // Host cannot steal a reservation.
		send(b, packet(family+2, b, b, 42, 1))
		roomOutputs(t, host)
		roomOutputs(t, a)
		send(a, packet(family+2, a, a, 42, 1))
		roomOutputs(t, host, 8071)
		roomOutputs(t, b, 8071)
		key := reliableActor{a.UID, family}
		if host.Room.Reliable[key].Pending {
			t.Fatal("completion left reservation")
		}
	}
}
