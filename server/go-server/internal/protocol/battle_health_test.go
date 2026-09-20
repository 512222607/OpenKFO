package protocol

import (
	"math"
	"testing"
)

func TestBattleHealthAmountNotFinalHP(t *testing.T) {
	for _, amount := range []float32{800, -120, 0} {
		p := make([]byte, 94)
		WriteUint32(p, 0, BattleEventHealth)
		WriteUint64(p, 4, 100)
		WriteUint64(p, 39, 42)
		WriteUint64(p, 47, 101)
		WriteUint32(p, 67, math.Float32bits(amount))
		WriteUint32(p, 72, math.Float32bits(-5))
		WriteUint32(p, 76, math.Float32bits(3))
		WriteUint64(p, 86, 7|(uint64(9)<<32))
		r, err := ParseBattleHealth(p)
		if err != nil || r.Sender != 100 || r.Target != 42 || r.Source != 101 || r.Damage != amount || r.TargetManaDelta != -5 || r.SourceManaDelta != 3 || r.Context != 7|(uint64(9)<<32) {
			t.Fatal(r, err)
		}
		for _, offset := range []int{67, 72, 76, 80} {
			bad := append([]byte(nil), p...)
			WriteUint32(bad, offset, math.Float32bits(float32(math.NaN())))
			if _, err := ParseBattleHealth(bad); err == nil {
				t.Fatal("nonfinite field accepted", offset)
			}
		}
		if _, err := ParseBattleHealth(p[:93]); err == nil {
			t.Fatal("short health frame accepted")
		}
		WriteUint32(p, 0, BattleEventState)
		if _, err := ParseBattleHealth(p); err == nil {
			t.Fatal("state interpreted as HP")
		}
	}
}
