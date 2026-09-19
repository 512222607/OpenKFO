package game

import (
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestTalismanRepairConfigurationAndPhase(t *testing.T) {
	r := persistence.TalismanRepairRule{Item: 303002, Material: 603001, Quantity: 1, Capacity: 10000}
	if (Config{TalismanRepairs: []persistence.TalismanRepairRule{r}}).ValidateTalismanRepairs() != nil {
		t.Fatal("valid rule")
	}
	for _, rs := range [][]persistence.TalismanRepairRule{{{}}, {r, r}} {
		if (Config{TalismanRepairs: rs}).ValidateTalismanRepairs() == nil {
			t.Fatal("invalid rules")
		}
	}
	h, s, _, _ := waitingRoomFixture()
	h.Store = nil
	if err := h.route(s, s.game(), protocol.Message{ID: 4202, Payload: protocol.Uint32Bytes(1)}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 20150)
	h.Config.TalismanRepairs = []persistence.TalismanRepairRule{r}
	s.game().Phase = "battle"
	if err := h.route(s, s.game(), protocol.Message{ID: 4204, Payload: make([]byte, 12)}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s)
	s.game().Phase = "room"
	s.Room.Members[s.UID].Ready = true
	if err := h.route(s, s.game(), protocol.Message{ID: 4202, Payload: protocol.Uint32Bytes(1)}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s, 20150)
}

func TestTalismanUseRejectsForeignContextBeforeStore(t *testing.T) {
	h, s, peer, _ := combatFixture()
	h.Config.TalismanUses = []TalismanUseRule{{Item: 303002, ActiveCost: 100}}
	p := make([]byte, 75)
	protocol.WriteUint32(p, 0, 8292)
	protocol.WriteUint64(p, 4, s.UID)
	protocol.WriteUint64(p, 59, s.UID)
	protocol.WriteUint32(p, 39, 37)
	protocol.WriteUint32(p, 67, 1)
	protocol.WriteUint32(p, 71, 7)
	for _, change := range []func([]byte){
		func(b []byte) { protocol.WriteUint64(b, 4, peer.UID) },
		func(b []byte) { protocol.WriteUint64(b, 59, peer.UID) },
		func(b []byte) { protocol.WriteUint32(b, 67, 2) },
		func(b []byte) { protocol.WriteUint32(b, 71, 8) },
		func(b []byte) { protocol.WriteUint32(b, 39, 27) },
	} {
		b := append([]byte{}, p...)
		change(b)
		if h.route(s, s.game(), protocol.Message{ID: 8071, Payload: b}) == nil {
			t.Fatal("foreign event admitted")
		}
	}
	roomOutputs(t, peer)
	if err := h.route(s, s.game(), protocol.Message{ID: 4201, Payload: make([]byte, 8)}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s)
	h.Config.TalismanUses = nil
	if err := h.route(s, s.game(), protocol.Message{ID: 8071, Payload: p}); err != nil {
		t.Fatal(err)
	}
	if len(s.TalismanPending) != 0 {
		t.Fatal("unconfigured rule queued")
	}
}
