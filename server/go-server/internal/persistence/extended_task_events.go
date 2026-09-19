package persistence

import (
	"database/sql"
	"kungfu.local/server/internal/protocol"
)

// The caller holds the settlement and account locks. Do not start a second
// transaction: a later player's failure must roll back these counts too.
func advanceExtendedTaskBattleTx(tx *sql.Tx, reward BattleReward, players int) error {
	if reward.TaskClientHash == "" || reward.BattleMode == nil || *reward.BattleMode > 3 || players < 2 || (reward.Outcome != "win" && reward.Outcome != "loss" && reward.Outcome != "draw") {
		return nil
	}
	states, err := extendedTasksTx(tx, reward.UID, reward.TaskClientHash)
	if err != nil {
		return err
	}
	for _, state := range states {
		if !advanceExtendedTaskBattle(&state, reward.BattleMode, reward.Outcome, players) {
			continue
		}
		counts := make([]byte, 12)
		for i, count := range state.Counts {
			protocol.WriteUint32(counts, i*4, count)
		}
		if _, err = tx.Exec("UPDATE extended_task_progress SET state=?,counts=? WHERE uid=? AND task_key=? AND cycle=?", state.State, counts, reward.UID, state.Key, state.Cycle); err != nil {
			return err
		}
	}
	return nil
}

// Condition keys are local to a task (0 can mean a battle or a tutorial).
// Event bindings are explicit server policy, never inferred from that number.
func validExtendedTaskEvent(event string) bool {
	switch event {
	case "", "battle_play", "battle_win", "survival_solo_win", "survival_team_win", "deathmatch_solo_win", "deathmatch_team_win":
		return true
	case "survival_solo_play", "survival_team_play", "deathmatch_solo_play", "deathmatch_team_play":
		return true
	default:
		return false
	}
}

func advanceExtendedTaskBattle(state *ExtendedTaskState, mode *byte, outcome string, players int) bool {
	if state.State != 2 || mode == nil || *mode > 3 || players < 2 || players > 8 || (outcome != "win" && outcome != "loss" && outcome != "draw") || len(state.Snapshot.Template.Conditions) != 3 {
		return false
	}
	changed, complete, hasCondition := false, true, false
	wins := [4]string{"survival_solo_win", "survival_team_win", "deathmatch_solo_win", "deathmatch_team_win"}
	plays := [4]string{"survival_solo_play", "survival_team_play", "deathmatch_solo_play", "deathmatch_team_play"}
	for i, c := range state.Snapshot.Template.Conditions {
		if c.Required == 0 {
			continue
		}
		hasCondition = true
		if c.Event == "" || !validExtendedTaskEvent(c.Event) {
			complete = false
			continue
		}
		matches := c.Event == "battle_play" || c.Event == plays[*mode] || (outcome == "win" && (c.Event == "battle_win" || c.Event == wins[*mode]))
		if matches && state.Counts[i] < uint32(c.Required) {
			state.Counts[i]++
			changed = true
		}
		if state.Counts[i] < uint32(c.Required) {
			complete = false
		}
	}
	if hasCondition && complete {
		state.State = 4
		changed = true
	}
	return changed
}
