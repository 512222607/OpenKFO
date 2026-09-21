package bridge

import (
	"path/filepath"
	"testing"
)

func TestImagePathOnlySupportsGfld(t *testing.T) {
	c := Config{ClientDirectory: t.TempDir()}
	for _, name := range []string{"", "gfld.dat"} {
		c.ClientExecutable = name
		image, err := c.ImagePath()
		if err != nil || image != filepath.Join(c.ClientDirectory, "gfld.dat") {
			t.Fatalf("selected %q: %v", image, err)
		}
	}
	for _, name := range []string{"gfxz.dat", "../gfld.dat", "other.exe"} {
		c.ClientExecutable = name
		if _, err := c.ImagePath(); err == nil {
			t.Fatalf("unsupported executable accepted: %s", name)
		}
	}
}
