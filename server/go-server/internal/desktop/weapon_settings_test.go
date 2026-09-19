package desktop

import (
	"encoding/json"
	"kungfu.local/server/internal/persistence"
	"testing"
)

func TestWeaponSettingsManagementTransport(t *testing.T) {
	var req Request
	if err := json.Unmarshal([]byte(`{"environment":"online","operation":"weapon_settings_save","weapon_settings":{"revision":7,"rules":{"enabled":false,"levels":[{"level":0,"score_threshold":50,"gold":300}]}}}`), &req); err != nil {
		t.Fatal(err)
	}
	calls := 0
	a := &Admin{Remote: func(r persistence.AdminRequest) (json.RawMessage, error) {
		calls++
		if r.Operation != "weapon_settings_save" || r.WeaponSettings == nil || r.WeaponSettings.Revision != 7 || len(r.WeaponSettings.Rules.Levels) != 1 || r.WeaponSettings.Rules.Levels[0].ScoreThreshold != 50 || r.WeaponSettings.Rules.Levels[0].Gold != 300 {
			t.Fatalf("lost weapon fields: %+v", r)
		}
		if err := r.WeaponSettings.Validate(); err != nil {
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

func TestVIPShopManagementTransport(t *testing.T) {
	var req Request
	if err := json.Unmarshal([]byte(`{"environment":"online","operation":"vip_shop_settings_save","vip_shop_settings":{"revision":4,"rules":{"enabled":true,"silver":90,"gold":80,"platinum":70}}}`), &req); err != nil {
		t.Fatal(err)
	}
	calls := 0
	a := &Admin{Remote: func(r persistence.AdminRequest) (json.RawMessage, error) {
		calls++
		if r.Operation != "vip_shop_settings_save" || r.VIPShopSettings == nil || r.VIPShopSettings.Revision != 4 || r.VIPShopSettings.Rules.Percent(3) != 80 {
			t.Fatalf("lost VIP policy %+v", r)
		}
		return json.RawMessage(`{"revision":5}`), nil
	}}
	if _, err := a.Call(req); err != nil || calls != 1 {
		t.Fatal(calls, err)
	}
}
