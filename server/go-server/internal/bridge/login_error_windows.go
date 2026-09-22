//go:build windows

package bridge

import (
	"syscall"
	"unsafe"
)

func showLoginFailure(identity Identity, image, message string) {
	current, err := processIdentity(identity.PID, image)
	if err != nil || current != identity {
		return
	}
	user := syscall.NewLazyDLL("user32.dll")
	var owner uintptr
	callback := syscall.NewCallback(func(window, parameter uintptr) uintptr {
		var pid uint32
		user.NewProc("GetWindowThreadProcessId").Call(window, uintptr(unsafe.Pointer(&pid)))
		visible, _, _ := user.NewProc("IsWindowVisible").Call(window)
		if pid == identity.PID && visible != 0 {
			owner = window
			return 0
		}
		return 1
	})
	user.NewProc("EnumWindows").Call(callback, 0)
	if owner == 0 {
		return
	}
	title, _ := syscall.UTF16PtrFromString("登录未完成")
	detail, _ := syscall.UTF16PtrFromString(message)
	const messageBoxWarning = 0x30
	user.NewProc("MessageBoxW").Call(owner, uintptr(unsafe.Pointer(detail)), uintptr(unsafe.Pointer(title)), messageBoxWarning)
}
