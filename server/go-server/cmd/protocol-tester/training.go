package main

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
)

func describeTraining(m protocol.Message) string {
	r, err := protocol.ParseTrainingStatus(m.Payload)
	if err != nil {
		return "名侠训练长度错误：21001/21005/21007要求56字节"
	}
	return fmt.Sprintf("名侠训练 UID=%d 等级=%d 分钟=%d 开始状态=%d 宝箱显示原值=%d 每小时经验=%d 经验上限=%d 未解字段=%v；预览字段不代表已经发奖", r.UID, r.Level, r.Minutes, r.Active, r.BoxDisplay, r.RewardPerHour, r.RewardCap, []uint32{r.Unknown12, r.Unknown24, r.Unknown32, r.Tail[0], r.Tail[1], r.Tail[2]})
}
