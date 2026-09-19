package desktop

import (
	"encoding/json"
	"kungfu.local/server/internal/persistence"
	"testing"
)

func TestTrainingManagementTransport(t *testing.T) {
	var req Request
	// The Flutter editor sends numeric mode IDs. Go's []byte must accept these,
	// even though responses encode this existing field as base64.
	if err := json.Unmarshal([]byte(`{"environment":"online","operation":"training_save","training":{"revision":7,"rules":{"enabled":false,"levels":[{"level":0,"xp_per_hour":50,"xp_cap":300}]}}}`), &req); err != nil {
		t.Fatal(err)
	}
	calls := 0
	a := &Admin{Remote: func(r persistence.AdminRequest) (json.RawMessage, error) {
		calls++
		if r.Operation != "training_save" || r.Training == nil || r.Training.Revision != 7 || len(r.Training.Rules.Levels) != 1 || r.Training.Rules.Levels[0].XPPerHour != 50 || r.Training.Rules.Levels[0].XPCap != 300 {
			t.Fatalf("lost honour fields: %+v", r)
		}
		if err := r.Training.Validate(); err != nil {
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
