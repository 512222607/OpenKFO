package protocol

import "bytes"

type TitleRewardOption struct {
	CatalogKey uint32
	Unknown    uint32
}

// Emulator award block consumed by 957670. Unused slots and unresolved
// header/pair words are zero; this is not a claim to recover original values.
func EncodeTitleAward(level byte, choices []uint32) ([]byte, error) {
	if level == 0 || len(choices) == 0 || len(choices) > 7 {
		return nil, ErrFrame
	}
	p := make([]byte, 64)
	p[0] = level
	seen := map[uint32]bool{}
	for i, key := range choices {
		if key == 0 || seen[key] {
			return nil, ErrFrame
		}
		seen[key] = true
		WriteUint32(p, 8+i*8, key)
	}
	return p, nil
}

// The first eight bytes are a header (only the title byte is named). Native
// 956F10 returns seven consecutive DWORD pairs from the copied 64-byte block.
func ParseTitleRewardOptions(p []byte) ([7]TitleRewardOption, error) {
	var rows [7]TitleRewardOption
	if len(p) < 64 {
		return rows, ErrFrame
	}
	for i := range rows {
		rows[i] = TitleRewardOption{ReadUint32(p, 8+i*8), ReadUint32(p, 12+i*8)}
	}
	return rows, nil
}

// 957280 clears 149 bytes and writes the selected catalogue key at +145,
// then sends 4126. It is not the 169-byte ordinary purchase request.
func ParseTitleRewardClaim(p []byte) (uint32, error) {
	if len(p) != 149 {
		return 0, ErrFrame
	}
	return ReadUint32(p, 145), nil
}

// 829B50 writes the first byte to profile+123; 957670 copies 64 bytes.
// Remaining award fields and the original exact packet length are unresolved.
func ParseTitleAward(p []byte) (byte, []byte, error) {
	if len(p) < 64 {
		return 0, nil, ErrFrame
	}
	return p[0], bytes.Clone(p), nil
}
