package game

import (
	"bytes"
	"encoding/binary"
	"encoding/hex"
	"kungfu.local/server/internal/persistence"
	"testing"
)

func TestFriendsCapturedRequestsAndMalformed(t *testing.T) {
	add, _ := hex.DecodeString("cf00000000037171710000")
	query, _ := hex.DecodeString("e100000000000000")
	r, err := parseFriendRequest(add)
	if err != nil || r.op != friendAdd || r.name != "qqq" {
		t.Fatalf("%+v %v", r, err)
	}
	if _, err = parseFriendRequest(query); err != nil {
		t.Fatal(err)
	}
	for i := 0; i < len(add); i++ {
		if _, err = parseFriendRequest(add[:i]); err == nil {
			t.Fatalf("accepted truncated request %d", i)
		}
	}
	for _, bad := range [][]byte{append(append([]byte{}, add...), 0), {207, 0, 0, 1, 0, 0}, {207, 0, 0, 0, 255, 255}, {207, 0, 0, 0, 0, 1, 0, 0, 0}, {207, 0, 0, 0, 0, 1, 255, 0, 0}, {209, 0, 0, 0}, {225, 0, 0, 0}, {203, 0, 0, 0, 2}} {
		if _, err = parseFriendRequest(bad); err == nil {
			t.Fatalf("accepted %x", bad)
		}
	}
	cn := friendPacket(friendRemove, friendString(nil, "饼饼/R"))
	if r, err = parseFriendRequest(cn.Payload); err != nil || r.name != "饼饼/R" {
		t.Fatalf("%+v %v", r, err)
	}
}

func TestFriendsNativeWireSnapshot(t *testing.T) {
	// 212/result=1 reaches gfld!99D4D0; integers after the 4B header are BE.
	want, _ := hex.DecodeString("d4000000000000010003717171")
	if got := friendResult(friendAdded, "qqq"); got.ID != 8020 || !bytes.Equal(got.Payload, want) {
		t.Fatalf("%x", got.Payload)
	}
	list := []persistence.Friend{{UID: 0x1122334455667788, Name: "qqq"}, {UID: 10013, Name: "饼饼/R"}}
	p, err := buildFriendList(list, func(uid uint64) bool { return uid == list[0].UID })
	if err != nil {
		t.Fatal(err)
	}
	b := p.Payload
	if binary.LittleEndian.Uint16(b) != 226 || b[4] != 11 || binary.BigEndian.Uint16(b[9:]) != 2 || b[11] != 0 {
		t.Fatalf("header %x", b)
	}
	o := 12
	for i, f := range list {
		wantState := byte(1)
		if i == 0 {
			wantState = 2
		}
		if b[o] != wantState {
			t.Fatal("presence")
		}
		o += 2
		n := int(binary.BigEndian.Uint16(b[o:]))
		o += 2
		if !bytes.Equal(b[o:o+n], persistence.GBK(f.Name)) {
			t.Fatal("name")
		}
		o += n
	}
	for _, f := range list {
		uid := uint64(binary.BigEndian.Uint32(b[o:]))<<32 | uint64(binary.BigEndian.Uint32(b[o+4:]))
		if uid != f.UID {
			t.Fatal("uid order")
		}
		o += 34
	}
	if len(b) != o+2 || binary.BigEndian.Uint16(b[o:]) != 0 {
		t.Fatal("missing auxiliary section")
	}
	empty, err := buildFriendList(nil, func(uint64) bool { return false })
	if err != nil || len(empty.Payload) != 14 {
		t.Fatal("empty full snapshot")
	}
	if _, err = buildFriendList(make([]persistence.Friend, 101), nil); err == nil {
		t.Fatal("native overflow")
	}
}

func FuzzFriendRequest(f *testing.F) {
	f.Add([]byte{207, 0, 0, 0, 0, 3, 'q', 'q', 'q', 0, 0})
	f.Fuzz(func(t *testing.T, b []byte) { _, _ = parseFriendRequest(b) })
}
