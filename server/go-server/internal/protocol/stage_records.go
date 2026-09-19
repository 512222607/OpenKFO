package protocol

// StageRecord is the 24-byte record inserted by A2A7D0 through 41CD20.
// MapID (+0) is the selected map from mapselect.xml, copied into RoomSet+5D8.
// RequiredMapID (+20) matches MapInfo.MapId in 7F8854 and supplies the condition
// label. Four intermediate DWORDs remain opaque; this is not an unlock policy.
type StageRecord struct {
	MapID         uint32
	Unknown       [4]uint32
	RequiredMapID uint32
}

func ParseStageRecords(p []byte) ([]StageRecord, error) {
	if len(p)%24 != 0 {
		return nil, ErrFrame
	}
	out := make([]StageRecord, len(p)/24)
	for i := range out {
		r := p[i*24 : (i+1)*24]
		out[i].MapID = ReadUint32(r, 0)
		for j := range out[i].Unknown {
			out[i].Unknown[j] = ReadUint32(r, 4+j*4)
		}
		out[i].RequiredMapID = ReadUint32(r, 20)
	}
	return out, nil
}

// EncodeStageRecords rejects duplicate keys: native insertion overwrites an
// earlier record with that key, so sending duplicates would hide server data.
func EncodeStageRecords(records []StageRecord) ([]byte, error) {
	seen := map[uint32]bool{}
	for _, r := range records {
		if seen[r.MapID] {
			return nil, ErrFrame
		}
		seen[r.MapID] = true
	}
	p := make([]byte, len(records)*24)
	for i, r := range records {
		o := i * 24
		WriteUint32(p, o, r.MapID)
		for j, v := range r.Unknown {
			WriteUint32(p, o+4+j*4, v)
		}
		WriteUint32(p, o+20, r.RequiredMapID)
	}
	return p, nil
}
