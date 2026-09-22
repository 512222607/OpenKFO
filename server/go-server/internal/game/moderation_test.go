package game

import (
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"testing"
	"time"
)

func TestBannedChatNotForwarded(t *testing.T) {
	for _, id := range []uint32{5000, 5002} {
		h, s, peer, outsider := combatFixture()
		size, lo, off := 215, 12, 13
		if id == 5000 {
			size, lo, off = 256, 50, 55
		}
		p := make([]byte, size)
		text := persistence.GBK("你是ＳＢ")
		p[lo] = byte(len(text) + 1)
		copy(p[off:], text)
		if id == 5000 {
			copy(p[29:50], persistence.GBK(outsider.Nickname))
		}
		if e := h.chat(s, protocol.Message{ID: id, Payload: p}); e != nil {
			t.Fatal(e)
		}
		out := roomOutputs(t, s, notice("").ID)
		if string(out[0].Payload) != string(notice("违禁词！").Payload) {
			t.Fatal("wrong notice")
		}
		roomOutputs(t, peer)
		roomOutputs(t, outsider)
		if s.Room == nil || s.game().Phase != "battle" {
			t.Fatal("rejection disconnected sender")
		}
		s.LastChat = time.Time{}
	}
}
func TestBannedRoomNameDoesNotMutateRoom(t *testing.T) {
	h, s, peer, _ := waitingRoomFixture()
	r := s.Room
	p := make([]byte, protocol.RoomRequestSize)
	copy(p, persistence.GBK("CNM的房间"))
	if !h.rejectRoomName(s, p) {
		t.Fatal("room name allowed")
	}
	roomOutputs(t, s, notice("").ID)
	roomOutputs(t, peer)
	if s.Room != r {
		t.Fatal("room changed")
	}
}
