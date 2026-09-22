package bridge

import (
	"path/filepath"
	"testing"
)

func TestImagePathSupportsKnownClientNames(t *testing.T) {
	c := Config{ClientDirectory: t.TempDir()}
	for _, name := range []string{"", "gfld.dat", "gfxz.dat"} {
		c.ClientExecutable = name
		image, err := c.ImagePath()
		expected := name
		if expected == "" {
			expected = "gfld.dat"
		}
		if err != nil || image != filepath.Join(c.ClientDirectory, expected) {
			t.Fatalf("selected %q: %v", image, err)
		}
	}
	for _, name := range []string{"../gfxz.dat", "../gfld.dat", "other.exe"} {
		c.ClientExecutable = name
		if _, err := c.ImagePath(); err == nil {
			t.Fatalf("unsupported executable accepted: %s", name)
		}
	}
}
