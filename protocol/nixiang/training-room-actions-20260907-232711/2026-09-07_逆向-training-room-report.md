# 自由训练开始与返回大厅恢复

本轮处理用户实际遇到的两个问题：自由训练房间的“开始”和“返回大厅”均没有反应。网络日志证明按钮请求已到服务端，而旧 RoomSession 缺少相应处理。已补齐完整训练握手与退出状态清理，全部53项协议、TCP和角色回归通过。正式安装并重新登录后，用户明确确认“返回大厅、重新开始训练都正常”；真实wire也记录了两次完整的自动训练开始和两次退出。首次临时推送试验与正式重登验证分别留有证据。

## 范围与输入

范围见 [scope.md](scope.md)。仅本项目已重建的单用户loopback实验服务、已有本地运行时镜像及隔离客户端；正式安装目录只读，原角色库不覆盖。`flavor=null`。这是兼容功能重建，不是原厂源码文本恢复，也不是完整多人服务端。

输入为32位 `game-runtime.bin.i64`，IDA base=0。表中绝对处理器指针减0x10000；相对CALL已正确，不能再减。镜像及导入摘要见 [E-imports](evidence/E-imports.md)，工具索引见 [tool-index.md](tool-index.md)。

## 实现后的行为

| 请求 | 回复 | 状态效果 |
|---|---|---|
| 3010/81、3070/14 | 3020/83、3100/245 | 保留前轮已验证建房和进房 |
| 4030/0 | 4080/53 | 仅对已进入的自由训练房间开始加载 |
| 4160/0 | 4180/0 | 本人完成加载后启动模式和帧更新 |
| 8040/14 | 8070/12 | 校验房间handle/UID，启用实际场景状态4 |
| 3110/0 | 3115/0 | 清当前房间和训练状态，保留登录、角色、连接 |
| 退出后的2250/8、2260/3 | 2270/8、2280/8 | 恢复大厅轮询，可以再次创建房间 |

重复开始、加载完成和入场确认不重复触发场景初始化。非自由训练模式不会被误放行；此轮不实现其开战流程。非法包不返回成功。退出清除 `request/entered/started/loading_complete/active`，旧3070不能重进已销毁的房间。

4080必须正好53字节：+0 DWORD房间handle，+5时钟基准，+11 WORD主持槽，+13八个DWORD玩家延迟，+45 QWORD本局标识。当前单用户本地训练使用槽0，时钟/延迟/本局标识为0。+11不是地图。8070为DWORD房间handle和同轮4080末8字节；不能回显8040中的UID。

随机地图0在此轮真实加载和训练中可用，没有强行更换为猜测地图。实际训练计时在8070之后开始变化，角色移动攻击获用户确认。4100是结算统计请求，不能当作开局成功回包；4030没有直接4040成功回复的依据。

## Evidence → Finding → Path

| Evidence | source_ref | 复核方式 | content_hash |
|---|---|---|---|
| E-01 | evidence/E-before-fix.json | 原wire行98842起，4030与3110无响应 | 见SHA256.json |
| E-02 | leave/findings.md、table-entries.json、0x80ed00.json | 消息表及两个3115处理器 | 见SHA256.json |
| E-03 | start/report.md、decomp-complete.json | 4080/53字段与加载虚表链 | 见SHA256.json |
| E-04 | start/loading-gate.md、loading-gate.json | 4160发送点、4180和离线等价分支 | 见SHA256.json |
| E-05 | leave/8070-fields.md、loading-followup.md及JSON | 8040请求、8070场景state4与本局标识 | 见SHA256.json |
| E-06 | evidence/E-live-*-release-probe.json | 当前会话一次推送，原配置自动恢复 | 见SHA256.json |
| E-07 | evidence/E-user-confirmation.md、E-live-training-scene.png | 用户确认移动攻击；界面证据 | 见SHA256.json |
| E-08 | candidate/test_training_protocol.py、validation.txt | 临时角色库和匿名TCP测试 | 见SHA256.json |
| E-09 | evidence/E-after-install-wire.json、E-user-confirmation.md | 23:29真实重登、退出、重建和训练，以及用户最终确认 | 见SHA256.json |

| Finding | severity | evidence_ids | location | confidence/status |
|---|---|---|---|---|
| F-01 缺少离房确认及状态复位 | n/a_re | E-01,E-02,E-08,E-09 | RoomSession.handle(3110) | high；已修复，源码/TCP/正式实机确认 |
| F-02 缺少训练三阶段握手 | n/a_re | E-01,E-03,E-04,E-05,E-06,E-07,E-08,E-09 | RoomSession.handle(4030/4160/8040) | high；已修复，重登后的自动握手和移动攻击确认 |
| F-03 结算包不能代替开始包 | n/a_re | E-05 | raw0x81a9b0→977E40→4110/696 | high；静态排除 |

P-01，path_type=callflow：建房进入→4030→4080/53→加载→4160→4180→8040/14→8070/12→场景state4→移动/攻击（E-03至E-08/F-02）。

P-02，path_type=callflow：返回大厅点击→3110/0→3115/0→client state6及server房间状态清除→2250/2260正常响应→重新建房（E-02,E-08/F-01）。

## 验证与恢复

候选实现只修改room_protocol.py，新增独立训练回归和真实训练建房样本。原角色协议、游戏帧、P2P和server入口保持原逻辑；候选目录副本用于独立测试。`candidate/test_role_protocol.py`只为候选测试改了import路径，不安装到现役目录。

从原项目根执行：

```powershell
.\toolchain\python313\python.exe -B -m unittest discover -s .\research\2026-09-06\work\login-to-world -p 'test*protocol.py'
.\toolchain\python313\python.exe -B -m unittest discover -s .\research\2026-09-07\role-create -p 'test_role_protocol.py'
```

测试覆盖完整TCP训练/退出/重建链、分片/粘包、重复与乱序请求、不正确handle/UID/长度、退出旧房间拒绝、原角色数据库行内容不变。新训练测试24项，加原29项，共53项。生产角色库只核对哈希，不在其上运行测试。

安装脚本先核验基线SHA256，保存旧源码和CURRENT_STATUS到本阶段backup目录，使用项目自身stop marker优雅停服，再复制3个文件并启动原START_ROLE_LAB.ps1。安装目录、备份和文件哈希写入installed-manifest.json。需要回退时，在服务停止后将backup内room_protocol.py复制回原lab目录，再用同一启动脚本启动；不要替换角色库。

## 时间线与边界

- 23:03–23:06 原wire确认自由训练建房、4030与3110都到达但未处理。
- 本轮核验现存mock源码与最新归档哈希一致，没有现役代码丢失。
- 分别恢复3115、4080、4180及8070处理链，原版源码文本仍不可由客户端精确恢复。
- 23:18左右首次实机4080触发加载并发4160。
- 23:20左右一次4180推送后出现8040，进入场景但用户反馈不能动。
- 随后补8070，用户确认“现在可以正常移动和攻击”。
- 53项候选及正式目录测试通过；23:29正式重登的两次训练和两次退出均成功，用户明确确认。

本轮只恢复单人自由训练开始和离房，不宣称多人同步、服务端伤害判定、结果持久化及其他模式完成。临时heartbeat探针仅验证客户端接收路径，正式代码严格按4160和8040分派，不保留heartbeat放行规则。

## 正式安装与最终验证

- 已安装至原项目，阶段目录：`training-room-actions-20260907-232711`，备份位于其 `backup/`。
- 当前v4 PID22820，正式目录44项协议/房间/P2P测试加9项角色测试共53项通过。
- 独立socket在正式10035端口验证完整8组请求响应，同连接退出后恢复大厅响应，角色库SHA256前后一致。见evidence/E-installed-socket-smoke.json。
- 安装后用户已确认返回大厅和重新开始训练均正常。
