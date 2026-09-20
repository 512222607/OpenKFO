package persistence

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestWeaponSwitchCardValidation(t *testing.T) {
	items := make([][]byte, 3)
	for i := range items {
		items[i] = make([]byte, 68)
		items[i][4] = protocol.ItemWeapon
		protocol.WriteUint32(items[i], 0, uint32(i+1))
		protocol.WriteUint16(items[i], 17, uint16(8+i))
	}
	items[2][4] = protocol.ItemWeaponSwitchCard
	protocol.WriteUint16(items[2], 17, 0)
	protocol.WriteUint16(items[2], 23, 99)
	for _, tc := range []struct {
		name string
		edit func([][]byte)
	}{
		{"empty", func(p [][]byte) { protocol.WriteUint16(p[2], 23, 0) }},
		{"expired card", func(p [][]byte) { protocol.WriteUint32(p[2], 19, 2) }},
		{"expired weapon", func(p [][]byte) { protocol.WriteUint32(p[1], 19, 0xffffffff) }},
		{"no secondary", func(p [][]byte) { protocol.WriteUint16(p[1], 17, 0) }},
		{"duplicate slot", func(p [][]byte) { protocol.WriteUint16(p[1], 17, 8) }},
		{"wrong kind", func(p [][]byte) { p[2][4] = protocol.ItemConsumable }},
		{"short record", func(p [][]byte) { p[2] = p[2][:25] }},
	} {
		t.Run(tc.name, func(t *testing.T) {
			p := [][]byte{bytes.Clone(items[0]), bytes.Clone(items[1]), bytes.Clone(items[2])}
			tc.edit(p)
			if _, e := weaponSwitchCard(p); e == nil {
				t.Fatal("invalid inventory accepted")
			}
		})
	}
	if _, e := weaponSwitchCard(items); e != nil {
		t.Fatal(e)
	}
	if _, e := weaponSwitchCard(append(items, bytes.Clone(items[2]))); e == nil {
		t.Fatal("ambiguous stacks accepted")
	}
}
