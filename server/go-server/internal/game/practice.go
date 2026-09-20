package game

import "kungfu.local/server/internal/protocol"

// This client's built-in practice dummy uses identity 100 (captured 8121 /
// 8126 / 8150). Do not admit an arbitrary low-ID range or learn identities from
// client damage reports. Stage monsters use the separate spawn registry.
const practiceDummyUID uint64 = 100

func (r *Room) hasPracticeDummy(uid uint64) bool {
	return r.Type() == protocol.FreePractice && uid == practiceDummyUID && r.Members[uid] == nil
}
