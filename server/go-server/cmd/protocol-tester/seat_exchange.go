package main

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
)

func describeSeatExchange(m protocol.Message) string {
	if m.ID == 3264 {
		return "换座请求被拒绝或因房间状态变化撤销"
	}
	if m.ID == 3267 {
		return "换座繁忙：已有待处理请求"
	}
	if m.ID == 3266 {
		return "3266含义尚未确认"
	}
	if len(m.Payload) != 24 {
		return "换座消息长度错误：需要24字节"
	}
	p := m.Payload
	return fmt.Sprintf("换座%d 发起UID=%d 目标UID=%d 原座位=%d 目标座位=%d；目标UID为0表示空位", m.ID, protocol.ReadUint64(p, 0), protocol.ReadUint64(p, 8), protocol.ReadUint32(p, 16), protocol.ReadUint32(p, 20))
}
