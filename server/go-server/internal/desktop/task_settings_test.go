package desktop

import (
	"encoding/json"
	"kungfu.local/server/internal/persistence"
	"testing"
)

func TestTaskManagementTransport(t *testing.T) {
	var req Request
	if err := json.Unmarshal([]byte(`{"environment":"online","operation":"tasks_save","tasks":{"revision":7,"rules":{"enabled":false,"tasks":[{"id":1001,"matches":10,"counters":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}]}}}`), &req); err != nil {
		t.Fatal(err)
	}
	calls := 0
	a := &Admin{Remote: func(r persistence.AdminRequest) (json.RawMessage, error) {
		calls++
		if r.Operation != "tasks_save" || r.Tasks == nil || r.Tasks.Revision != 7 || len(r.Tasks.Rules.Tasks) != 1 || r.Tasks.Rules.Tasks[0].Matches != 10 {
			t.Fatalf("lost task fields: %+v", r)
		}
		if err := r.Tasks.Validate(); err != nil {
			t.Fatal(err)
		}
		return json.RawMessage(`{"revision":8}`), nil
	}}
	if _, err := a.Call(req); err != nil {
		t.Fatal(err)
	}
	if calls != 1 {
		t.Fatal(calls)
	}
}
