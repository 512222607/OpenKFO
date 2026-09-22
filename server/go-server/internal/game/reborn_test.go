package game

import (
	"bytes"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestRebornAdmissionRequiresOptInAndPool(t *testing.T) {
	h, a, _, _ := waitingRoomFixture()
	p := bytes.Clone(a.Room.Request)
	p[46] = byte(protocol.RebornMode)
	allows := func(uint32) bool { return true }
	if _, err := h.resolveWithAllowed(p, allows); err == nil {
		t.Fatal("enabled without opt-in")
	}
	h.Config.RebornEnabled = true
	if _, err := h.resolveWithAllowed(p, allows); err == nil {
		t.Fatal("enabled without map pool")
	}
	h.Config.Pools["16:4"] = []uint32{804}
	if _, err := h.resolveWithAllowed(p, allows); err != nil {
		t.Fatal(err)
	}
	p[37] = 8
	h.Config.Pools["16:8"] = []uint32{804}
	if _, err := h.resolveWithAllowed(p, allows); err == nil {
		t.Fatal("native six-row limit exceeded")
	}
}
func TestRebornConsensusAndResultFields(t *testing.T) {
	_, a, b, _ := combatFixture()
	r := a.Room
	r.Request[46] = byte(protocol.RebornMode)
	p := settlementReport(r)
	protocol.WriteUint32(p, 37, uint32(2))
	protocol.WriteUint32(p, 87+37, uint32(9))
	protocol.WriteUint16(p, 87+45, 12)
	protocol.WriteUint16(p, 87+47, 3)
	protocol.WriteUint16(p, 87+4, 456)
	protocol.WriteUint16(p, 87+6, 123)
	r.Reports = map[uint64][]byte{a.UID: bytes.Clone(p), b.UID: bytes.Clone(p)}
	out := battleOutcomes(r)
	if out[a.UID] != "loss" || out[b.UID] != "win" {
		t.Fatal("HP used instead of points", out)
	}
	rewards := []persistence.BattleReward{{UID: a.UID, Profile: make([]byte, 360)}, {UID: b.UID, Profile: make([]byte, 360)}}
	result := settlementPacket(r, rewards, b.UID).Payload
	for i := 0; i < len(result); i += 500 {
		row := result[i : i+500]
		if protocol.ReadUint64(row, 0) == b.UID && (protocol.ReadUint32(row, 67) != 9 || protocol.ReadUint16(row, 71) != 12 || protocol.ReadUint16(row, 73) != 3 || protocol.ReadUint32(row, 75) != 456 || protocol.ReadUint32(row, 79) != 123 || protocol.ReadUint32(row, 83) != 1) {
			t.Fatal("native result fields")
		}
	}
	protocol.WriteUint16(r.Reports[b.UID], 87+45, 13)
	out = battleOutcomes(r)
	if out[a.UID] != "unconfirmed" || out[b.UID] != "unconfirmed" {
		t.Fatal("disagreement rewarded", out)
	}
	for _, raw := range r.Reports {
		protocol.WriteUint16(raw, 87+45, 12)
		protocol.WriteUint32(raw, 37, 0x80000000)
		protocol.WriteUint32(raw, 87+37, 0x80000001)
	}
	out = battleOutcomes(r)
	if out[b.UID] != "win" {
		t.Fatal("signed point comparison", out)
	}
}
func TestRebornEventAuthorityAndValues(t *testing.T) {
	for _, tc := range []struct {
		code, value uint32
		valid       bool
	}{{0, 0, true}, {2, 0, true}, {3, 3, true}, {4, 4, true}, {5, 65535, true}, {6, 3, true}, {7, 4, true}, {1, 1, false}, {5, 65536, false}, {7, 3, false}, {8, 0, false}} {
		h, a, b, _ := combatFixture()
		a.Room.Request[46] = byte(protocol.RebornMode)
		m := extendedPacket(protocol.BattleEventReborn, 55, a.UID, b.UID, 0)
		protocol.WriteUint32(m.Payload, 47, tc.code)
		protocol.WriteUint32(m.Payload, 51, tc.value)
		if err := h.battleMessage(a, a.game(), m); err != nil {
			t.Fatal(err)
		}
		if tc.valid {
			roomOutputs(t, b, 8071)
		} else {
			roomOutputs(t, b)
		}
		if err := h.battleMessage(a, a.game(), m); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, b)
		protocol.WriteUint64(m.Payload, 4, b.UID)
		if err := h.battleMessage(b, b.game(), m); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, a)
	}
}
