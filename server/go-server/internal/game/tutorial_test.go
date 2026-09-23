package game

import (
	"encoding/hex"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestNativeTutorialEntryWithoutPeerRegistration(t *testing.T) {
	h, _, _, s := waitingRoomFixture()
	h.Store = recoveryStore(t)
	s.Bound, s.P2P = false, 0
	// Actual native login request from the reported disconnect, not a request
	// assembled with the multiplayer tester's P2P-first assumptions.
	p, err := hex.DecodeString("d0c2cad6d1b5c1b7000000000000000000000000000000000000000000000000010100000001b1040000b10400000400000000000000000000000000000000000000000000000000000000000000000000")
	if err != nil {
		t.Fatal(err)
	}
	roomRequest(t, h, s, 3010, p)
	created := roomOutputs(t, s, 3020)[0]
	if len(created.Payload) != 83 || s.Room == nil || !s.Room.CreationPending || s.Bound || s.P2P != 0 {
		t.Fatal("tutorial entry altered network identity or skipped native creation", s.Room)
	}
	roomRequest(t, h, s, 4030, nil)
	roomOutputs(t, s) // cannot begin before the native join handshake
	join := make([]byte, 14)
	protocol.WriteUint16(join, 0, s.Room.ID)
	roomRequest(t, h, s, 3070, join)
	entry := roomOutputs(t, s, 3100, 3160)[0]
	if len(entry.Payload) != 245 || entry.Payload[65] != 4 || entry.Payload[62] != 1 || s.Room.CreationPending {
		t.Fatal("wrong tutorial room layout")
	}
	roomRequest(t, h, s, 3070, join)
	roomOutputs(t, s)
	roomRequest(t, h, s, 3110, nil)
	roomOutputs(t, s, 3115)
	if s.Room != nil || s.game().Phase != "lobby" {
		t.Fatal("tutorial exit left stale room")
	}
}

func TestTutorialAdmissionIsNotMultiplayerBypass(t *testing.T) {
	h, _, _, s := waitingRoomFixture()
	s.Bound = false
	p := make([]byte, 81)
	p[37], p[46] = 1, 4
	protocol.WriteUint32(p, 38, 1201)
	protocol.WriteUint32(p, 42, 1201)
	for _, mutate := range []func([]byte){
		func(p []byte) { p[37] = 2 },
		func(p []byte) { p[46] = 0 },
		func(p []byte) { protocol.WriteUint32(p, 38, 104) },
		func(p []byte) { protocol.WriteUint32(p, 42, 104) },
	} {
		bad := append([]byte(nil), p...)
		mutate(bad)
		if _, err := h.roomMessage(s, s.game(), protocol.Message{ID: 3010, Payload: bad}); err == nil || s.Room != nil {
			t.Fatal("unregistered multiplayer/other map admitted")
		}
	}
	if _, err := h.resolveWithAllowed(p, func(uint32) bool { return false }); err == nil {
		t.Fatal("tutorial bypassed map closure")
	}
}

// Captured from localtest1, 2026-09-19 20:59:24: tutorial NPC effect removal.
func TestTutorialNPCEffectCapture(t *testing.T) {
	payload, err := hex.DecodeString("d61f00001127000000000000010100000000000b000000ebee0100000000000000000000000000650000000000000000000000000000000c00000000000000000000000000000000000000000000000100000051000000")
	if err != nil {
		t.Fatal(err)
	}
	for _, scenario := range []string{"tutorial", "multiplayer", "wrong-map", "wrong-sender", "wrong-context", "npc-source"} {
		t.Run(scenario, func(t *testing.T) {
			h, s, peer, _ := combatFixture()
			r := s.Room
			r.Request[37], r.Request[46] = 1, 4
			protocol.WriteUint32(r.Request, 38, 1201)
			protocol.WriteUint32(r.Request, 42, 1201)
			r.Serial = 81
			p := append([]byte(nil), payload...)
			protocol.WriteUint64(p, 4, s.UID)
			switch scenario {
			case "multiplayer":
				r.Request[46] = 0
			case "wrong-map":
				protocol.WriteUint32(r.Request, 38, 104)
			case "wrong-sender":
				protocol.WriteUint64(p, 4, peer.UID)
			case "wrong-context":
				protocol.WriteUint32(p, 83, 82)
			case "npc-source":
				protocol.WriteUint64(p, 39, s.UID)
				protocol.WriteUint64(p, 47, 101)
			}
			err := h.battleMessage(s, s.game(), protocol.Message{ID: 8071, Payload: p})
			allowed := scenario == "tutorial" || scenario == "npc-source"
			if (err == nil) != allowed {
				t.Fatalf("allowed=%v err=%v", allowed, err)
			}
			if len(peer.Output) != 0 || len(s.Output) != 0 || len(r.Members[s.UID].BattleEvents) != 0 {
				t.Fatal("local NPC event escaped into multiplayer state")
			}
		})
	}
}
