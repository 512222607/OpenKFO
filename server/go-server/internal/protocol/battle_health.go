package protocol

import "math"

// Native 82A9D0 consumes an amount at +67, not an absolute HP value.
// Positive amounts enter damage processing; nonpositive amounts negate into
// HP addition. In the positive-damage branch +72/+76 enter 9E55A0
// (MP changes), not HP setters. Those parameters are raw values here.
type BattleHealth struct {
	Sender, Target, Source                   uint64
	Damage, TargetManaDelta, SourceManaDelta float32
	Context                                  uint64
}

func ParseBattleHealth(p []byte) (r BattleHealth, err error) {
	if len(p) != 94 || ReadUint32(p, 0) != BattleEventHealth {
		return r, ErrFrame
	}
	for _, offset := range []int{67, 72, 76, 80} {
		value := math.Float32frombits(ReadUint32(p, offset))
		if math.IsNaN(float64(value)) || math.IsInf(float64(value), 0) {
			return r, ErrFrame
		}
	}
	r.Sender, r.Target, r.Source = ReadUint64(p, 4), ReadUint64(p, 39), ReadUint64(p, 47)
	r.Damage = math.Float32frombits(ReadUint32(p, 67))
	r.TargetManaDelta = math.Float32frombits(ReadUint32(p, 72))
	r.SourceManaDelta = math.Float32frombits(ReadUint32(p, 76))
	r.Context = ReadUint64(p, 86)
	return r, nil
}
