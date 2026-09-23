package desktop

import "testing"

func TestStageTicketSale(t *testing.T) {
	enabled := true
	for _, id := range []uint32{603316, 603317, 603318, 603355, 603396, 603397, 603398, 603407} {
		if !stageTicket(60, id) {
			t.Fatal("missing ticket", id)
		}
		item := Item{Kind: 60, ID: id, Stackable: stageTicket(60, id)}
		o, err := offer(item, Request{Enabled: &enabled, Currency: "ticket", Price: 500, Quantity: 1, Days: 365})
		if err != nil {
			t.Fatal(err)
		}
		if o.Grant[4] != 60 || little.Uint16(o.Grant[23:]) != 1 || little.Uint32(o.Grant[13:]) != 0 || little.Uint32(o.Record[26:]) != 1 || little.Uint32(o.Record[38:]) != 500 {
			t.Fatal("incorrect ticket sale record", id)
		}
	}
	for _, id := range []uint32{603151, 603319, 603399, 603420} {
		if stageTicket(60, id) {
			t.Fatal("unrelated material classified as stage ticket", id)
		}
	}
	if stageTicket(25, 603316) {
		t.Fatal("wrong native type accepted")
	}
}
