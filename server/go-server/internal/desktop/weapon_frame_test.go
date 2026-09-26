package desktop

import (
	"bytes"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"testing"
)

func frameTestSource(t *testing.T) (*archive, []Item) {
	t.Helper()
	client := os.Getenv("OPENKFO_WEAPON_TEST_CLIENT")
	if client == "" {
		t.Skip("set OPENKFO_WEAPON_TEST_CLIENT for installed resource validation")
	}
	a, err := loadArchive(filepath.Join(client, "Data", "config.spf2"))
	if err != nil {
		t.Fatal(err)
	}
	items, err := catalog(client, false)
	if err != nil {
		t.Fatal(err)
	}
	items, err = itemsFromText(client, mustText(t, a, "item.txt"), true)
	if err != nil {
		t.Fatal(err)
	}
	return a, items
}

func mustText(t *testing.T, a *archive, name string) string {
	t.Helper()
	text, err := a.text(name)
	if err != nil {
		t.Fatal(err)
	}
	return text
}

// 帧级连招的第一条红线：共用动作块必须先克隆，原武器一个字节都不能动。
func TestFrameSwitchEditClonesSharedBlock(t *testing.T) {
	source, items := frameTestSource(t)
	before, err := inspect(source, items)
	if err != nil {
		t.Fatal(err)
	}

	// 挑一个"动作块被多把武器共用"的状态作为样本。
	var weapon Weapon
	var stage Stage
	for _, w := range before.weapons {
		for _, s := range w.Stages {
			if s.Action == "" || s.Action == "0" {
				continue
			}
			if len(before.owners[s.Action]) > 1 {
				weapon, stage = w, s
				break
			}
		}
		if stage.Action != "" {
			break
		}
	}
	if stage.Action == "" {
		t.Skip("本客户端没有共用的动作块")
	}
	original := before.blocks[actionKey(stage.Action)][0].original
	column, err := strconv.Atoi(stage.State)
	if err != nil {
		t.Fatalf("状态 %s 不是数字列", stage.State)
	}

	state := &weaponState{FrameSwitches: map[string]map[int]frameSwitchStageEdit{
		strconv.Itoa(weapon.ID): {column: {{Attrs: []FrameSwitchAttr{
			{Key: "keycode", Value: "8"},
			{Key: "switchstartframe", Value: "10"},
			{Key: "switchendframe", Value: "12"},
			{Key: "nextstate", Value: "2012"},
		}}}},
	}}
	edited, err := applyFrameSwitches(source, state, items)
	if err != nil {
		t.Fatal(err)
	}
	if bytes.Equal(edited.data, source.data) {
		t.Fatal("帧级连招没有写进配置包")
	}
	after, err := inspect(edited, items)
	if err != nil {
		t.Fatal(err)
	}
	lookup := map[int]Weapon{}
	for _, w := range after.weapons {
		lookup[w.ID] = w
	}

	// 1) 目标武器那一列指到了新块，新块带着刚写的切换。
	var updated Stage
	for _, s := range lookup[weapon.ID].Stages {
		if s.State == stage.State {
			updated = s
		}
	}
	if updated.Action == "" || updated.Action == stage.Action {
		t.Fatalf("共用块没有被克隆：%q", updated.Action)
	}
	clone := after.blocks[actionKey(updated.Action)]
	if len(clone) != 1 {
		t.Fatalf("克隆块不唯一：%d", len(clone))
	}
	text, err := clone[0].node.serialize()
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(text, `keycode="8"`) || !strings.Contains(text, `nextstate="2012"`) {
		t.Fatalf("克隆块里没有新写的切换：%s", text)
	}

	// 2) 原武器共用的那一块原样保留。
	animationBefore := mustText(t, source, "animation/"+stage.Action[:4]+".xml")
	animationAfter := mustText(t, edited, "animation/"+stage.Action[:4]+".xml")
	if !strings.Contains(animationAfter, original) {
		t.Fatal("原始动作块被改动")
	}
	if strings.Count(animationBefore, original) != 1 || strings.Count(animationAfter, original) != 1 {
		t.Fatalf("原始动作块出现次数异常：%d → %d",
			strings.Count(animationBefore, original), strings.Count(animationAfter, original))
	}

	// 3) 别的武器的行和动作一个都没变。
	for _, w := range before.weapons {
		if w.ID == weapon.ID {
			continue
		}
		for _, s := range w.Stages {
			var other Stage
			for _, o := range lookup[w.ID].Stages {
				if o.State == s.State {
					other = o
				}
			}
			if other.Action != s.Action {
				t.Fatalf("无关武器 %d 状态 %s 的动作被改了：%s → %s", w.ID, s.State, s.Action, other.Action)
			}
		}
	}

	// 4) 非白名单条目逐字节不变，重复应用逐条目稳定。
	allowed := frameSwitchFiles(source, state)
	allowed["itemact.txt"] = true
	for name := range source.entries {
		if allowed[name] {
			continue
		}
		a, err := source.raw(name)
		if err != nil {
			t.Fatal(err)
		}
		b, err := edited.raw(name)
		if err != nil {
			t.Fatal(err)
		}
		if !bytes.Equal(a, b) {
			t.Fatal("无关条目被改动", name)
		}
	}
	// 归档的 replace 每次都把新内容前插，所以整包字节必然不同；
	// 幂等要看每个条目的内容。
	again, err := applyFrameSwitches(edited, state, items)
	if err != nil {
		t.Fatal(err)
	}
	for name := range edited.entries {
		before, err := edited.raw(name)
		if err != nil {
			t.Fatal(err)
		}
		after, err := again.raw(name)
		if err != nil {
			t.Fatal(err)
		}
		if !bytes.Equal(before, after) {
			t.Fatalf("重复应用帧级连招不幂等：%s", name)
		}
	}
}

// 删除：把某个状态的列表换成空表，等于该状态不再有帧级连招。
func TestFrameSwitchRemoval(t *testing.T) {
	source, items := frameTestSource(t)
	info, err := inspect(source, items)
	if err != nil {
		t.Fatal(err)
	}
	weaponID, stageColumn := 0, 0
	for _, w := range info.weapons {
		if len(comboFrameSwitches(source, info, strconv.Itoa(w.ID))) == 0 {
			continue
		}
		for _, s := range w.Stages {
			column, convErr := strconv.Atoi(s.State)
			if convErr != nil || s.Action == "" || s.Action == "0" {
				continue
			}
			weaponID, stageColumn = w.ID, column
			break
		}
		if stageColumn != 0 {
			break
		}
	}
	if stageColumn == 0 {
		t.Skip("本客户端没有带帧级连招的武器")
	}
	state := &weaponState{FrameSwitches: map[string]map[int]frameSwitchStageEdit{
		strconv.Itoa(weaponID): {stageColumn: {}},
	}}
	edited, err := applyFrameSwitches(source, state, items)
	if err != nil {
		t.Fatal(err)
	}
	editedInfo, err := inspect(edited, items)
	if err != nil {
		t.Fatal(err)
	}
	left := comboFrameSwitches(edited, editedInfo, strconv.Itoa(weaponID))
	for _, sw := range left {
		if sw.State == strconv.Itoa(stageColumn) {
			t.Fatalf("状态 %d 的帧级连招没被清掉：%+v", stageColumn, sw)
		}
	}
}

// 纯文本层面的替换规则：保留第一条的位置、其余删除，其它字节不动。
func TestRewriteFrameSwitches(t *testing.T) {
	block := `<AnmDesc id = "129" >` + "\n" +
		`<Anm a="1"/>` + "\n" +
		`<CustomStateSwitch keycode="7" switchstartframe="1" switchendframe="2" nextstate="2012" />` + "\n" +
		`<Anm a="2"/>` + "\n" +
		`<CustomStateSwitch keycode="8" switchstartframe="3" switchendframe="4" nextstate="2013" />` + "\n" +
		`</AnmDesc>`
	fresh := []FrameSwitch{{Attrs: []FrameSwitchAttr{
		{Key: "keycode", Value: "9"},
		{Key: "switchstartframe", Value: "10"},
		{Key: "switchendframe", Value: "12"},
		{Key: "nextstate", Value: "2014"},
	}}}
	out, changed := rewriteFrameSwitches(block, fresh)
	if !changed {
		t.Fatal("应当报告改动")
	}
	if strings.Count(out, "<CustomStateSwitch") != 1 {
		t.Fatalf("旧切换没被清干净：%s", out)
	}
	if !strings.Contains(out, `keycode="9"`) {
		t.Fatalf("新切换没写进去：%s", out)
	}
	if strings.Count(out, `<Anm a="1"/>`) != 1 || strings.Count(out, `<Anm a="2"/>`) != 1 {
		t.Fatalf("兄弟节点被破坏：%s", out)
	}
	// 第一条的位置保住：新切换在 <Anm a="2"/> 之前。
	if strings.Index(out, "CustomStateSwitch") > strings.Index(out, `<Anm a="2"/>`) {
		t.Fatalf("切换的位置被挪到了兄弟节点之后：%s", out)
	}
	// 清空：全部删掉。
	empty, changed := rewriteFrameSwitches(block, nil)
	if !changed || strings.Contains(empty, "CustomStateSwitch") {
		t.Fatalf("清空失败：%s", empty)
	}
	// 原地没有切换、也不加：不动。
	same, changed := rewriteFrameSwitches(`<AnmDesc id="1"><Anm/></AnmDesc>`, nil)
	if changed || same != `<AnmDesc id="1"><Anm/></AnmDesc>` {
		t.Fatal("无改动时不该重写")
	}
}

// 校验要挡住会让客户端读不到的写法。
func TestValidateFrameSwitches(t *testing.T) {
	source, _ := frameTestSource(t)
	actionText := mustText(t, source, "itemact.txt")
	lines := strings.Split(actionText, "\n")
	header := strings.Split(strings.TrimSuffix(lines[0], "\r"), "\t")
	if len(header) < 3 {
		t.Skip("动作表没有状态列")
	}
	weaponKey := ""
	for _, line := range lines[1:] {
		cols := strings.Split(strings.TrimSuffix(line, "\r"), "\t")
		if len(cols) >= len(header) {
			weaponKey = cols[0]
			break
		}
	}
	if weaponKey == "" {
		t.Skip("动作表里没有完整的武器行")
	}
	// 前两列是武器编号与内部名，状态从第 3 列开始。
	state := header[2]
	valid := func(attrs ...FrameSwitchAttr) map[int]frameSwitchStageEdit {
		column, err := strconv.Atoi(state)
		if err != nil {
			t.Skip("表头第一列不是状态列")
		}
		return map[int]frameSwitchStageEdit{column: {{Attrs: attrs}}}
	}
	if err := validateFrameSwitches(source, weaponKey, valid(
		FrameSwitchAttr{Key: "switchstartframe", Value: "1"},
		FrameSwitchAttr{Key: "switchendframe", Value: "2"},
		FrameSwitchAttr{Key: "nextstate", Value: state},
	)); err != nil {
		t.Fatalf("合法配置被拒：%v", err)
	}
	cases := map[string]map[int]frameSwitchStageEdit{
		"状态不存在": {987654: {}},
		"目标状态不存在": valid(
			FrameSwitchAttr{Key: "switchstartframe", Value: "1"},
			FrameSwitchAttr{Key: "switchendframe", Value: "2"},
			FrameSwitchAttr{Key: "nextstate", Value: "999999"},
		),
		"缺 nextstate": valid(
			FrameSwitchAttr{Key: "switchstartframe", Value: "1"},
			FrameSwitchAttr{Key: "switchendframe", Value: "2"},
		),
		"窗口反了": valid(
			FrameSwitchAttr{Key: "switchstartframe", Value: "9"},
			FrameSwitchAttr{Key: "switchendframe", Value: "2"},
			FrameSwitchAttr{Key: "nextstate", Value: state},
		),
		"属性不认识": valid(
			FrameSwitchAttr{Key: "switchstartframe", Value: "1"},
			FrameSwitchAttr{Key: "switchendframe", Value: "2"},
			FrameSwitchAttr{Key: "nextstate", Value: state},
			FrameSwitchAttr{Key: "onload", Value: "alert(1)"},
		),
		"值里有引号": valid(
			FrameSwitchAttr{Key: "switchstartframe", Value: "1"},
			FrameSwitchAttr{Key: "switchendframe", Value: "2"},
			FrameSwitchAttr{Key: "nextstate", Value: state},
			FrameSwitchAttr{Key: "keycode", Value: `7" onload="x`},
		),
		"输入窗口只写一半": valid(
			FrameSwitchAttr{Key: "inputstartframe", Value: "1"},
			FrameSwitchAttr{Key: "switchstartframe", Value: "1"},
			FrameSwitchAttr{Key: "switchendframe", Value: "2"},
			FrameSwitchAttr{Key: "nextstate", Value: state},
		),
	}
	for name, edits := range cases {
		if err := validateFrameSwitches(source, weaponKey, edits); err == nil {
			t.Fatalf("%s：应当被拒绝", name)
		}
	}
}
