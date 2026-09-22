//go:build windows

package main

import (
	"fmt"
	"os"
	"runtime"
	"strconv"
	"syscall"
	"time"
	"unsafe"
)

type rect struct{ L, T, R, B int32 }
type point struct{ X, Y int32 }

const (
	fpsLayered        = 0x00080000
	fpsColorKey       = 0x00000001
	fpsGreen          = 0x0000ff00
	wmPaint           = 0x000f
	wmEraseBackground = 0x0014
)

type paintState struct {
	DC              uintptr
	Erase           int32
	Area            rect
	Restore, Update int32
	Reserved        [32]byte
}

func fps(args []string) error {
	if len(args) != 4 {
		return fmt.Errorf("FPS 参数无效")
	}
	pid, _ := strconv.ParseUint(args[0], 10, 32)
	created, _ := strconv.ParseUint(args[1], 10, 64)
	address, _ := strconv.ParseUint(args[2], 10, 32)
	h, err := identity(request{PID: uint32(pid), Created: created, Image: args[3]})
	if err != nil {
		return err
	}
	defer syscall.CloseHandle(h)
	mutex, _, _ := kernel.NewProc("CreateMutexW").Call(0, 0, uintptr(unsafe.Pointer(utf(fmt.Sprintf("Local\\OpenKFO-FPS-%d-%d", pid, created)))))
	if mutex == 0 {
		return fmt.Errorf("FPS lock failed")
	}
	defer syscall.CloseHandle(syscall.Handle(mutex))
	if r, _ := syscall.WaitForSingleObject(syscall.Handle(mutex), 0); r != 0 && r != 0x80 {
		return nil
	}
	defer kernel.NewProc("ReleaseMutex").Call(mutex)
	memory, err := syscall.OpenProcess(0x10, false, uint32(pid))
	if err != nil {
		return err
	}
	defer syscall.CloseHandle(memory)
	runtime.LockOSThread()
	defer runtime.UnlockOSThread()
	owner := gameWindow(uint32(pid))
	deadline := time.Now().Add(30 * time.Second)
	for owner == 0 && time.Now().Before(deadline) {
		var code uint32
		if syscall.GetExitCodeProcess(h, &code) != nil || code != 259 {
			return nil
		}
		time.Sleep(100 * time.Millisecond)
		owner = gameWindow(uint32(pid))
	}
	if owner == 0 {
		return fmt.Errorf("等待游戏窗口超时，无法显示 FPS")
	}
	// Black is the transparency key; paint only green text in the overlay.
	gdi := syscall.NewLazyDLL("gdi32.dll")
	paint := syscall.NewCallback(func(window, message, wp, lp uintptr) uintptr {
		if message == wmEraseBackground {
			return 1
		}
		if message == wmPaint {
			var ps paintState
			dc, _, _ := user.NewProc("BeginPaint").Call(window, uintptr(unsafe.Pointer(&ps)))
			var bounds rect
			user.NewProc("GetClientRect").Call(window, uintptr(unsafe.Pointer(&bounds)))
			const blackBrush = 4
			brush, _, _ := gdi.NewProc("GetStockObject").Call(blackBrush)
			user.NewProc("FillRect").Call(dc, uintptr(unsafe.Pointer(&bounds)), brush)
			gdi.NewProc("SetTextColor").Call(dc, fpsGreen)
			const transparentBackground = 1
			gdi.NewProc("SetBkMode").Call(dc, transparentBackground)
			var text [64]uint16
			length, _, _ := user.NewProc("GetWindowTextW").Call(window, uintptr(unsafe.Pointer(&text[0])), uintptr(len(text)))
			const centeredSingleLine = 0x0001 | 0x0004 | 0x0020
			user.NewProc("DrawTextW").Call(dc, uintptr(unsafe.Pointer(&text[0])), length, uintptr(unsafe.Pointer(&bounds)), centeredSingleLine)
			user.NewProc("EndPaint").Call(window, uintptr(unsafe.Pointer(&ps)))
			return 0
		}
		returnValue, _, _ := user.NewProc("DefWindowProcW").Call(window, message, wp, lp)
		return returnValue
	})
	// Own the entire paint path: STATIC can paint its default background on
	// WM_SETTEXT, bypassing WM_PAINT. A custom class never draws that box.
	type windowClass struct {
		Style                              uint32
		Procedure                          uintptr
		ClassExtra, WindowExtra            int32
		Instance, Icon, Cursor, Background uintptr
		Menu, Name                         *uint16
	}
	instance, _, _ := kernel.NewProc("GetModuleHandleW").Call(0)
	name := utf("OpenKFOTransparentFPS")
	wc := windowClass{Procedure: paint, Instance: instance, Name: name}
	if atom, _, e := user.NewProc("RegisterClassW").Call(uintptr(unsafe.Pointer(&wc))); atom == 0 {
		return e
	}
	defer user.NewProc("UnregisterClassW").Call(uintptr(unsafe.Pointer(name)), instance)
	const noActivate = 0x08000000
	const clickThrough = 0x00000020
	const toolWindow = 0x00000080
	const popupWindow = 0x80000000
	// Keep hidden until transparency is configured; no caption or border styles.
	w, _, err := user.NewProc("CreateWindowExW").Call(noActivate|clickThrough|toolWindow|fpsLayered, uintptr(unsafe.Pointer(name)), uintptr(unsafe.Pointer(utf("FPS:…"))), popupWindow, 0, 0, 150, 28, owner, 0, instance, 0)
	if w == 0 {
		return err
	}
	defer user.NewProc("DestroyWindow").Call(w)
	if ok, _, e := user.NewProc("SetLayeredWindowAttributes").Call(w, 0, 255, fpsColorKey); ok == 0 {
		return e
	}
	type message struct {
		Window         uintptr
		Msg            uint32
		WParam, LParam uintptr
		Time           uint32
		Pt             point
		Private        uint32
	}
	var msg message
	var prev uint32
	last := time.Now()
	first := true
	for {
		if r, _ := syscall.WaitForSingleObject(h, 0); r == 0 {
			return nil
		}
		for {
			ok, _, _ := user.NewProc("PeekMessageW").Call(uintptr(unsafe.Pointer(&msg)), 0, 0, 0, 1)
			if ok == 0 {
				break
			}
			user.NewProc("TranslateMessage").Call(uintptr(unsafe.Pointer(&msg)))
			user.NewProc("DispatchMessageW").Call(uintptr(unsafe.Pointer(&msg)))
		}
		var count uint32
		var n uintptr
		ok, _, _ := kernel.NewProc("ReadProcessMemory").Call(uintptr(memory), uintptr(address), uintptr(unsafe.Pointer(&count)), 4, uintptr(unsafe.Pointer(&n)))
		if ok == 0 || n != 4 {
			return fmt.Errorf("FPS counter unavailable")
		}
		if first {
			prev = count
			first = false
		}
		if time.Since(last) >= 500*time.Millisecond {
			caption := fmt.Sprintf("FPS:%.0f", float64(count-prev)/time.Since(last).Seconds())
			user.NewProc("SetWindowTextW").Call(w, uintptr(unsafe.Pointer(utf(caption))))
			user.NewProc("InvalidateRect").Call(w, 0, 0)
			prev = count
			last = time.Now()
		}
		var r rect
		var p point
		user.NewProc("GetClientRect").Call(owner, uintptr(unsafe.Pointer(&r)))
		user.NewProc("ClientToScreen").Call(owner, uintptr(unsafe.Pointer(&p)))
		iconic, _, _ := user.NewProc("IsIconic").Call(owner)
		visible, _, _ := user.NewProc("IsWindowVisible").Call(owner)
		if iconic != 0 || visible == 0 {
			user.NewProc("ShowWindow").Call(w, 0)
		} else {
			user.NewProc("SetWindowPos").Call(w, 0, uintptr(p.X+(r.R-150)/2), uintptr(p.Y+8), 150, 28, 0x10|0x40)
		}
		time.Sleep(100 * time.Millisecond)
	}
}

var _ = os.Args
