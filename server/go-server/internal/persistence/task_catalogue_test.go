package persistence

import (
	"strings"
	"testing"
)

func TestTaskCatalogueNotificationGate(t *testing.T) {
	hash := strings.Repeat("a", 64)
	r := TaskRules{ClientHash: hash, Catalogue: []TaskCatalogueEntry{{ID: 1001, Next: 1002, TitleLevel: 2, Enabled: true}, {ID: 1002, TitleLevel: 3, Enabled: false}}}
	if err := (TaskSettings{Rules: r}).Validate(); err != nil {
		t.Fatal(err)
	}
	if !r.CanNotifyCompletion(hash, 1001, 2) || !r.CanNotifyCompletion(hash, 1001, 3) {
		t.Fatal("valid template denied")
	}
	for _, c := range []struct {
		hash  string
		key   uint16
		title byte
	}{{"", 1001, 2}, {strings.Repeat("b", 64), 1001, 2}, {hash, 1001, 1}, {hash, 1002, 3}, {hash, 9999, 255}} {
		if r.CanNotifyCompletion(c.hash, c.key, c.title) {
			t.Fatal("unsafe notification accepted", c)
		}
	}
	for _, mutate := range []func(*TaskRules){func(x *TaskRules) { x.ClientHash = "" }, func(x *TaskRules) { x.ClientHash = strings.ToUpper(hash) }, func(x *TaskRules) { x.Catalogue = nil }, func(x *TaskRules) { x.Catalogue[0].TitleLevel = 256 }, func(x *TaskRules) { x.Catalogue[0].ID = 0 }, func(x *TaskRules) { x.Catalogue[1].ID = 1001 }, func(x *TaskRules) { x.Catalogue[0].Next = 1003 }} {
		copyRules := r
		copyRules.Catalogue = append([]TaskCatalogueEntry(nil), r.Catalogue...)
		mutate(&copyRules)
		if (TaskSettings{Rules: copyRules}).Validate() == nil || copyRules.CanNotifyCompletion(hash, 1001, 255) {
			t.Fatal("bad catalogue accepted", copyRules)
		}
	}
	if (TaskRules{}).CanNotifyCompletion(hash, 1001, 255) {
		t.Fatal("unbound template accepted")
	}
}
