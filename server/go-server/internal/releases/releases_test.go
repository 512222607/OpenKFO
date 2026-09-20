package releases

import (
	"archive/zip"
	"bytes"
	"net/http/httptest"
	"os"
	"path/filepath"
	"testing"
)

func TestReleaseBoundaries(t *testing.T) {
	for _, name := range []string{"Data/config.spf2", "../escape", "Data\\config.spf2", "bridge.json"} {
		var b bytes.Buffer
		z := zip.NewWriter(&b)
		f, _ := z.Create(name)
		f.Write([]byte("config"))
		z.Close()
		m := Manifest{Kind: "weapons", Version: "1", Notes: "test", SHA256: Hash(b.Bytes()), Size: int64(b.Len()), ConfigHash: Hash([]byte("config"))}
		m.Package = m.SHA256 + ".zip"
		if err := ValidatePackage(m, b.Bytes()); (err == nil) != (name == "Data/config.spf2") {
			t.Fatalf("%s: %v", name, err)
		}
	}
	dir := t.TempDir()
	os.WriteFile(filepath.Join(dir, "secret"), []byte("private"), 0600)
	for _, path := range []string{"/updates/../secret", "/updates/secret", "/updates/weapon.json"} {
		w := httptest.NewRecorder()
		Handler(dir).ServeHTTP(w, httptest.NewRequest("GET", path, nil))
		if w.Code != 404 {
			t.Fatal(path, w.Code)
		}
	}
}
