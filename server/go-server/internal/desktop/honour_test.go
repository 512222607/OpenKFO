package desktop

import (
	"encoding/json"
	"kungfu.local/server/internal/persistence"
	"testing"
)

func TestHonourManagementTransport(t *testing.T) {
	var req Request
	// The Flutter editor sends numeric mode IDs. Go's []byte must accept these,
	// even though responses encode this existing field as base64.
	if err := json.Unmarshal([]byte(`{"environment":"online","operation":"honour_save","honour":{"revision":7,"rules":{"periods":["第一期"],"modes":[0,1],"win_points":50,"level_points":[100,300]}}}`), &req); err != nil {
		t.Fatal(err)
	}
	calls := 0
	a := &Admin{Remote: func(r persistence.AdminRequest) (json.RawMessage, error) {
		calls++
		if r.Operation != "honour_save" || r.Honour == nil || r.Honour.Revision != 7 || r.Honour.Rules.Win != 50 || len(r.Honour.Rules.Modes) != 2 || r.Honour.Rules.Modes[1] != 1 {
			t.Fatalf("lost honour fields: %+v", r)
		}
		if err := r.Honour.Rules.Validate(); err != nil {
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
