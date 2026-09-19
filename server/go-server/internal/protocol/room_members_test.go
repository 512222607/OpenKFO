package protocol

import (
	"bytes"
	"testing"
)

func TestRoomMemberStrideAndIdentity(t *testing.T) {
	first := make([]byte, 149+68)
	first[0] = 42
	first[64] = 1
	first[149] = 7
	second := make([]byte, 149)
	second[0] = 43
	second[8] = 8
	second[76] = 2
	p := append(bytes.Clone(first), second...)
	rows, err := ParseRoomMembers(p)
	if err != nil || len(rows) != 2 || rows[0].UID() != 42 || rows[0].Spectator() || rows[0].EquipmentCount() != 1 || rows[1].UID() != 43 || rows[1].Slot() != 8 || !rows[1].Spectator() {
		t.Fatal(rows, err)
	}
	p[0] = 0
	if rows[0].UID() != 42 || rows[0].Raw[149] != 7 {
		t.Fatal("raw data lost or aliased")
	}
	for _, bad := range [][]byte{nil, first[:148], first[:len(first)-1], append(bytes.Clone(first), 0), bytes.Repeat(second, 17)} {
		if _, err := ParseRoomMembers(bad); err == nil {
			t.Fatal("accepted incomplete or excess records")
		}
	}
	if rows, err := ParseRoomMembers(bytes.Repeat(second, 16)); err != nil || len(rows) != 16 {
		t.Fatal("native record limit", err)
	}
}
