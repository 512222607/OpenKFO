package main

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
	"strings"
)

// Layouts from current native 826C30/8269C0/826AB0/826CF0 consumers.
// This diagnoses packets, not proof of durable delivery or a successful claim.
func describeMail(m protocol.Message) string {
	p := m.Payload
	switch m.ID {
	case protocol.MsgRenewItemResult:
		r, err := protocol.ParseRenewalResult(p)
		if err != nil {
			return "续费结果1430长度错误：成功至少5字节，失败至少1字节"
		}
		if !r.Succeeded {
			return "续费失败1430：请核对服务器报价、点券余额及原道具期限"
		}
		return fmt.Sprintf("续费成功回执1430：库存实例=%d；请结合2161库存更新和1230余额确认", r.InventoryInstance)
	case 1450:
		if len(p) < 4 {
			return "忽略续费提醒1450过短：需要库存实例"
		}
		return fmt.Sprintf("已忽略续费提醒1450：库存实例=%d；没有删除背包道具", protocol.ReadUint32(p, 0))
	case 1410:
		rows, err := protocol.ParseRenewalRecords(p)
		if err != nil {
			return "续费候选列表1410长度错误：应为124字节整条数组"
		}
		var out strings.Builder
		fmt.Fprintf(&out, "续费候选列表1410：%d条，每条124字节；不是收件箱，不能据此确认已续费", len(rows))
		for i, r := range rows {
			fmt.Fprintf(&out, "\n记录%d 首DWORD=%d 库存实例=%d 库存状态=%d 物品ID=%d 折扣原值=%d", i, protocol.ReadUint32(r.Raw[:], 0), r.InventoryInstance(), r.InventoryState(), r.ItemID(), r.DiscountRaw())
		}
		return out.String()
	case 1310:
		size := 339
		if len(p)%size != 0 {
			return fmt.Sprintf("邮件相关列表%d长度错误：应为%d字节整条数组", m.ID, size)
		}
		var out strings.Builder
		fmt.Fprintf(&out, "邮件相关列表%d：%d条，每条%d字节", m.ID, len(p)/size, size)
		for i := 0; i < len(p); i += size {
			fmt.Fprintf(&out, "\n记录%d 首DWORD=%d", i/size, protocol.ReadUint32(p, i))
			if m.ID == 1310 {
				fmt.Fprintf(&out, " 已读状态=%d 附件键=%d 附件类型=%d", protocol.ReadUint32(p, i+327), protocol.ReadUint32(p, i+331), protocol.ReadUint32(p, i+335))
			}
		}
		return out.String()
	case 1330:
		if len(p) < 136 {
			return "邮件详情1330过短：当前消费者至少复制136字节"
		}
		return fmt.Sprintf("邮件详情1330 邮件键=%d 状态=%d 附件键=%d 金币=%d 点券=%d 经验=%d 声望=%d 商品类型=%d 物品配置ID=%d；预览不代表领取成功", protocol.ReadUint32(p, 0), protocol.ReadUint32(p, 4), protocol.ReadUint32(p, 8), protocol.ReadUint32(p, 12), protocol.ReadUint32(p, 16), protocol.ReadUint32(p, 20), protocol.ReadUint32(p, 24), p[32], protocol.ReadUint32(p, 33))
	case 1350:
		if len(p) < 5 {
			return "邮件删除1350过短：需要结果字节与邮件键"
		}
		return fmt.Sprintf("邮件删除1350 结果=%d 邮件键=%d", p[0], protocol.ReadUint32(p, 1))
	}
	return ""
}
