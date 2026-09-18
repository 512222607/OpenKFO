# OpenKFO 协议文档索引

更新日期：2026-09-18。其余模块以 `b74129b` 为整理基线；房间文档包含本轮代码修正及客户端静态核验。

## 按功能查阅

| 文件 | 内容 |
| --- | --- |
| [RoomProtocol.md](RoomProtocol.md) | 房间列表、建房、进房、成员字段、换队、设置、退房、踢人；客户端发送/消费定位、缺口与冲突 |
| [TransportProtocol.md](TransportProtocol.md) | 本地登录认证、TLS/WSS JSON隧道、TCP二进制封包、SDK登录与UDP |
| [LoginProtocol.md](LoginProtocol.md) | 1010/2010、选角、角色档案、大厅交接及P2P绑定 |
| [BattleProtocol.md](BattleProtocol.md) | 准备/取消、4080开战、4160/8040屏障、8071事件中继 |
| [BUFF / DEBUFF](nixiang/buff-debuff/BuffProtocol.md) | 8126/8150字段、毫秒持续时间、效果到期门控及冰冻复现证据 |
| [逆向资料索引](nixiang/README.md) | 历史资料分组、当前核验结果、冲突和待补项 |
| [ItemProtocol.md](ItemProtocol.md) | 商城、购买、装备、消耗品、4210数量回执 |
| [ChatProtocol.md](ChatProtocol.md) | 私聊、大厅/房间聊天、系统提示、GBK与频率限制 |
| [LobbyProtocol.md](LobbyProtocol.md) | 排行、改名、余额、训练和菜单占位应答 |

各文档按“客户端如何发、服务端如何接收、服务端如何应答”描述；房间部分已展开到字段级，其余模块先列当前收发索引，未解出的字段明确保留待完善。

## 1. 范围、证据与阅读约定

本组文档按“客户端触发 → 上行参数 → 服务端接收与校验 → 下行参数 → 客户端消费”整理。房间协议展开到字段级；其他已实现功能提供收发索引和关键字段。未逐字段解出的内容明确标为保留、透传或待确认，不根据相邻消息号猜测含义。

以下证据应分开理解：

- **实现事实**：从当前 Go/C#/C++ 源码直接读取，表示程序现在怎么做。
- **客户端资料**：来自本目录反编译与实测笔记，表示资料记载的发送点、消费函数或字段含义；不是本轮重新反编译验证的结论。
- **本轮静态核验**：RoomProtocol.md明确标记的地址已复核当前客户端注册与指令，不能等同实机验证。
- **待确认**：资料相互冲突、资料与代码不同，或需要当前客户端实际收发验证。

当前本机 `gfld.dat` SHA-256 为 `98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b`，与登录器固定校验值一致。但所给协议笔记没有统一绑定到这个哈希，不能仅凭函数地址相似认定全部适用于该二进制。

符号约定：C=原生游戏客户端，B=本地 Go 桥接，S=Go 游戏服务端；`C→S` 省略中间 B。偏移均从**解码后的包体首字节**起算，默认十进制；`0x` 前缀才表示十六进制。`u8/u16/u32/u64` 为无符号整数，除明确标注外均为小端。`[a:b)` 含 a 不含 b。字符串槽位不等于实际字符数；游戏名字、聊天使用 GBK，JSON 使用 UTF-8。

### 1.1 对照入口

| 内容 | 实现源码 | 客户端资料 |
| --- | --- | --- |
| 二进制封包、SDK 登录包 | [wire.go](../server/go-server/internal/protocol/wire.go) | `状态面.js`、`会话.js` |
| 连接、认证与 JSON 隧道 | [server.go](../server/go-server/internal/game/server.go)、[tunnel.go](../server/go-server/internal/tunnel/tunnel.go) | `会话.js` |
| 本地登录、转发、进程绑定 | [bridge_windows.go](../server/go-server/internal/bridge/bridge_windows.go)、[native_windows.go](../server/go-server/internal/bridge/native_windows.go) | `状态面.js` |
| 选角、大厅、装备等派发 | [session.go](../server/go-server/internal/game/session.go) | `角色.js`、`装备.md`、`派发.js` |
| 房间、准备、装载 | [rooms.go](../server/go-server/internal/game/rooms.go)、[room_packets.go](../server/go-server/internal/game/room_packets.go) | `房间.js`、`战斗准备.js` |
| 战斗中继、消耗品 | [battle.go](../server/go-server/internal/game/battle.go)、[consumption.go](../server/go-server/internal/game/consumption.go) | `战斗内.js` |
| 上行构造位置 | 原生客户端不在本仓库内 | `上行发包-a.js`、`上行发包-b.js` |
| 汇总与修订 | 本文交叉核对，不自动采信冲突结论 | `规范摘要.js`、`增补.js`、`索引.js` |

表中原始研究笔记仅保留在本地，未随本次源码提交发布；上表名称用于说明来源，不是仓库文件链接。这些 `.js` 文件实际上是协议笔记文本，不是服务器执行脚本。笔记中“emu/kk单机版 已实现”不能视为 OpenKFO Go 已实现。Python 历史服务也不能证明当前 Go 具有相同功能。

## 2. 验证方式与维护规则

现有测试入口：

- `internal/protocol/wire_test.go`：封包与向量。
- `internal/game/room_lifecycle_test.go`：三人同步、成员字段、设置校验、重试、退出和房主转移。
- `internal/game/room_directory_test.go`：房间列表分页、过滤与259B布局。
- `internal/game/integration_test.go`：数据库与两名模拟玩家流程，需要独立 `KK_TEST_MYSQL_DSN`；未配置会跳过。
- `internal/game/battle_test.go`、`udp_relay_test.go`：事件中继、退出清理及UDP隔离。

本轮修改了房间实现，并对当前客户端做了静态反汇编核验；尚未抓包或进行原生多人实机验收。Go测试不能代替客户端模型、界面与场景验证。

后续每条协议变更应记录：客户端SHA-256、阶段、UI操作、方向、opcode、原始包体长度、脱敏字段值、服务端校验/应答、客户端实际结果。优先覆盖：两人同房、第三人入房、换队后换装、开关设置保存、地图变更、房主退出、踢人、装载时退出。抓包记录不公开账号摘要、令牌、私钥或真实玩家数据。

修改字段时同步更新本文的“当前写入”和“差异”两列；只有完成当前客户端验证后才把待确认改为已核验。服务端文件路径以本页链接为入口，不以历史Python实现代替Go行为。
