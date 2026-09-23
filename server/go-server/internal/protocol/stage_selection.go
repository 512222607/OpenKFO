package protocol

import "bytes"

const (
	MsgStageStateQuery uint32 = 21342
	MsgStageStateReply uint32 = 21343
)

// Native A27670 reads two counts, followed by 12-byte and 8-byte records.
// This server does not yet project these auxiliary records. Empty counts
// report no records, not invented clearance history or unlocked maps.
func EmptyStageState() []byte { return make([]byte, 8) }

// EncodeStageSelection is specific to 21373. Native 9290F3 compares each
// parsed integer with the positive PVE MapID; an empty string skips the
// control-state loop. A sole nonmatching zero forces every candidate through
// the disabled branch. It is a wire sentinel, never a persisted map/grant.
// The copied, uninterpreted header uses this server's reserved zero value.
func EncodeStageSelection(ids []uint32) ([]byte, error) {
	p, err := (StageProgress{MapIDs: ids}).Encode()
	if err != nil {
		return nil, err
	}
	if len(ids) == 0 {
		copy(p[4:], "0,")
	}
	return p, nil
}

func ParseStageSelection(p []byte) (StageProgress, error) {
	if len(p) == 404 && bytes.Equal(p[4:7], []byte{'0', ',', 0}) && bytes.Equal(p[7:], make([]byte, 397)) {
		return StageProgress{Header: ReadUint32(p, 0), MapIDs: []uint32{}}, nil
	}
	return ParseStageProgress(p)
}
