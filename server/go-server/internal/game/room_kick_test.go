package game

import (
	"kungfu.local/server/internal/protocol"
	"testing"
)

func TestRoomKickRejectionsPreserveRoomAndConnection(t *testing.T) {
	for _, scenario := range []string{"short", "long", "flag", "self", "missing", "loading", "battle", "stale session"} {
		t.Run(scenario, func(t *testing.T) {
			h, host, peer, _ := waitingRoomFixture()
			r := host.Room
			payload := append(protocol.Uint64Bytes(peer.UID), 0)
			switch scenario {
			case "short":
				payload = payload[:8]
			case "long":
				payload = append(payload, 0)
			case "flag":
				payload[8] = 1
			case "self":
				protocol.WriteUint64(payload, 0, host.UID)
			case "missing":
				protocol.WriteUint64(payload, 0, 99999)
			case "loading", "battle":
				r.Stage = scenario
			case "stale session":
				r.Members[host.UID].Session = &Session{UID: host.UID}
			}
			if err := h.kickRoomPlayer(host, payload); err != nil {
				t.Fatal("rejection disconnected player", err)
			}
			roomOutputs(t, host, 20150)
			roomOutputs(t, peer)
			if len(r.Members) != 2 || peer.Room != r || r.Owner != host.UID {
				t.Fatal("rejection changed room")
			}
		})
	}
}
