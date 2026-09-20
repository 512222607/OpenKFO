package game

import "kungfu.local/server/internal/protocol"

// The native event group ends when its list is exhausted and no living monster
// remains; corpse destruction follows later. Reconcile receipts without requiring
// the final corpse timer or treating an arbitrary 20401 as a kill. This is a
// necessary consistency check, not native script execution or payout authority.
func (r *Room) fosterReceiptsComplete() bool {
	plan := r.FosterPlan
	if r.Type() != protocol.FosterMode || !r.FosterFinishReported || plan == nil || len(plan.Groups) == 0 ||
		len(r.FosterSpawned) != len(plan.Groups) || len(r.FosterRetired) != len(plan.Groups) {
		return false
	}
	accounted := append([]int(nil), r.FosterRetired...)
	for _, actor := range r.PVEActors {
		if !actor.active {
			continue
		}
		if actor.maximumHP <= 0 || actor.reportedHP != 0 || actor.fosterGroup < 0 || actor.fosterGroup >= len(accounted) {
			return false
		}
		accounted[actor.fosterGroup]++
	}
	for i, group := range plan.Groups {
		if len(group.Spawns) == 0 || r.FosterSpawned[i] != len(group.Spawns) || r.FosterRetired[i] < 0 || accounted[i] != len(group.Spawns) {
			return false
		}
	}
	return true
}
