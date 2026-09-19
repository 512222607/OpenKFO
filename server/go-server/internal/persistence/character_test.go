package persistence

import (
	"bytes"
	"kungfu.local/server/internal/protocol"
	"testing"
)

func characterFixture() ([]byte, []CharacterChoice) {
	p := make([]byte, 68)
	copy(p, GBK("测试角色"))
	p[21] = 2
	p[22] = 13
	items := []uint32{152002, 132002, 122001, 172002, 162003, 142002, 253002}
	var choices []CharacterChoice
	for i, item := range items {
		choice := uint32(900 + i)
		protocol.WriteUint32(p, 23+i*4, choice)
		choices = append(choices, CharacterChoice{2, uint32(i), choice, item})
	}
	return p, choices
}
func TestCharacterCreationVerifiedLayout(t *testing.T) {
	p, c := characterFixture()
	p[67] = 0x5a
	role, err := ParseCharacterCreation(p, c)
	if err != nil {
		t.Fatal(err)
	}
	if role.Nickname != "测试角色" || len(role.Profile) != 360 || role.Profile[122] != 2 || role.Profile[124] != 13 || !bytes.Equal(role.Request, p) {
		t.Fatal("character layout")
	}
	options, err := CharacterOptions(c)
	if err != nil || len(options) != 112 {
		t.Fatal("option layout")
	}
	for i, item := range role.Inventory {
		if len(item) != 68 || protocol.ReadUint32(item, 5) != c[i].Item || protocol.ReadUint16(item, 17) != uint16(i+2) || protocol.ReadUint16(item, 23) != 1 {
			t.Fatalf("starter slot %d", i)
		}
	}
	p[0] = 0
	p[67] = 0
	if role.Request[0] == 0 || role.Request[67] != 0x5a {
		t.Fatal("request aliases input")
	}
}
func TestCharacterCreationRejectsUnissuedAndMalformedFields(t *testing.T) {
	for _, kind := range []string{"short", "long", "empty-name", "unterminated", "space", "control", "invalid-gbk", "gender", "variant", "unissued", "wrong-slot", "wrong-gender", "duplicate-option"} {
		t.Run(kind, func(t *testing.T) {
			p, c := characterFixture()
			switch kind {
			case "short":
				p = p[:67]
			case "long":
				p = append(p, 0)
			case "empty-name":
				p[0] = 0
			case "unterminated":
				copy(p[:21], bytes.Repeat([]byte{'a'}, 21))
			case "space":
				p[0] = ' '
			case "control":
				p[0] = 1
			case "invalid-gbk":
				p[0] = 0x81
				p[1] = 0
			case "gender":
				p[21] = 3
			case "variant":
				p[22] = 20
			case "unissued":
				protocol.WriteUint32(p, 23, 123456)
			case "wrong-slot":
				protocol.WriteUint32(p, 23, c[1].Choice)
			case "wrong-gender":
				p[21] = 1
			case "duplicate-option":
				c = append(c, c[0])
			}
			if _, err := ParseCharacterCreation(p, c); err == nil {
				t.Fatal("accepted invalid request")
			}
		})
	}
}
