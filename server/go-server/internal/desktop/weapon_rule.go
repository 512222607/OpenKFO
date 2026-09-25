package desktop

import (
	"fmt"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

// comborule.xml is the third weapon registration table in the archive. Where
// delayacttable.xml says which key advances a state machine, this one limits
// what the state machine is allowed to reach:
//
//	<ComboRule Weapon="253108">
//	  <!--最多成功命中 3 次，超过后不再命中-->
//	  <MaxComboForSkill Skill="2001899" MaxCombo="3"/>
//	  <!--最后一击改用别的状态/被动-->
//	  <MaxComboForSkill Skill="1380410" MaxCombo="2" ExceedState="3005" ExceedSkillProID=""/>
//	  <BlackListItem PrevSkill="1080120" CurSkill="1080130"/>   <!--两招不能连-->
//	  <WhiteListItem PrevSkill="1080120" CurSkill="1080140"/>   <!--只能接这一招-->
//	</ComboRule>
//
// The file ships its own authoring notes at the bottom (宁超 2011-8-2), quoted
// above. The critical detail is what Skill/PrevSkill/CurSkill actually name:
// they are the skillproid of the *action block* a state plays, not the state
// number and not the weapon id:
//
//	itemact state 2031 -> action 2001133031
//	  -> animation/2001.xml <AnmDesc id="133031">
//	     -> skillproid="1330310"   <-- this is what ComboRule names
//
// A clone weapon keeps its donor's block ids, so its rules must use the donor's
// numbering too; the shipped data does exactly that (253943 -> 942xxxx,
// 253937 -> 126xxxx, 253156 -> 157xxxx).
//
// Note that the trailing authoring note contains a literal <ComboRule> example
// inside an XML comment. Matching naively would treat that example as a real
// rule for 253108 and, worse, rewriting it would corrupt the documentation, so
// every scan below skips comment spans.
var (
	comboRuleBlockPattern = regexp.MustCompile(`(?s)<ComboRule\s+Weapon\s*=\s*"(\d+)"\s*>(.*?)</ComboRule\s*>`)
	comboRuleRootEnd      = regexp.MustCompile(`</ComboRuleList\s*>`)
	xmlCommentPattern     = regexp.MustCompile(`(?s)<!--.*?-->`)

	maxComboPattern = regexp.MustCompile(
		`<MaxComboForSkill\s+Skill\s*=\s*"([^"]*)"\s+MaxCombo\s*=\s*"([^"]*)"([^>]*)/>`)
	blackItemPattern = regexp.MustCompile(
		`<BlackListItem\s+PrevSkill\s*=\s*"([^"]*)"\s+CurSkill\s*=\s*"([^"]*)"\s*/>`)
	whiteItemPattern = regexp.MustCompile(
		`<WhiteListItem\s+PrevSkill\s*=\s*"([^"]*)"\s+CurSkill\s*=\s*"([^"]*)"\s*/>`)
	exceedAttrPattern = regexp.MustCompile(`(ExceedState|ExceedSkillProID)\s*=\s*"([^"]*)"`)
)

// ComboRuleMax is one <MaxComboForSkill>: the skill may land MaxCombo times, and
// the optional Exceed fields redirect the blow that exceeds the limit.
type ComboRuleMax struct {
	Skill            string `json:"skill"`
	MaxCombo         string `json:"max_combo"`
	ExceedState      string `json:"exceed_state,omitempty"`
	ExceedSkillProID string `json:"exceed_skill_pro_id,omitempty"`
}

// ComboRuleLink is one <BlackListItem> or <WhiteListItem>.
type ComboRuleLink struct {
	Prev string `json:"prev"`
	Cur  string `json:"cur"`
}

// ComboRuleSet is everything one weapon may declare in comborule.xml.
type ComboRuleSet struct {
	Max   []ComboRuleMax  `json:"max,omitempty"`
	Black []ComboRuleLink `json:"black,omitempty"`
	White []ComboRuleLink `json:"white,omitempty"`
}

func (s ComboRuleSet) empty() bool {
	return len(s.Max) == 0 && len(s.Black) == 0 && len(s.White) == 0
}

// commentSpans lists the byte ranges covered by XML comments. Both parsing and
// rewriting consult it so the authoring notes at the bottom of comborule.xml are
// never mistaken for data and never rewritten.
func commentSpans(text string) [][2]int {
	spans := [][2]int{}
	for _, at := range xmlCommentPattern.FindAllStringIndex(text, -1) {
		spans = append(spans, [2]int{at[0], at[1]})
	}
	return spans
}

func inSpans(spans [][2]int, offset int) bool {
	for _, span := range spans {
		if offset >= span[0] && offset < span[1] {
			return true
		}
	}
	return false
}

// comboRuleBlock is one real <ComboRule> found in the file.
type comboRuleBlock struct {
	Weapon string
	Body   string
	Start  int
	End    int
}

// comboRuleBlocks finds every real <ComboRule> block, skipping the examples the
// authoring comment contains.
func comboRuleBlocks(text string) []comboRuleBlock {
	spans := commentSpans(text)
	blocks := []comboRuleBlock{}
	for _, at := range comboRuleBlockPattern.FindAllStringSubmatchIndex(text, -1) {
		if inSpans(spans, at[0]) {
			continue
		}
		blocks = append(blocks, comboRuleBlock{
			Weapon: text[at[2]:at[3]],
			Body:   text[at[4]:at[5]],
			Start:  at[0],
			End:    at[1],
		})
	}
	return blocks
}

// comboRuleSetOf merges every block registered for one weapon. The shipped file
// has 253043 declared twice, so merging (rather than taking the first) is the
// only reading that loses nothing.
func comboRuleSetOf(text, weapon string) (ComboRuleSet, bool) {
	set := ComboRuleSet{}
	found := false
	for _, block := range comboRuleBlocks(text) {
		if block.Weapon != weapon {
			continue
		}
		found = true
		for _, match := range maxComboPattern.FindAllStringSubmatch(block.Body, -1) {
			entry := ComboRuleMax{Skill: match[1], MaxCombo: match[2]}
			for _, attr := range exceedAttrPattern.FindAllStringSubmatch(match[3], -1) {
				if attr[1] == "ExceedState" {
					entry.ExceedState = attr[2]
				} else {
					entry.ExceedSkillProID = attr[2]
				}
			}
			set.Max = append(set.Max, entry)
		}
		for _, match := range blackItemPattern.FindAllStringSubmatch(block.Body, -1) {
			set.Black = append(set.Black, ComboRuleLink{Prev: match[1], Cur: match[2]})
		}
		for _, match := range whiteItemPattern.FindAllStringSubmatch(block.Body, -1) {
			set.White = append(set.White, ComboRuleLink{Prev: match[1], Cur: match[2]})
		}
	}
	return set, found
}

// comboRuleWeapons lists the weapons the client already constrains, so the
// editor can tell official data from its own additions.
func comboRuleWeapons(text string) map[string]bool {
	weapons := map[string]bool{}
	for _, block := range comboRuleBlocks(text) {
		weapons[block.Weapon] = true
	}
	return weapons
}

func (s ComboRuleSet) render(weapon string) string {
	lines := []string{"\t<ComboRule Weapon=\"" + weapon + "\">"}
	for _, entry := range s.Max {
		attributes := []string{"Skill=\"" + entry.Skill + "\"", "MaxCombo=\"" + entry.MaxCombo + "\""}
		if entry.ExceedState != "" {
			attributes = append(attributes, "ExceedState=\""+entry.ExceedState+"\"")
		}
		if entry.ExceedSkillProID != "" {
			attributes = append(attributes, "ExceedSkillProID=\""+entry.ExceedSkillProID+"\"")
		}
		lines = append(lines, "\t\t<MaxComboForSkill "+strings.Join(attributes, " ")+" />")
	}
	for _, link := range s.Black {
		lines = append(lines, "\t\t<BlackListItem PrevSkill=\""+link.Prev+"\" CurSkill=\""+link.Cur+"\" />")
	}
	for _, link := range s.White {
		lines = append(lines, "\t\t<WhiteListItem PrevSkill=\""+link.Prev+"\" CurSkill=\""+link.Cur+"\" />")
	}
	lines = append(lines, "\t</ComboRule>")
	return strings.Join(lines, "\n") + "\n"
}

// comboRuleMarker names the block the editor added, so a later edit removes its
// own note along with the block instead of stacking a new one on every save.
const comboRuleMarker = "<!--编辑器定制的连招限制-->"

// lineIndentStart walks back to the start of the line, but only when everything
// between is indentation. A block that shares its line with other markup (the
// compact fixtures do) must not have its neighbours swallowed.
func lineIndentStart(text string, start int) int {
	at := start
	for at > 0 && text[at-1] != '\n' {
		at--
	}
	for index := at; index < start; index++ {
		if text[index] != ' ' && text[index] != '\t' && text[index] != '\r' {
			return start
		}
	}
	return at
}

// comboRuleOwnedStart is the first byte the editor may rewrite for a block: the
// whole indented line when the block already carries the editor's note, or just
// the block's own line for shipped data (the comments above a block belong to
// the original author and are left alone).
func comboRuleOwnedStart(text string, block comboRuleBlock) int {
	cut := block.Start
	for cut > 0 && (text[cut-1] == ' ' || text[cut-1] == '\t' || text[cut-1] == '\n' || text[cut-1] == '\r') {
		cut--
	}
	if strings.HasSuffix(text[:cut], comboRuleMarker) {
		return lineIndentStart(text, cut-len(comboRuleMarker))
	}
	return lineIndentStart(text, block.Start)
}

// comboRuleOwnedEnd is the byte just past the block plus the line break that
// closes it, so removing a block removes its line instead of leaving a blank one
// behind that would grow on every save.
func comboRuleOwnedEnd(text string, block comboRuleBlock) int {
	end := block.End
	for end < len(text) && (text[end] == ' ' || text[end] == '\t' || text[end] == '\r') {
		end++
	}
	if end < len(text) && text[end] == '\n' {
		end++
	}
	return end
}

// renderBlock is the editor's own output: a marker line naming who wrote it,
// then the rules.
func (s ComboRuleSet) renderBlock(weapon string) string {
	return "\t" + comboRuleMarker + "\n" + s.render(weapon)
}

// setComboRules writes one weapon's rules. The first block the weapon owns is
// replaced where it stands so repeated saves keep the weapon's position in the
// file (and stay byte-identical no matter in which order weapons are saved), any
// duplicate blocks are merged away, and a weapon with no block of its own gets
// one inserted before the list's closing tag. Other weapons' rules and the
// authoring comment are never touched.
func setComboRules(text, weapon string, rules ComboRuleSet) (string, error) {
	if closing := comboRuleRootEnd.FindAllStringIndex(text, -1); len(closing) != 1 {
		return "", fmt.Errorf("连招限制表结构错误")
	}
	owned := []comboRuleBlock{}
	for _, block := range comboRuleBlocks(text) {
		if block.Weapon == weapon {
			owned = append(owned, block)
		}
	}
	if len(owned) == 0 {
		if rules.empty() {
			return text, nil
		}
		at := comboRuleRootEnd.FindStringIndex(text)
		if at == nil {
			return "", fmt.Errorf("连招限制表结构错误")
		}
		return text[:at[0]] + rules.renderBlock(weapon) + text[at[0]:], nil
	}
	var builder strings.Builder
	cursor := 0
	for index, block := range owned {
		builder.WriteString(text[cursor:comboRuleOwnedStart(text, block)])
		cursor = comboRuleOwnedEnd(text, block)
		if index == 0 && !rules.empty() {
			builder.WriteString(rules.renderBlock(weapon))
		}
	}
	builder.WriteString(text[cursor:])
	return builder.String(), nil
}

// applyComboRules writes the author-authored rule sets into comborule.xml. The
// entry already exists in the archive, so this stays inside the writer's
// replace-only contract.
func applyComboRules(a *archive, rules map[string]ComboRuleSet) (*archive, error) {
	if len(rules) == 0 {
		return a, nil
	}
	text, err := a.text("comborule.xml")
	if err != nil {
		return nil, err
	}
	keys := make([]string, 0, len(rules))
	for key := range rules {
		keys = append(keys, key)
	}
	sort.Strings(keys)
	changed := false
	for _, key := range keys {
		set := rules[key]
		before := text
		if text, err = setComboRules(text, key, set); err != nil {
			return nil, err
		}
		if text != before {
			changed = true
		}
	}
	if !changed {
		return a, nil
	}
	encoded, err := encodeText(text)
	if err != nil {
		return nil, err
	}
	data, err := a.replace(map[string][]byte{"comborule.xml": encoded})
	if err != nil {
		return nil, err
	}
	return parseArchive(data)
}

// SkillOption is one skillproid the selected weapon can actually name in a
// ComboRule, together with the state that plays it and the block's own comment.
// Offering these instead of a free-text box is what keeps authors from typing a
// number that no action block ever references — a rule naming an unknown skill
// simply never fires.
type SkillOption struct {
	Skill string `json:"skill"`
	State string `json:"state"`
	Label string `json:"label"`
	Block string `json:"block"`
}

// skillOptions walks the weapon's stages, resolves each stage's action to its
// animation block and collects the skillproid of every hit-property node inside.
// Several skills can share one block (253133's block 133041 declares 1330410,
// 1330411 and 1330412 for 低挑/劈/高挑), so all of them are listed.
func skillOptions(info *inspection, weapon Weapon) []SkillOption {
	seen := map[string]bool{}
	options := []SkillOption{}
	for _, stage := range weapon.Stages {
		if stage.Action == "" || stage.Action == "0" {
			continue
		}
		for _, candidate := range info.blocks[actionKey(stage.Action)] {
			ids := []string{}
			candidate.node.walk(func(node *xmlNode) {
				if ref := node.get("skillproid"); ref != "" && ref != "0" {
					ids = append(ids, ref)
				}
			})
			label := actionDescription(candidate.node)
			if label == "" {
				label = stage.Label
			}
			for _, id := range ids {
				if seen[id] {
					continue
				}
				seen[id] = true
				options = append(options, SkillOption{
					Skill: id,
					State: stage.State,
					Label: label,
					Block: actionKey(stage.Action),
				})
			}
		}
	}
	sort.Slice(options, func(i, j int) bool {
		if options[i].Skill != options[j].Skill {
			return options[i].Skill < options[j].Skill
		}
		return options[i].State < options[j].State
	})
	return options
}

// weaponByID finds one inspected weapon by its id.
func weaponByID(info *inspection, key string) (Weapon, bool) {
	for _, weapon := range info.weapons {
		if strconv.Itoa(weapon.ID) == key {
			return weapon, true
		}
	}
	return Weapon{}, false
}

// comboRuleEditable decides whether the editor may write this weapon's rules.
// Self-made weapons are always fair game, and so is any weapon the client does
// not constrain yet — adding a limit where none exists cannot damage shipped
// data. Rewriting a block that ships in the client is refused, which keeps the
// original rule set recoverable from the baseline alone.
func comboRuleEditable(state *weaponState, key string, official, overridden bool) bool {
	if overridden {
		return true
	}
	if _, selfMade := state.Created[key]; selfMade {
		return true
	}
	return !official
}

// comboRuleView is the read side of the editor: the effective rule set, the
// rules that ship with the client, whether the weapon may be edited at all, and
// every skillproid its action blocks actually declare. shipped must be the
// pristine baseline — base already carries this editor's own overrides, so
// reading the "official" rules from it would report the override as shipped.
func comboRuleView(shipped *archive, info *inspection, state *weaponState, key, revision string) map[string]any {
	stored, overridden := state.ComboRules[key]
	official := false
	officialRules := ComboRuleSet{}
	if text, err := shipped.text("comborule.xml"); err == nil {
		if parsed, found := comboRuleSetOf(text, key); found {
			officialRules, official = parsed, true
		}
	}
	effective := stored
	if !overridden {
		effective = officialRules
	}
	weapon, _ := weaponByID(info, key)
	options := skillOptions(info, weapon)
	editable := comboRuleEditable(state, key, official, overridden)
	reason := ""
	if !editable {
		reason = "本客户端已内置该武器的连招限制，属官方数据，编辑器只改自建武器与未登记限制的武器"
	}
	return map[string]any{
		"weapon":         key,
		"rules":          effective,
		"shipped":        officialRules,
		"official":       official,
		"overridden":     overridden,
		"editable":       editable,
		"reason":         reason,
		"skills":         options,
		"unknown_skills": unknownComboSkills(effective, options),
		"revision":       revision,
	}
}
// validateComboRuleSet keeps the editor from writing a rule the client cannot
// use. Skill identifiers are free-form on purpose: a clone weapon legitimately
// names its donor's block ids, which live outside its own 2xxx stages, so an
// unknown number is reported as a warning rather than refused.
func validateComboRuleSet(set ComboRuleSet) error {
	check := func(field, value string) error {
		if value == "" {
			return fmt.Errorf("%s 不能为空", field)
		}
		number, err := strconv.Atoi(value)
		if err != nil || number < 1000 || number > 99999999 {
			return fmt.Errorf("%s 必须是动作块被动编号（如 1330310）", field)
		}
		return nil
	}
	for _, entry := range set.Max {
		if err := check("Skill", entry.Skill); err != nil {
			return err
		}
		limit, err := strconv.Atoi(entry.MaxCombo)
		if err != nil || limit < 1 || limit > 999 {
			return fmt.Errorf("最大命中次数必须是 1..999 之间的整数")
		}
		if entry.ExceedState != "" {
			if number, err := strconv.Atoi(entry.ExceedState); err != nil || number < 1000 || number > 9999 {
				return fmt.Errorf("ExceedState 必须是四位状态号（如 3005）")
			}
		}
		if entry.ExceedSkillProID != "" {
			if err := check("ExceedSkillProID", entry.ExceedSkillProID); err != nil {
				return err
			}
		}
	}
	// 校验只挡"写进去游戏读不懂"的数据，不挡官方自己就在用的写法：
	//
	// 1. Prev == Cur 就是"同一个技能不能连续放"这条规则本身。官方 comborule.xml
	//    的 373 条黑名单里有 85 条这样的自环（253013 的 80819 → 80819 就是一例，
	//    253164 一口气 6 条），以前当非法拒掉，官方数据既改不动也补不回来。
	// 2. 白名单的 CurSkill 允许为空，含义是"这个前招之后什么都不许接"
	//    （官方 253147 就靠它实现 ZC/ZX 只能接爆气：CurSkill=""）。
	//    黑名单官方没有空值用例，两端都必须是编号。
	for _, link := range set.Black {
		if err := check("PrevSkill", link.Prev); err != nil {
			return err
		}
		if err := check("CurSkill", link.Cur); err != nil {
			return err
		}
	}
	for _, link := range set.White {
		if err := check("PrevSkill", link.Prev); err != nil {
			return err
		}
		if link.Cur == "" {
			continue
		}
		if err := check("CurSkill", link.Cur); err != nil {
			return err
		}
	}
	return nil
}

// unknownComboSkills reports which numbers in a rule set no action block of the
// weapon declares. The editor shows them as a warning; the write still happens
// because donor-numbered clones are legitimate.
func unknownComboSkills(set ComboRuleSet, options []SkillOption) []string {
	known := map[string]bool{}
	for _, option := range options {
		known[option.Skill] = true
	}
	unknown := map[string]bool{}
	add := func(value string) {
		if value != "" && !known[value] {
			unknown[value] = true
		}
	}
	for _, entry := range set.Max {
		add(entry.Skill)
		add(entry.ExceedSkillProID)
	}
	for _, link := range append(append([]ComboRuleLink{}, set.Black...), set.White...) {
		add(link.Prev)
		add(link.Cur)
	}
	result := make([]string, 0, len(unknown))
	for value := range unknown {
		result = append(result, value)
	}
	sort.Strings(result)
	return result
}
