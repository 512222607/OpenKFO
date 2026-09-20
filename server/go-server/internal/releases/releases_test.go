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

func TestClientReleaseResources(t *testing.T) {
	for _, extra := range []string{"UI/test.xml", "runtime.dll", "bridge.json", "gfld.dat", "Data/../escape", "Data/test. /x"} {
		var b bytes.Buffer
		z := zip.NewWriter(&b)
		for _, name := range []string{"Data/config.spf2", extra} {
			f, _ := z.Create(name)
			f.Write([]byte("config"))
		}
		z.Close()
		m := Manifest{Kind: "client", Version: "test", Notes: "client resources", SHA256: Hash(b.Bytes()), Size: int64(b.Len()), ConfigHash: Hash([]byte("config"))}
		m.Package = m.SHA256 + ".zip"
		want := extra == "UI/test.xml" || extra == "runtime.dll"
		if err := ValidatePackage(m, b.Bytes()); (err == nil) != want {
			t.Fatalf("%s: %v", extra, err)
		}
	}
}

func TestWeaponPublishKeepsClientResources(t *testing.T) {
	makePackage := func(kind, value string, extra bool) (Manifest, []byte) {
		var b bytes.Buffer
		z := zip.NewWriter(&b)
		f, _ := z.Create("Data/config.spf2")
		f.Write([]byte(value))
		if extra {
			f, _ = z.Create("UI/test.xml")
			f.Write([]byte("keep"))
		}
		z.Close()
		m := Manifest{Kind: kind, Version: value, Notes: "test", SHA256: Hash(b.Bytes()), Size: int64(b.Len()), ConfigHash: Hash([]byte(value))}
		m.Package = m.SHA256 + ".zip"
		return m, b.Bytes()
	}
	previous, old := makePackage("client", "old", true)
	next, update := makePackage("weapons", "new", false)
	m, data, err := MergeClient(previous, old, next, update)
	if err != nil {
		t.Fatal(err)
	}
	if m.Kind != "client" || m.ConfigHash != next.ConfigHash {
		t.Fatal(m)
	}
	z, _ := zip.NewReader(bytes.NewReader(data), int64(len(data)))
	if len(z.File) != 2 {
		t.Fatalf("lost resource: %d entries", len(z.File))
	}
	if err = ValidatePackage(m, data); err != nil {
		t.Fatal(err)
	}
}

func TestLauncherReleaseChecksum(t *testing.T) {
	var b bytes.Buffer
	z := zip.NewWriter(&b)
	f, _ := z.Create("launcher.exe")
	f.Write([]byte("executable"))
	z.Close()
	m := Manifest{Kind: "launcher", Version: "test", Notes: "launcher", SHA256: Hash(b.Bytes()), Size: int64(b.Len()), ExecutableHash: Hash([]byte("executable"))}
	m.Package = m.SHA256 + ".zip"
	if err := ValidatePackage(m, b.Bytes()); err != nil {
		t.Fatal(err)
	}
	m.ExecutableHash = Hash([]byte("different"))
	if ValidatePackage(m, b.Bytes()) == nil {
		t.Fatal("wrong executable hash accepted")
	}
}
