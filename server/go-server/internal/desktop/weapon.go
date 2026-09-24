package desktop

import (
	"bytes"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"encoding/xml"
	"fmt"
	"io"
	"math"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"runtime"
	"sort"
	"strconv"
	"strings"
	"unicode"
)

type field struct {
	Key  string `json:"key"`
	Name string `json:"name"`
	Min  int    `json:"min"`
	Max  int    `json:"max"`
}

var propertyFields = []field{{"SkillDamage", "基础伤害", 0, 10000}, {"SkillEnhanceDamage", "强化伤害", 0, 10000}, {"RepulseTarget", "击退参数", 0, 120}, {"TripTarget", "击倒参数", 0, 2}, {"TargetFlurr", "浮空参数", 0, 3}, {"StandHurt", "站立受击动作", 0, 255}, {"StandHurtDown", "倒地受击动作", 0, 255}, {"StandHurtFly", "站立受击飞行动作", 0, 255}, {"FlyHurt", "飞行受击动作", 0, 255}, {"JumpHurtDown", "空中受击动作", 0, 255}, {"JumpHurtFall", "空中落地动作", 0, 255}}

type xmlNode struct {
	tag      string
	attrs    []xml.Attr
	children []*xmlNode
	text     string
	comment  bool
}

func parseXML(text string) (*xmlNode, error) {
	if strings.Contains(strings.ToUpper(text), "<!DOCTYPE") {
		return nil, fmt.Errorf("不支持 XML DTD")
	}
	decoder := xml.NewDecoder(strings.NewReader(text))
	decoder.CharsetReader = func(_ string, reader io.Reader) (io.Reader, error) { return reader, nil }
	var root *xmlNode
	stack := []*xmlNode{}
	for {
		token, err := decoder.Token()
		if err == io.EOF {
			break
		}
		if err != nil {
			return nil, err
		}
		switch value := token.(type) {
		case xml.StartElement:
			node := &xmlNode{tag: value.Name.Local, attrs: append([]xml.Attr(nil), value.Attr...)}
			if len(stack) > 0 {
				parent := stack[len(stack)-1]
				parent.children = append(parent.children, node)
			} else {
				if root != nil {
					return nil, fmt.Errorf("XML 根节点重复")
				}
				root = node
			}
			stack = append(stack, node)
		case xml.EndElement:
			if len(stack) == 0 {
				return nil, fmt.Errorf("XML 层级错误")
			}
			stack = stack[:len(stack)-1]
		case xml.CharData:
			if len(stack) > 0 {
				stack[len(stack)-1].text += string(value)
			}
		case xml.Comment:
			if len(stack) > 0 {
				parent := stack[len(stack)-1]
				parent.children = append(parent.children, &xmlNode{comment: true, text: string(value)})
			}
		}
	}
	if root == nil || len(stack) != 0 {
		return nil, fmt.Errorf("XML 不完整")
	}
	return root, nil
}
func (n *xmlNode) get(key string) string {
	for _, attr := range n.attrs {
		if attr.Name.Local == key {
			return attr.Value
		}
	}
	return ""
}
func (n *xmlNode) set(key, value string) {
	for index := range n.attrs {
		if n.attrs[index].Name.Local == key {
			n.attrs[index].Value = value
			return
		}
	}
	n.attrs = append(n.attrs, xml.Attr{Name: xml.Name{Local: key}, Value: value})
}
func (n *xmlNode) walk(visit func(*xmlNode)) {
	visit(n)
	for _, child := range n.children {
		child.walk(visit)
	}
}
func (n *xmlNode) clone() *xmlNode {
	copy := &xmlNode{tag: n.tag, attrs: append([]xml.Attr(nil), n.attrs...), text: n.text, comment: n.comment}
	for _, child := range n.children {
		copy.children = append(copy.children, child.clone())
	}
	return copy
}
func (n *xmlNode) encode(encoder *xml.Encoder) error {
	if n.comment {
		return encoder.EncodeToken(xml.Comment(n.text))
	}
	start := xml.StartElement{Name: xml.Name{Local: n.tag}, Attr: n.attrs}
	if err := encoder.EncodeToken(start); err != nil {
		return err
	}
	if n.text != "" {
		if err := encoder.EncodeToken(xml.CharData(n.text)); err != nil {
			return err
		}
	}
	for _, child := range n.children {
		if err := child.encode(encoder); err != nil {
			return err
		}
	}
	return encoder.EncodeToken(start.End())
}
func (n *xmlNode) serialize() (string, error) {
	var output bytes.Buffer
	encoder := xml.NewEncoder(&output)
	if err := n.encode(encoder); err != nil {
		return "", err
	}
	if err := encoder.Flush(); err != nil {
		return "", err
	}
	return output.String(), nil
}
func (a *archive) xml(name string) (*xmlNode, error) {
	text, err := a.text(name)
	if err != nil {
		return nil, err
	}
	return parseXML(text)
}

type Buff struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

func buffs(a *archive) ([]Buff, error) {
	root, err := a.xml("ustate.xml")
	if err != nil {
		return nil, err
	}
	result := []Buff{{0, "保持原效果"}, {-1, "清除原有 BUFF"}}
	label := ""
	for _, node := range root.children {
		if node.comment {
			label = strings.Split(strings.TrimSpace(node.text), "\n")[0]
			continue
		}
		if node.tag != "Data" {
			continue
		}
		active := false
		node.walk(func(child *xmlNode) {
			if child.tag == "LogicHandle" && child.get("Type") != "" {
				active = true
			}
		})
		if node.get("ActiveState") == "0" && active {
			id, err := strconv.Atoi(node.get("type"))
			if err != nil {
				return nil, err
			}
			name := label
			if id == 1 {
				name = "中毒"
			} else if id == 37 {
				name = "燃烧（献祭燃烧）"
			}
			runes := []rune(name)
			if len(runes) > 35 {
				name = string(runes[:35])
			}
			if name == "" {
				name = fmt.Sprintf("异常状态 %d", id)
			}
			result = append(result, Buff{id, name})
		}
		label = ""
	}
	return result, nil
}

type ComboNode struct {
	State string `json:"state"`
	Keys  string `json:"keys"`
}
type Combo struct {
	Name  string      `json:"name"`
	Nodes []ComboNode `json:"nodes"`
}

// Animation comments describe the action, not necessarily its input or public name.
func actionDescription(node *xmlNode) string {
	for _, child := range node.children {
		if !child.comment {
			break
		}
		text := strings.Join(strings.Fields(child.text), " ")
		if len([]rune(text)) > 100 || strings.ContainsAny(text, "<>�") {
			continue
		}
		if strings.ContainsFunc(text, func(r rune) bool { return unicode.Is(unicode.Han, r) }) {
			return text
		}
	}
	return ""
}

func combos(a *archive, id string) ([]Combo, error) {
	name := "weapon/" + id + "/combotip.xml"
	result := []Combo{}
	if _, ok := a.entries[name]; !ok {
		return result, nil
	}
	root, err := a.xml(name)
	if err != nil {
		return nil, err
	}
	return readComboSequences(root), nil
}

// Each ActNode is the next input in a sequence, not an independent shortcut.
func readComboSequences(root *xmlNode) []Combo {
	result := []Combo{}
	root.walk(func(node *xmlNode) {
		if node.tag != "Sequence" {
			return
		}
		sequence := Combo{Name: node.get("Name"), Nodes: []ComboNode{}}
		prefix := ""
		complete := true
		for _, child := range node.children {
			if child.comment || child.tag != "ActNode" {
				continue
			}
			keys := []string{}
			for _, input := range child.children {
				if input.comment || input.tag != "Icon" {
					continue
				}
				key := strings.TrimSpace(input.get("Name"))
				if key == "" {
					complete = false
				} else {
					keys = append(keys, key)
				}
			}
			if len(keys) == 0 {
				complete = false
			}
			prefix += strings.Join(keys, "")
			label := prefix
			if !complete {
				label = "按键提示不完整（" + sequence.Name + "）"
			}
			sequence.Nodes = append(sequence.Nodes, ComboNode{child.get("State"), label})
		}
		result = append(result, sequence)
	})
	return result
}

type Hit struct {
	ID     string            `json:"id"`
	Values map[string]string `json:"values"`
	Buff   string            `json:"buff"`
}
type Stage struct {
	Stage       int      `json:"stage"`
	State       string   `json:"state"`
	Label       string   `json:"label"`
	Action      string   `json:"action"`
	PropertyIDs []string `json:"property_ids"`
	Hits        []Hit    `json:"hits"`
	Supported   bool     `json:"supported"`
	Reason      string   `json:"reason"`
}
type Weapon struct {
	ID          int              `json:"id"`
	Name        string           `json:"name"`
	Icon        string           `json:"icon"`
	Description string           `json:"description"`
	Type        string           `json:"type"`
	Model       string           `json:"model"`
	Stages      []Stage          `json:"stages"`
	Combos      []Combo          `json:"combos"`
	BuffIDs     []int            `json:"buff_ids"`
	Allowed     map[string][]int `json:"allowed_values"`
	// ComboRows is how many delayacttable.xml transitions the weapon owns.
	// Zero means the client can never advance past the first hit.
	ComboRows int `json:"combo_rows"`
	// ComboSuggestion points at the weapon whose action row this one copies,
	// used as the default donor when completing a missing combo table.
	ComboSuggestion int `json:"combo_suggestion,omitempty"`
	// Effects reports whether acteffect.xml registers action effects for it.
	Effects bool `json:"effects"`
}
type block struct {
	original string
	node     *xmlNode
}

// item.txt column 2 is the weapon subtype; retain unknown values explicitly.
func weaponType(item Item) string {
	if len(item.Fields) <= 2 || item.Fields[2] == "" || item.Fields[2] == "#" {
		return "未分类"
	}
	switch item.Fields[2] {
	case "1":
		return "刀类"
	case "2":
		return "剑类"
	case "3":
		return "长柄"
	case "4":
		return "拳套"
	case "5":
		return "拳脚"
	case "6":
		return "重型"
	case "7":
		return "奇门"
	default:
		return "类型 " + item.Fields[2]
	}
}

// weaponTypes lists the item.txt column-2 subtypes an author may pick when
// inventing a weapon. The labels mirror weaponType so the editor and the
// catalogue speak the same language.
var weaponTypes = []map[string]string{
	{"value": "1", "label": "刀类"},
	{"value": "2", "label": "剑类"},
	{"value": "3", "label": "长柄"},
	{"value": "4", "label": "拳套"},
	{"value": "5", "label": "拳脚"},
	{"value": "6", "label": "重型"},
	{"value": "7", "label": "奇门"},
}

// weaponModels lists the RenderWare clumps shipped inside the client. A
// self-made weapon has to borrow one of them, because the client binary is
// never touched and unknown model names fall back to an invisible mesh.
func weaponModels(client string) []string {
	models := []string{}
	folder := filepath.Join(client, "Data", "Weapon", "Model")
	entries, err := os.ReadDir(folder)
	if err != nil {
		return models
	}
	for _, entry := range entries {
		if entry.IsDir() || !strings.EqualFold(filepath.Ext(entry.Name()), ".dff") {
			continue
		}
		models = append(models, entry.Name())
	}
	sort.Strings(models)
	return models
}

type inspection struct {
	weapons    []Weapon
	blocks     map[string][]block
	properties map[string][]*xmlNode
	ordered    []*xmlNode
	owners     map[string]map[string]bool
}

var animationPattern = regexp.MustCompile(`(?s)<AnmDesc\b[^>]*>.*?</AnmDesc\s*>`)

func actionKey(action string) string {
	if len(action) <= 4 {
		return ""
	}
	id, err := strconv.Atoi(action[4:])
	if err != nil {
		return ""
	}
	return action[:4] + "/" + strconv.Itoa(id)
}

func inspect(a *archive, items []Item) (*inspection, error) {
	buffRows, err := buffs(a)
	if err != nil {
		return nil, err
	}
	buffIDs := []int{}
	for _, row := range buffRows {
		buffIDs = append(buffIDs, row.ID)
	}
	text, err := a.text("itemact.txt")
	if err != nil {
		return nil, err
	}
	lines := [][]string{}
	for _, line := range strings.Split(strings.ReplaceAll(text, "\r\n", "\n"), "\n") {
		if strings.TrimSpace(line) != "" {
			lines = append(lines, strings.Split(line, "\t"))
		}
	}
	if len(lines) < 2 {
		return nil, fmt.Errorf("武器动作表为空")
	}
	header := lines[0]
	columns := map[string]int{}
	for index, state := range header {
		columns[state] = index
	}
	owners := map[string]map[string]bool{}
	for _, row := range lines[1:] {
		if len(row) > len(header) || len(row) < 2 {
			return nil, fmt.Errorf("武器动作字段错误")
		}
		for index, action := range row[2:] {
			if action != "0" {
				if owners[action] == nil {
					owners[action] = map[string]bool{}
				}
				owners[action][row[0]+":"+header[index+2]] = true
			}
		}
	}
	result := &inspection{weapons: []Weapon{}, blocks: map[string][]block{}, properties: map[string][]*xmlNode{}, owners: owners}
	files := map[string]bool{}
	for action := range owners {
		if len(action) > 4 {
			files["animation/"+action[:4]+".xml"] = true
		}
	}
	for file := range files {
		if _, ok := a.entries[file]; !ok {
			continue
		}
		animation, err := a.text(file)
		if err != nil {
			return nil, err
		}
		prefix := strings.TrimSuffix(strings.TrimPrefix(file, "animation/"), ".xml")
		for _, original := range animationPattern.FindAllString(animation, -1) {
			node, err := parseXML(original)
			if err != nil {
				return nil, err
			}
			id, err := strconv.Atoi(strings.TrimSpace(node.get("id")))
			if err != nil {
				return nil, err
			}
			key := prefix + "/" + strconv.Itoa(id)
			result.blocks[key] = append(result.blocks[key], block{original, node})
		}
	}

	root, err := a.xml("skillproperty.xml")
	if err != nil {
		return nil, err
	}
	for _, node := range root.children {
		if node.comment {
			continue
		}
		id := node.get("SkillProId")
		result.properties[id] = append(result.properties[id], node)
		result.ordered = append(result.ordered, node)
	}
	allowed := map[string][]int{}
	for _, field := range propertyFields[2:] {
		values := map[int]bool{}
		for _, node := range result.ordered {
			value := node.get(field.Key)
			if value == "" {
				value = "0"
			}
			number, err := strconv.Atoi(value)
			if err != nil {
				return nil, err
			}
			values[number] = true
		}
		for number := range values {
			allowed[field.Key] = append(allowed[field.Key], number)
		}
		sort.Ints(allowed[field.Key])
	}
	names := map[string]Item{}
	for _, item := range items {
		if item.Kind == 25 {
			names[strconv.FormatUint(uint64(item.ID), 10)] = item
		}
	}
	for _, row := range lines[1:] {
		item, ok := names[row[0]]
		if !ok {
			continue
		}
		sequences, err := combos(a, row[0])
		if err != nil {
			return nil, err
		}
		// The action table is authoritative; combo tips are labels, not an allowlist.
		states := append([]string(nil), header[2:len(row)]...)
		sort.SliceStable(states, func(i, j int) bool {
			a, _ := strconv.Atoi(states[i])
			b, _ := strconv.Atoi(states[j])
			return a >= 2000 && a < 3000 && !(b >= 2000 && b < 3000)
		})

		id, err := strconv.Atoi(row[0])
		if err != nil {
			return nil, err
		}
		model := ""
		if len(item.Fields) > 7 {
			model = item.Fields[7]
		}
		weapon := Weapon{ID: id, Name: item.Name, Icon: item.Icon, Description: item.Description, Type: weaponType(item), Model: model, Stages: []Stage{}, Combos: sequences, BuffIDs: buffIDs, Allowed: allowed}
		for _, state := range states {
			column, ok := columns[state]
			if !ok || column >= len(row) {
				return nil, fmt.Errorf("招式列缺失")
			}
			action := row[column]
			if action == "0" || action == "" {
				continue
			}
			number, err := strconv.Atoi(state)
			if err != nil {
				return nil, err
			}
			if number >= 2011 && number <= 2016 {
				number -= 2010
			}
			candidates := result.blocks[actionKey(action)]
			refs := map[string]bool{}
			for _, candidate := range candidates {
				candidate.node.walk(func(node *xmlNode) {
					ref := node.get("skillproid")
					if ref != "" && ref != "0" {
						refs[ref] = true
					}
				})
			}
			refIDs := []string{}
			unique := true
			for ref := range refs {
				refIDs = append(refIDs, ref)
				if len(result.properties[ref]) != 1 {
					unique = false
				}
			}
			sort.Strings(refIDs)
			reason := ""
			if len(candidates) != 1 || len(refs) == 0 || !unique {
				reason = "动作或命中属性未能唯一对应，暂不可应用"
				if len(candidates) == 1 && len(refs) == 0 {
					reason = "该动作没有直接命中属性（移动、受击或间接效果），不提供伤害编辑"
				}
			} else {
				for _, ref := range refIDs {
					node := result.properties[ref][0]
					if node.get("TargetSelf") != "0" || node.get("TargetEnemy") != "1" {
						reason = "该段包含非敌方命中效果，暂不可应用"
					}
				}
			}
			hits := []Hit{}
			for _, ref := range refIDs {
				if len(result.properties[ref]) != 1 {
					continue
				}
				node := result.properties[ref][0]
				values := map[string]string{}
				for _, field := range propertyFields {
					value := node.get(field.Key)
					if value == "" {
						value = "0"
					}
					values[field.Key] = value
				}
				buff := "0"
				for _, attr := range node.attrs {
					if attr.Name.Local == "UnNormalState" {
						buff = attr.Value
					}
				}
				for _, key := range []string{"UStateLevel", "UStateLastCycle"} {
					if value := node.get(key); value != "" {
						values[key] = value
					}
				}
				hits = append(hits, Hit{ref, values, buff})
			}
			labels := []string{}
			labelSeen := map[string]bool{}
			for _, sequence := range sequences {
				for _, node := range sequence.Nodes {
					if node.State == state && !labelSeen[node.Keys] {
						labels = append(labels, node.Keys)
						labelSeen[node.Keys] = true
					}
				}
			}
			label := strings.Join(labels, " / ")
			if label == "" {
				label = "动作说明缺失（按键待核实）"
				if len(candidates) == 1 {
					if description := actionDescription(candidates[0].node); description != "" {
						label = description + "（动画说明，非按键）"
					}
				}
			}

			weapon.Stages = append(weapon.Stages, Stage{number, state, label, action, refIDs, hits, reason == "", reason})
		}
		if len(weapon.Stages) > 0 {
			result.weapons = append(result.weapons, weapon)
		}
	}
	return result, nil
}

type Rule struct {
	Stage      int                           `json:"stage"`
	Buff       int                           `json:"buff"`
	Level      int                           `json:"level"`
	Duration   int                           `json:"duration"`
	Properties map[string]map[string]float64 `json:"properties,omitempty"`
}

func includes[T comparable](items []T, value T) bool {
	for _, item := range items {
		if item == value {
			return true
		}
	}
	return false
}
func validateRules(rules []Rule, weapon Weapon) ([]Rule, error) {
	if rules == nil || len(rules) > len(weapon.Stages) {
		return nil, fmt.Errorf("连招配置格式错误")
	}
	result := []Rule{}
	stages := map[int]Stage{}
	for _, stage := range weapon.Stages {
		stages[stage.Stage] = stage
	}
	seen := map[int]bool{}
	fields := map[string]field{}
	for _, field := range propertyFields {
		fields[field.Key] = field
	}
	for _, rule := range rules {
		stage, ok := stages[rule.Stage]
		if !ok || seen[rule.Stage] || !includes(weapon.BuffIDs, rule.Buff) || rule.Level < 1 || rule.Level > 3 || rule.Duration < 1 || rule.Duration > 60000 {
			return nil, fmt.Errorf("效果参数超出范围")
		}
		seen[rule.Stage] = true
		for ref, values := range rule.Properties {
			if !includes(stage.PropertyIDs, ref) || values == nil {
				return nil, fmt.Errorf("命中属性不属于当前招式")
			}
			for key, value := range values {
				field, ok := fields[key]
				if !ok || math.IsNaN(value) || math.IsInf(value, 0) || value < float64(field.Min) || value > float64(field.Max) {
					return nil, fmt.Errorf("伤害或攻击效果超出范围")
				}
				if key != "SkillDamage" && key != "SkillEnhanceDamage" && (value != math.Trunc(value) || !includes(weapon.Allowed[key], int(value))) {
					return nil, fmt.Errorf("受击参数不属于客户端原生配置")
				}
			}
		}
		if rule.Buff != 0 || len(rule.Properties) > 0 {
			if !stage.Supported {
				return nil, fmt.Errorf("%s", stage.Reason)
			}
			result = append(result, rule)
		}
	}
	sort.Slice(result, func(i, j int) bool { return result[i].Stage < result[j].Stage })
	return result, nil
}
func effects(info *inspection) []map[string]any {
	result := []map[string]any{}
	for _, choice := range [][2]string{{"repulse", "击退"}, {"float", "上升 / 悬空击飞"}, {"fall", "击倒"}} {
		for _, node := range info.ordered {
			match := choice[0] == "repulse" && node.get("RepulseTarget") == "1" || choice[0] == "float" && node.get("TargetFlurr") == "1" && node.get("StandHurtDown") == "1" && node.get("StandHurtFly") == "11" || choice[0] == "fall" && node.get("TripTarget") == "1" && node.get("TargetFlurr") == "0"
			if !match || node.get("TargetEnemy") != "1" || node.get("TargetSelf") != "0" {
				continue
			}
			values := map[string]int{}
			for _, field := range propertyFields[2:] {
				values[field.Key], _ = strconv.Atoi(node.get(field.Key))
			}
			result = append(result, map[string]any{"id": choice[0], "name": choice[1], "source": node.get("SkillProId"), "values": values})
			break
		}
	}
	return result
}
func render(a *archive, items []Item, plans map[string][]Rule) ([]byte, error) {
	info, err := inspect(a, items)
	if err != nil {
		return nil, err
	}
	weapons := map[string]Weapon{}
	for _, weapon := range info.weapons {
		weapons[strconv.Itoa(weapon.ID)] = weapon
	}
	animations := map[string]string{}
	actionTable, err := a.text("itemact.txt")
	if err != nil {
		return nil, err
	}
	actionLines := strings.Split(actionTable, "\n")
	header := strings.Split(strings.TrimSuffix(actionLines[0], "\r"), "\t")
	tableChanged := false
	reserved := map[string]bool{}
	for key := range info.blocks {
		reserved[key] = true
	}
	for action := range info.owners {
		reserved[actionKey(action)] = true
	}

	properties, err := a.text("skillproperty.xml")
	if err != nil {
		return nil, err
	}
	keys := []string{}
	for key := range plans {
		keys = append(keys, key)
	}
	sort.Strings(keys)
	clones := []string{}
	nextID := 900000000
	for _, key := range keys {
		weapon, ok := weapons[key]
		if !ok {
			return nil, fmt.Errorf("武器配置已变化")
		}
		rules, err := validateRules(plans[key], weapon)
		if err != nil {
			return nil, err
		}
		for _, rule := range rules {
			var stage Stage
			for _, candidate := range weapon.Stages {
				if candidate.Stage == rule.Stage {
					stage = candidate
					break
				}
			}
			source := info.blocks[actionKey(stage.Action)][0]
			file := "animation/" + stage.Action[:4] + ".xml"
			animation, ok := animations[file]
			if !ok {
				animation, err = a.text(file)
				if err != nil {
					return nil, err
				}
			}
			changed := source.node.clone()
			shared := len(info.owners[stage.Action]) > 1
			if shared {
				cloneID := 0
				for id := 999; id >= 1; id-- {
					key := stage.Action[:4] + "/" + strconv.Itoa(id)
					if !reserved[key] {
						cloneID = id
						reserved[key] = true
						break
					}
				}
				if cloneID == 0 {
					return nil, fmt.Errorf("%s 独立动作编号空间不足，未修改配置", file)
				}
				changed.set("id", strconv.Itoa(cloneID))
				newAction := stage.Action[:4] + fmt.Sprintf("%03d", cloneID)
				replaced := false
				for i, line := range actionLines[1:] {
					ending := ""
					if strings.HasSuffix(line, "\r") {
						ending = "\r"
					}
					cols := strings.Split(strings.TrimSuffix(line, "\r"), "\t")
					if len(cols) < 2 || cols[0] != key {
						continue
					}
					for j, state := range header {
						if j >= 2 && j < len(cols) && state == stage.State {
							cols[j] = newAction
							replaced = true
						}
					}
					actionLines[i+1] = strings.Join(cols, "\t") + ending
				}
				if !replaced {
					return nil, fmt.Errorf("找不到待隔离招式")
				}
				tableChanged = true
			}
			remap := map[string]string{}
			for _, oldID := range stage.PropertyIDs {
				for len(info.properties[strconv.Itoa(nextID)]) > 0 {
					nextID++
				}
				newID := strconv.Itoa(nextID)
				nextID++
				prop := info.properties[oldID][0].clone()
				prop.set("SkillProId", newID)
				if rule.Buff != 0 {
					buff, level, duration := rule.Buff, rule.Level, rule.Duration
					if buff < 0 {
						buff = 0
						level = 0
						duration = 0
					}
					prop.set("UnNormalState", strconv.Itoa(buff))
					prop.set("UStateLevel", strconv.Itoa(level))
					prop.set("UStateLastCycle", strconv.Itoa(duration))
				}
				for _, field := range propertyFields {
					if value, ok := rule.Properties[oldID][field.Key]; ok {
						prop.set(field.Key, strconv.FormatFloat(value, 'f', -1, 64))
					}
				}
				encoded, err := prop.serialize()
				if err != nil {
					return nil, err
				}
				clones = append(clones, encoded)
				remap[oldID] = newID
			}
			changed.walk(func(node *xmlNode) {
				if id, ok := remap[node.get("skillproid")]; ok {
					node.set("skillproid", id)
				}
			})
			if strings.Count(animation, source.original) != 1 {
				return nil, fmt.Errorf("动作定义无法唯一替换")
			}
			encoded, err := changed.serialize()
			if err != nil {
				return nil, err
			}
			if shared {
				ending := regexp.MustCompile(`</AnmInfo\s*>`)
				if len(ending.FindAllStringIndex(animation, -1)) != 1 {
					return nil, fmt.Errorf("动作表结构错误")
				}
				animation = ending.ReplaceAllStringFunc(animation, func(string) string { return "\n" + encoded + "\n</AnmInfo>" })
			} else {
				animation = strings.Replace(animation, source.original, encoded, 1)
			}
			animations[file] = animation
		}
	}
	if len(clones) == 0 {
		return append([]byte(nil), a.data...), nil
	}
	ending := regexp.MustCompile(`</SkillProperty\s*>`)
	if len(ending.FindAllStringIndex(properties, -1)) != 1 {
		return nil, fmt.Errorf("技能属性表结构错误")
	}
	properties = ending.ReplaceAllStringFunc(properties, func(string) string { return "\n" + strings.Join(clones, "\n") + "\n</SkillProperty>" })
	if _, err = parseXML(properties); err != nil {
		return nil, err
	}
	replacements := map[string][]byte{}
	for file, animation := range animations {
		if _, err := parseXML(animation); err != nil {
			return nil, err
		}
		encoded, err := encodeText(animation)
		if err != nil {
			return nil, err
		}
		replacements[file] = encoded
	}
	encoded, err := encodeText(properties)
	if err != nil {
		return nil, err
	}
	replacements["skillproperty.xml"] = encoded
	if tableChanged {
		encoded, err := encodeText(strings.Join(actionLines, "\n"))
		if err != nil {
			return nil, err
		}
		replacements["itemact.txt"] = encoded
	}
	return a.replace(replacements)
}
func digest(data []byte) string { sum := sha256.Sum256(data); return hex.EncodeToString(sum[:]) }
func atomicWrite(path string, data []byte) error {
	file, err := os.CreateTemp(filepath.Dir(path), filepath.Base(path)+".*.tmp")
	if err != nil {
		return err
	}
	temp := file.Name()
	defer os.Remove(temp)
	if _, err = file.Write(data); err != nil {
		file.Close()
		return err
	}
	if err = file.Sync(); err != nil {
		file.Close()
		return err
	}
	if err = file.Close(); err != nil {
		return err
	}
	return os.Rename(temp, path)
}

// Blueprint describes a weapon invented without touching the client binary.
// Its item row and action row are copied from a donor weapon that already ships
// in the client's config.spf2, so the untouched client still draws an existing
// RenderWare clump while the name, subtype and per-stage effects are new.
type Blueprint struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Type  string `json:"type"`
	Model string `json:"model"`
	Donor int    `json:"donor"`
	Note  string `json:"note,omitempty"`
}

const blueprintMinID, blueprintMaxID = 253000, 253999

// splitRows splits a tab separated table, dropping blank lines.
func splitRows(text string) [][]string {
	lines := strings.Split(strings.ReplaceAll(text, "\r\n", "\n"), "\n")
	rows := make([][]string, 0, len(lines))
	for _, line := range lines {
		if strings.TrimSpace(line) == "" {
			continue
		}
		rows = append(rows, strings.Split(line, "\t"))
	}
	return rows
}

// appendTabRow appends one row, matching the file's existing line ending so the
// untouched client keeps parsing the table the same way.
func appendTabRow(text, row string) string {
	ending := "\n"
	if strings.Contains(text, "\r\n") {
		ending = "\r\n"
	}
	body := strings.TrimRight(text, "\r\n")
	if body == "" {
		return row + ending
	}
	return body + ending + row + ending
}

func setCell(row []string, index int, value string) []string {
	for len(row) <= index {
		row = append(row, "")
	}
	row[index] = value
	return row
}

// itemRowIndex maps a level item id to its item.txt row (kind 25 only).
func itemRowIndex(text string) map[string][]string {
	index := map[string][]string{}
	for _, row := range splitRows(text) {
		if len(row) >= 2 && row[0] == "25" {
			index[row[1]] = row
		}
	}
	return index
}

// actionRowIndex maps a weapon id to its itemact.txt row.
func actionRowIndex(text string) map[string][]string {
	index := map[string][]string{}
	for _, row := range splitRows(text) {
		if len(row) >= 2 {
			index[row[0]] = row
		}
	}
	return index
}

// weaponItemIDs lists every item.txt id of kind 25. The reserved range must be
// validated against this table rather than against the renderable weapon list:
// item.txt is what validateBlueprint writes into, and a shipped id is taken
// even if it happens to carry no usable action row.
func weaponItemIDs(a *archive) []int {
	text, err := a.text("item.txt")
	if err != nil {
		return nil
	}
	ids := []int{}
	for key := range itemRowIndex(text) {
		if number, err := strconv.Atoi(key); err == nil {
			ids = append(ids, number)
		}
	}
	sort.Ints(ids)
	return ids
}

// applyBlueprints returns a configuration whose item.txt and itemact.txt carry
// one extra row per blueprint. Both files already exist in the archive, so the
// SGDP writer can replace them without growing the entry table.
func applyBlueprints(a *archive, created map[string]Blueprint) (*archive, error) {
	if len(created) == 0 {
		return a, nil
	}
	itemText, err := a.text("item.txt")
	if err != nil {
		return nil, err
	}
	actionText, err := a.text("itemact.txt")
	if err != nil {
		return nil, err
	}
	itemIndex := itemRowIndex(itemText)
	actionIndex := actionRowIndex(actionText)
	keys := make([]string, 0, len(created))
	for key := range created {
		keys = append(keys, key)
	}
	sort.Strings(keys)
	for _, key := range keys {
		blueprint := created[key]
		number := strconv.Itoa(blueprint.ID)
		if itemIndex[number] != nil {
			// Already emitted by an earlier apply; never duplicate a row.
			continue
		}
		donorItem := itemIndex[strconv.Itoa(blueprint.Donor)]
		if donorItem == nil {
			return nil, fmt.Errorf("供体武器 %d 缺少物品配置", blueprint.Donor)
		}
		donorAction := actionIndex[strconv.Itoa(blueprint.Donor)]
		if donorAction == nil {
			return nil, fmt.Errorf("供体武器 %d 缺少动作配置", blueprint.Donor)
		}
		itemRow := append([]string(nil), donorItem...)
		itemRow = setCell(itemRow, 0, "25")
		itemRow = setCell(itemRow, 1, number)
		itemRow = setCell(itemRow, 2, blueprint.Type)
		itemRow = setCell(itemRow, 3, blueprint.Name)
		itemRow = setCell(itemRow, 7, blueprint.Model)
		itemRow = setCell(itemRow, 9, "#")
		itemRow = setCell(itemRow, 16, blueprint.Name)
		itemText = appendTabRow(itemText, strings.Join(itemRow, "\t"))

		actionRow := append([]string(nil), donorAction...)
		actionRow = setCell(actionRow, 0, number)
		actionRow = setCell(actionRow, 1, blueprint.Name)
		actionText = appendTabRow(actionText, strings.Join(actionRow, "\t"))
	}
	items, err := encodeText(itemText)
	if err != nil {
		return nil, err
	}
	actions, err := encodeText(actionText)
	if err != nil {
		return nil, err
	}
	data, err := a.replace(map[string][]byte{"item.txt": items, "itemact.txt": actions})
	if err != nil {
		return nil, err
	}
	return parseArchive(data)
}

// validateBlueprint rejects anything the untouched client could not render or
// resolve. The model must already exist on disk: new RenderWare clumps cannot be
// authored from here.
func validateBlueprint(client string, source *archive, blueprint Blueprint) error {
	if blueprint.ID < blueprintMinID || blueprint.ID > blueprintMaxID {
		return fmt.Errorf("武器编号需在 %d..%d 之间", blueprintMinID, blueprintMaxID)
	}
	if name := blueprint.Name; name == "" || len([]rune(name)) > 24 || strings.ContainsAny(name, "\t\r\n") {
		return fmt.Errorf("武器名称需为 1..24 个字符且不含制表符")
	}
	switch blueprint.Type {
	case "1", "2", "3", "4", "5", "6", "7":
	default:
		return fmt.Errorf("武器子类无效")
	}
	if blueprint.Model == "" || filepath.Base(blueprint.Model) != blueprint.Model || !strings.EqualFold(filepath.Ext(blueprint.Model), ".dff") {
		return fmt.Errorf("模型文件名无效")
	}
	if _, err := os.Stat(filepath.Join(client, "Data", "Weapon", "Model", blueprint.Model)); err != nil {
		return fmt.Errorf("客户端缺少模型文件 %s，自建武器必须复用已有模型", blueprint.Model)
	}
	if blueprint.Donor == blueprint.ID {
		return fmt.Errorf("供体武器不能是自身")
	}
	if len([]rune(blueprint.Note)) > 200 {
		return fmt.Errorf("备注过长")
	}
	itemText, err := source.text("item.txt")
	if err != nil {
		return err
	}
	actionText, err := source.text("itemact.txt")
	if err != nil {
		return err
	}
	if itemRowIndex(itemText)[strconv.Itoa(blueprint.ID)] != nil {
		return fmt.Errorf("武器编号 %d 已存在", blueprint.ID)
	}
	donor := strconv.Itoa(blueprint.Donor)
	if itemRowIndex(itemText)[donor] == nil || actionRowIndex(actionText)[donor] == nil {
		return fmt.Errorf("供体武器 %d 不在本客户端可用的武器表中", blueprint.Donor)
	}
	return nil
}

type weaponState struct {
	Drafts      map[string][]Rule    `json:"drafts"`
	Applied     map[string][]Rule    `json:"applied"`
	Created     map[string]Blueprint `json:"created,omitempty"`
	Combos      map[string]int       `json:"combos,omitempty"`
	SourceHash  string               `json:"source_hash,omitempty"`
	AppliedHash string               `json:"applied_hash,omitempty"`
	// Targets holds one baseline and hash pair per managed client. The edit set
	// above is shared; each client is rendered onto its own baseline.
	Baselines map[string]*clientBaseline `json:"baselines,omitempty"`
}

func weaponHandle(request Request, client string, items []Item, folder string) (any, error) {
	if folder == "" {
		folder = filepath.Join(filepath.Dir(client), "weapon-config")
	}
	if err := os.MkdirAll(folder, 0700); err != nil {
		return nil, err
	}
	lockPath := filepath.Join(folder, "editing.lock")
	lock, err := os.OpenFile(lockPath, os.O_CREATE|os.O_EXCL|os.O_WRONLY, 0600)
	if err != nil {
		return nil, fmt.Errorf("另一项武器配置操作正在进行，请稍后重试：%w", err)
	}
	lock.Close()
	defer os.Remove(lockPath)
	statePath := filepath.Join(folder, "settings.json")
	state := weaponState{Drafts: map[string][]Rule{}, Applied: map[string][]Rule{}, Created: map[string]Blueprint{}}
	stateBytes, err := os.ReadFile(statePath)
	if err != nil && !os.IsNotExist(err) {
		return nil, err
	}
	if len(stateBytes) > 0 {
		if err = json.Unmarshal(stateBytes, &state); err != nil {
			return nil, err
		}
	}
	if state.Drafts == nil || state.Applied == nil {
		return nil, fmt.Errorf("配置方案状态不完整")
	}
	if state.Created == nil {
		state.Created = map[string]Blueprint{}
	}
	if state.Combos == nil {
		state.Combos = map[string]int{}
	}
	// The edit set is rendered onto whichever client the GM currently points at,
	// each client directory keeping its own baseline: the user can switch
	// clients, and a client can be refreshed by its own updater, so a single
	// shared baseline would silently overwrite those differences.
	entry := state.baselineFor(client)
	baseline := entry.path(folder)
	packagePath := configPath(client)
	sourcePath := baseline
	if _, err = os.Stat(baseline); os.IsNotExist(err) {
		sourcePath = packagePath
	} else if err != nil {
		return nil, err
	}
	source, err := loadArchive(sourcePath)
	if err != nil {
		return nil, err
	}
	if err = source.verify(); err != nil {
		return nil, err
	}
	if entry.SourceHash != "" && digest(source.data) != entry.SourceHash {
		return nil, fmt.Errorf("该客户端的基线备份已变化，已停止写入")
	}
	// Self-made weapons live in the same tables as the shipped ones, so the
	// inspection, isolation and rendering path below applies to them unchanged.
	// Combo registrations are layered on top: itemact.txt only says which
	// animation each state plays, delayacttable.xml is what lets the player
	// actually reach the next state, and a weapon without transitions cannot
	// chain attacks however complete its action row looks.
	plan := comboPlanOf(state.Created, state.Combos)
	base := source
	combo := comboResult{}
	if len(state.Created) > 0 {
		if base, err = applyBlueprints(source, state.Created); err != nil {
			return nil, err
		}
	}
	if len(plan) > 0 {
		if base, combo, err = applyComboTables(base, plan); err != nil {
			return nil, err
		}
	}
	if len(state.Created) > 0 || combo.Rows > 0 {
		text, err := base.text("item.txt")
		if err != nil {
			return nil, err
		}
		if items, err = itemsFromText(client, text, true); err != nil {
			return nil, err
		}
	}
	info, err := inspect(base, items)
	if err != nil {
		return nil, err
	}
	if err = annotateComboState(info, base); err != nil {
		return nil, err
	}
	current, err := os.ReadFile(packagePath)
	if err != nil {
		return nil, err
	}
	revision := digest(append(append([]byte(nil), current...), stateBytes...))
	if request.Operation == "weapon_catalog" {
		buffRows, err := buffs(base)
		if err != nil {
			return nil, err
		}
		return map[string]any{"weapons": info.weapons, "effects": effects(info), "fields": propertyFields, "buffs": buffRows, "drafts": state.Drafts, "applied": state.Applied, "created": state.Created, "combos": state.Combos, "client": describeClient(entry, folder), "clients": describeBaselines(&state, folder), "models": weaponModels(client), "types": weaponTypes, "used_ids": weaponItemIDs(source), "blueprint_min": blueprintMinID, "blueprint_max": blueprintMaxID, "revision": revision, "folder": folder}, nil
	}
	if request.Operation == "weapon_create" || request.Operation == "weapon_forget" {
		message := ""
		if request.Operation == "weapon_forget" {
			key := strconv.Itoa(request.Weapon)
			if _, ok := state.Created[key]; !ok {
				return nil, fmt.Errorf("该武器不是自建武器")
			}
			delete(state.Created, key)
			delete(state.Drafts, key)
			delete(state.Applied, key)
			delete(state.Combos, key)
			message = "已移除自建武器；重新应用或发布后才会从配置包消失"
		} else {
			if request.Blueprint == nil {
				return nil, fmt.Errorf("缺少武器蓝图")
			}
			blueprint := *request.Blueprint
			blueprint.Name = strings.TrimSpace(blueprint.Name)
			blueprint.Type = strings.TrimSpace(blueprint.Type)
			blueprint.Model = strings.TrimSpace(blueprint.Model)
			blueprint.Note = strings.TrimSpace(blueprint.Note)
			if err := validateBlueprint(client, source, blueprint); err != nil {
				return nil, err
			}
			key := strconv.Itoa(blueprint.ID)
			for other, existing := range state.Created {
				if other != key && existing.Name == blueprint.Name {
					return nil, fmt.Errorf("已有同名自建武器 %s", blueprint.Name)
				}
			}
			state.Created[key] = blueprint
			message = "已登记自建武器；保存效果并应用后写入配置包"
		}
		encoded, err := json.MarshalIndent(state, "", "  ")
		if err != nil {
			return nil, err
		}
		if err = atomicWrite(statePath, encoded); err != nil {
			return nil, err
		}
		return map[string]any{"created": state.Created, "revision": digest(append(append([]byte(nil), current...), encoded...)), "message": message}, nil
	}
	// weapon_combo completes the combo registration of an existing weapon. A
	// shipped weapon can carry a full action row yet own no transitions in
	// delayacttable.xml, which leaves it unchainable in game; borrowing another
	// weapon's state machine fixes it without touching the client binary.
	if request.Operation == "weapon_combo" {
		if request.Weapon == 0 {
			return nil, fmt.Errorf("请选择要补齐的武器")
		}
		target := strconv.Itoa(request.Weapon)
		actionText, err := base.text("itemact.txt")
		if err != nil {
			return nil, err
		}
		if actionRowIndex(actionText)[target] == nil {
			return nil, fmt.Errorf("武器 %s 不在本客户端的动作表中", target)
		}
		message := ""
		if request.Donor == 0 {
			if _, ok := state.Combos[target]; !ok {
				return nil, fmt.Errorf("该武器没有登记过连招补齐")
			}
			delete(state.Combos, target)
			message = "已取消连招补齐；重新应用后恢复原样"
		} else {
			donor := strconv.Itoa(request.Donor)
			if donor == target {
				return nil, fmt.Errorf("参考武器不能是自身")
			}
			itemText, err := base.text("item.txt")
			if err != nil {
				return nil, err
			}
			if itemRowIndex(itemText)[donor] == nil {
				return nil, fmt.Errorf("参考武器 %s 不在本客户端的武器表中", donor)
			}
			tableText, err := base.text("delayacttable.xml")
			if err != nil {
				return nil, fmt.Errorf("本客户端没有连招表，无法补齐")
			}
			tables := comboRowCounts(tableText)
			if tables[donor] == 0 {
				return nil, fmt.Errorf("参考武器 %s 自身也没有连招表，无法借用", donor)
			}
			if tables[target] > 0 {
				return nil, fmt.Errorf("该武器已有连招表，无需补齐")
			}
			state.Combos[target] = request.Donor
			message = fmt.Sprintf("已登记：借用参考武器的 %d 条连招；应用后生效", tables[donor])
		}
		encoded, err := json.MarshalIndent(state, "", "  ")
		if err != nil {
			return nil, err
		}
		if err = atomicWrite(statePath, encoded); err != nil {
			return nil, err
		}
		return map[string]any{"combos": state.Combos, "revision": digest(append(append([]byte(nil), current...), encoded...)), "message": message}, nil
	}
	// weapon_clients reports the selected client and every client we have a
	// baseline for. weapon_client_rebase re-captures the selected client's
	// baseline after something else replaced its config.spf2 — its own updater
	// does exactly that.
	if request.Operation == "weapon_clients" || request.Operation == "weapon_client_rebase" {
		message := ""
		if request.Operation == "weapon_client_rebase" {
			if err = ensureBaseline(entry, folder, true); err != nil {
				return nil, err
			}
			state.SourceHash = entry.SourceHash
			state.AppliedHash = entry.AppliedHash
			encoded, err := json.MarshalIndent(state, "", "  ")
			if err != nil {
				return nil, err
			}
			if err = atomicWrite(statePath, encoded); err != nil {
				return nil, err
			}
			message = "已按该客户端当前配置重新采集基线；旧基线已备份"
		}
		encoded, err := json.MarshalIndent(state, "", "  ")
		if err != nil {
			return nil, err
		}
		return map[string]any{
			"client":   describeClient(entry, folder),
			"clients":  describeBaselines(&state, folder),
			"revision": digest(append(append([]byte(nil), current...), encoded...)),
			"message":  message,
		}, nil
	}
	if request.Revision != revision {
		return nil, fmt.Errorf("配置已被其他操作更新，请重新打开武器配置后再保存")
	}
	var weapon *Weapon
	for index := range info.weapons {
		if info.weapons[index].ID == request.Weapon {
			weapon = &info.weapons[index]
			break
		}
	}
	if weapon == nil {
		return nil, fmt.Errorf("请选择本客户端的武器")
	}
	rules, err := validateRules(request.Rules, *weapon)
	if err != nil {
		return nil, err
	}
	key := strconv.Itoa(weapon.ID)
	if request.Operation == "weapon_publish" {
		if strings.TrimSpace(request.Notes) == "" || len(request.Notes) > 8000 {
			return nil, fmt.Errorf("请填写更新说明（最多 8000 字节）")
		}
		// Publish saved plans plus this editor, without overwriting local resources.
		plans := make(map[string][]Rule)
		for id, rules := range state.Applied {
			plans[id] = rules
		}
		for id, rules := range state.Drafts {
			plans[id] = rules
		}
		plans[key] = rules
		data, err := render(base, items, plans)
		if err != nil {
			return nil, err
		}
		check, err := parseArchive(data)
		if err != nil {
			return nil, err
		}
		if err = check.verify(); err != nil {
			return nil, err
		}
		names := []string{}
		for _, entry := range info.weapons {
			if _, exists := plans[strconv.Itoa(entry.ID)]; exists {
				names = append(names, entry.Name)
			}
		}
		state.Drafts[key] = rules
		encoded, err := json.MarshalIndent(state, "", "  ")
		if err != nil {
			return nil, err
		}
		if err = atomicWrite(statePath, encoded); err != nil {
			return nil, err
		}
		return weaponRelease{Data: data, Notes: "包含武器：" + strings.Join(names, "、") + "\n\n" + request.Notes}, nil
	}
	backup := ""
	message := "方案已保存，尚未应用到游戏"
	prepared := []*preparedClient{}
	switch request.Operation {
	case "weapon_save":
	case "weapon_apply", "weapon_restore":
		if runtime.GOOS == "windows" {
			command := exec.Command("tasklist", "/FI", "IMAGENAME eq gfld.dat", "/FO", "CSV", "/NH")
			hideWindow(command)
			output, err := command.Output()
			if err != nil {
				return nil, err
			}
			if bytes.Contains(bytes.ToLower(output), []byte("gfld.dat")) {
				return nil, fmt.Errorf("请先退出游戏客户端，再应用；可以先保存方案")
			}
		}
		if request.Operation == "weapon_restore" {
			delete(state.Applied, key)
			message = "该武器已恢复原效果；保存的方案仍保留"
		} else {
			state.Applied[key] = rules
			message = "配置已写入；启动游戏后加载，实战效果仍需验证"
		}
		// Render and validate before touching the disk: a failed guard must not
		// leave the client half-updated.
		plan, err := prepareClient(entry, folder, &state, state.Applied, info)
		if err != nil {
			return nil, err
		}
		prepared = append(prepared, plan)
		if err = commitClient(plan, folder); err != nil {
			return nil, err
		}
		backup = plan.Backup
		state.SourceHash = entry.SourceHash
		state.AppliedHash = entry.AppliedHash
	default:
		return nil, fmt.Errorf("未知武器配置操作")
	}
	if request.Operation != "weapon_restore" {
		state.Drafts[key] = rules
	}
	encoded, err := json.MarshalIndent(state, "", "  ")
	if err == nil {
		err = atomicWrite(statePath, encoded)
	}
	if err != nil {
		if len(prepared) > 0 {
			for _, plan := range prepared {
				if rollbackErr := atomicWrite(configPath(plan.Entry.Directory), plan.Current); rollbackErr != nil {
					return nil, fmt.Errorf("保存方案失败且回滚失败；请使用备份 %s：%v；%v", plan.Backup, err, rollbackErr)
				}
			}
		}
		return nil, err
	}
	var backupValue any
	if backup != "" {
		backupValue = backup
	}
	return map[string]any{"backup": backupValue, "message": message}, nil
}
