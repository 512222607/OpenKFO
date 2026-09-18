//go:build !windows

package main

func prepareLocalConsole() (func(), error) { return func() {}, nil }
