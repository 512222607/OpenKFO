package game

import (
	"bytes"
	"encoding/hex"
	"encoding/json"
	"os"
	"strconv"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestPracticeHealthCapturedReplay(t *testing.T) {
	b, err := os.ReadFile("testdata/practice-health-8121.json")
	if err != nil {
		t.Fatal(err)
	}
	var packets []string
	if err := json.Unmarshal(b, &packets); err != nil {
		t.Fatal(err)
	}
	if len(packets) != 104 {
		t.Fatal("incomplete captured regression")
	}
	h, owner, peer, outsider := combatFixture()
	owner.Room.Request[46] = byte(protocol.FreePractice)
	for _, encoded := range packets {
		p, err := hex.DecodeString(encoded)
		if err != nil {
			t.Fatal(err)
		}
		// Preserve captured flags, sequence and effect values; remap only
		// authenticated fixture identities and the current battle context.
		protocol.WriteUint64(p, 4, owner.UID)
		protocol.WriteUint64(p, 47, peer.UID)
		protocol.WriteUint32(p, 86, uint32(owner.Room.ID))
		protocol.WriteUint32(p, 90, owner.Room.Serial)
		m := protocol.Message{ID: 8071, Payload: p}
		if err := h.battleMessage(owner, owner.game(), m); err != nil {
			t.Fatal(err)
		}
		out := roomOutputs(t, peer, 8071)
		if !bytes.Equal(out[0].Payload, p) {
			t.Fatal("changed native health packet")
		}
		roomOutputs(t, owner)
		roomOutputs(t, outsider)
		if err := h.battleMessage(owner, owner.game(), m); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, peer)
		protocol.WriteUint64(p, 4, peer.UID)
		if err := h.battleMessage(peer, peer.game(), m); err != nil {
			t.Fatal(err)
		}
		roomOutputs(t, owner)
		roomOutputs(t, peer)
	}
}

func TestPracticeDummyStateAndTrustBoundaries(t *testing.T) {
	for _, event := range []struct {
		id            uint32
		size, context int
	}{
		{protocol.BattleEventHealth, 94, 86},
		{protocol.BattleEventState, 51, 0},
		{protocol.BattleEventBuff, 87, 79},
		{protocol.BattleEventSkillEffect, 71, 0},
	} {
		t.Run(strconv.FormatUint(uint64(event.id), 10), func(t *testing.T) {
			h, owner, peer, _ := combatFixture()
			owner.Room.Request[46] = byte(protocol.FreePractice)
			m := combatPacket(event.id, event.size, owner.UID, practiceDummyUID, event.context)
			if event.id == protocol.BattleEventSkillEffect {
				protocol.WriteUint64(m.Payload, 55, practiceDummyUID)
			}
			if event.id == protocol.BattleEventState {
				protocol.WriteUint32(m.Payload, 47, 7)
			} else {
				protocol.WriteUint64(m.Payload, 47, peer.UID)
			}
			valid := bytes.Clone(m.Payload)
			protocol.WriteUint64(m.Payload, 4, peer.UID)
			if err := h.battleMessage(owner, owner.game(), m); err == nil {
				t.Fatal("spoofed sender admitted")
			}
			m.Payload = bytes.Clone(valid)
			if event.context != 0 {
				protocol.WriteUint32(m.Payload, event.context+4, owner.Room.Serial+1)
				if err := h.battleMessage(owner, owner.game(), m); err == nil {
					t.Fatal("stale battle admitted")
				}
				m.Payload = bytes.Clone(valid)
			}
			owner.Room.Request[46] = byte(protocol.TeamSurvival)
			if err := h.battleMessage(owner, owner.game(), m); err == nil {
				t.Fatal("practice identity escaped mode")
			}
			owner.Room.Request[46] = byte(protocol.FreePractice)
			if err := h.battleMessage(owner, owner.game(), m); err != nil {
				t.Fatal(err)
			}
			roomOutputs(t, peer, 8071)
			roomOutputs(t, owner)
		})
	}
}
