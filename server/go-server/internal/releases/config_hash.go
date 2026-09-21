package releases

import (
	"encoding/json"
	"os"
)

// ActiveConfigHash uses the same release precedence as the game server.
func ActiveConfigHash(configPath, updatesDir string) (string, error) {
	if updatesDir != "" {
		m, err := Load(updatesDir, "client")
		if os.IsNotExist(err) {
			m, err = Load(updatesDir, "weapons")
		}
		if err == nil {
			return m.ConfigHash, nil
		}
		if !os.IsNotExist(err) {
			return "", err
		}
	}
	raw, err := os.ReadFile(configPath)
	if err != nil {
		return "", err
	}
	var c struct {
		Hash string `json:"config_hash"`
	}
	if err = json.Unmarshal(raw, &c); err != nil {
		return "", err
	}
	return c.Hash, nil
}
