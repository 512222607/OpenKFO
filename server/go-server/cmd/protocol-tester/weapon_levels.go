package main

import (
	"fmt"
	"strings"

	"kungfu.local/server/internal/protocol"
)

// 21411 is a packed array, with no count prefix. Field 16 has not been
// identified; preserve it in diagnostics instead of assigning game semantics.
// Native evidence: protocol/nixiang/room-enter-recovery/21410/current-fields.md.
func describeWeaponLevels(p []byte) string {
	if len(p) < 21 || len(p)%21 != 0 {
		return "武器升级配置长度错误：必须是非空的21字节记录数组"
	}
	var b strings.Builder
	fmt.Fprintf(&b, "武器升级配置 %d 条（配置回包不代表升级业务完成）", len(p)/21)
	seen := make(map[uint32]bool)
	for off := 0; off < len(p); off += 21 {
		level := protocol.ReadUint32(p, off)
		score := protocol.ReadUint32(p, off+4)
		gold := protocol.ReadUint32(p, off+8)
		odds := protocol.ReadUint32(p, off+12)
		attack := protocol.ReadUint32(p, off+17)
		fmt.Fprintf(&b, "\n等级=%d 熟练度阈值=%d 金币=%d 显示成功率=%d%% 未知字节16=0x%02X 攻击加成原值=%d", level, score, gold, odds, p[off+16], attack)
		if score == 0 {
			b.WriteString(" [风险：客户端进度分母为0]")
		}
		if seen[level] {
			b.WriteString(" [风险：重复等级]")
		}
		if level != uint32(off/21) {
			b.WriteString(" [风险：等级与数组索引不一致]")
		}
		seen[level] = true
	}
	return b.String()
}

// The native handler consumes only the first 22-byte record. It reloads the
// corresponding weapon from inventory rather than reading level/gold here.
func describeWeaponUpgradeResult(p []byte) string {
	if len(p) < 22 || len(p)%22 != 0 {
		return "武器升级结果长度错误：必须是非空的22字节记录数组"
	}
	result := "失败"
	if p[0] != 0 {
		result = "成功"
	}
	text := fmt.Sprintf("武器升级结果=%s 标志=%d 实例=%d；客户端从库存重新读取武器，结果包本身不含已确认的等级或余额字段", result, p[0], protocol.ReadUint32(p, 9))
	if len(p) > 22 {
		text += fmt.Sprintf(" [注意：共%d条，当前客户端只处理首条]", len(p)/22)
	}
	return text
}
