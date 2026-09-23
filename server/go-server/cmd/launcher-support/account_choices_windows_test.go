//go:build windows

package main

import (
	"encoding/binary"
	"strings"
	"testing"
	"unicode/utf16"
)

func TestAccountChoicesPayload(t *testing.T) {
	data, err := accountChoicesPayload([]credentials{{"测试", "first"}, {"second", "other"}})
	if err != nil || len(data) != 4100 || binary.LittleEndian.Uint32(data) != 2 {
		t.Fatalf("invalid payload size/count: %v", err)
	}
	read := func(offset int) string {
		var units []uint16
		for i := offset; i < offset+256; i += 2 {
			u := binary.LittleEndian.Uint16(data[i:])
			if u == 0 {
				break
			}
			units = append(units, u)
		}
		return string(utf16.Decode(units))
	}
	if read(4) != "测试" || read(260) != "first" || read(516) != "second" || read(772) != "other" {
		t.Fatal("account/password pair shifted")
	}
	for _, invalid := range [][]credentials{make([]credentials, 9), {{Account: strings.Repeat("a", 128)}}, {{Password: "bad\x00suffix"}}} {
		if _, err := accountChoicesPayload(invalid); err == nil {
			t.Fatal("invalid credentials accepted")
		}
	}
}
