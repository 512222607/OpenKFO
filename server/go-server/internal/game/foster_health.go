package game

import (
	"log"

	"kungfu.local/server/internal/protocol"
)

// Called only after room/authentication/context/finite-value checks and event
// deduplication. Native 9E46B0 clamps damage at zero; 9E4740 caps healing at max.
// Source-side effects (9C5E40) send their own 8121; never apply them twice here.
// Native local callbacks and unreceived events can diverge from this projection,
// so neither corpse removal nor this value authorizes progress or rewards.
func (r *Room) trackFosterHealth(payload []byte) {
	if r.Type() != protocol.FosterMode {
		return
	}
	event, err := protocol.ParseBattleHealth(payload)
	if err != nil {
		return
	}
	actor := r.PVEActors[event.Target]
	if !actor.active || actor.maximumHP <= 0 {
		return
	}
	before := actor.reportedHP
	actor.reportedHP = min(actor.maximumHP, max(float32(0), before-event.Damage))
	r.PVEActors[event.Target] = actor
	log.Printf("怪物血量（按收包累计，非通关依据） foster_health room=%d serial=%d sender=%d target=%d source=%d amount=%g hp_before=%g hp_after=%g max_hp=%g basis=received_events",
		r.ID, r.Serial, event.Sender, event.Target, event.Source, event.Damage, before, actor.reportedHP, actor.maximumHP)
}
