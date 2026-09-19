package main

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
	"strings"
)

func describeRoomMembers(m protocol.Message) string {
	if m.ID == 3130 {
		if len(m.Payload) != 8 {
			return "离房通知3130长度错误：需要8字节UID"
		}
		return fmt.Sprintf("玩家离开房间：UID=%d（原生按UID清理参战或观战对象）", protocol.ReadUint64(m.Payload, 0))
	}
	rows, err := protocol.ParseRoomMembers(m.Payload)
	if err != nil || (m.ID == 3090 && len(rows) != 1) {
		return "房间成员记录长度错误：149字节头＋装备数×68，列表最多16条"
	}
	var s strings.Builder
	fmt.Fprintf(&s, "房间成员%d：%d条", m.ID, len(rows))
	for _, r := range rows {
		kind := "参战"
		if r.Spectator() {
			kind = "观战"
		}
		fmt.Fprintf(&s, "；UID=%d %s 槽位=%d 装备=%d", r.UID(), kind, r.Slot(), r.EquipmentCount())
	}
	return s.String()
}
