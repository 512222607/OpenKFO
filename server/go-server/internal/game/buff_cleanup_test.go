package game

import (
	"bytes"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestRemoteBuffExpiryClearedSource(t *testing.T) {
	for _, invalid := range []string{"", "add", "duration", "unknown target", "stale battle"} {
		t.Run(invalid, func(t *testing.T) {
			hub, sender, target, outsider := combatFixture()
			message := combatPacket(8150, 87, sender.UID, target.UID, 79)
			protocol.WriteUint32(message.Payload, 55, 14)
			switch invalid {
			case "add":
				protocol.WriteUint32(message.Payload, 75, 1)
			case "duration":
				protocol.WriteUint32(message.Payload, 63, 3000)
			case "unknown target":
				protocol.WriteUint64(message.Payload, 39, outsider.UID)
			case "stale battle":
				protocol.WriteUint32(message.Payload, 83, 6)
			}
			err := hub.battleMessage(sender, sender.game(), message)
			if invalid != "" {
				if err == nil || len(target.Output) != 0 {
					t.Fatal("invalid remote cleanup accepted")
				}
				return
			}
			if err != nil || len(target.Output) != 1 || len(sender.Output) != 0 || len(outsider.Output) != 0 {
				t.Fatal("native cleanup rejected or sent outside room", err)
			}
			encoded, _ := protocol.Encode(message)
			if !bytes.Equal((<-target.Output).Data, encoded) {
				t.Fatal("cleanup payload changed")
			}
			if err = hub.battleMessage(sender, sender.game(), message); err != nil || len(target.Output) != 0 {
				t.Fatal("duplicate cleanup forwarded", err)
			}
		})
	}
}
