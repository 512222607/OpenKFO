package persistence

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestTaskBattleCounterMapping(t *testing.T) {
	for mode := byte(0); mode < 4; mode++ {
		p := make([]byte, 360)
		for _, outcome := range []string{"win", "loss", "draw"} {
			addTaskBattleCounters(p, &mode, outcome, 2)
		}
		for i := 0; i < 29; i++ {
			want := uint32(0)
			if i == 1+int(mode)*2 {
				want = 3
			}
			if i == 2+int(mode)*2 {
				want = 1
			}
			if got := protocol.ReadUint32(p, 129+i*4); got != want {
				t.Fatal(mode, i, got, want)
			}
		}
		protocol.WriteUint32(p, 133+int(mode)*8, 0x7fffffff)
		addTaskBattleCounters(p, &mode, "win", 2)
		if protocol.ReadUint32(p, 133+int(mode)*8) != 0x7fffffff {
			t.Fatal("counter wrapped")
		}
	}
	for _, c := range []struct {
		mode    byte
		outcome string
		players int
	}{{0, "unconfirmed", 2}, {5, "win", 2}, {0, "win", 1}, {255, "win", 8}} {
		p := make([]byte, 360)
		addTaskBattleCounters(p, &c.mode, c.outcome, c.players)
		for _, v := range p {
			if v != 0 {
				t.Fatal("ineligible battle counted", c)
			}
		}
	}
}
