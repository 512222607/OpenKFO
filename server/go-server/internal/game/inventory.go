package game

import (
	"bytes"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
	"sort"
)

func (s *Session) rememberInventory(records [][]byte) {
	s.Inventory = make(map[uint32][]byte, len(records))
	for _, r := range records {
		s.Inventory[protocol.ReadUint32(r, 0)] = bytes.Clone(r)
	}
}

func (s *Session) syncInventory(records [][]byte) {
	seen := make(map[uint32]bool, len(records))
	for _, r := range records {
		id := protocol.ReadUint32(r, 0)
		seen[id] = true
		old, exists := s.Inventory[id]
		if bytes.Equal(old, r) {
			continue
		}
		messageID := uint32(2160)
		if exists {
			messageID = 2161
		}
		s.sendGame(protocol.Message{ID: messageID, Payload: bytes.Clone(r)})
	}
	// Deletion's incremental layout is unverified; use the existing full snapshot.
	for id := range s.Inventory {
		if !seen[id] {
			s.sendGame(protocol.Message{ID: 1120, Payload: bytes.Join(records, nil)})
			break
		}
	}
	s.rememberInventory(records)
}

func weaponCollection(account persistence.Account) protocol.Message {
	ids := map[uint32]bool{}
	for _, r := range account.Inventory {
		if len(r) == 68 && r[4] == 25 && protocol.ReadUint32(r, 19) != 0xffffffff {
			ids[protocol.ReadUint32(r, 5)] = true
		}
	}
	ordered := make([]uint32, 0, len(ids))
	for id := range ids {
		ordered = append(ordered, id)
	}
	sort.Slice(ordered, func(i, j int) bool { return ordered[i] < ordered[j] })
	p := make([]byte, 20+9*len(ordered))
	protocol.WriteUint64(p, 8, account.UID)
	protocol.WriteUint32(p, 16, uint32(len(ordered)))
	for i, id := range ordered {
		protocol.WriteUint32(p, 20+i*9, id)
		p[20+i*9+8] = 1
	}
	return protocol.Message{ID: 2431, Payload: p}
}
