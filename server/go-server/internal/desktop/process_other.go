//go:build !windows

package desktop

import "os/exec"

func hideWindow(command *exec.Cmd) {}
