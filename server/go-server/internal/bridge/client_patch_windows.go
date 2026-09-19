package bridge

import (
	"bytes"
	"fmt"
	"syscall"
	"unsafe"
)

// Verified gfld.dat: the worker sets 17C87DC=1 immediately before returning
// (A1661F). Killing it at 98DE6A can interrupt DLL thread-detach cleanup and
// strand a CRT lock. Close only its handle, allowing normal thread teardown.
// Keep the same 15-byte footprint and stdcall stack balance. Disk is untouched.
const loadingThreadCleanupAddress = uintptr(0x98de6a)

var loadingThreadCleanupOriginal = []byte{0x6a, 0x00, 0x8b, 0x15, 0x30, 0x87, 0x7c, 0x01, 0x52, 0xff, 0x15, 0x54, 0x30, 0xb3, 0x00}
var loadingThreadCleanupSafe = []byte{0x8b, 0x15, 0x30, 0x87, 0x7c, 0x01, 0x52, 0xff, 0x15, 0x88, 0x30, 0xb3, 0x00, 0x90, 0x90}

func patchClientMemory(process syscall.Handle, address uintptr, expected, replacement []byte) error {
	if len(expected) == 0 || len(expected) != len(replacement) {
		return fmt.Errorf("invalid client patch length")
	}
	n := uintptr(len(expected))
	current := make([]byte, n)
	var count uintptr
	ok, _, err := kernel.NewProc("ReadProcessMemory").Call(uintptr(process), address, uintptr(unsafe.Pointer(&current[0])), n, uintptr(unsafe.Pointer(&count)))
	if ok == 0 || count != n || !bytes.Equal(current, expected) {
		return fmt.Errorf("unsupported client bytes at %#x: %v", address, err)
	}
	var old uint32
	ok, _, err = kernel.NewProc("VirtualProtectEx").Call(uintptr(process), address, n, 0x40, uintptr(unsafe.Pointer(&old)))
	if ok == 0 {
		return err
	}
	ok, _, writeErr := kernel.NewProc("WriteProcessMemory").Call(uintptr(process), address, uintptr(unsafe.Pointer(&replacement[0])), n, uintptr(unsafe.Pointer(&count)))
	var ignored uint32
	restored, _, restoreErr := kernel.NewProc("VirtualProtectEx").Call(uintptr(process), address, n, uintptr(old), uintptr(unsafe.Pointer(&ignored)))
	if ok == 0 || count != n {
		return fmt.Errorf("client patch write at %#x: %v", address, writeErr)
	}
	if restored == 0 {
		return restoreErr
	}
	ok, _, err = kernel.NewProc("FlushInstructionCache").Call(uintptr(process), address, n)
	if ok == 0 {
		return err
	}
	return nil
}
