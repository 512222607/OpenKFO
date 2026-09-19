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
		{`{"operation":"inventory_expiry","environment":"online"}`, "", 401},
		{`{"operation":"inventory_expiry","environment":"local"}`, "Bearer " + token, 403},
		{`{"operation":"inventory_expiry","environment":"online"}`, "Bearer " + token, 200},
		{`{"operation":"vip_grant","environment":"online"}`, "", 401},
		{`{"operation":"vip_grant","environment":"local"}`, "Bearer " + token, 403},
		{`{"operation":"vip_grant","environment":"online"}`, "Bearer " + token, 200},
	} {
		r := httptest.NewRequest("POST", "/gm/api", strings.NewReader(tc.body))
		r.Header.Set("Authorization", tc.auth)
		w := httptest.NewRecorder()
		handler.ServeHTTP(w, r)
		if w.Code != tc.status {
			t.Fatalf("status=%d want=%d", w.Code, tc.status)
		}
	}
	if calls != 3 {
		t.Fatalf("unauthorized calls=%d", calls)
	}
}

func TestStageManagementAuthorizationAndPayload(t *testing.T) {
	token := strings.Repeat("s", 32)
	calls := 0
	handler := New(token, func(r desktop.Request) (any, error) {
		calls++
		if r.Operation != "stages_save" || r.StageAccess == nil || r.StageAccess.Revision != 7 || len(r.StageAccess.Disabled) != 1 || r.StageAccess.Disabled[0] != 8110 {
			t.Fatalf("stage configuration lost in transport: %+v", r)
		}
		return r.StageAccess, nil
	})
	for _, tc := range []struct {
		env, auth string
		status    int
	}{
		{"online", "", 401}, {"local", "Bearer " + token, 403}, {"online", "Bearer " + token, 200},
	} {
		r := httptest.NewRequest("POST", "/gm/api", strings.NewReader(`{"operation":"stages_save","environment":"`+tc.env+`","stage_access":{"revision":7,"disabled_maps":[8110]}}`))
		r.Header.Set("Authorization", tc.auth)
		w := httptest.NewRecorder()
		handler.ServeHTTP(w, r)
		if w.Code != tc.status {
			t.Fatalf("status=%d want=%d", w.Code, tc.status)
		}
	}
	if calls != 1 {
		t.Fatalf("unauthorized stage save: %d calls", calls)
	}
}

func TestTrainingManagementAuthorizationAndPayload(t *testing.T) {
	token := strings.Repeat("s", 32)
	calls := 0
	handler := New(token, func(r desktop.Request) (any, error) {
		calls++
		if r.Operation != "training_save" || r.Training == nil || r.Training.Revision != 7 || len(r.Training.Rules.Levels) != 1 || r.Training.Rules.Levels[0].XPPerHour != 50 {
			t.Fatalf("stage configuration lost in transport: %+v", r)
		}
		return r.Training, nil
	})
	for _, tc := range []struct {
		env, auth string
		status    int
	}{
		{"online", "", 401}, {"local", "Bearer " + token, 403}, {"online", "Bearer " + token, 200},
	} {
		r := httptest.NewRequest("POST", "/gm/api", strings.NewReader(`{"operation":"training_save","environment":"`+tc.env+`","training":{"revision":7,"rules":{"enabled":false,"levels":[{"level":0,"xp_per_hour":50,"xp_cap":300}]}}}`))
		r.Header.Set("Authorization", tc.auth)
		w := httptest.NewRecorder()
		handler.ServeHTTP(w, r)
		if w.Code != tc.status {
			t.Fatalf("status=%d want=%d", w.Code, tc.status)
		}
	}
	if calls != 1 {
		t.Fatalf("unauthorized stage save: %d calls", calls)
	}
}

func TestTaskManagementAuthorizationAndPayload(t *testing.T) {
	token := strings.Repeat("s", 32)
	calls := 0
	handler := New(token, func(r desktop.Request) (any, error) {
		calls++
		if r.Operation != "tasks_save" || r.Tasks == nil || r.Tasks.Revision != 7 || len(r.Tasks.Rules.Tasks) != 1 || r.Tasks.Rules.Tasks[0].Matches != 10 {
			t.Fatalf("task configuration lost in transport: %+v", r)
		}
		return r.Tasks, nil
	})
	for _, tc := range []struct {
		env, auth string
		status    int
	}{
		{"online", "", 401}, {"local", "Bearer " + token, 403}, {"online", "Bearer " + token, 200},
	} {
		r := httptest.NewRequest("POST", "/gm/api", strings.NewReader(`{"operation":"tasks_save","environment":"`+tc.env+`","tasks":{"revision":7,"rules":{"enabled":false,"tasks":[{"id":1001,"matches":10,"counters":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}]}}}`))
		r.Header.Set("Authorization", tc.auth)
		w := httptest.NewRecorder()
		handler.ServeHTTP(w, r)
		if w.Code != tc.status {
			t.Fatalf("status=%d want=%d", w.Code, tc.status)
		}
	}
	if calls != 1 {
		t.Fatalf("unauthorized task save: %d calls", calls)
	}
}

func TestTitleManagementAuthorizationAndPayload(t *testing.T) {
	token := strings.Repeat("s", 32)
	calls := 0
	handler := New(token, func(r desktop.Request) (any, error) {
		calls++
		if r.Operation != "titles_save" || r.Titles == nil || r.Titles.Revision != 7 || len(r.Titles.Rules.Titles) != 1 || r.Titles.Rules.Titles[0].Matches != 10 {
			t.Fatalf("title configuration lost in transport: %+v", r)
		}
		return r.Titles, nil
	})
	for _, tc := range []struct {
		env, auth string
		status    int
	}{
		{"online", "", 401}, {"local", "Bearer " + token, 403}, {"online", "Bearer " + token, 200},
	} {
		r := httptest.NewRequest("POST", "/gm/api", strings.NewReader(`{"operation":"titles_save","environment":"`+tc.env+`","titles":{"revision":7,"rules":{"enabled":false,"titles":[{"level":1,"matches":10,"choices":[7]}]}}}`))
		r.Header.Set("Authorization", tc.auth)
		w := httptest.NewRecorder()
		handler.ServeHTTP(w, r)
		if w.Code != tc.status {
			t.Fatalf("status=%d want=%d", w.Code, tc.status)
		}
	}
	if calls != 1 {
		t.Fatalf("unauthorized title save: %d calls", calls)
	}
}

func TestWeaponSettingsManagementAuthorizationAndPayload(t *testing.T) {
	token := strings.Repeat("s", 32)
	calls := 0
	handler := New(token, func(r desktop.Request) (any, error) {
		calls++
		if r.Operation != "weapon_settings_save" || r.WeaponSettings == nil || r.WeaponSettings.Revision != 7 || len(r.WeaponSettings.Rules.Levels) != 1 || r.WeaponSettings.Rules.Levels[0].ScoreThreshold != 50 {
			t.Fatalf("weapon configuration lost in transport: %+v", r)
		}
		return r.WeaponSettings, nil
	})
	for _, tc := range []struct {
		env, auth string
		status    int
	}{
		{"online", "", 401}, {"local", "Bearer " + token, 403}, {"online", "Bearer " + token, 200},
	} {
		r := httptest.NewRequest("POST", "/gm/api", strings.NewReader(`{"operation":"weapon_settings_save","environment":"`+tc.env+`","weapon_settings":{"revision":7,"rules":{"enabled":false,"levels":[{"level":0,"score_threshold":50,"gold":300}]}}}`))
		r.Header.Set("Authorization", tc.auth)
		w := httptest.NewRecorder()
		handler.ServeHTTP(w, r)
		if w.Code != tc.status {
			t.Fatalf("status=%d want=%d", w.Code, tc.status)
		}
	}
	if calls != 1 {
		t.Fatalf("unauthorized weapon save: %d calls", calls)
	}
}

func TestVIPShopManagementAuthorization(t *testing.T) {
	token := strings.Repeat("s", 32)
	calls := 0
	h := New(token, func(r desktop.Request) (any, error) {
		calls++
		if r.VIPShopSettings == nil || r.VIPShopSettings.Revision != 4 || r.VIPShopSettings.Rules.Gold != 80 {
			t.Fatalf("lost VIP policy %+v", r)
		}
		return r.VIPShopSettings, nil
	})
	for _, tc := range []struct {
		env, auth string
		status    int
	}{{"online", "", 401}, {"local", "Bearer " + token, 403}, {"online", "Bearer " + token, 200}} {
		r := httptest.NewRequest("POST", "/gm/api", strings.NewReader(`{"operation":"vip_shop_settings_save","environment":"`+tc.env+`","vip_shop_settings":{"revision":4,"rules":{"enabled":true,"silver":90,"gold":80,"platinum":70}}}`))
		r.Header.Set("Authorization", tc.auth)
		w := httptest.NewRecorder()
		h.ServeHTTP(w, r)
		if w.Code != tc.status {
			t.Fatal(w.Code, tc.status)
		}
	}
	if calls != 1 {
		t.Fatal("unauthorized policy access", calls)
	}
}

func TestTalismanSettingsManagementAuthorizationAndPayload(t *testing.T) {
	token := strings.Repeat("s", 32)
	calls := 0
	handler := New(token, func(r desktop.Request) (any, error) {
		calls++
		if r.Operation != "talisman_settings_save" || r.TalismanSettings == nil || r.TalismanSettings.Revision != 7 || len(r.TalismanSettings.Rules.Uses) != 1 || r.TalismanSettings.Rules.Uses[0].ActiveCost != 50 {
			t.Fatalf("weapon configuration lost in transport: %+v", r)
		}
		return r.TalismanSettings, nil
	})
	for _, tc := range []struct {
		env, auth string
		status    int
	}{
		{"online", "", 401}, {"local", "Bearer " + token, 403}, {"online", "Bearer " + token, 200},
	} {
		r := httptest.NewRequest("POST", "/gm/api", strings.NewReader(`{"operation":"talisman_settings_save","environment":"`+tc.env+`","talisman_settings":{"revision":7,"rules":{"enabled":false,"uses":[{"item":303002,"active_cost":50,"passive_cost":300}]}}}`))
		r.Header.Set("Authorization", tc.auth)
		w := httptest.NewRecorder()
		handler.ServeHTTP(w, r)
		if w.Code != tc.status {
			t.Fatalf("status=%d want=%d", w.Code, tc.status)
		}
	}
	if calls != 1 {
		t.Fatalf("unauthorized weapon save: %d calls", calls)
	}
}
