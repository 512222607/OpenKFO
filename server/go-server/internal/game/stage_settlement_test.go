package game

import (
	"bytes"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestStageFinishRequiresServerProgress(t *testing.T) {
	h, owner, peer, outsider := combatFixture()
	r := owner.Room
	r.Request[46] = byte(protocol.StageAssault)
	r.StageWaves, _ = newStageWaves([]StageWavePlan{{Monsters: map[uint32]uint32{7: 1}}})
	p := settlementReport(r)
	for _, m := range r.Members {
		protocol.WriteUint16(p, int(m.Slot)*87+65, uint16(protocol.StageFinishWaves))
	}
	if out, err := validateStageFinish(r, p); err != nil || out != "" {
		t.Fatal("early clear accepted", out, err)
	}
	r.StageWaves.finished = true
	r.StageWaves.index = 1
	r.PVEActors = map[uint64]pveActor{42: {active: true}}
	if out, _ := validateStageFinish(r, p); out != "" {
		t.Fatal("living actor allowed clear")
	}
	r.PVEActors[42] = pveActor{active: false}
	if out, err := validateStageFinish(r, p); err != nil || out != persistence.StageOutcomeClear {
		t.Fatal("completed wave rejected", out, err)
	}
	if err := h.settleReport(peer, p); err != nil || r.Stage != "battle" {
		t.Fatal("peer changed finish", err)
	}
	bad := bytes.Clone(p)
	protocol.WriteUint32(bad, 71, r.Serial+1)
	if _, err := validateStageFinish(r, bad); err == nil {
		t.Fatal("stale report accepted")
	}
	if err := h.route(owner, owner.game(), protocol.Message{ID: 4110, Payload: p}); err != nil {
		t.Fatal(err)
	}
	if r.Stage != "finishing" || !bytes.Equal(r.Reports[owner.UID], p) {
		t.Fatal("controller report not recorded")
	}
	p[0] ^= 1
	if bytes.Equal(r.Reports[owner.UID], p) {
		t.Fatal("stored report aliases input")
	}
	if err := h.settleReport(owner, p); err != nil {
		t.Fatal(err)
	}
	if bytes.Equal(r.Reports[owner.UID], p) {
		t.Fatal("retry replaced committed finish")
	}
	roomOutputs(t, owner)
	roomOutputs(t, peer)
	roomOutputs(t, outsider)
}

func TestStageFailureDoesNotInferUnknownReasons(t *testing.T) {
	_, owner, _, _ := combatFixture()
	r := owner.Room
	r.Request[46] = byte(protocol.StageAssault)
	r.StageWaves, _ = newStageWaves([]StageWavePlan{{Monsters: map[uint32]uint32{7: 1}}})
	p := settlementReport(r)
	for _, m := range r.Members {
		protocol.WriteUint16(p, int(m.Slot)*87+65, 2)
	}
	if out, _ := validateStageFinish(r, p); out != "" {
		t.Fatal("live player marked failed")
	}
	for _, m := range r.Members {
		protocol.WriteUint16(p, int(m.Slot)*87+2, 0)
	}
	if out, err := validateStageFinish(r, p); err != nil || out != persistence.StageOutcomeFailed {
		t.Fatal(out, err)
	}
	for _, m := range r.Members {
		protocol.WriteUint16(p, int(m.Slot)*87+65, 3)
	}
	if out, _ := validateStageFinish(r, p); out != "" {
		t.Fatal("unknown counter reason invented failure")
	}
}
