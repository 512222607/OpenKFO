package gmversion

import "testing"

func TestExactVersion(t *testing.T) {
	for _, v := range []string{"", "1.0.0", "1.1.0 ", "1.1.0"} {
		if (Check(v) == nil) != (v == Current) {
			t.Fatalf("version %q", v)
		}
	}
}
