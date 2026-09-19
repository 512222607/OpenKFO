package protocol

// VIPStatus is the native 1038 payload. Unknown DWORDs are kept verbatim;
// nothing here treats them as dates, rewards or permissions.
type VIPStatus struct {
	Kind        uint32
	Unknown     [4]uint32
	ShopPercent uint32
	Tail        uint32
}

func ParseVIPStatus(p []byte) (VIPStatus, error) {
	var r VIPStatus
	if len(p) != 28 {
		return r, ErrFrame
	}
	r.Kind = ReadUint32(p, 0)
	for i := range r.Unknown {
		r.Unknown[i] = ReadUint32(p, 4+i*4)
	}
	r.ShopPercent = ReadUint32(p, 20)
	r.Tail = ReadUint32(p, 24)
	return r, nil
}
