package main

import (
	"bufio"
	"log"
	"os"
	"strings"
)

// Only an explicitly managed local worker accepts stop/EOF on its private
// stdin pipe. Production logging and network listeners are unchanged.
func watchLocalMonitor(stop func()) {
	if os.Getenv("OPENKFO_LOCAL_MONITOR") != "1" {
		return
	}
	go func() {
		scanner := bufio.NewScanner(os.Stdin)
		for scanner.Scan() {
			if strings.TrimSpace(scanner.Text()) == "stop" {
				break
			}
		}
		log.Printf("local_server_stop source=monitor_stdin error=%v", scanner.Err())
		stop()
	}()
}
