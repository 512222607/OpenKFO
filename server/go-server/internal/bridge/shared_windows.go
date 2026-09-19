package bridge

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"syscall"
	"time"
	"unsafe"
)

type ownedClient struct {
	process  *os.Process
	identity Identity
	done     chan struct{}
}

// Only the verified client executable created here is modified, before its first
// instruction. The executable on disk and all game assets remain shared.
func startSharedClient(image string) (*ownedClient, error) {
	app, err := syscall.UTF16PtrFromString(image)
	if err != nil {
		return nil, err
	}
	dir, err := syscall.UTF16PtrFromString(filepath.Dir(image))
	if err != nil {
		return nil, err
	}
	si := syscall.StartupInfo{}
	si.Cb = uint32(unsafe.Sizeof(si))
	var pi syscall.ProcessInformation
	if err = syscall.CreateProcess(app, nil, nil, nil, false, 0x4, nil, dir, &si, &pi); err != nil {
		return nil, err
	}
	defer syscall.CloseHandle(pi.Thread)
	defer syscall.CloseHandle(pi.Process)
	ok := false
	defer func() {
		if !ok {
			syscall.TerminateProcess(pi.Process, 1)
		}
	}()
	const address = uintptr(0xbd0210)
	replacement := []byte(fmt.Sprintf("K%08X\x00", pi.ProcessId))
	if err = patchClientMemory(pi.Process, address, []byte("KungfuKid\x00"), replacement); err != nil {
		return nil, err
	}
	if err = patchClientMemory(pi.Process, loadingThreadCleanupAddress, loadingThreadCleanupOriginal, loadingThreadCleanupSafe); err != nil {
		return nil, err
	}
	identity, err := processIdentity(pi.ProcessId, image)
	if err != nil {
		return nil, err
	}
	p, err := os.FindProcess(int(pi.ProcessId))
	if err != nil {
		return nil, err
	}
	resumed, _, err := kernel.NewProc("ResumeThread").Call(uintptr(pi.Thread))
	if resumed == 0xffffffff {
		p.Release()
		return nil, err
	}
	child := &ownedClient{process: p, identity: identity, done: make(chan struct{})}
	go func() { p.Wait(); close(child.done) }()
	ok = true
	log.Printf("shared_client_started pid=%d mutex=%q", identity.PID, replacement[:9])
	log.Printf("client_loading_thread_cleanup pid=%d mode=natural_exit", identity.PID)
	return child, nil
}

func RequestSharedWindow(config Config, number int) error {
	if number < 1 || number > 8 || config.ControlDirectory == "" {
		return fmt.Errorf("invalid shared window configuration")
	}
	if err := os.MkdirAll(config.ControlDirectory, 0700); err != nil {
		return err
	}
	return os.WriteFile(filepath.Join(config.ControlDirectory, fmt.Sprintf("start-%d.request", number)), nil, 0600)
}

func (b *Bridge) runShared(ctx context.Context) error {
	children := map[int]*ownedClient{}
	defer func() {
		b.mutex.Lock()
		defer b.mutex.Unlock()
		for _, s := range b.sessions {
			s.close()
		}
	}()
	statePath := func(n int) string { return filepath.Join(b.Config.ControlDirectory, fmt.Sprintf("window-%d.json", n)) }
	start := func(n int) error {
		child, err := startSharedClient(b.Image)
		if err != nil {
			return err
		}
		children[n] = child
		data, _ := json.Marshal(child.identity)
		if err = os.WriteFile(statePath(n), data, 0600); err != nil {
			child.process.Kill()
			return err
		}
		return nil
	}
	ticker := time.NewTicker(200 * time.Millisecond)
	defer ticker.Stop()
	idleSince := time.Now()
	for {
		select {
		case <-ctx.Done():
			return nil
		case old := <-b.relogin:
			for n, child := range children {
				if child.identity != old.identity {
					continue
				}
				old.close()
				b.mutex.Lock()
				if b.sessions[old.identity.PID] == old {
					delete(b.sessions, old.identity.PID)
				}
				b.mutex.Unlock()
				if err := child.process.Kill(); err != nil {
					log.Printf("shared_relogin_stop_failed: %v", err)
					break
				}
				select {
				case <-child.done:
				case <-time.After(10 * time.Second):
					return fmt.Errorf("client exit timeout")
				}
				delete(children, n)
				os.Remove(statePath(n))
				if err := start(n); err != nil {
					log.Printf("shared_relogin_start_failed: %v", err)
				}
				break
			}
		case <-ticker.C:
			for n, child := range children {
				select {
				case <-child.done:
					delete(children, n)
					os.Remove(statePath(n))
					b.mutex.Lock()
					if s := b.sessions[child.identity.PID]; s != nil && s.identity == child.identity {
						s.close()
						delete(b.sessions, child.identity.PID)
					}
					b.mutex.Unlock()
				default:
				}
			}
			for n := 1; n <= 8; n++ {
				request := filepath.Join(b.Config.ControlDirectory, fmt.Sprintf("start-%d.request", n))
				if _, err := os.Stat(request); err != nil {
					continue
				}
				if err := os.Remove(request); err != nil {
					continue
				}
				if children[n] != nil {
					continue
				}
				if err := start(n); err != nil {
					log.Printf("shared_window_start_failed window=%d error=%v", n, err)
				}
			}
			if len(children) > 0 {
				idleSince = time.Now()
			} else if time.Since(idleSince) > 30*time.Second {
				return nil
			}
		}
	}
}
