package protocol

import (
	"bytes"
	"strconv"
	"strings"
)

// StageProgress carries the 404-byte list consumed by 21373/21374.
// Header is retained without guessing its meaning. IDs are positive signed
// integers because the native list consumer converts text through atoi.
// For 21373, A54390 loads PVEEntryUI MapID at record+0x0c, compared at
// 9290F3. Do not substitute Group (+4) or SelectDifficulty (+8) as list IDs.
// 21374 additionally emits unlock notices; it is not a silent list refresh.
type StageProgress struct {
	Header uint32
	MapIDs []uint32
}

func (p StageProgress) Encode() ([]byte, error) {
	var text strings.Builder
	seen := map[uint32]bool{}
	for _, id := range p.MapIDs {
		if id == 0 || id > 0x7fffffff || seen[id] {
			return nil, ErrFrame
		}
		seen[id] = true
		text.WriteString(strconv.FormatUint(uint64(id), 10))
		text.WriteByte(',')
		if text.Len() >= 400 {
			return nil, ErrFrame
		}
	}
	out := make([]byte, 404)
	WriteUint32(out, 0, p.Header)
	copy(out[4:], text.String())
	return out, nil
}

func ParseStageProgress(p []byte) (StageProgress, error) {
	var result StageProgress
	if len(p) != 404 {
		return result, ErrFrame
	}
	end := bytes.IndexByte(p[4:], 0)
	if end < 0 {
		return result, ErrFrame
	}
	result.Header = ReadUint32(p, 0)
	if end == 0 {
		return result, nil
	}
	text := string(p[4 : 4+end])
	if !strings.HasSuffix(text, ",") {
		return StageProgress{}, ErrFrame
	}
	seen := map[uint32]bool{}
	for _, part := range strings.Split(text[:len(text)-1], ",") {
		if part == "" {
			return StageProgress{}, ErrFrame
		}
		for _, c := range part {
			if c < '0' || c > '9' {
				return StageProgress{}, ErrFrame
			}
		}
		n, err := strconv.ParseUint(part, 10, 31)
		if err != nil || n == 0 || seen[uint32(n)] {
			return StageProgress{}, ErrFrame
		}
		seen[uint32(n)] = true
		result.MapIDs = append(result.MapIDs, uint32(n))
	}
	return result, nil
}
