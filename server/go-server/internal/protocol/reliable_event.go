package protocol

// ReliableEvent exposes only fields verified in the native 82D0F0 dispatch
// and its consumers. ObjectKey is the unsigned key used by the two native
// pending maps (A443B0/A444E0, comparator 4C5F20), not a network sequence.
// Flag51 remains raw so diagnostics retain unsupported values.
// Parsing this record is not authorization to relay or apply an effect.
type ReliableEvent struct {
	Kind              uint32
	Sender, Actor     uint64
	ObjectKey, Flag51 uint32
	HasContext        bool
	Context           [2]uint32
}

func ParseReliableEvent(p []byte) (ReliableEvent, error) {
	var r ReliableEvent
	if len(p) < 4 {
		return r, ErrFrame
	}
	r.Kind = ReadUint32(p, 0)
	size := 0
	switch r.Kind {
	case 9000, 9001, 9002:
		size, r.HasContext = 63, true
	case 9500, 9501, 9502:
		size = 55
	default:
		return ReliableEvent{}, ErrFrame
	}
	if len(p) != size {
		return ReliableEvent{}, ErrFrame
	}
	r.Sender, r.Actor = ReadUint64(p, 4), ReadUint64(p, 39)
	r.ObjectKey, r.Flag51 = ReadUint32(p, 47), ReadUint32(p, 51)
	if r.HasContext {
		r.Context = [2]uint32{ReadUint32(p, 55), ReadUint32(p, 59)}
	}
	return r, nil
}
