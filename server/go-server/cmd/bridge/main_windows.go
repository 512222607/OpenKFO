//go:build windows

package main

import (
	"context"
	"flag"
	"log"
	"os"
	"os/signal"
	"path/filepath"
	"syscall"
	"unsafe"

	"kungfu.local/server/internal/bridge"
)

func main() {
	executable, err := os.Executable()
	if err != nil {
		log.Fatal(err)
	}
	configPath := flag.String("config", filepath.Join(filepath.Dir(executable), "bridge.json"), "online client configuration")
	launch := flag.Bool("launch", true, "start native client")
	flag.Parse()
	logFile, err := os.OpenFile(filepath.Join(filepath.Dir(executable), "online-client.log"), os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0600)
	if err != nil {
		log.Fatal(err)
	}
	defer logFile.Close()
	log.SetOutput(logFile)
	config, err := bridge.LoadConfig(*configPath)
	if err == nil {
		if *launch {
			var active bool
			active, err = bridge.ActivateExistingClient(filepath.Join(config.ClientDirectory, "gfld.dat"))
			if err == nil && active {
				log.Print("existing client activated; duplicate launch skipped")
				return
			}
		}
	}
	if err == nil {
		launcher, alreadyRunning, lockErr := bridge.AcquireLauncher(config.LoginPort)
		if lockErr != nil {
			err = lockErr
		} else {
			defer syscall.CloseHandle(launcher)
			if alreadyRunning {
				log.Print("launcher already starting; duplicate launch skipped")
				return
			}
		}
	}
	if err == nil {
		ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
		defer cancel()
		err = bridge.Run(ctx, config, *launch)
	}
	if err != nil {
		log.Printf("launcher stopped: %v", err)
		message, _ := syscall.UTF16PtrFromString("启动失败：" + err.Error() + "\n请查看 online-client.log。")
		title, _ := syscall.UTF16PtrFromString("功夫小子 · 线上测试")
		syscall.NewLazyDLL("user32.dll").NewProc("MessageBoxW").Call(0, uintptr(unsafe.Pointer(message)), uintptr(unsafe.Pointer(title)), 0x10)
		os.Exit(1)
	}
}
