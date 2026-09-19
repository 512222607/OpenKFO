package main

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
)

func describeTasks(m protocol.Message) string {
	if m.ID == 6030 || m.ID == 6040 || m.ID == 6060 || m.ID == 6090 {
		r, err := protocol.ParseTaskNotification(m.ID, m.Payload)
		if err != nil {
			return "任务通知截断：6030/6060/6090至少14B，6040至少6B；这是已读字段下界，不是完整包长结论"
		}
		meaning := map[uint32]string{
			6030: "设完成状态并读取客户端任务配置；未知任务键存在原生空指针风险，另可能更新角色资料+123",
			6040: "添加待接任务并刷新提示；不能代替完整任务列表",
			6060: "设已接状态并复制当前角色统计基线；重复通知会重置基线",
			6090: "恢复待接状态",
		}[m.ID]
		return fmt.Sprintf("任务通知%d 配置键=%d 长度=%d；%s", m.ID, r.Key, len(r.Raw), meaning)
	}
	if m.ID == 6050 || m.ID == 6080 {
		r, err := protocol.ParseTaskAction(m.ID, m.Payload)
		if err != nil {
			return "任务操作长度错误：6050/6080必须14B"
		}
		return fmt.Sprintf("任务操作%d 配置键=%d 上下文原值=%d；前8B不能作为玩家鉴权依据", m.ID, r.Key, r.Context)
	}
	rows, err := protocol.ParseTaskRecords(m.ID, m.Payload)
	if err != nil {
		return "任务列表长度错误：6010为7B/条，6020为123B/条，6041/6042为141B/条；不解析截断记录"
	}
	keys := make([]uint16, 0, 8)
	states := make([]byte, 0, 8)
	conditions := make([][7]protocol.ExtendedTaskCondition, 0, 8)
	for i, r := range rows {
		if i == 8 {
			break
		}
		keys = append(keys, r.Key)
		if m.ID == 6010 {
			states = append(states, r.Raw[6])
		}
		if m.ID == 6020 {
			progress, _ := protocol.ParseTaskProgress(r.Raw)
			states = append(states, progress.State)
		}
		if m.ID == 6041 || m.ID == 6042 {
			progress, _ := protocol.ParseExtendedTaskProgress(r.Raw)
			states = append(states, progress.State)
			conditions = append(conditions, progress.Conditions)
		}
	}
	if m.ID == 6010 {
		return fmt.Sprintf("任务简表6010 共%d条，前8条配置键=%v 状态原值=%v；原生展开为123B记录并清零快照", len(rows), keys, states)
	}
	if m.ID == 6020 {
		return fmt.Sprintf("任务列表6020 共%d条，前8条配置键=%v 状态原值=%v；每条后116B为角色数据快照，不是奖励表", len(rows), keys, states)
	}
	kind := map[uint32]string{6041: "每日任务", 6042: "新手任务"}[m.ID]
	return fmt.Sprintf("%s列表%d 共%d条，前8条配置键=%v 状态原值=%v 条件槽{编号 当前计数 未解值}=%v；仅诊断，不代表服务器已验证完成或发奖", kind, m.ID, len(rows), keys, states, conditions)
}

func describeExtendedTaskAction(m protocol.Message) string {
	switch m.ID {
	case 6051, 6052, 6081, 6082, 6311, 6312:
		r, err := protocol.ParseExtendedTaskAction(m.ID, m.Payload)
		if err != nil {
			return "每日/新手任务请求无效：必须19B、非零任务键及匹配操作的状态值"
		}
		return fmt.Sprintf("任务操作%d 配置键=%d 状态=%d 上下文原值=%d；上下文及未初始化尾部不可用于鉴权或收费", m.ID, r.Key, r.State, r.Context)
	default:
		r, err := protocol.ParseExtendedTaskNotification(m.ID, m.Payload)
		if err != nil {
			return "每日/新手任务通知截断：至少3B，不代表原始完整包长"
		}
		return fmt.Sprintf("任务通知%d 配置键=%d 状态原值=%d；新手状态3会移除任务，状态1会清进度，不能重复盲发", m.ID, r.Key, r.State)
	}
}
