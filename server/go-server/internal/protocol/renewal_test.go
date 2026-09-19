package protocol

import "testing"

func TestRenewalRecordNativeOffsetsAndIsolation(t *testing.T) {
	p := make([]byte, 248)
	copy(p[8:], []byte{0x78, 0x56, 0x34, 0x12})
	p[12] = 2
	copy(p[21:], []byte{0x49, 0xdc, 3, 0})
	p[70] = 80
	p[123], p[124], p[247] = 0xaa, 0xbb, 0xcc
	rows, err := ParseRenewalRecords(p)
	if err != nil || len(rows) != 2 {
		t.Fatal(rows, err)
	}
	if rows[0].InventoryInstance() != 0x12345678 || rows[0].InventoryState() != 2 || rows[0].ItemID() != 253001 || rows[0].DiscountRaw() != 80 {
		t.Fatal(rows[0])
	}
	clear(p)
	if rows[0].Raw[123] != 0xaa || rows[1].Raw[0] != 0xbb || rows[1].Raw[123] != 0xcc {
		t.Fatal("record bytes aliased or lost")
	}
	for _, n := range []int{1, 123, 125, 247} {
		if _, err = ParseRenewalRecords(make([]byte, n)); err == nil {
			t.Fatal("short record", n)
		}
	}
	if rows, err = ParseRenewalRecords(nil); err != nil || len(rows) != 0 {
		t.Fatal("empty list rejected")
	}
}
