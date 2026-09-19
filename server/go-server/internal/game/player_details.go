package game

import (
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

// 8218C0: target at +8, equipment count at +16, profile at +17 (360
// bytes), then 68-byte equipment records consumed by A3E1B0. The first
// eight bytes are not read by the handler and remain reserved.
func playerDetails(account persistence.Account) (protocol.Message, error) {
	if len(account.Profile) != 360 || (account.Profile[122] != 1 && account.Profile[122] != 2) {
		return protocol.Message{}, protocol.ErrFrame
	}
	payload := make([]byte, 377)
	protocol.WriteUint64(payload, 8, account.UID)
	copy(payload[17:], account.Profile)
	count := 0
	for _, item := range account.Inventory {
		if len(item) != 68 {
			return protocol.Message{}, protocol.ErrFrame
		}
		if protocol.ReadUint16(item, 17) == 0 {
			continue
		}
		count++
		if count > 255 {
			return protocol.Message{}, protocol.ErrFrame
		}
		payload = append(payload, item...)
	}
	payload[16] = byte(count)
	return protocol.Message{ID: 2421, Payload: payload}, nil
}
