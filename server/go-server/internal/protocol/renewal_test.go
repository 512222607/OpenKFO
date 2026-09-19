package protocol

import "testing"

func TestRenewalRequestNativeLayout(t *testing.T) {
	p := make([]byte, 173)
	// Fixed wire bytes, independent of the parser's read offsets.
	copy(p[0:], []byte{42, 0, 0, 0, 105, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8})
	copy(p[58:], []byte{8, 7, 6, 5, 4, 3, 2, 1})
	copy(p[149:], []byte{0x55, 0xdc, 3, 0})
	copy(p[161:], []byte{0xe8, 3, 0, 0})
	p[172] = 0xab
	r, err := ParseRenewalRequest(p)
	if err != nil || r.InventoryInstance() != 42 || r.Operation() != 105 || r.SenderUID() != 0x0807060504030201 || r.RecipientUID() != 0x0102030405060708 || r.CatalogKey() != 253013 || r.QuotedAmount() != 1000 {
		t.Fatal(r, err)
	}
	clear(p)
	if r.Raw[172] != 0xab || r.InventoryInstance() != 42 {
		t.Fatal("input alias or unknown field lost")
	}
	for _, n := range []int{0, 149, 169, 172, 174} {
		if _, err := ParseRenewalRequest(make([]byte, n)); err == nil {
			t.Fatal("wrong request shape accepted", n)
		}
	}
}

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
