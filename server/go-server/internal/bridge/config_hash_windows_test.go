//go:build windows

package bridge

import (
	"context"
	"crypto/sha256"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestResourceMismatchDoesNotBlockBridgeStartup(t *testing.T) {
	root := t.TempDir()
	if err := os.Mkdir(filepath.Join(root, "Data"), 0700); err != nil {
		t.Fatal(err)
	}
	for name, data := range map[string]string{"gfld.dat": "image", "Data/config.spf2": "new resources"} {
		if err := os.WriteFile(filepath.Join(root, name), []byte(data), 0600); err != nil {
			t.Fatal(err)
		}
	}
	c := Config{ClientDirectory: root, ClientSHA256: fmt.Sprintf("%x", sha256.Sum256([]byte("image"))), ConfigHash: strings.Repeat("a", 64), LoginCertificate: filepath.Join(root, "missing.crt")}
	// Reaching the certificate load proves the stale resource hash was accepted.
	if err := Run(context.Background(), c, false); !os.IsNotExist(err) {
		t.Fatalf("wanted missing certificate after resource check, got %v", err)
	}
	c.ClientSHA256 = strings.Repeat("b", 64)
	if err := Run(context.Background(), c, false); err == nil || !strings.Contains(err.Error(), "client file mismatch: gfld.dat") {
		t.Fatalf("executable check lost: %v", err)
	}
}
