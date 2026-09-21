package desktop

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestDecorativeEquipmentGrantAndShop(t *testing.T) {
	enabled := true
	for _, kind := range []byte{31, 77, 79} {
		item := Item{ID: uint32(kind)*10000 + 1, Kind: kind, Timed: timed(kind), Stackable: stackable(kind)}
		if !item.Timed || item.Stackable {
			t.Fatalf("kind %d must be supported equipment, not a stack", kind)
		}
		grant := template(item, 99, 30)
		o, err := offer(item, Request{Enabled: &enabled, Currency: "ticket", Price: 100, Days: 30, Quantity: 99})
		if err != nil {
			t.Fatal(err)
		}
		for _, record := range [][]byte{grant, o.Grant} {
			if len(record) != protocol.InventoryRecordSize || record[4] != kind || little.Uint32(record[13:]) != 30*24 || little.Uint16(record[23:]) != 0 || little.Uint16(record[17:]) != 0 || little.Uint32(record[19:]) != 0 {
				t.Fatalf("kind %d lost configured duration, gained a stack, or activated before equip", kind)
			}
		}
		if o.Category != 10 || o.Variant != kind || little.Uint32(o.Record[22:]) != 30*24 || little.Uint32(o.Record[38:]) != 100 {
			t.Fatalf("kind %d changed existing shop routing, duration or price", kind)
		}
	}
}
