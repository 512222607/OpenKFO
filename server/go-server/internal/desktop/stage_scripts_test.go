package desktop

import "testing"

func TestStageScriptBindings(t *testing.T) {
	text := "items={}\nconfigs={\r\n-- map and script\r\nmaps={\r\n{9170, \"act_zombiedefend_normal\"}, -- old comment\r\n{9190, \"act_Boss_easy\"}\r\n},monsters={}}"
	m, err := stageScriptBindings(text)
	if err != nil || len(m) != 2 || m[9170] != "script/pve/act_zombiedefend_normal.lua" || m[9190] != "script/pve/act_boss_easy.lua" {
		t.Fatal(m, err)
	}
	for _, body := range []string{
		``, `{0,"x"}`, `{4294967296,"x"}`, `{1,"../x"}`,
		`{1,"x"},{1,"y"}`, `{1,"x"}{2,"y"}`, `{1,getScript()}`,
		`--[[ hidden table ]]{1,"x"}`, `{1,"x"},unexpected`,
	} {
		if _, err := stageScriptBindings("configs={maps={" + body + "},monsters={}}"); err == nil {
			t.Fatalf("accepted invalid binding %q", body)
		}
	}
}
