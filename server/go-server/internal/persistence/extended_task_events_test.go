package persistence

import "testing"

func TestExtendedTaskBattleEvents(t *testing.T) {
	makeState := func(event string) ExtendedTaskState {
		return ExtendedTaskState{State: 2, Snapshot: ExtendedTaskSnapshot{Template: ExtendedTaskCatalogueEntry{Conditions: []ExtendedTaskRequirement{{Key: 0, Required: 2, Event: event}, {}, {}}}}}
	}
	for mode := byte(0); mode < 4; mode++ {
		for _, outcome := range []string{"win", "loss", "draw"} {
			for _, event := range []string{"battle_play", "battle_win", "survival_solo_win", "survival_team_win", "deathmatch_solo_win", "deathmatch_team_win", "survival_solo_play", "survival_team_play", "deathmatch_solo_play", "deathmatch_team_play"} {
				s := makeState(event)
				matched := event == "battle_play" || event == [4]string{"survival_solo_play", "survival_team_play", "deathmatch_solo_play", "deathmatch_team_play"}[mode] || outcome == "win" && (event == "battle_win" || event == [4]string{"survival_solo_win", "survival_team_win", "deathmatch_solo_win", "deathmatch_team_win"}[mode])
				if changed := advanceExtendedTaskBattle(&s, &mode, outcome, 2); changed != matched || (s.Counts[0] == 1) != matched || s.State != 2 {
					t.Fatal(mode, outcome, event, s)
				}
				if matched {
					advanceExtendedTaskBattle(&s, &mode, outcome, 2)
					if s.State != 4 || s.Counts[0] != 2 {
						t.Fatal(s)
					}
					if advanceExtendedTaskBattle(&s, &mode, outcome, 2) {
						t.Fatal("advanced completed task")
					}
				}
			}
		}
	}
	mode := byte(0)
	for _, state := range []byte{1, 3, 4} {
		s := makeState("battle_play")
		s.State = state
		if advanceExtendedTaskBattle(&s, &mode, "win", 2) {
			t.Fatal("wrong state")
		}
	}
	for _, event := range []string{"", "client_complete", "training_pass"} {
		s := makeState(event)
		s.Counts[0] = 2
		if advanceExtendedTaskBattle(&s, &mode, "win", 2) || s.State != 2 {
			t.Fatal("unsupported completed", event)
		}
	}
	for _, players := range []int{0, 1, 9} {
		s := makeState("battle_play")
		if advanceExtendedTaskBattle(&s, &mode, "win", players) {
			t.Fatal("bad player count")
		}
	}
	s := makeState("battle_play")
	if advanceExtendedTaskBattle(&s, nil, "win", 2) || advanceExtendedTaskBattle(&s, &mode, "unknown", 2) {
		t.Fatal("invalid battle")
	}
	mode = 5
	if advanceExtendedTaskBattle(&s, &mode, "win", 2) {
		t.Fatal("training counted")
	}
	s = makeState("battle_play")
	s.Snapshot.Template.Conditions[1] = ExtendedTaskRequirement{Key: 3, Required: 1}
	mode = 0
	advanceExtendedTaskBattle(&s, &mode, "win", 2)
	advanceExtendedTaskBattle(&s, &mode, "win", 2)
	if s.State != 2 || s.Counts[1] != 0 {
		t.Fatal("unbound condition bypassed")
	}
}
