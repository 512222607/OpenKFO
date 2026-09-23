package game

import (
	"bytes"
	"encoding/hex"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestFosterRoomCapturedCreate(t *testing.T) {
	request, err := hex.DecodeString("74657374303032b5c4b7bfbce400000000000000000000000000000000000000000101010006b11f0000b11f00000ae70300000000000000000000000000000000000028e71a0000000000000000000000")
	if err != nil {
		t.Fatal(err)
	}
	hash := strings.Repeat("a", 64)
	h := NewHub(nil, Config{ConfigHash: hash})
	access := persistence.StageAccess{ClientHash: hash, PVEMaps: []uint32{8110, 8113, 9170}, WavePlans: []persistence.StageWaveConfig{{MapID: 9170}}}
	resolved, err := h.resolveWithAccess(request, access)
	if err != nil || !bytes.Equal(resolved, request) {
		t.Fatal("captured 8113 request rejected or altered", err)
	}
	for _, scenario := range []string{"unknown", "closed", "version", "wave-map", "capacity", "suggested"} {
		r := bytes.Clone(request)
		a := access
		switch scenario {
		case "unknown":
			protocol.WriteUint32(r, protocol.RoomMapOffset, 999999)
		case "closed":
			a.Disabled = []uint32{8113}
		case "version":
			a.ClientHash = ""
		case "wave-map":
			protocol.WriteUint32(r, protocol.RoomMapOffset, 9170)
			protocol.WriteUint32(r, protocol.RoomSuggestedMapOffset, 9170)
		case "capacity":
			r[protocol.RoomCapacityOffset] = 0
		case "suggested":
			protocol.WriteUint32(r, protocol.RoomSuggestedMapOffset, 8110)
		}
		if _, err := h.resolveWithAccess(r, a); err == nil {
			t.Fatal("invalid admission", scenario)
		}
	}
	// Missing event plans must still prevent starting the battle.
	if _, err := h.Config.persistedFosterPlan(access, 8113, 1); err == nil {
		t.Fatal("missing plan admitted to battle")
	}
}

func TestPVECreationAcknowledgement(t *testing.T) {
	for _, mode := range []protocol.RoomType{protocol.FosterMode, protocol.StageAssault} {
		h, owner, peer, _ := waitingRoomFixture()
		r := owner.Room
		r.Request[protocol.RoomTypeOffset] = byte(mode)
		m := r.Members[owner.UID]
		delete(r.Members, owner.UID)
		delete(r.Members, peer.UID)
		h.completeRoomJoin(r, m, make([]byte, 68), nil)
		p := roomOutputs(t, owner, protocol.MsgRoomCreated)[0].Payload
		if len(p) != 83 || protocol.ReadUint16(p, 0) != r.ID || !bytes.Equal(p[2:], r.Request) || !r.CreationPending {
			t.Fatal("invalid PVE create acknowledgement")
		}
	}
}
