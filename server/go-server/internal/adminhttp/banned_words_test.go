package adminhttp

import (
	"kungfu.local/server/internal/desktop"
	"kungfu.local/server/internal/gmversion"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestBannedWordsRequireAdminAndVersion(t *testing.T) {
	token := strings.Repeat("x", 32)
	calls := 0
	h := New(token, func(r desktop.Request) (any, error) {
		calls++
		if r.BannedWords == nil || len(r.BannedWords.Words) != 1 {
			t.Fatal("lost words")
		}
		return r.BannedWords, nil
	})
	for _, tc := range []struct {
		auth, version string
		status        int
	}{{"", "1.1.0", 401}, {"Bearer " + token, "old", 409}, {"Bearer " + token, "1.1.0", 200}} {
		if tc.status == 200 {
			if e := gmversion.Check(tc.version); e != nil {
				t.Fatal(e)
			}
		}
		r := httptest.NewRequest("POST", "/gm/api", strings.NewReader(`{"operation":"banned_words_save","environment":"online","gm_version":"`+tc.version+`","banned_words":{"revision":1,"words":["SB"]}}`))
		r.Header.Set("Authorization", tc.auth)
		w := httptest.NewRecorder()
		h.ServeHTTP(w, r)
		if w.Code != tc.status {
			t.Fatal(w.Code, tc.status)
		}
	}
	if calls != 1 {
		t.Fatal(calls)
	}
}
