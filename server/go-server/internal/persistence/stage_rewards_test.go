package persistence

import (
	"encoding/json"
	"testing"
)

func TestStageRewardRules(t *testing.T) {
	var rules RewardRules
	if err := json.Unmarshal([]byte(`{"stage_rewards":[{"map_id":20051,"clear":{"experience":20,"gold":7,"tickets":2,"items":[12]},"failed":{"gold":1}}]}`), &rules); err != nil {
		t.Fatal(err)
	}
	if err := rules.Normalized().Validate(); err != nil {
		t.Fatal(err)
	}
	clear, ok := rules.StageReward(20051, StageOutcomeClear)
	if !ok || clear.Experience != 20 || clear.Gold != 7 || clear.Tickets != 2 || len(clear.Items) != 1 {
		t.Fatal("configuration fields lost", clear)
	}
	failed, ok := rules.StageReward(20051, StageOutcomeFailed)
	if !ok || failed.Gold != 1 || failed.Experience != 0 {
		t.Fatal("failed reward wrong")
	}
	for _, q := range []struct {
		mapID   uint32
		outcome string
	}{{1, StageOutcomeClear}, {20051, "win"}, {20051, ""}} {
		if _, ok := rules.StageReward(q.mapID, q.outcome); ok {
			t.Fatal("invalid stage matched")
		}
	}
	for _, bad := range [][]StageMapRewards{
		{{MapID: 0}}, {{MapID: 1}, {MapID: 1}}, make([]StageMapRewards, 257),
		{{MapID: 1, Clear: StageReward{Experience: 1000001}}},
		{{MapID: 1, Failed: StageReward{RewardBundle: RewardBundle{Items: []uint32{0}}}}},
		{{MapID: 1, Clear: StageReward{RewardBundle: RewardBundle{Tickets: 1000001}}}},
	} {
		if validateStageRewards(bad) == nil {
			t.Fatal("invalid stage configuration accepted")
		}
	}
}
