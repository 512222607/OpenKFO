package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestChangeRoomOwner(t *testing.T) {
	h, host, peer, _ := waitingRoomFixture()
	r := host.Room
	p := append(protocol.Uint32Bytes(uint32(r.ID)), protocol.Uint64Bytes(peer.UID)...)
	r.Members[peer.UID].Ready = true
	if err := h.route(host, host.game(), protocol.Message{ID: 4051, Payload: p}); err != nil {
		t.Fatal(err)
	}
	old := roomOutputs(t, host, 3160, 4070, 4052)
	next := roomOutputs(t, peer, 3160, 4070)
	if r.Owner != peer.UID || len(r.Members) != 2 || r.Members[peer.UID].Ready || protocol.ReadUint64(old[0].Payload, 0) != peer.UID || protocol.ReadUint64(next[0].Payload, 0) != peer.UID || len(old[2].Payload) != 2 || protocol.ReadUint16(old[2].Payload, 0) != 0 {
		t.Fatal("owner change not synchronized")
	}
	// The previous owner cannot transfer again after losing authority.
	if err := h.route(host, host.game(), protocol.Message{ID: 4051, Payload: p}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, host, 20150)
	roomOutputs(t, peer)
	protocol.WriteUint64(p, 4, host.UID)
	if err := h.route(peer, peer.game(), protocol.Message{ID: 4051, Payload: p}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, host, 3160)
	roomOutputs(t, peer, 3160, 4052)
	if r.Owner != host.UID {
		t.Fatal("new owner lacks authority")
	}
}

func TestChangeRoomOwnerRejectsWithoutMutation(t *testing.T) {
	for _, name := range []string{"short", "long", "wrong room", "high room bits", "self", "missing", "loading", "battle", "stale session"} {
		t.Run(name, func(t *testing.T) {
			h, host, peer, _ := waitingRoomFixture()
			r := host.Room
			p := append(protocol.Uint32Bytes(uint32(r.ID)), protocol.Uint64Bytes(peer.UID)...)
			switch name {
			case "short":
				p = p[:11]
			case "long":
				p = append(p, 0)
			case "wrong room":
				protocol.WriteUint32(p, 0, uint32(r.ID)+1)
			case "high room bits":
				protocol.WriteUint32(p, 0, uint32(r.ID)+65536)
			case "self":
				protocol.WriteUint64(p, 4, host.UID)
			case "missing":
				protocol.WriteUint64(p, 4, 99999)
			case "loading", "battle":
				r.Stage = name
			case "stale session":
				r.Members[host.UID].Session = &Session{UID: host.UID}
			}
			if err := h.route(host, host.game(), protocol.Message{ID: 4051, Payload: p}); err != nil {
				t.Fatal(err)
			}
			roomOutputs(t, host, 20150)
			roomOutputs(t, peer)
			if r.Owner != host.UID || len(r.Members) != 2 || peer.Room != r {
				t.Fatal("rejection mutated room")
			}
		})
	}
}
