package game

import (
	"bytes"
	"testing"

	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

func TestLobbyCatalogDefaultAndConfiguredRoutes(t *testing.T) {
	got, err := (Config{}).lobbyCatalog(19091)
	if err != nil {
		t.Fatal(err)
	}
	for i, old := range protocol.Catalog(19091) {
		if got[i].ID != old.ID || !bytes.Equal(got[i].Payload, old.Payload) {
			t.Fatal("default directory changed")
		}
	}
	c := Config{LobbyIDs: []uint32{1, 2}, LobbyNames: map[uint32]string{2: "新手频道"}}
	got, err = c.lobbyCatalog(19091)
	if err != nil || len(got[0].Payload) != 52 || len(got[1].Payload) != 92 {
		t.Fatal("catalog size", err)
	}
	for i := 0; i < 2; i++ {
		route, room := got[0].Payload[i*26:(i+1)*26], got[1].Payload[i*46:(i+1)*46]
		id := uint32(i + 1)
		if protocol.ReadUint32(route, 0) != id || protocol.ReadUint16(route, 4) != 19091 || protocol.ReadUint32(room, 0) != id || protocol.ReadUint32(room, 29) != id {
			t.Fatal("route/lobby ID mismatch")
		}
	}
	if !bytes.Equal(got[1].Payload[50:58], persistence.GBK("新手频道")) {
		t.Fatal("GBK name not encoded")
	}
	hub, s, _, _ := waitingRoomFixture()
	hub.Config.LobbyIDs = c.LobbyIDs
	hub.Config.LobbyNames = c.LobbyNames
	if err = hub.route(s, s.game(), protocol.Message{ID: 1157}); err != nil {
		t.Fatal(err)
	}
	replies := roomOutputs(t, s, 7080, 7070)
	if len(replies[1].Payload) != 92 {
		t.Fatal("refresh lost configured lobbies")
	}
}

func TestLobbyCatalogRejectsInvalidConfiguration(t *testing.T) {
	for _, c := range []Config{
		{LobbyIDs: []uint32{0}}, {LobbyIDs: []uint32{1, 1}}, {LobbyIDs: make([]uint32, 31)},
		{LobbyNames: map[uint32]string{2: "missing"}}, {LobbyNames: map[uint32]string{1: ""}},
		{LobbyNames: map[uint32]string{1: "bad\x00name"}}, {LobbyNames: map[uint32]string{1: "😀"}},
		{LobbyNames: map[uint32]string{1: "超过二十字节不能直接截断的频道名称"}},
	} {
		if _, err := c.lobbyCatalog(19091); err == nil {
			t.Fatal("invalid catalog accepted")
		}
	}
}
