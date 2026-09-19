package protocol

// RenewalRecord is the 124-byte record consumed by 8269C0 -> 8BBC20.
// It is diagnostic-only until renewal requests, prices and receipt semantics
// are recovered. Unknown bytes stay intact; no encoder or purchase permission.
type RenewalRecord struct {
	Raw [124]byte
}

func (r RenewalRecord) InventoryInstance() uint32 { return ReadUint32(r.Raw[:], 8) }
func (r RenewalRecord) InventoryState() uint32    { return ReadUint32(r.Raw[:], 12) }
func (r RenewalRecord) ItemID() uint32            { return ReadUint32(r.Raw[:], 21) }
func (r RenewalRecord) DiscountRaw() byte         { return r.Raw[70] }

func ParseRenewalRecords(payload []byte) ([]RenewalRecord, error) {
	if len(payload)%124 != 0 {
		return nil, ErrFrame
	}
	rows := make([]RenewalRecord, len(payload)/124)
	for i := range rows {
		copy(rows[i].Raw[:], payload[i*124:(i+1)*124])
	}
	return rows, nil
}
