package main

import (
	"fmt"
	"kungfu.local/server/internal/protocol"
	"strings"
)

// Keep uncertain counters labelled by their record offset, not invented names.
func describeScoreboard(p []byte) string {
	if len(p) != 334 {
		return fmt.Sprintf("8155计分同步长度错误：收到%d，要求334字节", len(p))
	}
	var out strings.Builder
	fmt.Fprintf(&out, "8155计分同步 发送UID=%d 序号=%d 汇总原始值=%x", protocol.ReadUint64(p, 4), protocol.ReadUint32(p, 19), p[39:46])
	for slot := 0; slot < 8; slot++ {
		r := p[46+36*slot : 82+36*slot]
		fmt.Fprintf(&out, "\n槽%d UID=%d DWORD[8,12]=[%d,%d] WORD[16,18]=[%d,%d] DWORD[20,24,28]=[%d,%d,%d] WORD[32]=%d 保留=%x", slot, protocol.ReadUint64(r, 0), protocol.ReadUint32(r, 8), protocol.ReadUint32(r, 12), protocol.ReadUint16(r, 16), protocol.ReadUint16(r, 18), protocol.ReadUint32(r, 20), protocol.ReadUint32(r, 24), protocol.ReadUint32(r, 28), protocol.ReadUint16(r, 32), r[34:36])
	}
	return out.String()
}
