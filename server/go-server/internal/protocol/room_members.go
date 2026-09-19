package protocol

import "bytes"

const RoomMemberRecordSize = 149

// RoomMemberRecord retains unconfirmed fields. 3090 carries one record;
// 3105 consumes at most sixteen, advancing by 149 + byte[64]*68.
type RoomMemberRecord struct{ Raw []byte }

func (r RoomMemberRecord) UID() uint64          { return ReadUint64(r.Raw, 0) }
func (r RoomMemberRecord) Slot() byte           { return r.Raw[8] }
func (r RoomMemberRecord) Spectator() bool      { return r.Raw[76] != 0 }
func (r RoomMemberRecord) EquipmentCount() byte { return r.Raw[64] }

func ParseRoomMembers(p []byte) ([]RoomMemberRecord, error) {
	if len(p) == 0 {
		return nil, ErrFrame
	}
	var rows []RoomMemberRecord
	for len(p) > 0 {
		if len(rows) == 16 || len(p) < RoomMemberRecordSize {
			return nil, ErrFrame
		}
		n := RoomMemberRecordSize + int(p[64])*InventoryRecordSize
		if len(p) < n {
			return nil, ErrFrame
		}
		rows = append(rows, RoomMemberRecord{Raw: bytes.Clone(p[:n])})
		p = p[n:]
	}
	return rows, nil
}
