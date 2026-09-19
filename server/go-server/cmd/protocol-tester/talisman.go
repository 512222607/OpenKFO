package main

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
)

// Native 99AB90/99AE70, 873F30 and 874360. Raw values remain raw until
// their consumers and ownership mapping have been recovered.
func describeTalisman(m protocol.Message) string {
	p := m.Payload
	if m.ID == 4203 {
		if len(p) < 32 {
			return "法宝修理报价4203过短：原生至少复制32字节"
		}
		return fmt.Sprintf("法宝修理报价4203 物品键=%d 物品配置=%d 材料配置=%d 材料数量原值=%d 当前额度原值=%d 最大额度原值=%d 标记=%d；额度显示除以100", protocol.ReadUint32(p, 0), protocol.ReadUint32(p, 4), protocol.ReadUint32(p, 8), protocol.ReadUint32(p, 16), protocol.ReadUint32(p, 20), protocol.ReadUint32(p, 24), protocol.ReadUint32(p, 28))
	}
	if m.ID == 4205 || m.ID == 4207 {
		if len(p) < 8 {
			return "法宝结果过短：消费者至少读取8字节"
		}
		if m.ID == 4205 {
			return fmt.Sprintf("法宝修理结果4205 字段0=%d 错误码=%d（0成功）", protocol.ReadUint32(p, 0), protocol.ReadUint32(p, 4))
		}
		return fmt.Sprintf("法宝额度不足4207 物品键=%d 物品配置=%d", protocol.ReadUint32(p, 0), protocol.ReadUint32(p, 4))
	}
	if m.ID == 4206 {
		if len(p) != 12 {
			return "法宝使用结果4206长度错误：需要12字节"
		}
		return fmt.Sprintf("法宝使用结果4206 物品键=%d 剩余额度原值=%d 警告标记=%d；额度显示除以100", protocol.ReadUint32(p, 0), protocol.ReadUint32(p, 4), protocol.ReadUint32(p, 8))
	}
	size := map[uint32]int{4201: 8, 4202: 4, 4204: 12, 8071: 75}[m.ID]
	if len(p) != size {
		return fmt.Sprintf("法宝消息%d长度错误：需要%d字节", m.ID, size)
	}
	if m.ID == 8071 {
		e, err := protocol.ParseTalismanEvent(p)
		if err != nil {
			return "法宝事件格式错误：仅8291/8292、75字节、槽37/38"
		}
		return fmt.Sprintf("法宝事件%d 槽位=%d 发送UID=%d 实体UID=%d 房间上下文=%d/%d；中间16字节未解，不表示已扣除消耗", e.Kind, e.Slot, e.Sender, e.Actor, e.Room, e.Battle)
	}

	if m.ID == 4201 {
		return fmt.Sprintf("法宝使用4201 物品键原值=%d 消耗字段原值=%d；被动路径未明确赋值，不可据此直接扣费", protocol.ReadUint32(p, 0), protocol.ReadUint32(p, 4))
	}
	if m.ID == 4202 {
		return fmt.Sprintf("法宝修理报价4202 物品键原值=%d", protocol.ReadUint32(p, 0))
	}
	return fmt.Sprintf("法宝修理4204 实例=%d 材料配置=%d 保留字段=%d", protocol.ReadUint32(p, 0), protocol.ReadUint32(p, 4), protocol.ReadUint32(p, 8))
}
