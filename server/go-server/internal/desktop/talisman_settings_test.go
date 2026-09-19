package desktop

import (
	"encoding/json"
	"kungfu.local/server/internal/persistence"
	"testing"
)

func TestTalismanSettingsManagementTransport(t *testing.T) {
	var req Request
	if err := json.Unmarshal([]byte(`{"environment":"online","operation":"talisman_settings_save","talisman_settings":{"revision":7,"rules":{"enabled":false,"uses":[{"item":303002,"active_cost":50,"passive_cost":300}]}}}`), &req); err != nil {
		t.Fatal(err)
	}
	calls := 0
	a := &Admin{Remote: func(r persistence.AdminRequest) (json.RawMessage, error) {
		calls++
		if r.Operation != "talisman_settings_save" || r.TalismanSettings == nil || r.TalismanSettings.Revision != 7 || len(r.TalismanSettings.Rules.Uses) != 1 || r.TalismanSettings.Rules.Uses[0].ActiveCost != 50 || r.TalismanSettings.Rules.Uses[0].PassiveCost != 300 {
			t.Fatalf("lost weapon fields: %+v", r)
		}
		if err := r.TalismanSettings.Validate(); err != nil {
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
