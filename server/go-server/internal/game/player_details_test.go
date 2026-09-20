package game

import (
	"bytes"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestPlayerDetailsUsesTargetProfileAndOnlyEquippedItems(t *testing.T) {
	a, err := persistence.NewAccountWithStarterCharacter(10002, "detailstest", "123456")
	if err != nil {
		t.Fatal(err)
	}
	equipped, spare := make([]byte, 68), make([]byte, 68)
	equipped[4], spare[4] = 25, 25
	protocol.WriteUint16(equipped, 17, 8)
	a.Inventory = [][]byte{spare, equipped}
	m, err := playerDetails(a)
	if err != nil {
		t.Fatal(err)
	}
	if m.ID != 2421 || len(m.Payload) != 445 || protocol.ReadUint64(m.Payload, 8) != a.UID || m.Payload[16] != 1 || !bytes.Equal(m.Payload[17:377], a.Profile) || !bytes.Equal(m.Payload[377:], equipped) {
		t.Fatal("incorrect native profile response")
	}
	if m.Payload[139] != a.Profile[122] || m.Payload[141] != a.Profile[124] {
		t.Fatal("client model fields do not align")
	}
	a.Profile[122] = 0
	if _, err = playerDetails(a); err == nil {
		t.Fatal("unsupported model would be silently ignored")
	}
}

func TestViewOtherPlayerRoutes2420To2421(t *testing.T) {
	hub, viewer, target, _ := waitingRoomFixture()
	hub.Store = recoveryStore(t)
	request := make([]byte, 8)
	protocol.WriteUint64(request, 0, target.UID)
	if err := hub.route(viewer, viewer.game(), protocol.Message{ID: 2420, Payload: request}); err != nil {
		t.Fatal(err)
	}
	packets := roomOutputs(t, viewer, 2421)
	if protocol.ReadUint64(packets[0].Payload, 8) != target.UID {
		t.Fatal("returned viewer instead of selected player")
	}
	roomOutputs(t, target)
	// The basic statistics tab keeps the same selected-player UID and
	// appends opaque client state (captured: c4 b6 af d7).
	stats := append(append([]byte(nil), request...), 0xc4, 0xb6, 0xaf, 0xd7)
	if err := hub.route(viewer, viewer.game(), protocol.Message{ID: 20360, Payload: stats}); err != nil {
		t.Fatal("viewing another player's statistics disconnected viewer", err)
	}
	roomOutputs(t, viewer, 20370)
	roomOutputs(t, target)
	if err := hub.route(viewer, viewer.game(), protocol.Message{ID: 20360, Payload: stats[:11]}); err == nil {
		t.Fatal("accepted truncated statistics request")
	}
	// Native 2421 consumer immediately queries the selected player's 21000.
	// Regression: treating that read target as the login identity disconnected
	// the viewer after an otherwise correct profile response.
	if err := hub.route(viewer, viewer.game(), protocol.Message{ID: 21000, Payload: request}); err != nil {
		t.Fatal(err)
	}
	status := roomOutputs(t, viewer, 21001)[0].Payload
	if len(status) != 56 || protocol.ReadUint64(status, 0) != target.UID || protocol.ReadUint32(status, 20) != uint32(target.UID) || protocol.ReadUint32(status, 28) != 1 {
		t.Fatal("training status did not use selected target")
	}
	roomOutputs(t, target)
	if err := hub.route(viewer, viewer.game(), protocol.Message{ID: 1232}); err != nil {
		t.Fatal("profile chain broke subsequent requests", err)
	}
	roomOutputs(t, viewer, 1230)
	if err := hub.route(viewer, viewer.game(), protocol.Message{ID: 21000, Payload: protocol.Uint64Bytes(999999)}); err != nil {
		t.Fatal("missing profile disconnected viewer", err)
	}
	roomOutputs(t, viewer, 20150)
	if err := hub.route(viewer, viewer.game(), protocol.Message{ID: 21002, Payload: request}); err == nil {
		t.Fatal("training start accepted another UID")
	}
	if err := hub.route(viewer, viewer.game(), protocol.Message{ID: 21000, Payload: request[:7]}); err == nil {
		t.Fatal("accepted truncated training UID")
	}
	if err := hub.route(viewer, viewer.game(), protocol.Message{ID: 2420, Payload: request[:7]}); err == nil {
		t.Fatal("accepted truncated UID")
	}
}
