package game

import (
	"bytes"
	"fmt"
	"strings"
	"unicode"

	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

func (c Config) lobbyName(id uint32) string {
	if name, ok := c.LobbyNames[id]; ok {
		return name
	}
	if id == 1 {
		return "Local Lobby"
	}
	return fmt.Sprintf("Lobby %d", id)
}

func (c Config) ValidateLobbies() error {
	if len(c.LobbyIDs) > 30 {
		return fmt.Errorf("at most 30 lobbies are supported")
	}
	ids := c.LobbyIDs
	if len(ids) == 0 {
		ids = []uint32{1}
	}
	seen := map[uint32]bool{}
	for _, id := range ids {
		name := c.lobbyName(id)
		raw := persistence.GBK(name)
		decoded, err := persistence.DecodeGBK(raw)
		if id == 0 || seen[id] || err != nil || decoded != name || len(raw) == 0 || len(raw) > 20 || strings.TrimSpace(name) != name || strings.IndexFunc(name, unicode.IsControl) >= 0 {
			return fmt.Errorf("invalid or duplicate lobby ID/name")
		}
		seen[id] = true
	}
	for id := range c.LobbyNames {
		if !seen[id] {
			return fmt.Errorf("lobby name has no configured ID")
		}
	}
	return nil
}

// A2BA90 consumes 26-byte endpoints; A2BAD0 consumes 46-byte lobbies.
// Distinct routes prevent the native UI from reusing the previous lobby connection.
func (c Config) lobbyCatalog(port uint16) ([]protocol.Message, error) {
	if err := c.ValidateLobbies(); err != nil {
		return nil, err
	}
	ids := c.LobbyIDs
	if len(ids) == 0 {
		ids = []uint32{1}
	}
	base := protocol.Catalog(port)
	result := []protocol.Message{{ID: 7080}, {ID: 7070}}
	for _, id := range ids {
		endpoint, lobby := bytes.Clone(base[0].Payload), bytes.Clone(base[1].Payload)
		protocol.WriteUint32(endpoint, 0, id)
		protocol.WriteUint32(lobby, 0, id)
		clear(lobby[4:25])
		copy(lobby[4:25], persistence.GBK(c.lobbyName(id)))
		protocol.WriteUint32(lobby, 29, id)
		result[0].Payload = append(result[0].Payload, endpoint...)
		result[1].Payload = append(result[1].Payload, lobby...)
	}
	return result, nil
}
