package desktop

import (
	"encoding/json"
	"kungfu.local/server/internal/persistence"
	"testing"
)

func TestTitleManagementTransport(t *testing.T) {
	var req Request
	if err := json.Unmarshal([]byte(`{"environment":"online","operation":"titles_save","titles":{"revision":7,"rules":{"enabled":false,"titles":[{"level":1,"matches":10,"choices":[7]}]}}}`), &req); err != nil {
		t.Fatal(err)
	}
	calls := 0
	a := &Admin{Remote: func(r persistence.AdminRequest) (json.RawMessage, error) {
		calls++
		if r.Operation != "titles_save" || r.Titles == nil || r.Titles.Revision != 7 || len(r.Titles.Rules.Titles) != 1 || r.Titles.Rules.Titles[0].Matches != 10 {
			t.Fatalf("lost task fields: %+v", r)
		}
		if err := r.Titles.Validate(); err != nil {
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
