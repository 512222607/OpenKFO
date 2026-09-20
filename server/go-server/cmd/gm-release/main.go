// Build a public GM runtime ZIP from the allowlisted files only, then publish via SSH.
package main

import (
	"archive/zip"
	"bytes"
	"flag"
	"fmt"
	"kungfu.local/server/internal/desktop"
	"kungfu.local/server/internal/releases"
	"os"
	"path/filepath"
	"strings"
	"time"
)

func main() {
	root := flag.String("root", ".", "repository root")
	dir := flag.String("directory", "", "complete GM release directory")
	notes := flag.String("notes", "", "release notes")
	flag.Parse()
	if err := run(*root, *dir, *notes); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
func run(root, dir, notes string) error {
	if dir == "" || strings.TrimSpace(notes) == "" {
		return fmt.Errorf("directory and notes are required")
	}
	var buffer bytes.Buffer
	z := zip.NewWriter(&buffer)
	err := filepath.WalkDir(dir, func(path string, e os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if e.IsDir() {
			return nil
		}
		rel, _ := filepath.Rel(dir, path)
		rel = filepath.ToSlash(rel)
		allowed := rel == "OpenKFO.Updater.exe" || rel == "GM管理器.exe" || rel == "kungfu-desktop-admin.exe" || strings.HasSuffix(strings.ToLower(rel), ".dll") && !strings.Contains(rel, "/") || strings.HasPrefix(rel, "data/")
		if !allowed {
			return nil
		}
		if e.Type()&os.ModeSymlink != 0 {
			return fmt.Errorf("symlink rejected")
		}
		data, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		f, err := z.Create(rel)
		if err == nil {
			_, err = f.Write(data)
		}
		return err
	})
	if err != nil {
		return err
	}
	if err = z.Close(); err != nil {
		return err
	}
	raw := buffer.Bytes()
	m := releases.Manifest{Kind: "gm", Version: time.Now().UTC().Format("20060102T150405Z"), Notes: notes, SHA256: releases.Hash(raw), Size: int64(len(raw))}
	m.Package = m.SHA256 + ".zip"
	result, err := desktop.New(root).Publish(m, raw)
	if err == nil {
		fmt.Println(result)
	}
	return err
}
