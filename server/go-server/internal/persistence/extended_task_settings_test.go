package persistence

import (
	"encoding/json"
	"reflect"
	"strings"
	"testing"
)

func extendedTaskFixture() *ExtendedTaskRules {
	return &ExtendedTaskRules{ClientHash: strings.Repeat("a", 64), Catalogue: []ExtendedTaskCatalogueEntry{{Kind: "newbie", ID: 3002, Conditions: []ExtendedTaskRequirement{{Key: 0, Required: 1}, {Key: 3, Required: 1}, {}}}}, Tasks: []ExtendedTaskRule{{Kind: "newbie", ID: 3002, Enabled: true, Experience: 50, Gold: 500}}}
}

func TestExtendedTaskPolicy(t *testing.T) {
	r := extendedTaskFixture()
	if err := r.Validate(); err != nil {
		t.Fatal(err)
	}
	a := TaskSettings{Rules: TaskRules{Extended: r}}
	data, err := json.Marshal(a)
	if err != nil {
		t.Fatal(err)
	}
	var restored TaskSettings
	if err = json.Unmarshal(data, &restored); err != nil || restored.Validate() != nil || !reflect.DeepEqual(a, restored) {
		t.Fatal(restored, err)
	}
	for _, mutate := range []func(*ExtendedTaskRules){
		func(r *ExtendedTaskRules) { r.Catalogue[0].Name = strings.Repeat("名", 129) },
		func(r *ExtendedTaskRules) { r.ClientHash = "" },
		func(r *ExtendedTaskRules) { r.ClientHash = strings.Repeat("A", 64) },
		func(r *ExtendedTaskRules) { r.Catalogue = nil },
		func(r *ExtendedTaskRules) { r.Catalogue[0].Kind = "daily" },
		func(r *ExtendedTaskRules) { r.Catalogue[0].Conditions = nil },
		func(r *ExtendedTaskRules) { r.Catalogue[0].Conditions[1].Key = 0 },
		func(r *ExtendedTaskRules) { r.Catalogue = append(r.Catalogue, r.Catalogue[0]) },
		func(r *ExtendedTaskRules) { r.Tasks[0].ID = 3003 },
		func(r *ExtendedTaskRules) { r.Tasks[0].Kind = "daily" },
		func(r *ExtendedTaskRules) { r.Tasks[0].Gold = 0x80000000 },
		func(r *ExtendedTaskRules) { r.Tasks = append(r.Tasks, r.Tasks[0]) },
		func(r *ExtendedTaskRules) { r.Catalogue[0].Conditions = make([]ExtendedTaskRequirement, 3) },
	} {
		r := extendedTaskFixture()
		mutate(r)
		if (TaskSettings{Rules: TaskRules{Extended: r}}).Validate() == nil {
			t.Fatal("invalid policy accepted", r)
		}
	}
	r.Tasks[0].Enabled = false
	if err := r.Validate(); err != nil || r.Tasks[0].Gold != 500 {
		t.Fatal("disabled draft lost", err)
	}
}
