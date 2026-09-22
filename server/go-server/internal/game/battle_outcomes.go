package game

import "kungfu.local/server/internal/protocol"

// Local settlement policy, not a claim to reproduce the original server economy.
// Survival uses agreement on alive/dead; deathmatch uses agreed low-byte kill
// counters from native 987E40. Never use HP to rank a score-based match.
func battleOutcomes(r *Room) map[uint64]string {
	result := map[uint64]string{}
	groups := map[uint64]uint64{}
	for uid, m := range r.Members {
		if !m.Spectator {
			result[uid] = "unconfirmed"
			groups[uid] = uid
			if r.Type().IsTeam() {
				groups[uid] = uint64(m.Team)
			}
		}
	}
	if len(r.Reports) != len(result) {
		return result
	}
	var base map[uint64]protocol.BattleReportRecord
	rebornMode := r.Type() == protocol.RebornMode
	scoreMode := r.Type() == protocol.SoloDeathmatch || r.Type() == protocol.TeamDeathmatch || rebornMode
	for uid, p := range r.Reports {
		if _, ok := result[uid]; !ok {
			return result
		}
		if _, err := validateBattleReport(r, p); err != nil {
			return result
		}
		rows, _ := protocol.ParseBattleReport(p)
		current := map[uint64]protocol.BattleReportRecord{}
		for _, row := range rows {
			if _, ok := result[row.UID]; ok {
				current[row.UID] = row
			}
		}
		if base == nil {
			base = current
			continue
		}
		for uid, row := range current {
			previous := base[uid]
			if rebornMode {
				if row.RebornPoints != previous.RebornPoints || row.RebornCounts != previous.RebornCounts {
					return result
				}
			} else if scoreMode {
				if row.EnemyKills != previous.EnemyKills || row.PenaltyKills != previous.PenaltyKills {
					return result
				}
			} else if (row.Health == 0) != (previous.Health == 0) {
				return result
			}
		}
	}
	if len(base) == 0 {
		return result
	}
	winners := map[uint64]bool{}
	if scoreMode {
		scores := map[uint64]int{}
		for uid, row := range base {
			scores[groups[uid]] = 0
			if rebornMode {
				scores[uid] = int(row.RebornPoints)
			} else if !r.Type().IsTeam() {
				scores[uid] = int(row.EnemyKills) - int(row.PenaltyKills)
			}
		}
		if r.Type() == protocol.TeamDeathmatch {
			for group := range scores {
				for uid, row := range base {
					if groups[uid] == group {
						scores[group] += int(row.EnemyKills)
					} else {
						scores[group] += int(row.PenaltyKills)
					}
				}
			}
		}
		highest := int(-1 << 31)
		for group, score := range scores {
			if score > highest {
				highest = score
				winners = map[uint64]bool{group: true}
			} else if score == highest {
				winners[group] = true
			}
		}
	} else {
		for uid, row := range base {
			if row.Health > 0 {
				winners[groups[uid]] = true
			}
		}
	}
	for uid := range result {
		result[uid] = "draw"
		if len(winners) == 1 {
			result[uid] = "loss"
			if winners[groups[uid]] {
				result[uid] = "win"
			}
		}
	}
	return result
}
