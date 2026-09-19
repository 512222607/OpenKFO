package main

import (
	"bytes"
	"fmt"
	"kungfu.local/server/internal/protocol"
	"strings"
)

// These replies are not interchangeable room setting records. Current native
// consumers copy 404 bytes for 21373/21374 without checking payload length.
func describeRoomSettings(m protocol.Message) string {
	n := len(m.Payload)
	switch m.ID {
	case 21370:
		if n != 0 {
			return "设置面板请求21370长度错误：应为空载荷"
		}
		return "设置面板初始化21370：本服已配置时先下发21372目录记录，再下发21373可选地图；未配置返回提示。21371属于兑换面板，不作为本查询成功应答"
	case 21371:
		if n != 8 {
			return "物品兑换面板21371长度错误：原生要求8字节"
		}
		return fmt.Sprintf("物品兑换面板21371 两个DWORD原值=%d/%d；AnimateDestItem使用第二值整数除100=%d，随后刷新所需/已有物品；非已证明的关卡进度应答", protocol.ReadUint32(m.Payload, 0), protocol.ReadUint32(m.Payload, 4), protocol.ReadUint32(m.Payload, 4)/100)
	case 21372:
		if n%24 != 0 {
			return "设置面板21372长度错误：应为24字节记录流"
		}
		records, err := protocol.ParseStageRecords(m.Payload)
		if err != nil {
			return "设置面板21372记录解析失败"
		}
		var detail strings.Builder
		seen := map[uint32]bool{}
		duplicate := false
		for i, r := range records {
			if seen[r.MapID] {
				duplicate = true
			}
			seen[r.MapID] = true
			if i < 8 {
				fmt.Fprintf(&detail, " [%d]目标地图ID=%d 未解=%v 条件地图ID=%d", i, r.MapID, r.Unknown, r.RequiredMapID)
				if r.RequiredMapID == 0xffffffff {
					detail.WriteString("（本服无匹配前置地图标记，不代表已通关）")
				}
			}
		}
		if len(records) > 8 {
			detail.WriteString("；仅展示前8条，完整值见HEX")
		}
		if duplicate {
			detail.WriteString("；重复键：客户端将覆盖较早记录")
		}
		return fmt.Sprintf("设置面板21372 记录数=%d，每条24字节%s", len(records), detail.String())
	case 21373, 21374:
		if n < 404 {
			return fmt.Sprintf("设置面板%d过短：客户端直接复制404字节，不可发送空成功包", m.ID)
		}
		end := bytes.IndexByte(m.Payload[4:404], 0)
		if end < 0 {
			return fmt.Sprintf("设置面板%d文本缺少结束符：+4起400字节内必须有NUL，原生字符串读取存在越界风险", m.ID)
		}
		text := string(m.Payload[4 : 4+end])
		count := strings.Count(text, ",")
		warning := ""
		if m.ID == 21374 {
			warning += "；匹配地图会触发关卡开启提示，不应作为静默全量刷新反复发送"
		} else if count == 0 {
			warning += "；空分割列表跳过难度按钮状态循环，不能据此认定旧解锁已撤销"
		}
		if text != "" && !strings.HasSuffix(text, ",") {
			warning = "；末项无逗号，原生661A70不会加入分割结果"
		}
		if n == 404 {
			parse := protocol.ParseStageProgress
			if m.ID == 21373 {
				parse = protocol.ParseStageSelection
			}
			if progress, err := parse(m.Payload); err == nil {
				warning += fmt.Sprintf("；地图键=%v", progress.MapIDs)
				if m.ID == 21373 && text == "0," {
					warning += "；无可选地图标记，将进入逐项不匹配分支"
				}
			} else {
				warning += "；不符合服务器正整数、无重复地图键格式，保留原始HEX供核对"
			}
		}
		return fmt.Sprintf("设置面板%d 字节=%d，首DWORD原值=%d；至少404字节消费结构，文本字节=%d，原生分割项=%d%s；关卡/难度进度业务仍待核验", m.ID, n, protocol.ReadUint32(m.Payload, 0), end, count, warning)
	}
	return ""
}
