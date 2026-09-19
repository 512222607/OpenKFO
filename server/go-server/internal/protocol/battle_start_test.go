package protocol

import "testing"

func TestBattleStartNativeLayout(t *testing.T) {
	p := make([]byte, 53)
	for i := range p {
		p[i] = 0xa5
	}
	WriteUint32(p, 0, 42)
	WriteUint16(p, 11, 7)
	for i := 0; i < 8; i++ {
		WriteUint32(p, 13+i*4, uint32(i*35))
	}
	r, err := ParseBattleStart(p)
	if err != nil || r.RoomID != 42 || r.ControllerSlot != 7 || r.NetworkDelay[7] != 245 {
		t.Fatal(r, err)
	}
	for _, i := range []int{4, 5, 9, 10, 45, 52} {
		if r.Raw[i] != 0xa5 {
			t.Fatal("unknown field changed", i)
		}
	}
	p[45] = 0
	if r.Raw[45] != 0xa5 {
		t.Fatal("retained input alias")
	}
	for _, n := range []int{0, 12, 45, 52, 54} {
		if _, err := ParseBattleStart(make([]byte, n)); err == nil {
			t.Fatal("invalid length accepted", n)
		}
	}
}
