# 逆向协议资料索引

更新：2026-09-18。此目录同时包含历史实验、候选实现和当前核验结果，不能把旧脚本当作现行服务器。按功能查阅，避免根据消息编号相邻或历史文件名推断含义。

## 当前补全入口

| 文档 | 内容与证据边界 |
| --- | --- |
| [BuffProtocol.md](buff-debuff/BuffProtocol.md) | 8071/8126/8150 字段、添加/删除、毫秒计时、自动到期门控；本轮直接核验客户端二进制 |
| [BattleEventProtocol.md](buff-debuff/BattleEventProtocol.md) | 8071 信封、服务器校验、丢弃与断开条件、逐跳日志排查 |
| [EvidenceAndGaps.md](EvidenceAndGaps.md) | 各模块已知内容、历史冲突、缺口和后续验证顺序 |
| [总协议索引](../protocol.md) | 当前源码对应的登录、房间、战斗、物品等模块文档 |

## 历史资料按模块归档

以下路径是本地历史资料索引，本次源码提交未包含旧备份、截图和候选安装脚本；GitHub 阅读请优先使用上方当前文档。

| 模块 | 入口 | 阅读限制 |
| --- | --- | --- |
| 登录/建角 | 角色报告（本地历史资料：`role-create/2026-09-07_逆向-role-create-report.md`）、重登验证（本地历史资料：`role-create/E-017-real-client-relogin-confirmed.md`） | 旧实验账号与 Python 实现不代表当前部署 |
| 频道/大厅 | 频道调用链（本地历史资料：`channel-world/E-018-ida-channel-control-flow.md`） | 旧运行时镜像存在地址映射差异 |
| P2P | UDP 握手报告（本地历史资料：`p2p-room/2026-09-07_逆向-sdp2p-udp-login-report.md`） | UDP 握手分析可参考；早期房间响应候选已被后续报告纠正 |
| 建房/进房 | 进房恢复报告（本地历史资料：`room-enter-recovery/2026-09-07_逆向-room-enter-report.md`）、成员档案（本地历史资料：`room-enter-recovery/avatar/E-avatar-3100.md`） | 以较晚的恢复报告和当前 RoomProtocol 为准 |
| 准备/开战 | 训练报告（本地历史资料：`training-room-actions-20260907-232711/2026-09-07_逆向-training-room-report.md`）、8070 字段（本地历史资料：`training-room-actions-20260907-232711/leave/8070-fields.md`） | 可移动不等于所有战斗计时/状态门均正确 |
| 背包/装备 | 仓库报告（本地历史资料：`all-weapons-20260907-235015/equip/warehouse-report.md`）、永久武器修复（本地历史资料：`all-weapons-20260907-235015/2026-09-08_永久武器与仓库换装修复.md`） | 永久装备期限与 BUFF 持续时间是不同系统 |

## 证据规则

- **静态确认**：给出二进制 SHA-256、函数地址、指令或配置消费路径。
- **实包确认**：给出时间、方向、长度、偏移；`S->C queued` 仅证明进入发送队列。
- **源码事实**：说明当前 Go 服务器的行为，不等同原版协议规范。
- **待验证**：尚缺消费路径、实机对照或字段单位。不得用猜测填满表格。

偏移从解码后的 payload 首字节起算；数字默认十进制，地址与 `0x` 数字为十六进制；多字节整数默认小端。8071 的子命令偏移不包含外层 TCP 帧头。

新增证据仅保存必要的反汇编与战斗包，不保存认证内容、私有配置、公网地址或客户端资源包。未执行旧目录中的安装、注入或候选部署脚本。
