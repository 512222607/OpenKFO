package protocol

import "bytes"

// TaskNotification exposes only fields read by the current native handlers.
// They have no packet-length check: these are minimum readable sizes, not a
// claim about the original server's exact wire length. Keep unknown bytes.
func ParseTaskNotification(id uint32, p []byte) (TaskRecord, error) {
	var offset int
	switch id {
	case 6030, 6060, 6090:
		offset = 12
	case 6040:
		offset = 4
	default:
		return TaskRecord{}, ErrFrame
	}
	if len(p) < offset+2 {
		return TaskRecord{}, ErrFrame
	}
	return TaskRecord{Key: ReadUint16(p, offset), Raw: bytes.Clone(p)}, nil
}

// TaskRecord only names the key actually used by native consumers. The opaque
// bytes are retained until progress/reward field semantics are established.
type TaskRecord struct {
	Key uint16
	Raw []byte
}

// TaskAction is the native 6050/6080 request. Prefix carries a UID in one
// sender, but 831400 leaves it uninitialized. It cannot authenticate an actor;
// handlers must use the authenticated session and validate server-side state.
type TaskAction struct {
	Prefix  [8]byte
	Context uint32
	Key     uint16
}

func ParseTaskAction(id uint32, p []byte) (TaskAction, error) {
	var r TaskAction
	if (id != 6050 && id != 6080) || len(p) != 14 {
		return r, ErrFrame
	}
	copy(r.Prefix[:], p[:8])
	r.Context, r.Key = ReadUint32(p, 8), ReadUint16(p, 12)
	return r, nil
}

// TaskProgress is the 123-byte 6020 record. Native A47690 sets state2 and
// copies profile+129..244 to this baseline. It is not 29 reward amounts.
type TaskProgress struct {
	Unknown0        uint32
	Key             uint16
	State           byte
	ProfileBaseline [29]uint32
}

func EncodeTaskProgress(rows []TaskProgress) ([]byte, error) {
	if len(rows) > 512 {
		return nil, ErrFrame
	}
	if len(rows) == 0 {
		return make([]byte, 7), nil
	}
	p := make([]byte, len(rows)*123)
	seen := map[uint16]bool{}
	for i, r := range rows {
		if r.Key == 0 || seen[r.Key] || r.State < 1 || r.State > 3 {
			return nil, ErrFrame
		}
		seen[r.Key] = true
		record := p[i*123:]
		WriteUint32(record, 0, r.Unknown0)
		WriteUint16(record, 4, r.Key)
		record[6] = r.State
		for j, value := range r.ProfileBaseline {
			WriteUint32(record, 7+j*4, value)
		}
	}
	return p, nil
}

func ParseTaskProgress(p []byte) (TaskProgress, error) {
	var r TaskProgress
	if len(p) != 123 {
		return r, ErrFrame
	}
	r.Unknown0 = ReadUint32(p, 0)
	r.Key = ReadUint16(p, 4)
	r.State = p[6]
	for i := range r.ProfileBaseline {
		r.ProfileBaseline[i] = ReadUint32(p, 7+i*4)
	}
	return r, nil
}

func ParseTaskRecords(id uint32, p []byte) ([]TaskRecord, error) {
	var stride, keyOffset int
	switch id {
	case 6010:
		stride, keyOffset = 7, 4
		if len(p) == 0 {
			return nil, ErrFrame
		}
	case 6020:
		stride, keyOffset = 123, 4
		// Native requires >=7 and then divides by123; legacy servers used a
		// seven-byte empty response. It is not a header on non-empty lists.
		if len(p) == 7 {
			return []TaskRecord{}, nil
		}
		if len(p) == 0 {
			return nil, ErrFrame
		}
	case 6041, 6042:
		stride, keyOffset = 141, 12
	default:
		return nil, ErrFrame
	}
	if len(p)%stride != 0 {
		return nil, ErrFrame
	}
	rows := make([]TaskRecord, 0, len(p)/stride)
	for i := 0; i < len(p); i += stride {
		rows = append(rows, TaskRecord{Key: ReadUint16(p, i+keyOffset), Raw: bytes.Clone(p[i : i+stride])})
	}
	return rows, nil
}
