package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"kungfu.local/server/internal/desktop"
	"os"
	"path/filepath"
)

func run() (any, error) {
	root := flag.String("root", ".", "repository directory")
	flag.Parse()
	absolute, err := filepath.Abs(*root)
	if err != nil {
		return nil, err
	}
	input, err := io.ReadAll(io.LimitReader(os.Stdin, (4<<20)+1))
	if err != nil {
		return nil, err
	}
	if len(input) > 4<<20 {
		return nil, fmt.Errorf("请求过大")
	}
	var request desktop.Request
	if err = json.Unmarshal(input, &request); err != nil {
		return nil, err
	}
	return desktop.New(absolute).Call(request)
}
func main() {
	result, err := run()
	response := map[string]any{"ok": err == nil}
	if err != nil {
		response["error"] = err.Error()
	} else {
		response["result"] = result
	}
	if err = json.NewEncoder(os.Stdout).Encode(response); err != nil {
		os.Exit(1)
	}
}
