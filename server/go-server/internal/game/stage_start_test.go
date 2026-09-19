package game

import (
	"bytes"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"strings"
	"testing"
)

func TestStageStartConfigurationFailureKeepsSessions(t *testing.T) {
	h, owner, peer, _ := waitingRoomFixture()
	r := owner.Room
	r.Request[46] = byte(protocol.StageAssault)
	for _, m := range r.Members {
		m.Ready = true
	}
	h.beginNetworkProbe(r)
	defer h.cancelNetworkProbe(r)
	if err := h.networkDelayReply(owner, nil); err != nil {
		t.Fatal(err)
	}
	if err := h.networkDelayReply(peer, nil); err != nil {
		t.Fatal("configuration failure disconnected player", err)
	}
	if owner.Room != r || peer.Room != r || r.Stage != "room" || r.StageWaves != nil || r.NetworkProbe != nil {
		t.Fatal("failed initialization changed room")
	}
	for _, m := range r.Members {
		if m.Ready {
			t.Fatal("failed initialization left player ready")
		}
	}
}

func TestPersistedStagePlan(t *testing.T) {
	hash := strings.Repeat("a", 64)
	c := Config{ConfigHash: hash, StageWaves: map[uint32][]StageWavePlan{9170: {{Monsters: map[uint32]uint32{0: 99}}}}}
	a := persistence.StageAccess{ClientHash: hash, PVEMaps: []uint32{9170}, Requirements: []persistence.StageTitleRequirement{{MapID: 9170, Name: "Stage"}}, WavePlans: []persistence.StageWaveConfig{{MapID: 9170, ScriptHash: hash, RuntimeHash: hash, Templates: []string{"Monster"}, Variants: []StageWaveVariant{{MinPlayers: 1, MaxPlayers: 2, Waves: []StageWavePlan{{Monsters: map[uint32]uint32{0: 4}}}}}}}}
	t.Run("admission requires matching saved plan", func(t *testing.T) {
		h := &Hub{Config: c}
		request := make([]byte, protocol.RoomRequestSize)
		request[protocol.RoomTypeOffset] = byte(protocol.StageAssault)
		protocol.WriteUint32(request, protocol.RoomMapOffset, 9170)
		for _, capacity := range []byte{1, 2} {
			request[protocol.RoomCapacityOffset] = capacity
			before := bytes.Clone(request)
			resolved, err := h.resolveWithAccess(request, a)
			if err != nil || protocol.ReadUint32(resolved, protocol.RoomSuggestedMapOffset) != 9170 || !bytes.Equal(before, request) {
				t.Fatal("valid stage admission", err)
			}
		}
		for _, kind := range []string{"missing", "version", "closed", "capacity", "map", "suggested", "foster"} {
			bad := bytes.Clone(request)
			policy := a
			switch kind {
			case "missing":
				policy.WavePlans = nil
			case "version":
				policy.ClientHash = strings.Repeat("b", 64)
			case "closed":
				policy.Disabled = []uint32{9170}
			case "capacity":
				bad[protocol.RoomCapacityOffset] = 3
			case "map":
				protocol.WriteUint32(bad, protocol.RoomMapOffset, 0)
			case "suggested":
				protocol.WriteUint32(bad, protocol.RoomSuggestedMapOffset, 9171)
			case "foster":
				bad[protocol.RoomTypeOffset] = byte(protocol.FosterMode)
			}
			policy.ForceOpenAll = true
			if _, err := h.resolveWithAccess(bad, policy); err == nil {
				t.Fatal("force-open bypassed", kind)
			}
		}
	})
	w, err := c.persistedStagePlan(a, 9170, 2)
	if err != nil || w.plans[0].Monsters[0] != 4 {
		t.Fatal(w, err)
	}
	a.WavePlans[0].Variants[0].Waves[0].Monsters[0] = 8
	if w.plans[0].Monsters[0] != 4 {
		t.Fatal("GM edit mutated an active battle")
	}
	newWave, err := c.persistedStagePlan(a, 9170, 2)
	if err != nil || newWave.plans[0].Monsters[0] != 8 {
		t.Fatal("next battle missed edited plan", err)
	}
	for _, kind := range []string{"version", "disabled", "missing", "party", "map"} {
		b := a
		id := uint32(9170)
		players := 2
		switch kind {
		case "version":
			b.ClientHash = strings.Repeat("b", 64)
		case "disabled":
			b.Disabled = []uint32{9170}
		case "missing":
			b.WavePlans = nil
		case "party":
			players = 3
		case "map":
			id = 9171
		}
		if _, err := c.persistedStagePlan(b, id, players); err == nil {
			t.Fatal("accepted", kind)
		}
	}
}
