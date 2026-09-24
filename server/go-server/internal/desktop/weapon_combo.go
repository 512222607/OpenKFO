package desktop

import (
	"fmt"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

// The client keeps a per-weapon combo state machine in delayacttable.xml:
//
//	<Item WeaponTypeId ="253089" OldState="2011" NewState="2012" KeyInput="1" StartPart="1"/>
//
// Pressing the key named by KeyInput (see <KeyInputList> in the same file:
// 1 = normal attack, 2 = special, 3 = aim, 4 = jump, 5 = forward, 6 = back)
// while the weapon sits in OldState moves it to NewState. itemact.txt only
// declares which animation plays in each state; without a transition row the
// state can never advance, so the weapon cannot chain attacks at all.
//
// action effects are registered separately in acteffect.xml:
//
//	<WeaponEffect ItemID = "253089"> <EffectFile .../> ... </WeaponEffect>
//
// Some shipped weapons were authored by copying another weapon's itemact row
// but never got either registration, which is exactly why an untouched client
// can show a complete 招式 list in the editor yet refuse to combo in game.
var (
	comboRowPattern = regexp.MustCompile(
		`<Item\s+WeaponTypeId\s*=\s*"(\d+)"\s+OldState\s*=\s*"(\d+)"\s+NewState\s*=\s*"(\d+)"\s+KeyInput\s*=\s*"(\d+)"\s+StartPart\s*=\s*"(\d+)"\s*/>`)
	comboListEndPattern = regexp.MustCompile(`</ItemList\s*>`)
	effectBlockPattern  = regexp.MustCompile(
		`(?s)<WeaponEffect\s+ItemID\s*=\s*"(\d+)"\s*>(.*?)</WeaponEffect\s*>`)
	effectRootEndPattern = regexp.MustCompile(`</ActEffect\s*>`)
)

// comboRow is one parsed transition; keeping the fields instead of the raw text
// lets a cloned row be re-emitted with a consistent attribute shape.
type comboRow struct {
	OldState string
	NewState string
	KeyInput string
	StartPart string
}

func (r comboRow) render(weapon string) string {
	return fmt.Sprintf(`<Item WeaponTypeId ="%s" OldState="%s" NewState="%s" KeyInput="%s" StartPart="%s"/>`,
		weapon, r.OldState, r.NewState, r.KeyInput, r.StartPart)
}

// comboRowsOf collects the transitions registered for one weapon id.
func comboRowsOf(text, weapon string) []comboRow {
	rows := []comboRow{}
	for _, match := range comboRowPattern.FindAllStringSubmatch(text, -1) {
		if match[1] != weapon {
			continue
		}
		rows = append(rows, comboRow{OldState: match[2], NewState: match[3], KeyInput: match[4], StartPart: match[5]})
	}
	return rows
}

// comboRowCounts reports how many transitions each weapon has, so the editor
// can flag the ones the client will refuse to chain.
func comboRowCounts(text string) map[string]int {
	counts := map[string]int{}
	for _, match := range comboRowPattern.FindAllStringSubmatch(text, -1) {
		counts[match[1]]++
	}
	return counts
}

// appendComboRows copies a donor's transitions onto another weapon. It is a
// no-op when the target already has rows, so repeated applies stay idempotent.
func appendComboRows(text, donor, target string) (string, int, error) {
	rows := comboRowsOf(text, donor)
	if len(rows) == 0 {
		return text, 0, fmt.Errorf("参考武器 %s 没有连招表，无法借用", donor)
	}
	if len(comboRowsOf(text, target)) > 0 {
		return text, 0, nil
	}
	closing := comboListEndPattern.FindAllStringIndex(text, -1)
	if len(closing) != 1 {
		return text, 0, fmt.Errorf("连招表结构错误")
	}
	rebuilt := make([]string, 0, len(rows))
	for _, row := range rows {
		rebuilt = append(rebuilt, row.render(target))
	}
	block := "\n\t<!--自建/补齐：借用 " + donor + " 的连招-->\n\t" + strings.Join(rebuilt, "\n\t") + "\n"
	at := closing[0][0]
	return text[:at] + block + text[at:], len(rebuilt), nil
}

// effectBlockOf returns the raw <WeaponEffect> body registered for a weapon.
func effectBlockOf(text, weapon string) (string, bool) {
	for _, match := range effectBlockPattern.FindAllStringSubmatch(text, -1) {
		if match[1] == weapon {
			return match[2], true
		}
	}
	return "", false
}

// appendEffectBlock copies a donor's action-effect registration onto another
// weapon. Missing entries only cost visuals, so failures are reported to the
// caller instead of aborting the whole write.
func appendEffectBlock(text, donor, target string) (string, bool) {
	body, ok := effectBlockOf(text, donor)
	if !ok {
		return text, false
	}
	if _, exists := effectBlockOf(text, target); exists {
		return text, false
	}
	closing := effectRootEndPattern.FindAllStringIndex(text, -1)
	if len(closing) != 1 {
		return text, false
	}
	block := "\n<!--自建/补齐：借用 " + donor + " 的动作特效-->\n\t<WeaponEffect ItemID = \"" + target + "\">" +
		body + "</WeaponEffect>\n"
	at := closing[0][0]
	return text[:at] + block + text[at:], true
}

// comboPlan maps a weapon that needs registrations to the donor it borrows from.
type comboPlan map[string]string

// comboPlanOf merges the donors implied by self-made blueprints with the
// explicit completion requests stored in the editor state.
func comboPlanOf(created map[string]Blueprint, combos map[string]int) comboPlan {
	plan := comboPlan{}
	for key, blueprint := range created {
		if blueprint.Donor > 0 {
			plan[key] = strconv.Itoa(blueprint.Donor)
		}
	}
	for target, donor := range combos {
		if donor > 0 {
			plan[target] = strconv.Itoa(donor)
		}
	}
	return plan
}

// comboResult summarises what one completion pass actually wrote.
type comboResult struct {
	Weapons int
	Rows    int
	Effects int
}

// applyComboTables returns a configuration in which every weapon in the plan
// owns a combo state machine (and, when the donor has one, an action-effect
// block). Both target files already exist in the archive, so this stays inside
// the writer's replace-only contract.
func applyComboTables(a *archive, plan comboPlan) (*archive, comboResult, error) {
	summary := comboResult{}
	if len(plan) == 0 {
		return a, summary, nil
	}
	targets := make([]string, 0, len(plan))
	for target := range plan {
		targets = append(targets, target)
	}
	sort.Strings(targets)

	replacements := map[string][]byte{}
	for _, file := range []string{"delayacttable.xml", "acteffect.xml"} {
		text, err := a.text(file)
		if err != nil {
			continue
		}
		changed := false
		for _, target := range targets {
			donor := plan[target]
			if file == "delayacttable.xml" {
				next, rows, err := appendComboRows(text, donor, target)
				if err != nil {
					return nil, summary, err
				}
				if rows > 0 {
					text, changed = next, true
					summary.Rows += rows
					summary.Weapons++
				}
				continue
			}
			if next, ok := appendEffectBlock(text, donor, target); ok {
				text, changed = next, true
				summary.Effects++
			}
		}
		if changed {
			encoded, err := encodeText(text)
			if err != nil {
				return nil, summary, err
			}
			replacements[file] = encoded
		}
	}
	if len(replacements) == 0 {
		return a, summary, nil
	}
	data, err := a.replace(replacements)
	if err != nil {
		return nil, summary, err
	}
	result, err := parseArchive(data)
	if err != nil {
		return nil, summary, err
	}
	return result, summary, nil
}

// annotateComboState fills in the combo/effect columns of the catalogue so the
// editor can warn about weapons the client will refuse to chain. Both files are
// optional: a client that ships without them simply has nothing to report.
func annotateComboState(info *inspection, a *archive) error {
	counts := map[string]int{}
	if text, err := a.text("delayacttable.xml"); err == nil {
		counts = comboRowCounts(text)
	}
	effects := map[string]bool{}
	if text, err := a.text("acteffect.xml"); err == nil {
		for _, match := range effectBlockPattern.FindAllStringSubmatch(text, -1) {
			effects[match[1]] = true
		}
	}
	actionLines := [][]string{}
	if text, err := a.text("itemact.txt"); err == nil {
		for _, line := range splitRows(text) {
			actionLines = append(actionLines, line)
		}
	}
	suggestions := comboSuggestions(actionLines, counts)
	for i := range info.weapons {
		weapon := &info.weapons[i]
		key := strconv.Itoa(weapon.ID)
		weapon.ComboRows = counts[key]
		weapon.Effects = effects[key]
		if weapon.ComboRows == 0 {
			weapon.ComboSuggestion = suggestions[weapon.ID]
		}
	}
	return nil
}

// comboSuggestions picks, for every weapon with no transitions, the shipped
// weapon whose itemact row matches it best. A weapon distilled from a donor
// (like 混沌宇宙 from 龙拳) matches on every shared action column, so the
// suggestion is normally exactly the original template.
func comboSuggestions(actionLines [][]string, counts map[string]int) map[int]int {
	suggestions := map[int]int{}
	rows := map[string][]string{}
	for _, row := range actionLines {
		if len(row) >= 2 {
			rows[row[0]] = row
		}
	}
	candidates := []string{}
	for id, count := range counts {
		if count > 0 {
			candidates = append(candidates, id)
		}
	}
	sort.Strings(candidates)
	for id, row := range rows {
		if counts[id] > 0 {
			continue
		}
		target, err := strconv.Atoi(id)
		if err != nil {
			continue
		}
		best, bestScore := 0, 0
		for _, candidate := range candidates {
			other := rows[candidate]
			score := 0
			for i := 2; i < len(row) && i < len(other); i++ {
				if row[i] != "" && row[i] == other[i] {
					score++
				}
			}
			if score <= bestScore {
				continue
			}
			if number, err := strconv.Atoi(candidate); err == nil {
				best, bestScore = number, score
			}
		}
		if best > 0 {
			suggestions[target] = best
		}
	}
	return suggestions
}

// keyInputNames maps a delayacttable KeyInput id to its human label (see the
// <KeyInputList> comments in the same file).
var keyInputNames = map[string]string{
	"1":  "普通攻击",
	"2":  "特殊攻击",
	"3":  "瞄准",
	"4":  "跳跃",
	"5":  "前",
	"6":  "后",
	"7":  "必杀",
	"8":  "C+C",
	"9":  "C+C",
	"10": "防御",
	"11": "C+X",
	"12": "C+Z",
	"13": "C+X",
	"20": "向前",
	"21": "向后",
}

func keyInputLabel(key string) string {
	if name, ok := keyInputNames[key]; ok {
		return name
	}
	return "按键" + key
}

// comboChain returns the delayacttable transitions for one weapon, annotated
// with the human labels of both states, so the editor can draw the chain
// instead of a flat stage list.
func comboChain(a *archive, info *inspection, weaponID string) []map[string]string {
	text, err := a.text("delayacttable.xml")
	if err != nil {
		return nil
	}
	rows := comboRowsOf(text, weaponID)
	if len(rows) == 0 {
		return nil
	}
	labels := map[string]string{}
	for _, weapon := range info.weapons {
		if strconv.Itoa(weapon.ID) != weaponID {
			continue
		}
		for _, stage := range weapon.Stages {
			labels[stage.State] = stage.Label
		}
		break
	}
	label := func(state string) string {
		if text, ok := labels[state]; ok && text != "" {
			return state + " · " + text
		}
		return state
	}
	result := make([]map[string]string, 0, len(rows))
	for _, row := range rows {
		result = append(result, map[string]string{
			"old":       row.OldState,
			"new":       row.NewState,
			"key":       row.KeyInput,
			"key_label": keyInputLabel(row.KeyInput),
			"old_label": label(row.OldState),
			"new_label": label(row.NewState),
		})
	}
	return result
}

// ComboTransition is one author-authored edge of a weapon's combo state
// machine: from OldState, pressing KeyInput (see keyInputNames) advances to
// NewState.
type ComboTransition struct {
	OldState  string `json:"old"`
	NewState  string `json:"new"`
	KeyInput  string `json:"key"`
	StartPart string `json:"part,omitempty"`
}

func (t ComboTransition) row() comboRow {
	part := t.StartPart
	if part == "" {
		part = "1"
	}
	return comboRow{OldState: t.OldState, NewState: t.NewState, KeyInput: t.KeyInput, StartPart: part}
}

// setComboRows replaces every transition a weapon owns with the given set,
// leaving the rest of delayacttable.xml intact.
func setComboRows(text, weapon string, rows []comboRow) (string, error) {
	lines := strings.Split(text, "\n")
	out := make([]string, 0, len(lines))
	for _, line := range lines {
		trimmed := strings.TrimSpace(line)
		if strings.HasPrefix(trimmed, "<Item") {
			if match := comboRowPattern.FindStringSubmatch(trimmed); match != nil && match[1] == weapon {
				continue
			}
		}
		out = append(out, line)
	}
	rebuilt := make([]string, 0, len(rows))
	for _, row := range rows {
		rebuilt = append(rebuilt, "\t"+row.render(weapon))
	}
	text = strings.Join(out, "\n")
	closing := comboListEndPattern.FindAllStringIndex(text, -1)
	if len(closing) != 1 {
		return "", fmt.Errorf("连招表结构错误")
	}
	block := "\t<!--编辑器定制的连招-->\n" + strings.Join(rebuilt, "\n") + "\n"
	at := closing[0][0]
	return text[:at] + block + text[at:], nil
}

// applyComboChains writes the author-authored state machines into
// delayacttable.xml, replacing the existing rows (and any borrowed donor rows)
// for each weapon that has one.
func applyComboChains(a *archive, chains map[string][]ComboTransition) (*archive, error) {
	if len(chains) == 0 {
		return a, nil
	}
	text, err := a.text("delayacttable.xml")
	if err != nil {
		return nil, err
	}
	keys := make([]string, 0, len(chains))
	for key := range chains {
		keys = append(keys, key)
	}
	sort.Strings(keys)
	for _, key := range keys {
		rows := make([]comboRow, 0, len(chains[key]))
		for _, transition := range chains[key] {
			rows = append(rows, transition.row())
		}
		if text, err = setComboRows(text, key, rows); err != nil {
			return nil, err
		}
	}
	encoded, err := encodeText(text)
	if err != nil {
		return nil, err
	}
	data, err := a.replace(map[string][]byte{"delayacttable.xml": encoded})
	if err != nil {
		return nil, err
	}
	return parseArchive(data)
}
