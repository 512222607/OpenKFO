package main

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
)

func describeVIP(m protocol.Message) string {
	if m.ID == 1020 {
		if len(m.Payload) < 37 {
			return "登录1020过短：VIP类型位于+33 DWORD，原生至少37字节"
		}
		return fmt.Sprintf("登录1020 VIP类型=%d（+33 DWORD）；此包不包含1038的24字节权益块", protocol.ReadUint32(m.Payload, 33))
	}
	if m.ID != 1038 {
		return ""
	}
	r, err := protocol.ParseVIPStatus(m.Payload)
	if err != nil {
		return "VIP刷新1038长度错误：原生要求28字节"
	}
	label := "非VIP/未识别类型"
	switch r.Kind {
	case 2:
		label = "白银VIP"
	case 3:
		label = "黄金VIP"
	case 4:
		label = "铂金VIP"
	}
	return fmt.Sprintf("VIP刷新 类型=%d(%s) 商城比例原值=%d（正值参与价格×比例÷100）；未知+4..16=%v +24=%d，不解释为到期时间", r.Kind, label, r.ShopPercent, r.Unknown, r.Tail)
}
