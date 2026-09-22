package persistence

import (
	"errors"
	"github.com/go-sql-driver/mysql"
	"os"
	"strings"
	"testing"
	"time"
)

func TestBannedWordsRejectNamesBeforeDatabase(t *testing.T) {
	s := &Store{}
	if _, err := s.RoleManager().Rename(1, "SHABI"); !errors.Is(err, ErrBannedWord) {
		t.Fatal(err)
	}
	p, choices := characterFixture()
	for i := 0; i < 21; i++ {
		p[i] = 0
	}
	copy(p, GBK("幹你娘"))
	if _, err := s.RoleManager().CreateCharacter(1, p, choices); !errors.Is(err, ErrBannedWord) {
		t.Fatal(err)
	}
}
func TestBannedWordsMySQL(t *testing.T) {
	dsn := os.Getenv("OPENKFO_DEBUG_DSN")
	if dsn == "" {
		t.Skip("isolated DB required")
	}
	cfg, err := mysql.ParseDSN(dsn)
	if err != nil || !strings.HasPrefix(cfg.DBName, "openkfo_debug_") {
		t.Fatal("refusing non-debug database")
	}
	s, err := Open(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer s.DB.Close()
	other, err := OpenExisting(dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer other.DB.Close()
	if err = s.SeedBannedWords([]string{"CNM", "SB"}); err != nil {
		t.Fatal(err)
	}
	if !errors.Is(other.CheckText("ＳＢ"), ErrBannedWord) {
		t.Fatal("seed not enforced")
	}
	rules, err := s.BannedWords()
	if err != nil {
		t.Fatal(err)
	}
	old := rules
	rules.Words = []string{"测试坏词"}
	saved, err := s.SaveBannedWords(rules)
	if err != nil || saved.Revision != rules.Revision+1 {
		t.Fatal(saved, err)
	}
	if _, err = s.SaveBannedWords(old); err == nil {
		t.Fatal("stale update overwrote rules")
	}
	if err = s.SeedBannedWords([]string{"do-not-overwrite"}); err != nil {
		t.Fatal(err)
	}
	time.Sleep(1100 * time.Millisecond)
	if !errors.Is(other.CheckText("測試壞詞"), ErrBannedWord) {
		t.Fatal("cross-process refresh failed")
	}
	if err = other.CheckText("SB"); err != nil {
		t.Fatal("removed rule remains active", err)
	}
	saved.Words = nil
	if _, err = s.SaveBannedWords(saved); err != nil {
		t.Fatal(err)
	}
	if err = s.CheckText("测试坏词"); err != nil {
		t.Fatal("intentional empty list ignored", err)
	}
}
