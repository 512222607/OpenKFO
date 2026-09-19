package protocol

import (
	"bytes"
	"reflect"
	"testing"
)

func TestStageProgressNativeText(t *testing.T) {
	original := StageProgress{Header: 0x12345678, MapIDs: []uint32{8110, 8111, 8120}}
	p, e := original.Encode()
	if e != nil || len(p) != 404 || !bytes.Equal(p[4:20], []byte("8110,8111,8120,\x00")) {
		t.Fatal("native text shape", e)
	}
	decoded, e := ParseStageProgress(p)
	if e != nil || !reflect.DeepEqual(original, decoded) {
		t.Fatal(decoded, e)
	}
	for _, text := range []string{"8110", "8110,,", "-1,", "2147483648,", "0,", "8110,8110,", "1x,", " 1,"} {
		bad := make([]byte, 404)
		copy(bad[4:], text)
		if _, e := ParseStageProgress(bad); e == nil {
			t.Fatal("invalid progress", text)
		}
	}
	if _, e := ParseStageProgress(bytes.Repeat([]byte{'1'}, 404)); e == nil {
		t.Fatal("missing terminator")
	}
	for _, ids := range [][]uint32{{0}, {1, 1}, {0xffffffff}} {
		if _, e := (StageProgress{MapIDs: ids}).Encode(); e == nil {
			t.Fatal("invalid IDs")
		}
	}
	ids := make([]uint32, 40)
	for i := range ids {
		ids[i] = 1000000000 + uint32(i)
	}
	if _, e := (StageProgress{MapIDs: ids}).Encode(); e == nil {
		t.Fatal("text overflow silently truncated")
	}
}
