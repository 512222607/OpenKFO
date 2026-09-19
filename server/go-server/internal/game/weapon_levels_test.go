package game

import (
	"bytes"
	"encoding/hex"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestWeaponLevelWireAndRouting(t *testing.T) {
	h, s, peer, _ := waitingRoomFixture()
	// Synthetic values, not an official table. Deliberately exercise the
	// unaligned unsigned field at +17 and nonzero unknown byte +16.
	h.Config.WeaponLevels = []WeaponLevel{{0, 1000, 500, 75, 0xa5, 0xf1234567}, {1, 2000, 900, 50, 0, 200}}
	want, _ := hex.DecodeString("00000000e8030000f40100004b000000a5674523f101000000d0070000840300003200000000c8000000")
	for _, phase := range []string{"lobby", "room"} {
		s.game().Phase = phase
		for attempt := 0; attempt < 2; attempt++ {
			if err := h.route(s, s.game(), protocol.Message{ID: 21410}); err != nil {
				t.Fatal(err)
			}
			got := roomOutputs(t, s, 21411)[0]
			if !bytes.Equal(got.Payload, want) {
				t.Fatalf("wire = %x, want %x", got.Payload, want)
			}
			roomOutputs(t, peer)
		}
	}
	for _, m := range []protocol.Message{{ID: 21410, Payload: []byte{0}}, {ID: 21412}, {ID: 21412, Payload: make([]byte, 5)}} {
		if h.route(s, s.game(), m) == nil {
			t.Fatal("invalid request accepted", m.ID)
		}
		roomOutputs(t, s)
	}
	s.game().Phase = "battle"
	if err := h.route(s, s.game(), protocol.Message{ID: 21410}); err != nil {
		t.Fatal(err)
	}
	roomOutputs(t, s)
}

func TestWeaponLevelConfigurationValidation(t *testing.T) {
	for _, c := range []Config{{WeaponUpgradeMode: "unknown"}, {WeaponUpgradeMode: "consume_score_keep_level"}} {
		if c.ValidateWeaponLevels() == nil {
			t.Fatal("invalid upgrade mode/config accepted")
		}
	}
	for _, rows := range [][]WeaponLevel{
		{{Level: 1, ScoreThreshold: 1}},
		{{ScoreThreshold: 0}},
		{{ScoreThreshold: 1, DisplayOdds: 101}},
		{{ScoreThreshold: 1}, {Level: 0, ScoreThreshold: 2}},
		make([]WeaponLevel, 257),
	} {
		if _, err := (Config{WeaponLevels: rows}).weaponLevelPayload(); err == nil {
			t.Fatal("bad table accepted")
		}
	}
	h, s, _, _ := waitingRoomFixture()
	for _, m := range []protocol.Message{{ID: 21410}, {ID: 21412, Payload: protocol.Uint32Bytes(123)}} {
		if err := h.route(s, s.game(), m); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, s, 20150)
	}
}
