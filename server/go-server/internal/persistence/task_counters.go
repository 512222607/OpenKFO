package persistence

import "kungfu.local/server/internal/protocol"

// Native BaseQuest totals profile+133/+141/+149/+157. mapselect modes
// 0..3 map to survival solo/team and deathmatch solo/team respectively.
// Call only within the persisted settlement transaction, after replay lookup.
func addTaskBattleCounters(profile []byte, mode *byte, outcome string, players int) {
	if len(profile) != 360 || mode == nil || *mode > 3 || players < 2 || (outcome != "win" && outcome != "loss" && outcome != "draw") {
		return
	}
	offset := 133 + int(*mode)*8
	increment := func(at int) {
		value := protocol.ReadUint32(profile, at)
		// Never wrap counters or rewrite an existing out-of-range value.
		if value < 0x7fffffff {
			protocol.WriteUint32(profile, at, value+1)
		}
	}
	increment(offset)
	if outcome == "win" {
		increment(offset + 4)
	}
}
