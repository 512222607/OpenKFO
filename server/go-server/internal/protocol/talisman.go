package protocol

// Native 9DE410 and 9F94B0 pass equipment slots 37/38 to the
// 99AB90/99AE70 event senders. Bytes 43..58 are not initialized by those
// senders: retain them on the wire, but never interpret them as authority.
type TalismanEvent struct {
	Kind, Sequence uint32
	Sender, Actor  uint64
	Slot           uint16
	Room, Battle   uint32
}

func ParseTalismanEvent(p []byte) (TalismanEvent, error) {
	var e TalismanEvent
	if len(p) != 75 {
		return e, ErrFrame
	}
	kind, slot := ReadUint32(p, 0), ReadUint32(p, 39)
	if (kind != 8291 && kind != 8292) || (slot != 37 && slot != 38) {
		return e, ErrFrame
	}
	e = TalismanEvent{Kind: kind, Sequence: ReadUint32(p, 19), Sender: ReadUint64(p, 4), Actor: ReadUint64(p, 59), Slot: uint16(slot), Room: ReadUint32(p, 67), Battle: ReadUint32(p, 71)}
	return e, nil
}

// Match binds the event to authenticated state, not its own claimed identity.
func (e TalismanEvent) Match(uid uint64, room, battle uint32) bool {
	return uid != 0 && e.Sender == uid && e.Actor == uid && e.Room == room && e.Battle == battle
}
