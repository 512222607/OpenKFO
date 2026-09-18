# 登录与选角协议（LoginProtocol）

> 实现基线：`b74129b`，整理日期：2026-09-18。以当前 Go 实现为准，客户端笔记用于交叉参考；本轮未重新反编译或进行实机验证。偏移默认十进制，详见[总索引与约定](protocol.md)。

## 1. 角色登录到大厅

| C/B 触发或消息 | 上行参数 | S 接收条件/行为 | S 下行 |
| --- | --- | --- | --- |
| B ready | 无业务包体 | TablesReady=true；已有 bootstrap channel 才推档案 | 1151：360B Profile + 68B×库存条目 |
| C 1010 | 96B；+0 u64 UID；+49 u32 build=594 | channel=connected，认证授权有效，尚无 bootstrap/game channel | 1131(44B)、1020(37B)、1230(4B)、1120(库存)、7080(26B)、7070(46B)；条件满足再 1151 |
| C 3320 选角 | 4B，当前仅接受 u32=1 | bootstrap channel，profile_sent/handoff 阶段 | 3330 回显；首次发送 1201(u32=1)，开放 2 分钟交接窗口 |
| C 2010 新游戏连接 | 同 1010 的 96B 基础校验 | 交接有效且无已有 game channel | 2030(52B)；阶段=lobby |
| C 1157 | 0B | 请求目录 | 7080 + 7070 |
| C 1156 | 12B：+0 UID，+8 P2P ID | 必须是当前游戏 channel、UID/P2P 匹配、P2P 未过期 | 不回包；Bound=true |
| C 0 | 0B | 心跳/空消息 | 不回包 |

7070/7080 为大厅和端点目录；2030 带本机桥接端点和上下文。资料记载 2030 处理尾部触发 1156。当前服务器身份以 TLS 认证后的 Session 为准，不能靠原生包中换一个 UID 切换账号。

原生包的外层认证和 SDK 登录封包见 [TransportProtocol.md](TransportProtocol.md)。进入大厅后的房间请求见 [RoomProtocol.md](RoomProtocol.md)。
