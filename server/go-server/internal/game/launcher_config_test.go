package game

import "testing"

func TestLauncherCredentialsKey(t *testing.T) {
	for _, c := range []struct {
		key   string
		valid bool
	}{{"", true}, {"1234567890abcde", false}, {"1234567890abcdef", true}, {"1234567890abcde ", false}, {"1234567890abcde界", false}} {
		if err := (Config{LauncherCredentialsKey: c.key}).ValidateLauncherCredentials(); (err == nil) != c.valid {
			t.Errorf("key validation: valid=%v error=%v", c.valid, err)
		}
	}
}
