package main

import (
	"bytes"
	"fmt"

	"golang.org/x/text/encoding/simplifiedchinese"
	"kungfu.local/server/internal/protocol"
)

func describeHonour(p []byte) string {
	if len(p) < 4 {
		return "荣誉战绩回包过短"
	}
	if protocol.ReadUint32(p, 0) == 0 {
		return "荣誉战绩为空：客户端清空该页，不显示尾部提示文字"
	}
	if len(p) < 37 {
		return "荣誉战绩回包过短：需要36字节头及NUL结尾说明"
	}
	end := bytes.IndexByte(p[36:], 0)
	if end < 0 {
		return "荣誉战绩说明缺少NUL结尾"
	}
	description, err := simplifiedchinese.GBK.NewDecoder().Bytes(p[36 : 36+end])
	if err != nil {
		return "荣誉战绩说明GBK解码失败"
	}
	rank, honour, level := protocol.ReadUint32(p, 16), protocol.ReadUint32(p, 20), protocol.ReadUint32(p, 24)
	games, wins := protocol.ReadUint32(p, 28), protocol.ReadUint32(p, 32)
	rate := float64(0)
	if games != 0 {
		rate = float64(wins) / float64(games) * 100
	}
	warning := ""
	if wins > games || games > 0x7fffffff || wins > 0x7fffffff {
		warning = " [风险：胜场超过场次或超过客户端有符号计数范围]"
	}
	if level > 10 {
		warning += " [风险：荣誉等级超出当前客户端图标范围0–10]"
	}
	if honour > 0x7fffffff || rank > 0x7fffffff {
		warning += " [风险：荣誉值或排名超出客户端有符号范围]"
	}
	return fmt.Sprintf("荣誉排名=%d 荣誉值=%d 荣誉等级=%d 挑战场次=%d 胜场=%d 胜率=%.1f%% 说明=%q%s", rank, honour, level, games, wins, rate, description, warning)
}
