package protocol

import "math"

const (
	BattleEventPVEActorCreate uint32 = 20400
	BattleEventPVEActorRemove uint32 = 20401
)

// 93C340 produces 67B; 827AD0 forwards these fields to CPVEBaseMode's
// virtual +108. TemplateValue identifies the native monster configuration;
// its value is not an inventory item or a player UID.
type PVEActorCreate struct {
	Sender, Actor  uint64
	TemplateValue  uint32
	Position       [3]float32
	DirectionValue uint32
	Raw            [67]byte
}

func ParsePVEActorCreate(p []byte) (r PVEActorCreate, err error) {
	if len(p) != len(r.Raw) || ReadUint32(p, 0) != BattleEventPVEActorCreate {
		return r, ErrFrame
	}
	copy(r.Raw[:], p)
	r.Sender, r.Actor = ReadUint64(p, 4), ReadUint64(p, 39)
	r.TemplateValue, r.DirectionValue = ReadUint32(p, 47), ReadUint32(p, 63)
	for i := range r.Position {
		r.Position[i] = math.Float32frombits(ReadUint32(p, 51+4*i))
		if math.IsNaN(float64(r.Position[i])) || math.IsInf(float64(r.Position[i]), 0) {
			return PVEActorCreate{}, ErrFrame
		}
	}
	return r, nil
}

type PVEActorRemove struct {
	Sender, Actor uint64
	Raw           [47]byte
}

// 93C1C0 sends actor identity +39; 827A60 consumes it via virtual +10C.
// Removing an entity is not authoritative evidence of a kill or a cleared wave.
func ParsePVEActorRemove(p []byte) (r PVEActorRemove, err error) {
	if len(p) != len(r.Raw) || ReadUint32(p, 0) != BattleEventPVEActorRemove {
		return r, ErrFrame
	}
	copy(r.Raw[:], p)
	r.Sender, r.Actor = ReadUint64(p, 4), ReadUint64(p, 39)
	return r, nil
}
