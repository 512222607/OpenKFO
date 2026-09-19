package protocol

import "bytes"

// ParseExtendedTaskAuxRecords is diagnostics only. Native 20530/A2BEE0 has
// a broken record loop in the inspected build (length is incremented, index
// remains zero). Do not add an encoder or send nonempty lists to that client.
// The consumer routes by task key at +12; other fields are not yet named.
func ParseExtendedTaskAuxRecords(p []byte) ([]TaskRecord, error) {
	if len(p)%22 != 0 {
		return nil, ErrFrame
	}
	rows := make([]TaskRecord, 0, len(p)/22)
	for i := 0; i < len(p); i += 22 {
		rows = append(rows, TaskRecord{Key: ReadUint16(p, i+12), Raw: bytes.Clone(p[i : i+22])})
	}
	return rows, nil
}

// ExtendedTaskAction is the 19B native daily/newbie action. Context is a
// process-local value in the observed sender, never an authenticated UID.
// The sender does not initialize Tail; it cannot be a nonce or price.
type ExtendedTaskAction struct {
	Key     uint16
	State   byte
	Context uint32
	Tail    [12]byte
}

func ParseExtendedTaskAction(id uint32, p []byte) (ExtendedTaskAction, error) {
	var r ExtendedTaskAction
	var state byte
	switch id {
	case 6051, 6052:
		state = 2
	case 6081, 6082:
		state = 1
	case 6311, 6312:
		state = 3
	default:
		return r, ErrFrame
	}
	if len(p) != 19 || p[2] != state || ReadUint16(p, 0) == 0 {
		return r, ErrFrame
	}
	r.Key, r.State, r.Context = ReadUint16(p, 0), p[2], ReadUint32(p, 3)
	copy(r.Tail[:], p[7:])
	return r, nil
}

// Native getters return map value+4, so UI +0x10 is wire record+16.
// Do not infer reward or condition fields from the rest of the 141B record.
type ExtendedTaskProgress struct {
	Key         uint16
	State       byte
	Raw         []byte
	DisplayMode uint16
	Conditions  [7]ExtendedTaskCondition
}

// Native UI matches Key to the template's three condition keys, then reads
// Current for display. Unknown is the third DWORD of each 12B slot.
type ExtendedTaskCondition struct {
	Key     uint32
	Current uint32
	Unknown uint32
}

// EncodeExtendedTaskProgress constructs this emulator's list from recovered
// fields. Unknown header/trailer fields are zero; this does not claim to
// reproduce the original server's complete record or its reward display.
func EncodeExtendedTaskProgress(id uint32, rows []ExtendedTaskProgress) ([]byte, error) {
	if (id != 6041 && id != 6042) || len(rows) > 1024 {
		return nil, ErrFrame
	}
	p := make([]byte, len(rows)*141)
	seen := map[uint16]bool{}
	for i, r := range rows {
		if seen[r.Key] || r.State < 1 || r.State > 4 || (id == 6041 && (r.Key < 2000 || r.Key > 3000)) || (id == 6042 && r.Key <= 3000) {
			return nil, ErrFrame
		}
		seen[r.Key] = true
		entry := p[i*141 : (i+1)*141]
		WriteUint16(entry, 12, r.Key)
		WriteUint16(entry, 14, r.DisplayMode)
		entry[16] = r.State
		for j, c := range r.Conditions {
			if c.Current > 0x7fffffff || c.Unknown != 0 {
				return nil, ErrFrame
			}
			WriteUint32(entry, 53+j*12, c.Key)
			WriteUint32(entry, 57+j*12, c.Current)
		}
	}
	return p, nil
}

func ParseExtendedTaskProgress(p []byte) (ExtendedTaskProgress, error) {
	if len(p) != 141 {
		return ExtendedTaskProgress{}, ErrFrame
	}
	r := ExtendedTaskProgress{Key: ReadUint16(p, 12), DisplayMode: ReadUint16(p, 14), State: p[16], Raw: bytes.Clone(p)}
	for i := range r.Conditions {
		offset := 53 + i*12
		r.Conditions[i] = ExtendedTaskCondition{Key: ReadUint32(p, offset), Current: ReadUint32(p, offset+4), Unknown: ReadUint32(p, offset+8)}
	}
	return r, nil
}

// Native acknowledgements read only key+0 and state+2 without a length guard.
// Three bytes is a readable lower bound, not a proven original packet size.
func ParseExtendedTaskNotification(id uint32, p []byte) (ExtendedTaskProgress, error) {
	switch id {
	case 6031, 6032, 6061, 6062, 6091, 6092, 6301, 6302:
	default:
		return ExtendedTaskProgress{}, ErrFrame
	}
	if len(p) < 3 {
		return ExtendedTaskProgress{}, ErrFrame
	}
	return ExtendedTaskProgress{Key: ReadUint16(p, 0), State: p[2], Raw: bytes.Clone(p)}, nil
}
