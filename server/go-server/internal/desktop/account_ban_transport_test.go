package desktop

import (
	"encoding/json"
	"kungfu.local/server/internal/persistence"
	"testing"
)

func TestAccountBanTransport(t *testing.T) {
	for _, tc := range []struct {
		name    string
		enabled bool
		expiry  int64
	}{
		{"timed", true, 2000000000}, {"permanent", true, 0}, {"unban", false, 0},
	} {
		t.Run(tc.name, func(t *testing.T) {
			calls := 0
			a := &Admin{Remote: func(r persistence.AdminRequest) (json.RawMessage, error) {
				calls++
				if r.Enabled != tc.enabled || r.ExpiresAt == nil || *r.ExpiresAt != tc.expiry || r.UID != 42 || r.Reason != "test" || r.ID != "ban-test" {
					t.Fatalf("fields lost: %+v", r)
				}
				return json.RawMessage(`{}`), nil
			}}
			if _, err := a.Call(Request{Environment: "online", Operation: "user_ban_save", UID: 42, ID: "ban-test", Reason: "test", Enabled: &tc.enabled, ExpiresAt: &tc.expiry}); err != nil {
				t.Fatal(err)
			}
			if calls != 1 {
				t.Fatal("not forwarded")
			}
		})
	}
	a := &Admin{Remote: func(persistence.AdminRequest) (json.RawMessage, error) {
		t.Fatal("missing action forwarded")
		return nil, nil
	}}
	if _, err := a.Call(Request{Environment: "online", Operation: "user_ban_save"}); err == nil {
		t.Fatal("missing action accepted")
	}
}
