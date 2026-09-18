package adminhttp

import (
	"kungfu.local/server/internal/desktop"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestAuthorizationAndOnlineScope(t *testing.T) {
	token := strings.Repeat("x", 32)
	calls := 0
	handler := New(token, func(r desktop.Request) (any, error) { calls++; return map[string]any{"saved": true}, nil })
	for _, tc := range []struct {
		body, auth string
		status     int
	}{
		{`{"operation":"rewards_get","environment":"online"}`, "", 401},
		{`{"operation":"rewards_get","environment":"local"}`, "Bearer " + token, 403},
		{`{"operation":"weapon_apply","environment":"online"}`, "Bearer " + token, 403},
		{`{"operation":"rewards_get","environment":"online"} {}`, "Bearer " + token, 400},
		{`{"operation":"rewards_get","environment":"online"}`, "Bearer " + token, 200},
	} {
		r := httptest.NewRequest("POST", "/gm/api", strings.NewReader(tc.body))
		r.Header.Set("Authorization", tc.auth)
		w := httptest.NewRecorder()
		handler.ServeHTTP(w, r)
		if w.Code != tc.status {
			t.Fatalf("status=%d want=%d", w.Code, tc.status)
		}
	}
	if calls != 1 {
		t.Fatalf("unauthorized calls=%d", calls)
	}
}
