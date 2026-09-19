package desktop

import (
	"crypto/sha256"
	"fmt"
	"os"
	"strings"
	"testing"
)

func TestBaseQuestNativeArchive(t *testing.T) {
	path := os.Getenv("OPENKFO_CLIENT_ARCHIVE")
	if path == "" {
		t.Skip("archive required")
	}
	before, e := os.ReadFile(path)
	if e != nil {
		t.Fatal(e)
	}
	rows, hash, e := readBaseQuestCatalogue(path)
	if e != nil {
		t.Fatal(e)
	}
	if hash != fmt.Sprintf("%x", sha256.Sum256(before)) {
		t.Fatal("catalogue hash mismatch")
	}
	if len(rows) != 50 || rows[0].ID != 1001 || rows[0].Matches != 10 || rows[0].Next != 1002 || !rows[0].Enabled {
		t.Fatal("native task catalogue mismatch", len(rows))
	}
	if rows[5].ID != 1006 || rows[5].Counters[0] != 16 {
		t.Fatal("native counter alignment mismatch")
	}
	after, e := os.ReadFile(path)
	if e != nil {
		t.Fatal(e)
	}
	if sha256.Sum256(before) != sha256.Sum256(after) {
		t.Fatal("client archive changed")
	}
	t.Logf("Read %d BaseQuest templates; archive unchanged", len(rows))
}

func TestBaseQuestTemplateValidation(t *testing.T) {
	f := make([]string, 41)
	for i := range f {
		f[i] = "0"
	}
	f[38] = "7"
	f[0], f[1], f[5], f[7], f[35], f[40] = "1001", "test", "10", "16", "29", "1"
	line := strings.Join(f, "\t")
	r, e := baseQuests("\ufeff" + line + "\r\n")
	if e != nil || len(r) != 1 || r[0].Counters[0] != 16 || r[0].Counters[28] != 29 || r[0].TitleLevel != 7 || r[0].UnknownRank != 7 {
		t.Fatal(r, e)
	}
	for _, c := range []struct {
		i int
		v string
	}{{0, "65536"}, {5, "-1"}, {7, "4294967296"}, {36, "65536"}, {39, "1002"}, {39, "1001"}, {40, "2"}} {
		copyFields := append([]string(nil), f...)
		copyFields[c.i] = c.v
		if _, e := baseQuests(strings.Join(copyFields, "\t")); e == nil {
			t.Fatal("invalid field accepted", c)
		}
	}
	for _, text := range []string{"", line + "\n" + line, strings.Join(f[:40], "\t")} {
		if _, e := baseQuests(text); e == nil {
			t.Fatal("invalid template accepted")
		}
	}
}
