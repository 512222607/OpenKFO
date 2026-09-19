package main

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
)

func describeReliableEvent(p []byte) string {
	r, err := protocol.ParseReliableEvent(p)
	if err != nil {
		return "战斗确认族格式错误：9000–9002要求63B，9500–9502要求55B"
	}
	s := fmt.Sprintf("战斗确认族%d 发送者=%d 实体=%d 对象键=%d 状态51=%d", r.Kind, r.Sender, r.Actor, r.ObjectKey, r.Flag51)
	if r.HasContext {
		s += fmt.Sprintf(" 上下文55=%d/59=%d", r.Context[0], r.Context[1])
	}
	if r.Flag51 > 1 {
		s += " [状态值超出已确认的0/1发送路径]"
	}
	return s + "；本人申请/完成，控制者回复；对象可用性仍由原生控制者判断"
}
