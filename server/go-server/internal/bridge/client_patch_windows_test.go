package bridge

import (
	"bytes"
	"syscall"
	"testing"
	"unsafe"
)

func TestClientMemoryPatchRequiresExactOriginal(t *testing.T) {
	address, _, err := kernel.NewProc("VirtualAlloc").Call(0, 4096, 0x3000, 0x04)
	if address == 0 {
		t.Fatal(err)
	}
	defer kernel.NewProc("VirtualFree").Call(address, 0, 0x8000)
	buf := unsafe.Slice((*byte)(unsafe.Pointer(address)), len(loadingThreadCleanupOriginal))
	copy(buf, loadingThreadCleanupOriginal)
	process, err := syscall.GetCurrentProcess()
	if err != nil {
		t.Fatal(err)
	}
	wrong := append([]byte(nil), loadingThreadCleanupOriginal...)
	wrong[0] ^= 1
	if patchClientMemory(process, address, wrong, loadingThreadCleanupSafe) == nil || !bytes.Equal(buf, loadingThreadCleanupOriginal) {
		t.Fatal("mismatched client must not be patched")
	}
	if err := patchClientMemory(process, address, loadingThreadCleanupOriginal, loadingThreadCleanupSafe); err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(buf, loadingThreadCleanupSafe) {
		t.Fatal("patch not installed")
	}
}
