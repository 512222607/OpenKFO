package adminhttp

import (
	"kungfu.local/server/internal/desktop"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestStageUnlockManagementAuthorization(t *testing.T) {
	token := strings.Repeat("s", 32)
	calls := 0
	handler := New(token, func(r desktop.Request) (any, error) {
		calls++
		if r.UID != 17 || r.StageUnlocks == nil || r.StageUnlocks.UID != 17 || r.StageUnlocks.Revision != 4 || r.StageUnlocks.ClientHash != strings.Repeat("a", 64) || len(r.StageUnlocks.Maps) != 1 || r.StageUnlocks.Maps[0] != 8110 {
			t.Fatalf("unlock fields lost: %+v", r)
		}
		return r.StageUnlocks, nil
	})
	for _, tc := range []struct {
		environment, auth string
		status            int
	}{{"online", "", 401}, {"local", "Bearer " + token, 403}, {"online", "Bearer " + token, 200}} {
		body := `{"gm_version":"1.1.0","operation":"stage_unlocks_save","environment":"` + tc.environment + `","uid":17,"stage_unlocks":{"uid":17,"revision":4,"client_hash":"` + strings.Repeat("a", 64) + `","maps":[8110]}}`
		r := httptest.NewRequest("POST", "/gm/api", strings.NewReader(body))
		r.Header.Set("Authorization", tc.auth)
		w := httptest.NewRecorder()
		handler.ServeHTTP(w, r)
		if w.Code != tc.status {
			t.Fatalf("got %d want %d", w.Code, tc.status)
		}
	}
	if calls != 1 {
		t.Fatal("unauthorized invocation", calls)
	}
}
