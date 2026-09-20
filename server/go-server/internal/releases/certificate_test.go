package releases

import (
	"net/http/httptest"
	"os"
	"path/filepath"
	"testing"
)

func TestOnlyPublicLoginCertificateIsServed(t *testing.T) {
	dir := t.TempDir()
	for _, name := range []string{"login.crt", "login.key"} {
		if err := os.WriteFile(filepath.Join(dir, name), []byte(name), 0600); err != nil {
			t.Fatal(err)
		}
	}
	for _, name := range []string{"login.crt", "login.key"} {
		w := httptest.NewRecorder()
		Handler(dir).ServeHTTP(w, httptest.NewRequest("GET", "/updates/"+name, nil))
		want := 404
		if name == "login.crt" {
			want = 200
		}
		if w.Code != want {
			t.Fatalf("%s: status %d", name, w.Code)
		}
	}
}
