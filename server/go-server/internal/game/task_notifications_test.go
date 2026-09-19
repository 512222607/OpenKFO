package game

import (
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestTaskCompletionMessages(t *testing.T) {
	hash := strings.Repeat("a", 64)
	profile := make([]byte, 360)
	profile[123] = 2
	protocol.WriteUint32(profile, 0, 77)
	a := persistence.TaskAwards{Keys: []uint16{1001, 1001, 1002, 1003}, Profile: profile, NotificationRules: persistence.TaskRules{ClientHash: hash, Catalogue: []persistence.TaskCatalogueEntry{{ID: 1001, Enabled: true, TitleLevel: 2}, {ID: 1002, Enabled: true, TitleLevel: 3}, {ID: 1003, Enabled: false}}}}
	rows := []protocol.TaskProgress{{Key: 1001, State: 3}, {Key: 1002, State: 3}, {Key: 1003, State: 3}}
	m := taskCompletionMessages(0x123456789, hash, a, rows)
	if len(m) != 1 || m[0].ID != 6030 || len(m[0].Payload) != 14 || protocol.ReadUint64(m[0].Payload, 0) != 0x123456789 || protocol.ReadUint32(m[0].Payload, 8) != 77 || protocol.ReadUint16(m[0].Payload, 12) != 1001 {
		t.Fatal(m)
	}
	if len(taskCompletionMessages(1, "wrong", a, rows)) != 0 || len(taskCompletionMessages(1, hash, a, nil)) != 0 {
		t.Fatal("unsafe notification")
	}
	a.Keys = nil
	if len(taskCompletionMessages(1, hash, a, rows)) != 0 {
		t.Fatal("repeat completion notification")
	}
}

func TestExtendedTaskCompletionMessages(t *testing.T) {
	daily := persistence.ExtendedTaskState{Key: 2001, State: 4, Cycle: "2026-09-19", Snapshot: persistence.ExtendedTaskSnapshot{ClientHash: strings.Repeat("a", 64), Rule: persistence.ExtendedTaskRule{Kind: "daily"}}}
	newbie := daily
	newbie.Key, newbie.Cycle, newbie.Snapshot.Rule.Kind = 3002, "", "newbie"
	pending := daily
	pending.Key, pending.State = 2002, 2
	claimed := daily
	claimed.Key, claimed.State = 2003, 3
	notified := map[uint16]string{}
	states := []persistence.ExtendedTaskState{daily, newbie, pending, claimed, daily}
	ms := extendedTaskCompletionMessages(states, notified)
	if len(ms) != 2 || ms[0].ID != 6031 || ms[1].ID != 6032 {
		t.Fatal(ms)
	}
	for i, key := range []uint16{2001, 3002} {
		if len(ms[i].Payload) != 3 || protocol.ReadUint16(ms[i].Payload, 0) != key || ms[i].Payload[2] != 4 {
			t.Fatal(ms[i])
		}
	}
	if len(extendedTaskCompletionMessages(states, notified)) != 0 {
		t.Fatal("duplicate notification")
	}
	daily.Cycle = "2026-09-20"
	if len(extendedTaskCompletionMessages([]persistence.ExtendedTaskState{daily}, notified)) != 1 {
		t.Fatal("new cycle suppressed")
	}
}

func TestTaskSuccessorMessages(t *testing.T) {
	hash := strings.Repeat("b", 64)
	rules := persistence.TaskRules{ClientHash: hash, Catalogue: []persistence.TaskCatalogueEntry{{ID: 1, Next: 2, Enabled: true}, {ID: 2, Enabled: true}}, Tasks: []persistence.TaskRule{{ID: 1, Next: 2, Enabled: true, Matches: 1, Counters: make([]uint32, 29)}, {ID: 2, Enabled: true, Matches: 1, Counters: make([]uint32, 29)}}}
	a := persistence.TaskAwards{Keys: []uint16{1, 1}, NotificationRules: rules}
	rows := []protocol.TaskProgress{{Key: 1, State: 3}, {Key: 2, State: 1, Unknown0: 77}}
	ms := taskSuccessorMessages(hash, a, rows)
	if len(ms) != 1 || ms[0].ID != 6040 || len(ms[0].Payload) != 6 || protocol.ReadUint16(ms[0].Payload, 4) != 2 || protocol.ReadUint32(ms[0].Payload, 0) != 77 {
		t.Fatal(ms)
	}
	rows[1].State = 2
	if len(taskSuccessorMessages(hash, a, rows)) != 0 {
		t.Fatal("accepted task reset")
	}
	rows[1].State = 1
	if len(taskSuccessorMessages("wrong", a, rows)) != 0 {
		t.Fatal("wrong client accepted")
	}
	a.NotificationRules.Catalogue[0].Next = 0
	if len(taskSuccessorMessages(hash, a, rows)) != 0 {
		t.Fatal("mismatched successor accepted")
	}
}
