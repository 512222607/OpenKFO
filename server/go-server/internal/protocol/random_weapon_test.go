package protocol

import (
	"bytes"
	"testing"
)

func TestRandomWeaponNativeLayouts(t *testing.T) {
	p := RandomWeaponPreferences(42, RandomWeaponAll).Payload
	if len(p) != 271 || ReadUint64(p, 0) != 42 || p[8] != 0 || ReadUint32(p, 267) != 8 {
		t.Fatal("preferences layout")
	}
	record := make([]byte, 68)
	record[4] = 25
	WriteUint32(record, 0, 123)
	WriteUint32(record, 5, 253002)
	WriteUint16(record, 17, 8)
	encoded := RandomWeaponRecord(record)
	if ReadUint32(encoded, 9)/100 != ReadUint32(record, 5) || ReadUint32(record, 9) != 0 || ReadUint32(encoded, 0) != 123 || ReadUint16(encoded, 17) != 8 {
		t.Fatal("native appearance encoding or source mutation")
	}
	if !bytes.Equal(RandomWeaponRecord(nil), make([]byte, 68)) {
		t.Fatal("cancel record")
	}
}
