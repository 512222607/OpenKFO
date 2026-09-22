package moderation

import (
	"fmt"
	"strings"
	"testing"
)

func TestNormalizationAndDefaults(t *testing.T) {
	words, e := Clean(DefaultWords())
	if e != nil {
		t.Fatal(e)
	}
	f := Compile(words)
	for _, text := range []string{"SB", "ＳＢ", "s-h-a-b-i", "C N M", "傻逼", "幹你娘", "屌你老母", "冚家鏟", "腦殘", "你是s.b啊", "c\u200bnm"} {
		if !f.Contains(text) {
			t.Errorf("not blocked: %q", text)
		}
	}
	for _, text := range []string{"功夫小子", "今天一起打团战", "装备武器", "台湾香港澳门", "test001", "准备好了", "中国玩家"} {
		if f.Contains(text) {
			t.Errorf("false positive: %q", text)
		}
	}
}
func TestLargeDictionaryAndValidation(t *testing.T) {
	words := make([]string, MaxWords)
	for i := range words {
		words[i] = fmt.Sprintf("blocked%dword", i)
	}
	clean, e := Clean(words)
	if e != nil {
		t.Fatal(e)
	}
	if !Compile(clean).Contains("beforeblocked49999wordafter") {
		t.Fatal("last entry missing")
	}
	for _, words := range [][]string{{"!!!"}, {strings.Repeat("字", 65)}, make([]string, MaxWords+1), {string([]byte{255})}} {
		if _, e := Clean(words); e == nil {
			t.Fatal("invalid list accepted")
		}
	}
	clean, e = Clean(Parse("\ufeffSB\n sb,ＳＢ；腦殘\r\n脑残"))
	if e != nil || len(clean) != 2 {
		t.Fatal(clean, e)
	}
	if Compile(nil).Contains("text") {
		t.Fatal("empty dictionary blocked all")
	}
}

func TestLeaderNamesAndVariants(t *testing.T) {
	f := Compile(DefaultWords())
	for _, name := range []string{
		"陈独秀", "周恩来", "朱鎔基", "習近平", "李強", "丁薛祥", "何立峰",
		"趙樂際", "王滬寧", "鐵凝", "雪克來提·扎克爾", "帕巴拉·格列朗傑",
		"蔣介石", "賴清德", "林鄭月娥", "李家超", "何厚鏵", "岑浩輝",
		"习\u200b近 平", "王-沪-宁",
	} {
		for _, content := range []string{name, "玩家说" + name + "你好"} {
			if !f.Contains(content) {
				t.Errorf("leader name not blocked: %q", content)
			}
		}
	}
	for _, content := range []string{"主席", "总理", "中华人民共和国", "台湾香港澳门玩家", "准备开始团战"} {
		if f.Contains(content) {
			t.Errorf("ordinary content blocked: %q", content)
		}
	}
}
