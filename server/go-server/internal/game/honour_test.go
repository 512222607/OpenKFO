package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestHonourPolicyIsolation(t *testing.T) {
	c := Config{Honour: HonourRules{Periods: []string{"第一期", "第二期"}, Modes: []byte{1}, Win: 10, Loss: 2, Draw: 3}}
	if err := c.ValidateHonour(); err != nil {
		t.Fatal(err)
	}
	for _, v := range []struct {
		mode           byte
		outcome        string
		players        int
		period, points uint32
	}{{1, "win", 2, 2, 10}, {1, "loss", 2, 2, 2}, {1, "draw", 2, 2, 3}, {0, "win", 2, 0, 0}, {1, "unconfirmed", 2, 0, 0}, {1, "win", 1, 0, 0}, {5, "win", 2, 0, 0}} {
		p, n := c.honourAward(v.mode, v.outcome, v.players)
		if p != v.period || n != v.points {
			t.Fatal(v, p, n)
		}
	}
	for _, r := range []HonourRules{{Modes: []byte{0}}, {Periods: []string{"x"}, Modes: []byte{5}}, {Periods: []string{"x"}, Modes: []byte{1, 1}}, {Periods: []string{"bad\x00name"}}, {Periods: []string{"😀"}}, {Win: 0xffffffff}} {
		if (Config{Honour: r}).ValidateHonour() == nil {
			t.Fatal("invalid policy accepted")
		}
	}
	h, s, _, _ := waitingRoomFixture()
	for _, period := range []uint32{0, 1, 0xffffffff} {
		p := make([]byte, 12)
		protocol.WriteUint64(p, 0, s.UID)
		protocol.WriteUint32(p, 8, period)
		if err := h.route(s, s.game(), protocol.Message{ID: 20360, Payload: p}); err != nil {
			t.Fatal(err)
		}
		r := roomOutputs(t, s, 20370)[0]
		if len(r.Payload) != 37 || protocol.ReadUint32(r.Payload, 0) != 0 {
			t.Fatal("missing history must clear UI")
		}
	}
}

func TestHonourLevelThresholds(t *testing.T) {
	rules := HonourRules{Periods: []string{"第一期"}, LevelPoints: []uint32{100, 300, 500}}
	if err := (Config{Honour: rules}).ValidateHonour(); err != nil {
		t.Fatal(err)
	}
	for _, tc := range []struct{ points, level uint32 }{{0, 0}, {99, 0}, {100, 1}, {299, 1}, {300, 2}, {499, 2}, {500, 3}, {0x7fffffff, 3}} {
		if got := rules.level(tc.points); got != tc.level {
			t.Fatal(tc, got)
		}
	}
	if (HonourRules{}).level(10000) != 0 {
		t.Fatal("unconfigured grading")
	}
	for _, thresholds := range [][]uint32{{1, 1}, {10, 9}, {0x80000000}, make([]uint32, 11)} {
		rules.LevelPoints = thresholds
		if (Config{Honour: rules}).ValidateHonour() == nil {
			t.Fatal("invalid grade table", thresholds)
		}
	}
	rules.LevelPoints = []uint32{0}
	if rules.level(0) != 1 {
		t.Fatal("explicit first grade")
	}
	rules.Periods = nil
	if (Config{Honour: rules}).ValidateHonour() == nil {
		t.Fatal("no history")
	}
}
