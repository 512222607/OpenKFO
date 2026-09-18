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
	"time"
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
	root.walk(func(node *xmlNode) {
		if node.tag != "Sequence" {
			return
		}
		sequence := Combo{Name: node.get("Name"), Nodes: []ComboNode{}}
		for _, child := range node.children {
			if child.comment {
				continue
			}
			keys := []string{}
			for _, input := range child.children {
				if input.get("Name") != "" {
					keys = append(keys, input.get("Name"))
				}
			}
			label := strings.Join(keys, "+")
			if label == "" {
				label = "原始按键未标注"
			}
			sequence.Nodes = append(sequence.Nodes, ComboNode{child.get("State"), label})
		}
		result = append(result, sequence)
	})
	return result, nil
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
	ID      int              `json:"id"`
	Name    string           `json:"name"`
	Stages  []Stage          `json:"stages"`
	Combos  []Combo          `json:"combos"`
	BuffIDs []int            `json:"buff_ids"`
	Allowed map[string][]int `json:"allowed_values"`
}
type block struct {
	original string
	node     *xmlNode
}
type inspection struct {
	weapons    []Weapon
	blocks     map[string][]block
	properties map[string][]*xmlNode
	ordered    []*xmlNode
}

var animationPattern = regexp.MustCompile(`(?s)<AnmDesc\b[^>]*>.*?</AnmDesc\s*>`)

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
	animation, err := a.text("animation/2001.xml")
	if err != nil {
		return nil, err
	}
	result := &inspection{weapons: []Weapon{}, blocks: map[string][]block{}, properties: map[string][]*xmlNode{}}
	for _, original := range animationPattern.FindAllString(animation, -1) {
		node, err := parseXML(original)
		if err != nil {
			return nil, err
		}
		result.blocks[node.get("id")] = append(result.blocks[node.get("id")], block{original, node})
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
	names := map[string]string{}
	for _, item := range items {
		if item.Kind == 25 {
			names[strconv.FormatUint(uint64(item.ID), 10)] = item.Name
		}
	}
	for _, row := range lines[1:] {
		name, ok := names[row[0]]
		if !ok {
			continue
		}
		sequences, err := combos(a, row[0])
		if err != nil {
			return nil, err
		}
		states := []string{"2011", "2012", "2013", "2014", "2015", "2016"}
		seen := map[string]bool{}
		for _, state := range states {
			seen[state] = true
		}
		for _, sequence := range sequences {
			for _, node := range sequence.Nodes {
				if _, exists := columns[node.State]; exists && !seen[node.State] {
					states = append(states, node.State)
					seen[node.State] = true
				}
			}
		}
		id, err := strconv.Atoi(row[0])
		if err != nil {
			return nil, err
		}
		weapon := Weapon{ID: id, Name: name, Stages: []Stage{}, Combos: sequences, BuffIDs: buffIDs, Allowed: allowed}
		for _, state := range states {
			column, ok := columns[state]
			if !ok || column >= len(row) {
				return nil, fmt.Errorf("招式列缺失")
			}
			action := row[column]
			if action == "0" {
				continue
			}
			number, err := strconv.Atoi(state)
			if err != nil {
				return nil, err
			}
			if number >= 2011 && number <= 2016 {
				number -= 2010
			}
			candidates := []block{}
			if strings.HasPrefix(action, "2001") {
				candidates = result.blocks[action[4:]]
			}
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
			} else if len(owners[action]) != 1 || !owners[action][row[0]+":"+state] {
				reason = "该动作被其他武器或招式共用，暂不可单独修改"
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
				label = state
			}
			if number <= 6 {
				label = fmt.Sprintf("第 %d 下 C", number)
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
	animation, err := a.text("animation/2001.xml")
	if err != nil {
		return nil, err
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
			source := info.blocks[stage.Action[4:]][0]
			changed := source.node.clone()
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
			animation = strings.Replace(animation, source.original, encoded, 1)
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
	encodedAnimation, err := encodeText(animation)
	if err != nil {
		return nil, err
	}
	encodedProperties, err := encodeText(properties)
	if err != nil {
		return nil, err
	}
	return a.replace(map[string][]byte{"animation/2001.xml": encodedAnimation, "skillproperty.xml": encodedProperties})
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

type weaponState struct {
	Drafts      map[string][]Rule `json:"drafts"`
	Applied     map[string][]Rule `json:"applied"`
	SourceHash  string            `json:"source_hash,omitempty"`
	AppliedHash string            `json:"applied_hash,omitempty"`
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
	state := weaponState{Drafts: map[string][]Rule{}, Applied: map[string][]Rule{}}
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
	baseline := filepath.Join(folder, "original.spf2")
	packagePath := filepath.Join(client, "Data", "config.spf2")
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
	if state.SourceHash != "" && digest(source.data) != state.SourceHash {
		return nil, fmt.Errorf("原始配置备份已变化，已停止写入")
	}
	info, err := inspect(source, items)
	if err != nil {
		return nil, err
	}
	current, err := os.ReadFile(packagePath)
	if err != nil {
		return nil, err
	}
	revision := digest(append(append([]byte(nil), current...), stateBytes...))
	if request.Operation == "weapon_catalog" {
		buffRows, err := buffs(source)
		if err != nil {
			return nil, err
		}
		return map[string]any{"weapons": info.weapons, "effects": effects(info), "fields": propertyFields, "buffs": buffRows, "drafts": state.Drafts, "applied": state.Applied, "revision": revision, "folder": folder}, nil
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
	backup := ""
	message := "方案已保存，尚未应用到游戏"
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
		expected := state.AppliedHash
		if expected == "" {
			expected = digest(source.data)
		}
		if digest(current) != expected {
			return nil, fmt.Errorf("游戏配置已被其他程序修改，已停止覆盖")
		}
		if request.Operation == "weapon_restore" {
			delete(state.Applied, key)
			message = "该武器已恢复原效果；保存的方案仍保留"
		} else {
			state.Applied[key] = rules
			message = "配置已写入；启动游戏后加载，实战效果仍需验证"
		}
		data, err := render(source, items, state.Applied)
		if err != nil {
			return nil, err
		}
		verified, err := parseArchive(data)
		if err != nil {
			return nil, err
		}
		if err = verified.verify(); err != nil {
			return nil, err
		}
		if _, err = verified.xml("skillproperty.xml"); err != nil {
			return nil, err
		}
		if _, err = verified.xml("animation/2001.xml"); err != nil {
			return nil, err
		}
		for name := range source.entries {
			after, err := verified.raw(name)
			if err != nil {
				return nil, err
			}
			if name == "animation/2001.xml" || name == "skillproperty.xml" {
				continue
			}
			before, err := source.raw(name)
			if err != nil {
				return nil, err
			}
			if !bytes.Equal(before, after) {
				return nil, fmt.Errorf("无关配置校验失败，未写入")
			}
		}
		if sourcePath == packagePath {
			if err = atomicWrite(baseline, source.data); err != nil {
				return nil, err
			}
		}
		backup = filepath.Join(folder, "before-"+time.Now().Format("20060102-150405.000000000")+".spf2")
		if err = atomicWrite(backup, current); err != nil {
			return nil, err
		}
		if err = atomicWrite(packagePath, data); err != nil {
			return nil, err
		}
		state.SourceHash = digest(source.data)
		state.AppliedHash = digest(data)
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
		if backup != "" {
			if rollbackErr := atomicWrite(packagePath, current); rollbackErr != nil {
				return nil, fmt.Errorf("保存方案失败且回滚失败；请使用备份 %s：%v；%v", backup, err, rollbackErr)
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
