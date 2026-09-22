package moderation

import (
	_ "embed"
	"fmt"
	"golang.org/x/text/unicode/norm"
	"sort"
	"strings"
	"unicode"
	"unicode/utf8"
)

const MaxWords = 50000
const MaxWordRunes = 64
const MaxFileBytes = 2 << 20
const Notice = "违禁词！"

//go:embed default_words.txt
var defaults string

// OpenCC TSCharacters.txt, Apache-2.0; see OPENCC-LICENSE.
//go:embed traditional.txt
var traditional string
var simplified = func() map[rune]rune {
	out := map[rune]rune{}
	for _, line := range strings.Split(traditional, "\n") {
		if strings.HasPrefix(line, "#") {
			continue
		}
		fields := strings.Fields(line)
		if len(fields) >= 2 {
			a, b := []rune(fields[0]), []rune(fields[1])
			if len(a) == 1 && len(b) == 1 {
				out[a[0]] = b[0]
			}
		}
	}
	return out
}()

func Normalize(s string) string {
	var b strings.Builder
	for _, r := range strings.ToLower(norm.NFKC.String(s)) {
		if v, ok := simplified[r]; ok {
			r = v
		}
		if unicode.IsLetter(r) || unicode.IsNumber(r) {
			b.WriteRune(r)
		}
	}
	return b.String()
}
func DefaultWords() []string { return strings.Fields(defaults) }

// TXT imports accept one word per line or comma/semicolon-separated entries.
func Parse(text string) []string {
	return strings.FieldsFunc(strings.TrimPrefix(text, "\ufeff"), func(r rune) bool { return r == '\n' || r == '\r' || r == ',' || r == '，' || r == ';' || r == '；' })
}
func Clean(words []string) ([]string, error) {
	if len(words) > MaxWords {
		return nil, fmt.Errorf("最多 %d 条违禁词", MaxWords)
	}
	unique := map[string]string{}
	size := 0
	for _, word := range words {
		word = strings.TrimSpace(word)
		if word == "" {
			continue
		}
		size += len(word)
		if !utf8.ValidString(word) || utf8.RuneCountInString(word) > MaxWordRunes || size > MaxFileBytes {
			return nil, fmt.Errorf("违禁词过长、编码无效或词库过大")
		}
		key := Normalize(word)
		if utf8.RuneCountInString(key) > MaxWordRunes {
			return nil, fmt.Errorf("规范化后的违禁词过长")
		}
		if key == "" {
			return nil, fmt.Errorf("违禁词不能仅包含符号：%q", word)
		}
		if _, ok := unique[key]; !ok {
			unique[key] = word
		}
	}
	result := make([]string, 0, len(unique))
	for _, w := range unique {
		result = append(result, w)
	}
	sort.Strings(result)
	return result, nil
}

type node struct {
	next     map[rune]*node
	terminal bool
}
type Filter struct{ root node }

func Compile(words []string) *Filter {
	f := &Filter{}
	for _, word := range words {
		if Normalize(word) == "" {
			continue
		}
		n := &f.root
		for _, r := range Normalize(word) {
			if n.next == nil {
				n.next = map[rune]*node{}
			}
			if n.next[r] == nil {
				n.next[r] = &node{}
			}
			n = n.next[r]
		}
		n.terminal = true
	}
	return f
}

// Inputs are short native fields. At most MaxWordRunes transitions per start,
// independent of the number of dictionary entries.
func (f *Filter) Contains(text string) bool {
	if f == nil {
		return false
	}
	chars := []rune(Normalize(text))
	for i := range chars {
		n := &f.root
		for j := i; j < len(chars) && j-i < MaxWordRunes; j++ {
			n = n.next[chars[j]]
			if n == nil {
				break
			}
			if n.terminal {
				return true
			}
		}
	}
	return false
}
