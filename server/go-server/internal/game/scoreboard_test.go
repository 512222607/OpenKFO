package game

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestScoreboardAuthorityRosterAndReplay(t *testing.T) {
	h, host, peer, outsider := combatFixture()
	p := make([]byte, 334)
	protocol.WriteUint32(p, 0, 8155)
	protocol.WriteUint64(p, 4, host.UID)
	protocol.WriteUint32(p, 19, 1)
	copy(p[39:46], []byte{1, 2, 3, 4, 5, 6, 7})
	protocol.WriteUint64(p, 46, host.UID)
	protocol.WriteUint64(p, 82, peer.UID)
	protocol.WriteUint32(p, 54, 17)
	protocol.WriteUint32(p, 90, 9)
	m := protocol.Message{ID: 8071, Payload: p}
	if err := h.battleMessage(host, host.game(), m); err != nil {
		t.Fatal(err)
	}
	got := roomOutputs(t, peer, 8071)[0]
	if !bytes.Equal(got.Payload, p) {
		t.Fatal("scoreboard altered")
	}
	roomOutputs(t, host)
	roomOutputs(t, outsider)
	if err := h.battleMessage(host, host.game(), m); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, peer)
	unauthorized := bytes.Clone(p)
	protocol.WriteUint64(unauthorized, 4, peer.UID)
	if err := h.battleMessage(peer, peer.game(), protocol.Message{ID: 8071, Payload: unauthorized}); err != nil {
		t.Fatal("non-owner should be ignored", err)
	}
	roomOutputs(t, host)
	for _, mutate := range []func([]byte){
		func(p []byte) { protocol.WriteUint64(p, 4, peer.UID) },
		func(p []byte) { protocol.WriteUint64(p, 46, outsider.UID) },
		func(p []byte) { protocol.WriteUint64(p, 82, host.UID) },
		func(p []byte) { protocol.WriteUint64(p, 82, 0) },
		func(p []byte) { protocol.WriteUint64(p, 118, outsider.UID) },
		func(p []byte) { p[126] = 1 },
	} {
		bad := bytes.Clone(p)
		mutate(bad)
		if h.battleMessage(host, host.game(), protocol.Message{ID: 8071, Payload: bad}) == nil {
			t.Fatal("invalid scoreboard accepted")
		}
		roomOutputs(t, peer)
	}
	for _, n := range []int{333, 335} {
		bad := make([]byte, n)
		copy(bad, p)
		if h.battleMessage(host, host.game(), protocol.Message{ID: 8071, Payload: bad}) == nil {
			t.Fatal("invalid length accepted")
		}
	}
	host.Room.Stage = "settlement"
	if err := h.battleMessage(host, host.game(), m); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, peer)
}
