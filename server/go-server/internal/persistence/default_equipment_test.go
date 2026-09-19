package persistence

import "testing"

func TestNativeDefaultEquipmentSlots(t *testing.T) {
	// Values independently decoded from 660CE0's jump tables in current gfld.dat.
	for kind, want := range map[byte]uint16{12: 4, 13: 3, 14: 7, 15: 2, 16: 6, 17: 5, 20: 10, 21: 11, 25: 8} {
		got := defaultEquipmentSlot(kind)
		if got != want {
			t.Fatalf("kind=%d slot=%d want=%d", kind, got, want)
		}
		allowed := false
		for _, slot := range Slots[kind] {
			allowed = allowed || slot == got
		}
		if !allowed {
			t.Fatalf("default bypasses supported slots for %d", kind)
		}
	}
	for _, kind := range []byte{0, 18, 26, 30, 31, 64, 71, 75, 76, 255} {
		if defaultEquipmentSlot(kind) != 0 {
			t.Fatalf("unverified auto-equipment enabled for %d", kind)
		}
	}
}
