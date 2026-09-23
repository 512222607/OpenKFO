package game

import (
	"strings"
	"testing"
	"time"

	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

func TestSoloFosterReadyReachesNetworkProbe(t *testing.T) {
	for _, mode := range []protocol.RoomType{protocol.FosterMode, protocol.StageAssault, protocol.SoloSurvival, protocol.TeamSurvival} {
		t.Run(mode.String(), func(t *testing.T) {
			h, owner, peer, _ := waitingRoomFixture()
			r := owner.Room
			delete(r.Members, peer.UID)
			peer.Room = nil
			r.Request[protocol.RoomTypeOffset] = byte(mode)
			owner.P2PUntil = time.Now().Add(time.Minute)
			roomRequest(t, h, owner, protocol.MsgReady, nil)
			defer h.cancelNetworkProbe(r)
			if mode == protocol.FosterMode || mode == protocol.StageAssault {
				roomOutputs(t, owner, protocol.MsgPlayerReady, protocol.MsgNetworkDelayProbe)
				if r.NetworkProbe == nil || !r.Members[owner.UID].Ready || r.Stage != "room" {
					t.Fatal("solo PVE did not reach normal pre-start validation")
				}
			} else {
				roomOutputs(t, owner)
				if r.NetworkProbe != nil || r.Members[owner.UID].Ready {
					t.Fatal("competitive room incorrectly allowed solo start")
				}
			}
		})
	}
}

func TestPersistedFosterPlan(t *testing.T) {
	hash := strings.Repeat("a", 64)
	c := Config{ConfigHash: hash}
	a := persistence.StageAccess{ClientHash: hash, PVEMaps: []uint32{8110}, Requirements: []persistence.StageTitleRequirement{{MapID: 8110, Name: "Stage"}}, FosterPlans: []persistence.FosterConfig{{MapID: 8110, ScriptHash: hash, RuntimeHash: hash, ConfigHash: hash, Templates: []string{"Monster"}, Plan: protocol.FosterPlan{InitialHP: []float32{8}, PlayerLimit: 6, GlobalLimit: 32, Groups: []protocol.FosterGroup{{SubLimit: 2, GroupLimit: 20, Spawns: []protocol.FosterSpawn{{Template: 0, Direction: 2}}}}}}}}
	for _, players := range []int{1, 2, 6} {
		if _, err := c.persistedFosterPlan(a, 8110, players); err != nil {
			t.Fatal("supported party rejected", players, err)
		}
	}
	plan, err := c.persistedFosterPlan(a, 8110, 2)
	if err != nil {
		t.Fatal(err)
	}
	a.FosterPlans[0].Plan.Groups[0].Spawns[0].Direction = 4
	a.FosterPlans[0].Plan.Groups[0].SubLimit = 1
	a.FosterPlans[0].Plan.InitialHP[0] = 75
	if plan.InitialHP[0] != 8 {
		t.Fatal("GM HP edit changed current battle")
	}
	if plan.Groups[0].Spawns[0].Direction != 2 || plan.Groups[0].SubLimit != 2 {
		t.Fatal("GM mutation affected current battle")
	}
	next, err := c.persistedFosterPlan(a, 8110, 2)
	if err != nil || next.InitialHP[0] != 75 || next.Groups[0].Spawns[0].Direction != 4 || next.Groups[0].SubLimit != 1 {
		t.Fatal("next battle missed GM update", err)
	}
	for _, scenario := range []string{"version", "disabled", "missing", "empty-party", "large-party", "unknown-map", "missing-hp"} {
		policy, mapID, players := a, uint32(8110), 2
		switch scenario {
		case "version":
			policy.ClientHash = strings.Repeat("b", 64)
		case "missing-hp":
			policy.FosterPlans = append([]persistence.FosterConfig(nil), a.FosterPlans...)
			policy.FosterPlans[0].Plan.InitialHP = nil
		case "disabled":
			policy.Disabled = []uint32{8110}
		case "missing":
			policy.FosterPlans = nil
		case "empty-party":
			players = 0
		case "large-party":
			players = 7
		case "unknown-map":
			mapID = 8111
		}
		if _, err := c.persistedFosterPlan(policy, mapID, players); err == nil {
			t.Fatal("invalid plan accepted", scenario)
		}
	}
}

func TestFosterStartFailureKeepsSessions(t *testing.T) {
	h, owner, peer, _ := waitingRoomFixture()
	r := owner.Room
	r.Request[46] = byte(protocol.FosterMode)
	for _, m := range r.Members {
		m.Ready = true
	}
	h.beginNetworkProbe(r)
	defer h.cancelNetworkProbe(r)
	for _, s := range []*Session{owner, peer} {
		if err := h.networkDelayReply(s, nil); err != nil {
			t.Fatal("configuration failure disconnected player", err)
		}
	}
	if r.Stage != "room" || r.FosterPlan != nil || owner.Room != r || peer.Room != r || r.NetworkProbe != nil {
		t.Fatal("failed start changed room")
	}
	for _, m := range r.Members {
		if m.Ready {
			t.Fatal("failed start left ready state")
		}
	}
}
