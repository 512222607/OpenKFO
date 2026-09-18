package bridge

import (
	"os"
	"path/filepath"
	"syscall"
	"testing"
)

func TestInstancePorts(t *testing.T) {
	for _, example := range []struct {
		name, config string
		login        int
		invalid      bool
	}{
		{"legacy", `{}`, 18084, false},
		{"second", `{"login_port":18184,"sdk_port":18100,"game_port":18101}`, 18184, false},
		{"duplicate", `{"login_port":18000}`, 0, true},
		{"out of range", `{"game_port":65536}`, 0, true},
	} {
		t.Run(example.name, func(t *testing.T) {
			path := filepath.Join(t.TempDir(), "bridge.json")
			if err := os.WriteFile(path, []byte(example.config), 0600); err != nil {
				t.Fatal(err)
			}
			config, err := LoadConfig(path)
			if (err != nil) != example.invalid {
				t.Fatalf("unexpected error: %v", err)
			}
			if err == nil && config.LoginPort != example.login {
				t.Fatalf("login port: %d", config.LoginPort)
			}
		})
	}
}

func TestLauncherLocksArePerInstance(t *testing.T) {
	first, duplicate, err := AcquireLauncher(49184)
	if err != nil {
		t.Fatal(err)
	}
	defer syscall.CloseHandle(first)
	if duplicate {
		t.Fatal("unexpected existing test launcher")
	}
	second, duplicate, err := AcquireLauncher(49185)
	if err != nil {
		t.Fatal(err)
	}
	defer syscall.CloseHandle(second)
	if duplicate {
		t.Fatal("separate instance shares launcher lock")
	}
	repeated, duplicate, err := AcquireLauncher(49184)
	if err != nil {
		t.Fatal(err)
	}
	defer syscall.CloseHandle(repeated)
	if !duplicate {
		t.Fatal("same instance did not retain duplicate guard")
	}
}
