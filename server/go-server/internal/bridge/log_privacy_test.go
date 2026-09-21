package bridge

import (
	"bytes"
	"strings"
	"testing"
)

func TestPrivateLogWriter(t *testing.T) {
	var out bytes.Buffer
	w := PrivateLogWriter{&out}
	input := "dial tcp 192.0.2.1:19091->127.0.0.1:18001: timeout; wss://game.example.top/kk/tunnel; lookup game.example.top on [::1]:53; sdk_port=18000 uid=42 channel=2 elapsed=130ms\n"
	n, err := w.Write([]byte(input))
	if err != nil || n != len(input) {
		t.Fatal(n, err)
	}
	for _, secret := range []string{"192.0.2", "127.0.0", "19091", "18001", "18000", "example.top", "::1", ":53"} {
		if strings.Contains(out.String(), secret) {
			t.Fatal(out.String())
		}
	}
	if !strings.Contains(out.String(), "uid=42 channel=2 elapsed=130ms") {
		t.Fatal(out.String())
	}
}
