package game

import (
	"bytes"
	"testing"

	"kungfu.local/server/internal/protocol"
)

func TestWeaponRewardSelectorCatalogue(t *testing.T) {
	const key uint32 = 1879301205
	row := make([]byte, 108)
	row[4] = protocol.ItemWeapon
	protocol.WriteUint32(row, 5, 253013)
	protocol.WriteUint32(row, 9, key)
	for _, scenario := range []string{"valid", "empty", "truncated", "wrong-key", "no-icon", "wrong-kind", "duplicate-first-invalid"} {
		t.Run(scenario, func(t *testing.T) {
			_, s, _, _ := combatFixture()
			catalog := bytes.Clone(row)
			switch scenario {
			case "empty":
				catalog = nil
			case "truncated":
				catalog = catalog[:107]
			case "wrong-key":
				protocol.WriteUint32(catalog, 0, key)
				protocol.WriteUint32(catalog, 9, 1)
			case "no-icon":
				protocol.WriteUint32(catalog, 5, 0)
			case "wrong-kind":
				catalog[4] = 0
			case "duplicate-first-invalid":
				catalog[4] = 0
				catalog = append(catalog, row...)
			}
			sent, err := sendTutorialReward(s, []uint32{key}, catalog)
			if scenario != "valid" {
				if err == nil || sent || s.TitleOffer != 0 || len(s.Output) != 0 {
					t.Fatal("invalid catalogue opened or bound a reward selector")
				}
				return
			}
			if err != nil || !sent || s.TitleOffer != 2 {
				t.Fatal("valid tutorial offer rejected", err)
			}
			out := roomOutputs(t, s, 1550, protocol.MsgTitleAward)
			if !bytes.Equal(out[0].Payload, row) || len(out[1].Payload) != 64 || protocol.ReadUint32(out[1].Payload, 8) != key {
				t.Fatal("catalogue and reward choice do not match native lookup")
			}
		})
	}
}
