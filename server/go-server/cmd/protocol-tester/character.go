package main

import (
	"fmt"
	"kungfu.local/server/internal/persistence"
	"kungfu.local/server/internal/protocol"
)

func creationRequest(name string, options []byte) ([]byte, error) {
	if len(options) == 0 || len(options)%16 != 0 || len(options) > 512*16 {
		return nil, fmt.Errorf("invalid 1125 choices")
	}
	choices := make([]persistence.CharacterChoice, 0, len(options)/16)
	for i := 0; i < len(options); i += 16 {
		choices = append(choices, persistence.CharacterChoice{Gender: protocol.ReadUint32(options, i), Slot: protocol.ReadUint32(options, i+4), Choice: protocol.ReadUint32(options, i+8), Item: protocol.ReadUint32(options, i+12)})
	}
	for gender := uint32(1); gender <= 2; gender++ {
		p := make([]byte, 68)
		encoded := persistence.GBK(name)
		if len(encoded) == 0 || len(encoded) > 20 {
			return nil, fmt.Errorf("nickname must fit 20 GBK bytes")
		}
		copy(p, encoded)
		p[21] = byte(gender)
		for slot := uint32(0); slot < 7; slot++ {
			for _, c := range choices {
				if c.Gender == gender && c.Slot == slot {
					protocol.WriteUint32(p, 23+int(slot)*4, c.Choice)
					break
				}
			}
		}
		if _, err := persistence.ParseCharacterCreation(p, choices); err == nil {
			return p, nil
		}
	}
	return nil, fmt.Errorf("nickname or complete seven-slot choices invalid")
}

func (c *client) prepareCharacter(name string) error {
	creating := false
	for n := 0; n < 64; n++ {
		frame, messages, err := c.read()
		if err != nil {
			return err
		}
		if frame.Channel != 2 {
			continue
		}
		for _, m := range messages {
			switch m.ID {
			case 1125:
				if name == "" {
					return fmt.Errorf("此账号尚无角色，请填写创建角色昵称")
				}
				if creating {
					return fmt.Errorf("duplicate creation candidate response")
				}
				request, err := creationRequest(name, m.Payload)
				if err != nil {
					return err
				}
				if err = c.game(2, 1150, request); err != nil {
					return err
				}
				creating = true
			case 1152:
				return fmt.Errorf("服务器拒绝创建角色")
			case 1151:
				if len(m.Payload) < 360 || (len(m.Payload)-360)%68 != 0 {
					return fmt.Errorf("invalid character response")
				}
				if !creating {
					return nil
				}
				if err = c.game(2, 3320, protocol.Uint32Bytes(1)); err != nil {
					return err
				}
				return c.wait(2, 1130)
			}
		}
	}
	return fmt.Errorf("未收到角色资料或创建候选")
}
