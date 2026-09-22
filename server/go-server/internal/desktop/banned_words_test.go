package desktop

import (
	"encoding/json"
	"kungfu.local/server/internal/persistence"
	"testing"
)

func TestBannedWordsTransport(t *testing.T) {
	a := &Admin{Remote: func(r persistence.AdminRequest) (json.RawMessage, error) {
		if r.BannedWords == nil || r.BannedWords.Revision != 4 || len(r.BannedWords.Words) != 2 {
			t.Fatal("fields lost")
		}
		return json.RawMessage(`{"revision":5,"words":["SB","CNM"]}`), nil
	}}
	if _, err := a.Call(Request{Environment: "online", Operation: "banned_words_save", BannedWords: &persistence.BannedWordsSettings{Revision: 4, Words: []string{"SB", "CNM"}}}); err != nil {
		t.Fatal(err)
	}
}
