package main

import (
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestCreationRequestUsesIssuedChoices(t *testing.T) {
	var choices []persistence.CharacterChoice
	for slot := uint32(0); slot < 7; slot++ {
		choices = append(choices, persistence.CharacterChoice{Gender: 2, Slot: slot, Choice: 900 + slot, Item: 150001 + slot})
	}
	options, err := persistence.CharacterOptions(choices)
	if err != nil {
		t.Fatal(err)
	}
	request, err := creationRequest("测试角色", options)
	if err != nil {
		t.Fatal(err)
	}
	if len(request) != 68 || request[21] != 2 {
		t.Fatal("did not select complete gender candidate")
	}
	for slot := 0; slot < 7; slot++ {
		if protocol.ReadUint32(request, 23+slot*4) != uint32(900+slot) {
			t.Fatal("sent resource ID instead of issued choice")
		}
	}
	for _, name := range []string{"", " name", "name\n", strings.Repeat("中", 11), "角色😀"} {
		if _, err := creationRequest(name, options); err == nil {
			t.Fatalf("accepted invalid nickname %q", name)
		}
	}
	for _, invalid := range [][]byte{nil, options[:len(options)-1], options[:len(options)-16], append(append([]byte{}, options...), options[:16]...), make([]byte, 513*16)} {
		if _, err := creationRequest("测试角色", invalid); err == nil {
			t.Fatal("accepted invalid or incomplete choices")
		}
	}
}
