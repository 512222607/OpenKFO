package game

import (
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestStageAccessSelection(t *testing.T) {
	h := NewHub(nil, Config{Pools: map[string][]uint32{"0:2": {101, 102}}})
	p := make([]byte, 81)
	p[37] = 2
	a := persistence.StageAccess{Disabled: []uint32{101}}
	r, e := h.resolveWithAccess(p, a)
	if e != nil || protocol.ReadUint32(r, 38) != 102 {
		t.Fatal("random selected closed map", e)
	}
	protocol.WriteUint32(p, 38, 101)
	if _, e = h.resolveWithAccess(p, a); e == nil {
		t.Fatal("explicit closed map accepted")
	}
	protocol.WriteUint32(p, 38, 0)
	a.Disabled = append(a.Disabled, 102)
	if _, e = h.resolveWithAccess(p, a); e == nil {
		t.Fatal("empty enabled pool accepted")
	}
	protocol.WriteUint32(p, 38, 103)
	if _, e = h.resolveWithAccess(p, persistence.StageAccess{}); e == nil {
		t.Fatal("switch unlocked unsupported map")
	}
}

func TestStageExplicitOpenOutsideOriginalPool(t *testing.T) {
	hash := "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
	h := NewHub(nil, Config{ConfigHash: hash, Pools: map[string][]uint32{"0:2": {101}}})
	a := persistence.StageAccess{ClientHash: hash, ForceOpenAll: true, Requirements: []persistence.StageTitleRequirement{{MapID: 999, Name: "Configured stage"}}}
	p := make([]byte, 81)
	p[37] = 2
	protocol.WriteUint32(p, 38, 999)
	r, e := h.resolveWithAccess(p, a)
	if e != nil || protocol.ReadUint32(r, 42) != 999 {
		t.Fatal("explicit map not resolved", e)
	}
	protocol.WriteUint32(p, 42, 101)
	if _, e = h.resolveWithAccess(p, a); e == nil {
		t.Fatal("contradicting map accepted")
	}
	protocol.WriteUint32(p, 42, 0)
	p[46] = 4
	if _, e = h.resolveWithAccess(p, a); e == nil {
		t.Fatal("override bypassed game-mode validation")
	}
	p[46] = 0
	a.Disabled = []uint32{999}
	if _, e = h.resolveWithAccess(p, a); e == nil {
		t.Fatal("override bypassed closed map")
	}
}
