package protocol

const MsgRenewItem uint32 = 1420

// RenewalRequest is the 173-byte request built by native 8C2820.
// Amount is untrusted client input, not an authoritative price. Operation 105
// is retained without guessing a currency; unknown bytes remain in Raw.
type RenewalRequest struct {
	Raw [173]byte
}

func (r RenewalRequest) InventoryInstance() uint32 { return ReadUint32(r.Raw[:], 0) }
func (r RenewalRequest) Operation() uint32         { return ReadUint32(r.Raw[:], 4) }
func (r RenewalRequest) SenderUID() uint64         { return ReadUint64(r.Raw[:], 8) }
func (r RenewalRequest) RecipientUID() uint64      { return ReadUint64(r.Raw[:], 58) }
func (r RenewalRequest) CatalogKey() uint32        { return ReadUint32(r.Raw[:], 149) }
func (r RenewalRequest) QuotedAmount() uint32      { return ReadUint32(r.Raw[:], 161) }

func ParseRenewalRequest(payload []byte) (r RenewalRequest, err error) {
	if len(payload) != len(r.Raw) {
		return r, ErrFrame
	}
	copy(r.Raw[:], payload)
	return r, nil
}

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
