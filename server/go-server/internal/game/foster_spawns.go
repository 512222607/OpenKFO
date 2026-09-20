package game

import "kungfu.local/server/internal/protocol"

// Each event group advances independently. Match the complete native spawn
// literal; template counts alone would permit skipping ahead to the boss.
// This does not infer death from a removal or verify group trigger timing.
func (r *Room) fosterSpawnGroup(event protocol.PVEActorCreate) int {
	plan := r.FosterPlan
	if plan == nil || len(r.FosterSpawned) != len(plan.Groups) {
		return -1
	}
	active := uint32(0)
	living := make([]uint32, len(plan.Groups))
	for _, actor := range r.PVEActors {
		if actor.active {
			active++ // Includes corpses until native 20401 destruction.
			if actor.fosterGroup < 0 || actor.fosterGroup >= len(living) {
				return -1
			}
			// The Lua sub-list counts living monsters only. Unknown template
			// health must not create spare capacity by looking like a corpse.
			if actor.maximumHP <= 0 || actor.reportedHP != 0 {
				living[actor.fosterGroup]++
			}
		}
	}
	if active >= plan.GlobalLimit {
		return -1
	}
	matched := -1
	for i, group := range plan.Groups {
		if living[i] >= group.SubLimit || living[i] >= group.GroupLimit {
			continue
		}
		next := r.FosterSpawned[i]
		if next < 0 || next >= len(group.Spawns) {
			continue
		}
		spawn := group.Spawns[next]
		if spawn.Template == event.TemplateValue && spawn.Position == event.Position && spawn.Direction == event.DirectionValue {
			if matched != -1 {
				return -1 // Ambiguous plans need native group evidence, not a guess.
			}
			matched = i
		}
	}
	return matched
}
