package game

import "fmt"

// This key is distributed to launchers; it is not a server authentication secret.
func (c Config) ValidateLauncherCredentials() error {
	if c.LauncherCredentialsKey == "" {
		return nil
	}
	if len(c.LauncherCredentialsKey) != 16 {
		return fmt.Errorf("launcher_credentials_key must contain 16 printable ASCII characters")
	}
	for _, b := range []byte(c.LauncherCredentialsKey) {
		if b < 33 || b > 126 {
			return fmt.Errorf("launcher_credentials_key must contain 16 printable ASCII characters")
		}
	}
	return nil
}
