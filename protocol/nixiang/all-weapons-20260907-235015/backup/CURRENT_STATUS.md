# 功夫小子 mock server 交接状态

> 最新状态（2026-09-07 23:31，Asia/Shanghai）：**自由训练开始与返回大厅处理已补齐**。实机4030/0→4080/53进入加载，4160/0→4180/0进入场景但尚不能动；继续8040/14→8070/12后用户明确确认“现在可以正常移动和攻击”。新RoomSession按该三阶段自动分派，3110/0→3115/0并清entered/started/loading_complete/active/request，恢复大厅2250/2260响应。8070末8字节复用4080的本局标识，不是UID；4100是结算请求，不用于开局。原项目源码已更新，正式v4 PID22820；53项测试和完整正式端口socket链通过，原角色库哈希未变。安装后用户已确认返回大厅和重新开始训练均正常。 源码、旧版备份、证据、安装清单、测试和报告位于research/2026-09-07/training-room-actions-20260907-232711/。仍只实现本地单人自由训练，非完整多人或原厂源码恢复。

> 最新状态（2026-09-07 23:29，Asia/Shanghai）：**自由训练开始与返回大厅处理已补齐**。实机4030/0→4080/53进入加载，4160/0→4180/0进入场景但尚不能动；继续8040/14→8070/12后用户明确确认“现在可以正常移动和攻击”。新RoomSession按该三阶段自动分派，3110/0→3115/0并清entered/started/loading_complete/active/request，恢复大厅2250/2260响应。8070末8字节复用4080的本局标识，不是UID；4100是结算请求，不用于开局。原项目源码已更新，正式v4 PID22820；53项测试和完整正式端口socket链通过，原角色库哈希未变。首次临时推送实机已由用户确认能移动攻击；正式服务完整自动握手和退出通过socket，重登后的返回大厅及训练UI复测待用户反馈。 源码、旧版备份、证据、安装清单、测试和报告位于research/2026-09-07/training-room-actions-20260907-232711/。仍只实现本地单人自由训练，非完整多人或原厂源码恢复。

> 最新状态（2026-09-07 23:01，Asia/Shanghai）：**创建团队战房间→进入房间已获真实客户端确认**，用户原话“已经进入房间”。22:58:29 wire确认3010/81→3020/83→3550/12→3070/14→3100/245。本轮根因是IDA raw镜像表指针到文件地址需减0x10000，旧3020/4、3030/196、205xx/25xx“房间推进”结论均已纠正。当前room_protocol.py使用WORD房间handle1并回显原81字节请求，3070回3100/245；2250回2270/8、2260回2280/8。实机进房后发现特殊3550/12被过严UID检查误关连接，已修复为仅校验长度并保留原包；最后socket实测在同连接收到3550与下一条2270，确认该断线问题已排除。最终服务PID38572；20项协议/P2P/房间测试+9项角色测试共29项通过。源码、旧版备份、实机wire切片、用户确认、静态分析和哈希均在research/2026-09-07/room-enter-recovery/。原角色数据库未替换。请重登使用最后修正版；下一阶段再继续房间内操作与战斗，尚不能称完整游戏服务端已恢复。

> 最新状态（2026-09-07 22:56，Asia/Shanghai）：本轮发现根本地址映射错误：game-runtime.bin.i64 中表指针须减0x10000，且消息表项为opcode/kind/handler。真正3020要求83字节（WORD房间handle+原3010/81回显），会推进3550/12与3070/14；3070成功回复为3100/245。已新增room_protocol.py，删除旧3020/4和3030/196/20564/40/20560/1误推送，纠正2250->2270/8、2260->2280/8；旧顶部25xx推进判断不再成立。地图0已从真实客户端配置树确认是随机地图。源码/TCP19项测试通过，服务已准备切换。真实进房UI尚待重登复测；重点看3070、3100后是否发21428/0。详细证据见research/2026-09-07/room-enter-recovery/2026-09-07_逆向-room-enter-report.md；本轮前源码和文档已备份于同目录backup-20260907-225642。

> 最新状态（2026-09-07 22:42，Asia/Shanghai）：用户刚完成一次新版 server 下的真实建房点击复测。wire 确认 `3010/81` 创建请求已发出，v4 server 已按当前实现返回 `3020/4`（room id `12100000`）、`20564/40`、`20560/1(00)`；客户端随后确实进入新阶段并发送 `2540/1(00)` 与 `2560/9(0000000000e9030000)`，server 也已分别返回 `2550/62` 与 `2570/62`。这证明 `20560/00` 是有效推进链路，问题已从“点击创建后没有反应”后移到 `25xx` 阶段之后：当前 `2550/2570` 最小自玩家 payload 长度正确但字段可能过瘦，客户端后续仍回到 `2260/2250` 大厅轮询与 P2P `1013/1014` 心跳，没有观察到可见进房或新的明确阶段包。当前运行 v4 PID `41284`，配置已开启 `room_stage.push_room_enter_ack_20560_after_create=true` 与 `room_stage.enable_post_enter_25xx=true`。下一步优先静态恢复 `2530/68`、`2550/62`、`2570/62` 的完整玩家/场景字段，或补 `21410/0` 的前置初始化响应；Frida attach 当前会导致客户端退出，暂不作为首选验证方式。

> 最新状态（2026-09-07 22:40，Asia/Shanghai）：用户允许 UAC 后，本轮继续推进“创建团队战房间点确定没反应”。新增并验证 `3010/81` 建房成功后主动推送 `20560/1`（payload `00`），同时补齐显式入房路径 `20540/8 -> 20560/1`。真实 wire 复查显示：22:29 的客户端在收到 `3020/4 + 20564/40 + 20560/1` 后，首次出现此前没有的新阶段请求 `2540/1` 和 `2560/9`，说明 `20560` 确实推进了房间进入链路；当时服务端尚未响应这两个新请求。本轮随后按 IDA 表项补齐 `2540/1 -> 2550/62`、`2560/9 -> 2570/62`，payload 为本地 UID `1001`、room id `12100000`、角色名 `t07` 的最小自玩家记录；`lab-control.json` 已同步并开启 `room_stage.push_room_enter_ack_20560_after_create=true`、`room_stage.enable_post_enter_25xx=true`。协议测试 26 项通过；socket 烟测确认 `3010 -> 3020/20564/20560`，`2540 -> 2550/62`，`2560 -> 2570/62`；v4 server 已重启到 PID `41284`。动态 Frida 附着会导致客户端连接关闭/退出，暂不继续用探针。当前还缺一次“重启客户端后真实建房”的干净复测：请重新打开隔离客户端，登录到大厅，创建团队战房间并点确定；若仍不进房，优先看 `2570` 之后出现的新消息或 UI 提示。

> 最新状态（2026-09-07 22:08，Asia/Shanghai）：用户复测反馈“还是不行”。复查最新 `lab-wire-v4.jsonl`：真实建房点击后服务端已返回 `3020/4`（room id `12100000`）并主动推送 `20564/40`，但客户端仍未发出 `20540/8` 入房请求，只回到 `2260/2250` 大厅轮询。因此 `20564` 主动推送不足以推进创建后入房。本轮改追未响应的大厅/房间初始化请求：IDA 确认 `20546/0` 在团队战/房间面板初始化时固定发送，`sub_A1C240` 接受 28 字节状态包并把第一 DWORD 写入 `sub_9BCF80` 读取的模式状态；`sub_914010` 对该状态有 `== 1` 检查。已新增候选 `20546 -> 20566/28`，payload 为 `01000000` + 6 个零 DWORD；配置开关 `room_stage.enable_room_mode_20566=true`。当前运行中的 v4 已重启到 PID `49584`；验证：`login-to-world` 协议单测 21 项通过，socket 烟测确认 `20546/0 -> 20566/28`，`3010/81 -> 3020/4 + 20564/40` 保持不变。下一步请在真实客户端重新登录/回大厅后创建团队战房间并点确定；若仍不进房，优先继续追 `20566` 后是否出现新的 UI 请求或仍停留在 `2260/2250` 轮询。

> 最新状态（2026-09-07 21:55，Asia/Shanghai）：用户结束游戏后允许继续推进房间阶段。本轮将建房后的下一步实验从无效的 `3030/196` 切到房间上下文路径：`role_protocol.py` 新增 `ROOM_CREATE_CONTEXT_PUSH_DELAY_MS`，`3010/81` 现在先回 `3020/4`，并在 `control.room_stage.push_room_context_20564_after_create == true` 时主动推 `20564/40`；`lab-control.json` 当前实验配置为 `push_room_state_3030_after_create=false`、`push_room_context_20564_after_create=true`，`2260 -> 2580` 继续关闭。理由：IDA 确认 `3020` handler 只写 room id 和刷新按钮，`3030/196` 实机无效；而 `20564/40` raw handler `sub_A1C630 -> sub_A1C1E0 -> sub_826250 -> sub_825840` 会直接置房间上下文并刷新房间 UI。验证：`test_game_protocol.py` 14 项、`test_role_protocol.py` 9 项、`test_p2p_protocol.py` 5 项均通过；旧 v4 已优雅停止，新 v4 已启动，PID `40324`；`smoke_3010.py` 确认当前运行服务返回 `3020/4` + `20564/40`。下一步请在真实客户端重新登录/回大厅后创建团队战房间并点确定；若仍不进入房间，读取这次 `3010` 后的 wire，优先看是否出现 `20540/8` 或新的房间阶段请求。

> 最新状态（2026-09-07 21:11，Asia/Shanghai）：用户复测后反馈“能点确定了，但是没有反应”。复查最新 `lab-wire-v4.jsonl`：OK 点击已连续发出真实 `3010/81`（房名 `t07的房间`），当前服务稳定返回 `3020/4`，payload `a0a1b800`（room id `12100000`），但随后客户端没有发送 `20540` 进房请求，也没有新的 `20544` 上下文请求，只继续大厅轮询。IDA 复核结论：`3020` handler `sub_A1C170` 只要求 4 字节并写入 room id，不负责生成/进入完整房间；恢复出的消息/action 表显示 `3030` 落到 196 字节房间状态路径。已修正：`role_protocol.py` 新增 `build_room_state_payload()`，`3010/81` 现在返回 `3020/4` 后，会在 `control.room_stage.push_room_state_3030_after_create == true` 时继续推送 `3030/196`；`2260 -> 2580/8` 仍默认关闭，避免弹窗再次被刷新打断。v4 服务已重启到 PID `50432`。验证：`test_game_protocol.py` 13 项、`test_role_protocol.py` 9 项、`test_p2p_protocol.py` 5 项均通过；`smoke_3010.py` 确认当前运行服务返回两帧：`3020/4`、`3030/196`，其中 `off_54=00ff00ff`、`off_61=a0a1b800`。下一步请在真实客户端重新点一次“创建团队战房间”并点确定；若仍不进入房间，继续看这次 `3030/196` 后 wire 中出现的第一条新消息或缺口。

> 最新状态（2026-09-07 20:54，Asia/Shanghai）：用户复测发现“创建团队战房间”弹窗会先出现、随后立刻消失。复查 `lab-wire-v4.jsonl`：20:49 左右是一次 fresh login；20:52 的弹窗消失窗口里没有新的 `3010/81` 建房请求，也没有 `20540` 进房请求、没有真实客户端发出的 `20544`，只有大厅周期请求与反复的 `2260/3 -> 2580/8`、`2250/8 -> 2500/1304`。结论：刚启用的空页 `2580/8` 虽然符合 IDA handler 长度，但在真实 UI 上会推动/刷新大厅状态，打断创建弹窗，导致客户端还没发出 `3010` 就回到轮询。已修正：`2260` 响应默认禁用；`role_protocol.py` 只在 `control.room_stage.enable_room_page_2580 == true` 时返回 `2580/8`，`lab-control.json` 中 `game.2260.enabled=false`，因此当前运行中的 v4 服务无需重启已停止响应 `2260`；`20544 -> 20564/40` 保持启用。验证：`test_game_protocol.py` 11 项、`test_role_protocol.py` 9 项、`test_p2p_protocol.py` 5 项均通过；本地 socket 探针确认当前服务为 `2260 -> no response`，`20544 -> 20564/40`。下一步请重新在大厅点“创建团队战房间”，预期弹窗应不再被 `2580` 刷掉；若这次能发出 `3010/81`，继续观察 `3020/4` 后的下一条新消息。

> 以下 20:54/20:38/19:41/19:20/18:50/16:01/01:07/00:37 历史摘要及历史章节保留作证据，以本段与最新日志为准。

> 最新状态（2026-09-07 20:38，Asia/Shanghai）：本轮继续推进 server 端恢复，补齐房间阶段两个缺口。IDA 复核确认：`2260/3` 的响应候选 handler 是 `sub_814280`，要求 payload 长度 `8 + n * 0x103`，并通过 `sub_91E5D0` 把 UI/controller 状态从 `10/11` 推到 `12`；因此新增最小空页响应 `2260 -> 2580/8`，payload `0000000001000000`（`total_rooms=0,total_pages=1`），先解锁状态而不伪造 0x103 房间富记录。另一路确认：`sub_84E160` 会在 room-context flag 未置位时发送 `20544/0`，`sub_A1C630 -> sub_A1C1E0 -> sub_84DF70` 只接受并复制 40 字节上下文；因此新增 `20544 -> 20564/40`，payload 首槽 `<room_id=12100000,value=1>`，余 32 字节为 0。代码侧：`role_protocol.py` 新增 `build_room_page_payload()`、`build_room_context_payload()` 以及 `2260/20544` handler；`test_game_protocol.py` 增加对应断言；`lab-control.json` 同步热加载 fallback，所以当前 v4 进程无需重启也能响应。验证：`test_game_protocol.py` 11 项、`test_role_protocol.py` 9 项、`test_p2p_protocol.py` 5 项均通过；本地 socket 探针确认当前运行服务返回 `2260 -> 2580/8` 与 `20544 -> 20564/40`。当前边界：还没做这两个新增响应后的真实客户端复测；下一步 fresh login 后建房，观察 `lab-wire-v4.jsonl` 中 `3020/4` 后是否出现 `2580`、`20544/20564`、`20540` 或其它新的非零房间阶段消息。

> 以下 19:41/19:20/18:50/16:01/01:07/00:37 历史摘要及历史章节保留作证据，以本段与最新日志为准。

> 最新状态（2026-09-07 19:41，Asia/Shanghai）：用户在 `2500/1304` 修正后实机复测，仍然“点确定后没进房”。复查 `lab-wire-v4.jsonl`：19:22:56 与 19:23:02 两次建房点击均发出 `3010/81`（房名 `t07的房间`），当时旧服务返回 `3020/196`，但 payload 只有 6 个非零字节；之后客户端继续 `2260/2250` 轮询，未出现 `20540` 进房请求。IDA 新结论：`sub_91DC40` / `sub_91DCD0` / `sub_91DD40` 发送 `2260/3` 后会把 UI/controller 状态置为 `this+248 = 10/11`；`sub_9148B0` 与 `sub_7F6F40` 读取 `sub_9BD390(dword_17C86FC)+348/+352`，只有 `+352` 的 room id 非零时才调用 `sub_826090(room_id)` 生成真实 196 字节房间结构并进入后续 UI/房间流程。`sub_A1C170` 明确要求响应 payload `a3 == 4`，并把这 4 字节 DWORD 写入 `+352` 与 `sub_84DF00`；因此 `3010 -> 3020/196` 是第二个确定长度错误，当前已修正为 `3010 -> 3020/4`，payload 为 `a0a1b800`（room id `12100000`）。标注中的判断也已归档：`sub_A1C070` / `sub_A1BFE0` 是离房/清房上下文，`sub_A1C170` 写房号，`sub_A1C630` 处理 `a2 == 40` 的后续阶段。代码侧：`role_protocol.py` 新增 `ROOM_CREATE_ACK_SIZE = 4`，`build_room_create_ack_payload()` 返回 `<I room_id`；`test_game_protocol.py` 与 `lab-control.json` 已同步，9 项协议单测通过。v4 服务已再次优雅重启到 PID `43868`，本地 socket 探针确认当前运行服务返回 `3020/4` 与 `2500/1304`。当前边界：尚未做 `3020/4` 后的实机客户端复测；下一步重新登录客户端再点建房。若仍不进房，优先追 `2260` 的对应响应映射，或继续补 `sub_A1C630` 所需的 40 字节阶段。

> 以下 19:20/18:50/16:01/01:07/00:37 历史摘要及历史章节保留作证据，以本段与最新日志为准。

> 最新状态（2026-09-07 19:20，Asia/Shanghai）：用户实机复测“建房按确定没有反应”后，重新核对 wire 与 IDA：按钮确实触发了 `3010/81`，服务端也返回 `3020/196`，但随后客户端只继续轮询 `2260/2250`，未发出 `20540` 进房请求。此前 `2500/17` compact list 的结论已修正：IDA 中 `sub_A1B840` 在调用 `sub_84E410 -> sub_827740` 前要求入包长度 `a2 >= 0x518`，因此 17 字节包可能停在分发层。本轮已把 `role_protocol.py` 的 `build_room_list_payload()` 改为 `2500/1304`（`DWORD count=1` + 1 条 13 字节房间记录 + 补零到 100 个槽位），`lab-control.json` 的 `2250` payload 同步为 1304 字节，前 17 字节仍为 `01000000a0a1b800000000000000000001`；`test_game_protocol.py` 已同步并通过 9 项测试。v4 服务已优雅重启到 PID 20328，本地 socket 探针确认当前运行服务返回 `message_id=2500`、`payload_len=1304`。下一步请重新登录客户端后再试建房；若仍不进入房间，继续追 `2260/2580` 状态响应或补齐 `3020` 中由 `sub_826090` 生成的 196 字节富字段。

> 以下 18:50/16:01/01:07/00:37 历史摘要及历史章节保留作证据，以本段与最新日志为准。

> 最新状态（2026-09-07 18:50，Asia/Shanghai）：IDA 已切回主程序数据库 `research/2026-09-06/spc32/work/game-runtime.bin.i64`。本轮纠正房间阶段两个关键点：真实客户端 BattleMode 表里确认存在 key `121000`，因此 mock 房间实例 ID 改为 `12100000`（`12100000 / 100 == 121000`），不再用登录 UID `1001`；`2250/8` 房间列表请求已确认由 `2500` compact payload 处理，handler 链为 `sub_84E410 -> sub_827740`，payload 结构为 `DWORD count + count * 13`。当前 `role_protocol.py` 新增 `build_room_list_payload()` 与 `2250/8 -> 2500/17` 分支；`lab-control.json` 同步热加载 fallback：`3010 -> 3020/196` 现在写入 `off_54=00ff00ff`、`off_5c=01`、`off_61=a0a1b800`，`2250 -> 2500/17` payload 为 `01000000a0a1b800000000000000000001`。测试结果：`login-to-world` 协议单测 14 项通过，`role-create` 单测 9 项通过；本地 socket 烟测确认当前运行服务不重启即可返回新 `3020/196` 与 `2500/17`。真实 `lab-wire-v4.jsonl` 已看到客户端轮询 `2250` 后收到 `2500/17`。当前边界：**客户端已经拿到一个可选房间列表项；还未观察到用户点击列表项/建房后的下一条真实非零消息。下一步等用户方便再在大厅里点一次房间列表项或创建入口；若仍不推进，专门追 `2260` 状态响应或 `20540` 进房链路。** 本轮未重启服务、未触发 UAC。

> 以下 17:50/16:49/16:01/01:07/01:12 历史摘要及历史章节保留作证据，以本段与最新日志为准。

> 最新状态（2026-09-07 16:01，Asia/Shanghai）：**角色选择 → 频道选择 → 世界交接 → 游戏大厅已经由真实隔离客户端验证打通。** 频道记录改为非零 ID `1` 后，客户端发送 `3320/4`，接收 `1201/4(0)`，随后发送 `2010/96`；v4 现在返回已验证的 `2030/52`（世界 ID、`127.0.0.1:5136`、route ID），客户端进入“频道：本地测试服”的大厅并显示角色 `t07`。`2030` 后还观察到完整的大厅初始化请求簇以及到 5136 的 TCP 连接。创建竞技房间并选择团体战时，客户端在本地报错“还没有连接P2PServer, 无法加入房间”；因此当前精确边界是：**10035 大厅协议已通，5136 只有 TCP 建连，尚缺 P2P 应用层握手，创建房间请求尚未发出。** 角色协议测试 9 项、游戏协议测试 7 项通过。阶段报告见 `research/2026-09-07/p2p-room/2026-09-07_逆向-channel-world-p2p-checkpoint.md`。下一步应逆向 `SDP2P.dll`（SHA-256 `3F8120FCDA641FA898618B66926655C6F0F5E28C50999E855445F239D60CF160`）的服务端首包与连接状态机，不能靠猜测房间参数。

> 以下 01:07/01:12 顶部摘要及历史章节保留作证据，以本段与本轮阶段报告为准。

> 最新状态（2026-09-07 01:07，Asia/Shanghai）：真实隔离客户端已完成非零外观 1150 采集，接受 1151/836（360 字节角色 + 七条 68 字节物品），发出 3320，并在收到有效 1130 后进入“频道选择”，显示 t07 和正确外观。已新增 role_protocol.py 与 lab_server_v4.py，SQLite 保存 t07；7 项角色/TCP 测试及原有 6 项协议测试通过。v3 已正常停止，当前 v4 PID 10956 监听本机 8094/8000/10035/5136。新入口 tools/START_ROLE_LAB.ps1，客户端入口仍为 tools/START_ISOLATED_GAME.bat。**2026-09-07 01:12 用户已确认实机重登可直接恢复既有角色 t07（原话“可以直接恢复07”），持久化恢复验证通过，证据 E-017。下一步继续频道连接与大厅/世界；此前频道点击仅出现“祝您玩得开心”的问题尚未解决。** 先读 research/2026-09-07/role-create/2026-09-07_逆向-role-create-report.md。旧全零 1130 保持禁用，v4 从已验证字段生成有效角色记录；不能照搬旧固定回包配置。

> 以下上一阶段顶部摘要及历史章节保留作证据，以本段与本轮报告为准。

> 最新状态（2026-09-07 00:37，Asia/Shanghai）：创建角色外观选择已经获得真实隔离客户端动态验证。E-011 从客户端运行时有序树导出并逐条交叉验证了全部 3,511 条物品配置；有效 ID 是范围 `100000..990390` 的完整 DWORD，`0..255` 无记录。实验配置按性别和槽位使用真实 ID：头 `151/152xxx`、脸 `131/132xxx`、身体 `121/122xxx`、手 `171/172xxx`、腿 `161/162xxx`、脚 `141/142xxx`、武器 `253xxx`，共 56 条、`1125/896`。客户端重启并重新登录后，用户确认外观已经可以选择，E-012 已记录该动态结果。因此 1125 结构、完整 DWORD 本地 ID 和 UI 循环路径均已验证；此前无法切换的直接原因是候选 `0/1/2/3` 不存在。本地服务 PID 29152 继续监听 8094/8000/10035/5136，错误的 `1130/360` 保持禁用。**下一步是采集带非零外观值的 1150，并恢复角色创建成功、360 字节角色状态、持久化和进入世界。**

> 接手先读 [游戏协议阶段逆向报告](research/2026-09-06/work/login-to-world/report/2026-09-06_逆向-game-protocol-report.md) 和 [登录至游戏连接阶段详细记录](research/2026-09-06/work/login-to-world/LOGIN_TO_WORLD_PROGRESS.md)。当前 codec 在 `game_protocol.py`，测试在 `test_game_protocol.py`，实验响应由 `lab-control.json` 的 `game.1010` 响应序列控制；正式安装目录保持只读。

> 界面证据纠正：用户曾点击提示框“确认”，不能将提示消失单独归因于回包修复。网络日志证实 10035 连接和收包，但不代表角色登录完成。

## 以下为保留的历史概览

旧的“最新进展”、时间和故障结论是历史记录；当前状态以本页顶部及最新交接章节为准。


> 最新进展：已补齐 SPC 函数表 +4，真实点击登录不再立即崩溃，已采集 128 字节真实登录请求。当前仍未实现正确服务端响应，不能登录游玩。以文末“点击登录空指针修复”章节为准。

> 保存位置更新：所有重要材料已归档到本项目 research/，工具链位于 toolchain/。请以文末“项目目录长期归档”为准。

> 最新进展（2026-09-06）：SPC32 启动兼容版已显示真实游戏主窗口，当前错误为“初始化 SDLoginClient 组件失败”。请优先阅读文末同日修复章节；前文返回值无关、ret 0x10c 等判断保留为历史记录，不再作为当前结论。

更新时间：2026-09-06 约 11:55，Asia/Shanghai

更新补充：游戏安装/目标目录已经改为 `C:\Program Files (x86)\kk`，用于避开中文路径导致的编码问题。后续命令和脚本应优先使用这个目录。

这份文档用于重新打开一个新的 Codex 窗口后快速接上当前进度。当前目标是：为本地《功夫小子》客户端做一个最小可登录 Go mock server。代码已经放在：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server
```

## 当前结论

已经解决的部分：

- Go mock server 已创建、可编译、可运行。
- 游戏 `config.xml` 已成功改成指向本地 `127.0.0.1`。
- `SPL.exe` 参数启动问题已经修过：
  - “所有参数必须以 -- 开头”已解决。
  - “未知参数”已解决。
- `RUN_START_LOCAL.bat` 现在能用正确参数启动 `SPL.exe`。
- `SPL.exe` 已经可以打到本地 mock server：
  - TCP 探测 `127.0.0.1:8000`
  - TCP 探测 `127.0.0.1:8094`
  - HTTP 请求 `GET /config/1464/config_update/update`

仍未解决的部分：

- 当前仍卡在 SPL 弹窗：`网络配置错误`。
- 现有证据显示：`/config/1464/config_update/update` 需要一种特定的加密/签名/压缩配置格式；普通明文、XML、JSON、zip、gzip、zlib、直接返回本地 `SPDATA` 文件都无法通过。
- 还没有进入真正登录 TCP 握手阶段；日志里目前只有端口 connect/close，没有客户端发出的登录包。

## 当前运行状态

最后确认时，本地 mock server 正在运行：

```text
进程：kungfu-mock-server.exe
路径：C:\Users\24032\Desktop\code\kungfu-mock-server\kungfu-mock-server.exe
监听：
  127.0.0.1:8080
  127.0.0.1:8000
  127.0.0.1:8094
  127.0.0.1:10035
  127.0.0.1:5136
启动参数：
  -http 127.0.0.1:8080
  -host 127.0.0.1
  -ports 8000,8094,10035,5136
  -config configs\responses.json
  -log-dir logs
  -net-config-dir "C:\Program Files (x86)\kk\SPDATA"
```

如果新窗口需要重新启动 server：

```powershell
Set-Location -LiteralPath 'C:\Users\24032\Desktop\code\kungfu-mock-server'
.\kungfu-mock-server.exe -http '127.0.0.1:8080' -host '127.0.0.1' -ports '8000,8094,10035,5136' -config 'configs\responses.json' -log-dir 'logs' -net-config-dir 'C:\Program Files (x86)\kk\SPDATA'
```

## 游戏配置现状

目标配置文件：

```text
C:\Program Files (x86)\kk\Data\config.xml
```

当前内容已经改成本地：

```xml
<?xml version="1.0" encoding="gb2312" ?>
<GameClient>
	<Updater>
		<UpdateInfo Url="http://127.0.0.1:8080/KKTest/updateinfo.zip"></UpdateInfo>
		<LaunchExe Name="Client.exe"></LaunchExe>
	</Updater>
	<PrePaidURL URL="http://ingame.pay.sdo.com/ingame/default.aspx?"></PrePaidURL>
	<RegisterURL URL= "http://register.sdo.com/register.asp?from=17&amp;zone=0"   />
	<OperationURL opcode="" />
	<LoginServer ID="0" Name="..." Ip="127.0.0.1" Port="8000" LoginPort="8094" loadigw="0" AreaID="0"></LoginServer>
</GameClient>
```

注意：

- 原始远端登录 IP 曾是 `47.100.39.183`。
- 原始更新 URL 曾是 `http://61.152.103.95:8080/KKTest/updateinfo.zip`。
- `LaunchExe` 之前是 `KKClient.dat`，但安装目录里没有这个文件，所以已改成现有的 `Client.exe`。

相关脚本：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\tools\RUN_AS_ADMIN_apply_config.bat
C:\Users\24032\Desktop\code\kungfu-mock-server\tools\apply-client-local-uac.ps1
```

`apply-client-local-uac.ps1` 已修复中文路径乱码问题：它现在不再硬编码中文目录名，而是扫描 `Program Files (x86)` 下包含 `SPL.exe` 和 `Data\config.xml` 的目录。

## 启动方式

不要直接点 Launcher，也不要直接双击 `Client.exe`。

当前推荐启动：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\tools\RUN_START_LOCAL.bat
```

这个 bat 会调用：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\tools\start-spl-local.ps1
```

修复后的 SPL 启动参数是：

```text
--game_id 1464 --client_name Client.exe --server http://127.0.0.1:8080 --client_arg "--server=127.0.0.1 --port=8000 --login_port=8094"
```

关键点是 `--client_arg` 后面的值必须整体加引号，否则会触发 SPL 弹窗：

```text
未知参数
```

## 已遇到的错误和处理结果

### 1. “所有参数必须以 -- 开头”

原因：SPL 启动参数格式不符合它自己的解析要求。

已处理：

- `start-spl-local.ps1` 改为直接传 SPL 需要的参数：
  - `--game_id`
  - `--client_name`
  - `--server`
  - `--client_arg`

### 2. “未知参数”

原因：`--client_arg` 的值没有作为一个完整参数传入，里面的 `--port` / `--login_port` 被 SPL 当成自己的参数。

已处理：

```text
--client_arg "--server=127.0.0.1 --port=8000 --login_port=8094"
```

### 3. 直接启动 `Client.exe` 报缺 `SPC32.dll`

截图提示：

```text
由于找不到 SPC32.dll，无法继续执行代码。重新安装程序可能会解决此问题。
```

结论：

- 不能直接启动 `Client.exe`。
- `SPC32.dll` 不在当前游戏安装目录里。
- 这大概率是 SkyProtect/SPL/SPS 启动链负责准备或加载的组件。
- 所以当前路线必须继续走 `SPL.exe`，不能绕过 SPL 直接跑 Client。

### 4. 当前卡点：“网络配置错误”

这个错误现在是真正的卡点。

已确认：

- SPL 已经能连接本地 `8000` / `8094`。
- SPL 已经能请求本地：

```text
GET /config/1464/config_update/update
User-Agent: xgddft
Accept: */*
```

但返回体格式不对，所以 SPL 弹：

```text
网络配置错误
```

## 已测试过的网络配置响应

### 本地 SPDATA 文件

测试脚本：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\tools\test-spdata-candidates.ps1
```

测试过这些文件：

```text
C:\Program Files (x86)\kk\SPDATA\data0
C:\Program Files (x86)\kk\SPDATA\data1
C:\Program Files (x86)\kk\SPDATA\data2
C:\Program Files (x86)\kk\SPDATA\data3
C:\Program Files (x86)\kk\SPDATA\data4
C:\Program Files (x86)\kk\SPDATA\data5
C:\Program Files (x86)\kk\SPDATA\data6
C:\Program Files (x86)\kk\SPDATA\data7
C:\Program Files (x86)\kk\SPDATA\data8
C:\Program Files (x86)\kk\SPDATA\data9
C:\Program Files (x86)\kk\SPDATA\SPDATA0
C:\Program Files (x86)\kk\SPDATA\SPDATA1
C:\Program Files (x86)\kk\SPDATA\SPDATA2
C:\Program Files (x86)\kk\SPDATA\SPDATA3
C:\Program Files (x86)\kk\SPDATA\SPDATA4
C:\Program Files (x86)\kk\SPDATA\SPDATA5
C:\Program Files (x86)\kk\SPDATA\SPDATA6
C:\Program Files (x86)\kk\SPDATA\SPDATA7
```

结果：

- 每个候选都只触发 `8000` / `8094` 端口探测。
- 没有任何候选让客户端进入登录 TCP 发包阶段。
- 部分候选甚至没有触发 HTTP 配置请求。

### mock server 内置响应模式

已测试：

```text
url-list
xml
ini
json
empty
config-xml
sky-json
zip
zlib-url-list
zlib-json
zlib-config-xml
gzip-url-list
gzip-json
```

结果：

- HTTP 都能被 SPL 请求到。
- 但全部仍停在 `网络配置错误`。
- 没有进入 TCP 登录握手。

## Go mock server 能力

主程序：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\cmd\kungfu-mock-server\main.go
```

已实现：

- TCP 监听：
  - `8000`
  - `8094`
  - `10035`
  - `5136`
- HTTP 监听：
  - 默认 `127.0.0.1:8080`
- HTTP 路由：
  - `/config/1464/config_update/update`
  - `*.zip`
  - 其它路径返回 `OK`
- TCP 包日志：
  - 写入 `logs\`
- 可配置 TCP 响应规则：
  - `configs\responses.json`
- 网络配置响应模式：
  - `-net-config-mode url-list|xml|ini|json|empty|config-xml|sky-json|zip|zlib-*|gzip-*`
  - `-net-config-file <file>`
  - `-net-config-dir <dir>`，会轮流返回 `data*` / `SPDATA*` 文件

重新编译命令：

```powershell
Set-Location -LiteralPath 'C:\Users\24032\Desktop\code\kungfu-mock-server'
$env:GOCACHE = 'C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\initial-analysis\work\gocache'
go build -o 'C:\Users\24032\Desktop\code\kungfu-mock-server\kungfu-mock-server.exe' '.\cmd\kungfu-mock-server'
```

## 重要日志位置

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\logs
```

重要日志类型：

- `YYYYMMDD-HHMMSS-port8000-conn*.log`
- `YYYYMMDD-HHMMSS-port8094-conn*.log`
- `candidate-*.stderr.log`
- `mode-*.stderr.log`
- `mode2-*.stderr.log`

现有 TCP 日志大多只有：

```text
port=8000 conn=N remote=127.0.0.1:xxxxx started=...
```

还没有出现：

```text
C->S
```

这表示客户端还没有发登录协议包。

## 外网探测结果

尝试过的原始/候选地址：

```text
http://47.100.39.183/config/1464/config_update/update
http://47.100.39.183:8080/config/1464/config_update/update
http://61.152.103.95:8080/KKTest/config/1464/config_update/update
http://61.152.103.95:8080/config/1464/config_update/update
http://kkupdate.8yx.com/update/config/1464/config_update/update
http://kkupdate.8yx.com/config/1464/config_update/update
```

结果：

- `47.100.39.183/config/...` 返回 401，内容类似 `SpaceOS authentication required`。
- `47.100.39.183:8080/...` 超时。
- `61.152.103.95:8080/...` 超时或 empty reply。
- `kkupdate.8yx.com/...` 返回 404。

也尝试过直接连原登录端口：

```text
47.100.39.183:8000
47.100.39.183:8094
```

结果：

- 连接后没有服务端主动首包。
- 所以本地 mock server 目前不需要先发 banner。

## 逆向/静态分析线索

已安装 reverse-skill：

```text
C:\Users\24032\.codex\skills\reverse-skill
```

用过的技能：

- `protocol-reverse`
- `ida-reverse`
- `docs-generator`

当前新增逆向工具链：

```text
工具根目录：C:\Users\24032\Desktop\code\kungfu-mock-server\toolchain
Python：C:\Users\24032\Desktop\code\kungfu-mock-server\toolchain\python313\python.exe
Python 包：pefile 2024.8.26，capstone 5.0.9
JDK 21：C:\Users\24032\Desktop\code\kungfu-mock-server\toolchain\jdk-21.0.12.1+1
Ghidra：C:\Users\24032\Desktop\code\kungfu-mock-server\toolchain\ghidra_12.1.3_PUBLIC\ghidraRun.bat
x32dbg：C:\Users\24032\Desktop\code\kungfu-mock-server\toolchain\x64dbg\release\x32\x32dbg.exe
x64dbg：C:\Users\24032\Desktop\code\kungfu-mock-server\toolchain\x64dbg\release\x64\x64dbg.exe
便捷命令目录：C:\Users\24032\Desktop\code\kungfu-mock-server\toolchain\bin
```

注意：工具安装脚本已经把 `C:\Users\24032\Desktop\code\kungfu-mock-server\toolchain\bin`、portable Python、JDK bin 写入用户级 PATH。已经打开的终端/Codex shell 可能不会立刻刷新 PATH；必要时用上面的完整路径，或者重新打开一个终端。

本机当前仍没有 IDA/r2，但已经安装了 Ghidra、x32dbg 和 portable Python：

```text
where r2       -> not found
where rabin2   -> not found
where ida.exe  -> not found
where ida64.exe -> not found
Ghidra         -> C:\Users\24032\Desktop\code\kungfu-mock-server\toolchain\ghidra_12.1.3_PUBLIC\ghidraRun.bat
x32dbg         -> C:\Users\24032\Desktop\code\kungfu-mock-server\toolchain\x64dbg\release\x32\x32dbg.exe
Python         -> C:\Users\24032\Desktop\code\kungfu-mock-server\toolchain\python313\python.exe
```

尝试启动 IDA MCP：

```text
powershell -NoProfile -ExecutionPolicy Bypass -File 'C:\Users\24032\.codex\skills\reverse-skill\ida-reverse\scripts\start.ps1'
```

结果：

```text
ERR:IDADIR not set and IDA Pro not found. Set IDADIR to your IDA install dir (folder containing ida.exe).
```

早前为了轻量分析，曾给工作目录安装过 Python 临时依赖；现在优先使用 `C:\Users\24032\Desktop\code\kungfu-mock-server\toolchain\python313\python.exe`：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\initial-analysis\work\pydeps
```

包含：

- `capstone`
- `pefile`

分析脚本：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\initial-analysis\work\analyze_spl_http.py
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\initial-analysis\work\find_spl_xrefs.py
```

SPL 静态分析发现：

- `SPL.exe` 是 32 位 PE。
- 入口/普通 `.text` 之外还有两个巨大的可执行段：

```text
.FYJ0 executable, very large
.FYJ2 executable, very large
```

这很像加壳/保护代码区，导致普通静态 xref 找不到 HTTP 解析逻辑。

SPL 里能看到的关键字符串/导入：

```text
--game_id
--client_name
--server
--client_arg
所有参数必须以 -- 开头
未知参数
所有服务器连接失败
WinHttpOpenRequest
WinHttpReceiveResponse
WinHttpSendRequest
InternetOpenA
InternetConnectA
InternetReadFile
HttpSendRequestA
xgddft
Accept: */*
Pragma: no-cache
Cache-Control: no-cache
zlib inflate errors such as incorrect data check / incorrect header check
```

但“网络配置错误”这个中文字符串没有在 SPL/SPS/Launcher 的普通字符串扫描中直接找到，可能来自资源、压缩区、映射表，或 SPL.dll。

## 权限和编码坑

Codex shell 实际令牌是：

```text
Mandatory Label\Medium Mandatory Level
```

这意味着即使用户“以管理员打开 Codex”，部分 shell 写 `Program Files` 仍可能失败。

解决方式：

- 用 `RUN_AS_ADMIN_apply_config.bat` 触发 UAC 管理员 PowerShell。
- 脚本不能硬编码中文路径，否则可能出现：

```text
C:\Program Files (x86)\鍔熷か灏忓瓙\Data\config.xml
```

已修复：

- `apply-client-local-uac.ps1` 自动扫描游戏目录，不再写死中文路径。

## 建议下一步

2026-09-06 后续进展：

- 已安装并验证 Ghidra、x32dbg、portable Python、Frida。
- 已复制只读分析副本到：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\kungfu-targets
```

- 已生成静态分诊报告：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\triage.md
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\triage.json
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\spdata_probe.json
```

- 静态分诊结论：
  - `SPL.exe` 是当前主目标：32 位 PE，导入表明确包含 `WINHTTP.dll` / `WININET.dll` 的 HTTP API。
  - `SPL.exe` 存在高熵可执行段 `.FYJ0` / `.FYJ2` 和高熵 overlay，Ghidra 自动分析出现大量 bad body / function overlap，说明静态函数边界不可靠，疑似保护/壳。
  - `SPL.dll` / `SPS.exe` 也有高熵大段和动态 API 迹象，但 `/config/1464/config_update/update` 这条 HTTP 链优先从 `SPL.exe` 动态抓。
  - `SPDATA` 候选文件不像普通 zip/gzip/zlib 响应；`data*` 第一 DWORD 很像长度字段，但直接作为 HTTP body 已验证不过。

- 已准备 Frida 动态 hook：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\spl_http_hook.js
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\run_spl_frida.py
```

- Frida `spawn` SPL 失败：

```text
frida.NotSupportedError: unable to spawn executable ... 0x000002e4
```

- 普通启动工作区副本 SPL 失败：

```text
OSError: [WinError 740] 请求的操作需要提升
```

- 因此动态抓 HTTP buffer 的下一步需要用户明确授权：以管理员权限运行 Frida runner，启动并 hook 本地分析副本 `SPL.exe`，采样 `InternetReadFile` / `WinHttpReadData` / `MessageBoxA/W` / `GetProcAddress`。

优先路线：

1. 取得真实 `/config/1464/config_update/update` 响应体。
   - 最好来源：以前可用 server 的抓包、旧缓存、代理日志。
   - 一旦拿到真实响应，mock server 就可以直接复现外层配置流程。

2. 如果没有真实响应，就上调试/逆向工具。
   - 推荐：IDA / Ghidra / x64dbg 任意一个。
   - 目标：定位 SPL 在 `InternetReadFile` / `WinHttpReceiveResponse` 后如何解析配置 body，以及 `网络配置错误` 的触发条件。
   - 因为 SPL 有 `.FYJ0/.FYJ2` 可执行保护段，纯字符串扫描已经不够。

3. 继续 mock TCP 登录前，必须先过 SPL 的网络配置解析。
   - 当前没有任何 `C->S` 登录包。
   - 所以现在不要急着写账号密码登录逻辑；客户端还没走到那一步。

## 2026-09-06 13:54 动态逆向补充

已经按用户授权通过 UAC 管理员 PowerShell 运行 Frida runner，目标为：

```text
C:\Program Files (x86)\kk\SPL.exe
```

相关脚本：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\spl_http_hook.js
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\run_spl_frida.py
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\run_frida_uac.ps1
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\summarize_frida_events.py
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\spdata_outer_decode.py
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\disasm_slice.py
```

Frida 输出：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\frida-spl-http-access.json
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\frida-spl-http-access.runner.log
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\frida-spl-http-access.dynamic_range_dump.0083.bin
```

关键证据：

- SPL 使用 WinInet 请求本地 `GET /config/1464/config_update/update`。
- `HttpQueryInfoA` 返回 HTTP `200`，`Content-Length=3656`。
- `InternetReadFile` 成功读取 `3656` 字节，body 与 `C:\Program Files (x86)\kk\SPDATA\SPDATA0` 完全一致。
- `SPDATA0` 与 5/20/50/100/200ms copy dump 的 MD5 均为：

```text
23032558c08c6ff8ebb6dc20b86c7db5
```

- 仍然没有进入 TCP 登录发包阶段；`logs\*-port8000-*.log` 和 `logs\*-port8094-*.log` 仍只有连接/关闭，没有 `C->S`。

已确认 SPL 运行时使用 RWX 私有动态代码页解析 HTTP body：

```text
dynamic range base = 0x4c80000
size = 4194304
protection = rwx
file = null
```

Stalker 已能稳定捕获 `rep movs` 复制点：

```text
stalker_rep_movs@0x41bd6e
src = HTTP body buffer
dst = copied body buffer
len = 3656
```

也捕获到一个疑似运行时节点/容器校验片段：

```asm
04ce71cd: xor dword ptr [ebx], eax
04ce71cf: mov al, byte ptr [ebx + 2]
04ce71d2: xor al, byte ptr [ebx + 1]
04ce71d5: xor al, byte ptr [ebx]
04ce71d7: cmp byte ptr [ecx - 5], al
```

含义：某些 4 字节块先 XOR 一个 dword key，再校验第 4 字节是否等于前三字节 XOR。但把当次 `eax=0xc73d3256` 套到整个 `SPDATA0` 只命中 `8/913`，因此这个 key 不是 `SPDATA0` 的全局解密 key，更像 SPL 运行时内部节点/容器校验。

SPDATA 外层结构新发现：

```text
first_u32_le = decoded_length
(file_size - 4) % 4 == 0
((file_size - 4) / 4) * 3 == decoded_length
```

例：

```text
SPDATA0 len=3656 first=2739 groups=913
data0   len=2708 first=2028 groups=676
SPDATA1 len=472  first=351  groups=117
```

这说明 SPDATA 至少有一层 `u32 decoded_len + 4字节组 -> 3字节有效数据` 的外层容器。简单丢弃固定字节生成的 4 种变体仍不像明文，且 zlib/gzip 均不能直接解开；例如 `SPDATA0.drop3.bin`：

```text
size=2739
md5=0551dd1815680a3a0e5bafb89ef9c356
printable_ratio≈0.385
entropy≈7.912
```

当前判断：

- HTTP 传输已经通了，失败点在 SPL 对 body 的内存解析/校验阶段。
- 不建议继续盲试 XML/JSON/zip/gzip/zlib 或单个 SPDATA 候选。
- 下一步应继续恢复 SPDATA 的 `4->3` 解包函数和内层变换/校验逻辑。
- 只有日志里出现 `C->S` 登录包后，才进入登录 TCP mock 阶段。

## 新窗口接手提示词

可以直接把下面这段发给新窗口：

```text
请读取 C:\Users\24032\Desktop\code\kungfu-mock-server\CURRENT_STATUS.md，然后继续帮我做《功夫小子》的本地 Go mock server。当前卡在 SPL 的“网络配置错误”：SPL 已能请求本地 /config/1464/config_update/update，也能探测 8000/8094，但所有已测试的配置响应格式都没通过。请优先分析 SPL 期望的配置响应格式，或者帮我继续动态/静态逆向它的解析逻辑。
```

## 2026-09-06 14:xx Client 启动链静态分诊

用户已将游戏目标目录改为：

```text
C:\Program Files (x86)\kk
```

新增只读分析脚本与输出：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\client_launch_probe.py
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\import_xref_probe.py
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-launch-probe.json
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-launch-triage\triage.json
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-launch-triage\triage.md
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-exe-clientct-xrefs.json
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-ct-spc32-xrefs.json
```

关键 SHA256：

```text
Client.exe     C5C5C528E5665E1B0A719724A3B52EB0509C8C00CFD51BB13D90ABE20DE9B900
Client_CT.dll  00A46090476EBE64C9B2040154C754AD0B99780297A7E4C560036542953D302C
SPL.exe        2644D8BDB6F9FF3048788BE2DB9948E75682533DBBA6BCEFC1E1812116EB15EA
```

Client 启动链发现：

- `Client.exe` 直接导入 `Client_CT.dll` 的 ordinal `#1`。
- `Client_CT.dll` 导出 `MainFunction`，ordinal `#1`，VA `0x10001420`。
- `Client.exe` 对该 IAT 槽有一个直接调用点：

```asm
0x00011000: push 0x1e03000
0x00011005: push 0
0x00011007: push 0x21e68
0x0001100c: call 0x13c10
0x00011011: add esp, 0xc
0x00011014: call dword ptr [0x1b000] ; Client_CT.dll ordinal #1
```

- `Client_CT.dll` 直接导入 `SPC32.dll` 的 ordinal `#1`，IAT VA `0x10f79028`。
- `SPC32.dll` 不是 delay import，而是硬导入；当前 `C:\Program Files (x86)\kk` 内不存在 `SPC32.dll`，C 盘递归搜索也没有找到残留。
- 对 `Client_CT.dll` 中 `SPC32.dll!#1` 的普通代码 xref 扫描暂未发现直接引用，说明可能是保护/混淆后间接调用，或仅用于 loader/import 级别的初始化门。

当前判断：

- “破解 SPL”不是轻量工作：SPL 有保护段、高熵/动态 RWX 代码、运行时配置校验和 Frida 干扰迹象。
- 但“让游戏本体能跑”的路线不一定等于完整破解 SPL。可行路线分两条：
  1. 继续让 SPL 通过配置解析，保持原启动链。
  2. 尝试重建最小 Client 启动环境：先解决 `SPC32.dll` 硬依赖，再观察 `Client_CT.dll` 进入 `MainFunction` 后实际需要哪些参数/本地状态/网络配置。
- 不建议直接 patch SPL 或直接跳过反外挂逻辑；更稳的下一步是做 `SPC32.dll` 依赖确认/兼容 shim 实验，且只在本地离线目录里验证。

## 2026-09-06 14:xx SPC32.dll 离线兼容性验证

新增脚本与输出：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\make_spc32_stub.py
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\test_client_stub.ps1
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\client_runtime_hook.js
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\run_client_shim_frida.py
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\run_client_frida_inner.ps1
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\run_client_frida_uac.ps1
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\disasm_hex.py
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\spc32-stubs\*.dll
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\client-shim-test\
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-shim-tests\summary.json
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-shim-frida-ret0.json
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-shim-frida-ret0.runner.log
```

隔离目录：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\client-shim-test
```

已生成多个 32 位原生 `SPC32.dll` 占位变体，均只导出 ordinal `#1`，用于离线加载/调用约定验证：

```text
SPC32_ret0.dll / SPC32_ret0_long.dll
SPC32_ret4.dll / SPC32_ret4_long.dll
SPC32_ret8.dll / SPC32_ret8_long.dll
SPC32_ret12.dll / SPC32_ret12_long.dll
SPC32_ret16.dll / SPC32_ret16_long.dll
SPC32_ret0_pop10c_long.dll
SPC32_ret1_pop10c_long.dll
```

加载级结果：

- `SPC32_ret0`、`SPC32_ret4`、`SPC32_ret8`、`SPC32_ret16` 都能让隔离目录中的 `Client.exe` 启动并保持 5 秒以上。
- `SPC32_ret12` 触发 `0xC0000005` 访问违规。
- 这说明 `SPC32.dll` 缺失确实是第一道加载器门，但简单占位 DLL 已能让 `Client.exe + Client_CT.dll` 进入更深初始化。

Frida 动态结果：

- UAC Frida 能注入隔离目录中的 32 位 `Client.exe`。
- 进程初始模块包含：

```text
Client.exe
Client_CT.dll
SPC32.dll
msvcrt.dll
```

- `Client_CT.dll` 在文件中 `.text/.rdata/.data/.gac0` raw_size 为 0，真实代码由高熵 `.gac2` 在运行时还原。
- 运行时 `Client_CT.MainFunction` 地址为 `Client_CT base + 0x1420`，内存中已从空/保护占位还原为正常函数序言：

```asm
55 8b ec 83 ec 08 ...
```

- 直接 `Interceptor.attach` 到 `Client_CT.MainFunction` 会导致 Frida 连接断开，不建议继续用入口 patch 的方式碰该地址。
- 更稳的观察点是 `Client.exe` 本体 EP 和 `SPC32.dll!#1`。

`Client.exe` 启动链：

- `Client.exe` EP `0x1132f` 已命中。
- EP 初始化函数 `0x13458 / 0x133c5 / 0x11780 / 0x1346d / 0x13b1a / 0x13721 / 0x13950 / 0x110b2 / 0x13ba7` 均能返回。
- `Client.exe` 随后进入 `0x11000`，该函数会清零约 `0x1e03000` 字节 `.data` 区域，再调用：

```asm
0x00011014: call dword ptr [0x1b000] ; Client_CT.dll ordinal #1
```

`SPC32.dll!#1` 调用形态：

- 使用 `SPC32_ret0_long.dll` / `SPC32_ret1_pop10c_long.dll` 后，Frida 能 hook 到 `SPC32.dll!#1`。
- `Client_CT.dll` 会调用 `SPC32.dll!#1` 一次，时间约在进程启动后 600ms。
- 调用栈参数：

```text
stack4 = 0x5b8 = 1464
stack8 起始为 ASCII 路径
```

实测路径：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\client-shim-test\Web.ini
```

栈形态说明：

- `SPC32.dll!#1` 不是普通 `int fn(int game_id, char *path)` 指针传参。
- 它更像 `game_id + 内联定长 path buffer` 的特殊/旧式调用约定。
- 路径字符串在 `esp+8`，首个 `NUL` 在 `esp+113`。
- 下一个明显非零栈块约在 `esp+0x110`，因此候选清栈长度约 `ret 0x108` 或 `ret 0x10c`。

已测试：

- `eax=0; ret 0x10c`：`SPC32.dll!#1` 返回值为 0，但 `Client_CT` 未回到 `Client.exe`。
- `eax=1; ret 0x10c`：`SPC32.dll!#1` 返回值为 1，但 `Client_CT` 仍未回到 `Client.exe`。

当前判断：

- 简单 dummy return 不足以完整兼容 `SPC32.dll!#1`。
- 真实 `SPC32.dll!#1` 很可能除了返回状态，还会初始化某些本地保护/环境状态，或者写入 `Client_CT` 后续要检查的全局状态。
- `SPC32.dll` 分支从“缺失依赖”推进到了“需要模拟真实副作用/调用约定”的阶段。
- 如果能找到原始 `SPC32.dll`，优先级会非常高；它可能来自旧安装目录、补丁包、安装包缓存、网吧客户端备份或同版本完整客户端。
- 如果找不到原 DLL，下一步应继续在 `SPC32.dll!#1` 返回地址 `0x79415d16` 附近跟踪 `Client_CT` 运行时代码，定位它在 `SPC32` 返回后检查什么状态。

## 2026-09-06 15:xx SPC32 shim trace/dump 补充

用户已确认原始 `SPC32.dll` 找不到，后续路线切换为：在隔离目录中继续模拟 `SPC32.dll!#1` 的行为，并动态跟踪 `Client_CT.dll` 在 `SPC32` 返回后的检查逻辑。

新增/更新脚本：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\client_spc_trace_hook.js
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\run_client_spc_trace_inner.ps1
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\run_client_spc_trace_uac.ps1
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\summarize_client_spc_trace.py
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\rebuild_client_ct_memdump.py
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\find_mem_strings.py
```

`make_spc32_stub.py` 已扩展生成更多调用约定候选：

```text
SPC32_ret0_pop100_long.dll / SPC32_ret1_pop100_long.dll
SPC32_ret0_pop104_long.dll / SPC32_ret1_pop104_long.dll
SPC32_ret0_pop108_long.dll / SPC32_ret1_pop108_long.dll
SPC32_ret0_pop10c_long.dll / SPC32_ret1_pop10c_long.dll
SPC32_ret0_pop110_long.dll / SPC32_ret1_pop110_long.dll
SPC32_ret0_pop114_long.dll / SPC32_ret1_pop114_long.dll
SPC32_ret0_pop118_long.dll / SPC32_ret1_pop118_long.dll
```

已通过 UAC 管理员 Frida runner 跑通：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-spc-trace-ret1-pop10c-cleanstrings.json
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-spc-trace-ret1-pop10c-cleanstrings.summary.md
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-spc-trace-ret0-pop10c-cleanstrings.json
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-spc-trace-ret0-pop10c-cleanstrings.summary.md
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-spc-trace-ret1-pop10c-dump.json
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-spc-trace-ret1-pop10c-dump.summary.md
```

关键动态证据：

- `Client_CT.dll` 调用 `SPC32.dll!#1` 前会读取：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\client-shim-test\Web.ini
[config]
ID=1464
```

- `SPC32.dll!#1` 调用形态进一步确认：

```text
game_id = 1464
inline path = ...\client-shim-test\Web.ini
return address = Client_CT.dll+0x665d16
runtime VA = 0x79415d16 when Client_CT base = 0x78db0000
```

- `eax=0; ret 0x10c` 与 `eax=1; ret 0x10c` 的 Stalker call-summary 完全一致：

```text
events=23
unique Client_CT call targets=90
only_ret1=[]
only_ret0=[]
```

结论：当前阻塞点基本不是 `SPC32.dll!#1` 的返回值，而是原始 `SPC32.dll` 缺失的副作用/初始化状态。

已成功 dump `SPC32` 调用点时的 `Client_CT.dll` 运行时内存段：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\client-spc-dumps\
```

并合成为按 `Client_CT.dll` 模块偏移排列的内存镜像：

```text
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\Client_CT.spc_enter.mem.bin
C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\prior-analysis\work\analysis\Client_CT.spc_enter.mem.bin.map.json
```

内存镜像中的字符串锚点：

```text
SPC32.dll     offset=0x22d2a74
MainFunction  offset=0x2361d7a
Client_CT.dll offset=0x2361d87
```

`Client_CT.dll+0x665d16` 附近线性反汇编开头：

```asm
Client_CT.dll+0x665d16: call 0x798d285c
Client_CT.dll+0x665d1b: xchg dword ptr [esp + 0xc], ebx
Client_CT.dll+0x665d1f: shl byte ptr [esp + 8], 0xbd
Client_CT.dll+0x665d24: mov dword ptr [esp + 8], 0x6d9e83a1
Client_CT.dll+0x665d2c: jne 0x79b002a2
Client_CT.dll+0x665d32: or byte ptr [esp + 8], 0x3f
Client_CT.dll+0x665d37: jbe 0x792c37a3
```

注意：返回地址附近仍表现出明显混淆/动态调度特征，线性反汇编不能直接当作真实顺序控制流。

当前建议下一步：

1. 基于 `Client_CT.spc_enter.mem.bin` 做静态切片，围绕 `Client_CT.dll+0x665d16`、`0x798d285c`、`0x796bb095`、`0x79a4b782` 和 Stalker call-summary 里的高频目标继续恢复控制流。
2. 在 Frida 中增加更细的执行采样，重点抓 `Client_CT.dll+0x665d16` 之后对全局数据区或栈上 `Web.ini` 路径附近缓冲的读写。
3. 继续保持所有 `SPC32.dll` shim 实验只在隔离目录执行，不写入真实 `C:\Program Files (x86)\kk`。


## 2026-09-06 SPC32 启动兼容修复；下一卡点 SDLoginClient

### 当前结果与边界

- 用户明确丢失的是原游戏服务端源码，只剩客户端；长远目标是重建兼容服务端。
- 已生成 32 位 SPC32.dll 启动兼容实现，正常桌面、无 Frida 实测显示《功夫小子 V 1.1.1》主窗口和盛大游戏界面。
- 当前真实弹窗：**初始化 SDLoginClient 组件失败**。
- 尚未恢复登录、服务端或战斗。兼容 DLL 只验证启动流程，不保证完整原厂接口、退出流程或登录后行为。
- 正式安装目录 C:/Program Files (x86)/kk 未修改，所有本轮实验在隔离副本进行。

### 已确认接口和对旧判断的修正

1. SPC32 ordinal #1 返回值被当成函数指针表地址。返回 0/1 时，Client_CT.dll+0x4d6630 分别读取地址 0/1 并访问违规；相同 call-summary 不能证明返回值无关。
2. 工厂清栈改为 ret 0x108，配合函数表才能推进初始化。此大小与 game_id 4 字节加内联路径缓冲 260 字节相符。旧 ret 0x10c 不是已验证方案。
3. 返回表 +0：兼容函数返回 1、普通 ret；返回表 +8：收到窗口句柄形态的首参数，兼容函数返回 0、ret 4。表 +8 用诊断地址确认；ret16 曾失败，ret4 推进窗口初始化。
4. 原厂函数名称、完整参数语义及副作用未恢复。未实现表项保持零。
5. 旧追踪代码关闭 Stalker.parse 的 annotate，却按字符串 call/block/ret 解析，丢弃了执行顺序。本轮启用 annotate 后获取真实序列。
6. 进程存活和主函数不返回不是成功标准，旧实验包含异常处理阶段。
7. 本轮已能直接启动隔离 Client.exe，故不必先完整解决 SPL 配置才能观察游戏本体；SPL 原网络配置问题仍作为未解决备选路线保留。

### 隔离副本和启动方法

隔离客户端目录：

C:/Users/24032/Desktop/code/kungfu-mock-server/research/2026-09-06/spc32/work/client-test

已从原安装目录补齐根目录 DLL、Data、SDO。Data 约 2.72 GB，不含在交付压缩包里。

双击本机启动入口：

C:/Users/24032/Desktop/code/kungfu-mock-server/research/2026-09-06/spc32/outputs/spc32-repair/START_ISOLATED.bat

脚本以隔离目录为工作目录，并设置进程级 __COMPAT_LAYER=RunAsInvoker；没有修改系统兼容设置。工具沙箱窗口可能不显示在用户桌面，必须区分沙箱运行和正常桌面画面验证。

### 修复产物

交付目录：C:/Users/24032/Desktop/code/kungfu-mock-server/research/2026-09-06/spc32/outputs/spc32-repair

- SPC32.dll：1536 字节，启动兼容实现。
- build_spc32.py、pe32_builder.py：仅依赖 Python 标准库，在同目录执行 python build_spc32.py 可重建 DLL。
- REPORT.md：完整证据与接口推导。
- README.md：使用说明与验证边界。
- startup-result.png：正常桌面、无 Frida 的实际游戏画面，显示 SDLoginClient 错误。
- evidence/：已归档追踪记录。
- SHA256.json：文件校验值。

压缩包：C:/Users/24032/Desktop/code/kungfu-mock-server/research/2026-09-06/spc32/outputs/spc32-repair.zip

SPC32.dll SHA256：a23e504fa35818e3ac366b04f18f998afbf6dfe32c49e1298fadd3920020fbb5

验证包括：源码重建逐字节一致；32 位 PE 与 ordinal #1 导出；三个 HIGHLOW 重定位项模拟验证；实际非首选地址加载后 25 秒动态运行无 access-violation；正常桌面实际游戏截图。仍有系统处理的 C++ 异常，不应描述为完全没有异常。正式 Client.exe / Client_CT.dll 哈希已复核与前文一致。

### 另外处理过的依赖缺失

- 曾在正常桌面发生 Client.exe+0xa2feb7 空指针读取。
- 运行时反汇编定位到 SDO/sdologinentry.dll 加载，涉及 igwInitialize、igwGetModule、igwTerminal。
- 当时隔离目录漏了整个 SDO；补齐后推进到当前 SDLoginClient 初始化失败弹窗。
- 本体运行时内存镜像：C:/Users/24032/Desktop/code/kungfu-mock-server/research/2026-09-06/spc32/work/game-runtime.bin。
- 镜像按 Client.exe 模块偏移排列，该次基址 0x10000；这不是已重建成可直接运行的 PE。
- 本轮诊断脚本位于 ni-2/work/diagnose.py 和 ni-2/work/observe.js；正常桌面旧崩溃追踪位于 ni-2/work/observe-desktop.jsonl。脚本依赖本机分析目录，非独立通用工具包。

### 下一步／接手提示

请保留已经验证的 SPC32 启动兼容实现，优先分析“初始化 SDLoginClient 组件失败”：检查隔离目录的 SDLogin.dll、SDO 配置、SDK 日志，以及初始化调用返回值。不要再重复尝试 SPC32 布尔返回值占位方案，也不要将现阶段错误当作缺失 SPC32。

接手先读本节与交付 REPORT.md。只在 ni-2/work/client-test 隔离副本中继续实验。当前阶段不宣称游戏可以登录或游玩。


## 2026-09-06 项目目录长期归档（最新保存位置）

用户要求：后续重要报告、中间分析和代码均保存到本项目，不再以 Documents/Codex 作为唯一存放位置。

- 本轮 SPC32：research/2026-09-06/spc32/work 与 outputs。
- 前轮 SPL/SPC 分析、内存镜像、Ghidra 项目：research/2026-09-06/prior-analysis/work。
- 最初恢复脚本与配置备份：research/2026-09-06/initial-analysis/work。
- 本地工具链副本：toolchain（Python/Frida、Ghidra、JDK、x64dbg）。不修改系统 PATH。
- 当前隔离游戏：research/2026-09-06/spc32/work/client-test。
- 启动入口：tools/START_ISOLATED_GAME.bat。
- 修复交付：research/2026-09-06/spc32/outputs/spc32-repair。
- 归档清单：research/2026-09-06/MIGRATION_MANIFEST.json。

原始日志和证据文件按 SHA256 验证复制，内容保留历史路径；脚本与说明中的已知活动路径已改为项目目录。旧 Codex 文件暂留作备份，没有删除。排除了可再生的 Go 缓存、旧重复 pydeps、__pycache__ 和工具下载压缩包；已安装的分析工具及 Python 依赖已归档。旧证据中的绝对路径作为历史采集信息保留。

当前功能状态不变：SPC32 启动兼容已验证，下一卡点是“初始化 SDLoginClient 组件失败”，尚不能登录游玩。


## 2026-09-06 SDLogin 初始化修复：已到达账号密码登录界面

用户本轮明确：原服务端程序、数据库、备份均不存在。后续按仅有客户端重建兼容服务端推进，不再建议找服务端备份。

- 真实根因：隔离副本漏拷 LG_PublicKey.dat；原安装目录仍存在。
- CreateLoginClient 成功；虚表 slot 5 的初始化经 SDLogin.dll+0x2970 读取公钥，缺失返回 AL=0。补齐后返回 AL=1。整个 EAX 的高位不是布尔结果。
- 仅补齐隔离根目录 LG_PublicKey.dat 和 UserAgreement.html，没有 patch SDLogin.dll、Client.exe、Client_CT.dll，也未改已有 SPC32.dll。
- 正常桌面、无 Frida 最终已显示账号、密码和登录按钮。截图：research/2026-09-06/sdlogin/login-restored.png。
- 启动入口仍为 tools/START_ISOLATED_GAME.bat。
- 诊断脚本、前后日志、哈希和报告：research/2026-09-06/sdlogin/。报告名：2026-09-06_reverse-SDLogin-report.md。repair_dependencies.py 可重复检查及补齐两份已确认缺失的资源，遇到不同目标文件拒绝覆盖。
- SDO SDK 缺配置的旧警告未证明全部解决，但并非这次 SDLoginClient 弹窗的直接根因。
- 当前边界：仅到登录界面，本轮未输入凭据、未验证登录 TCP 发包、未实现角色或战斗。下一步采集本地登录握手并恢复协议；公钥不等于服务端私钥。


## 2026-09-06 本地登录协议联调与点击崩溃

- 明确验证边界：此前没有在游戏界面自动输入账号密码；独立 DLL 测试不能代表真实游戏登录。用户反馈输入后点击登录，游戏界面消失。
- 已停止会计时结束游戏进程的 login_probe 实验。转储另确认实际空指针崩溃：Client_CT.dll+0xce880e，0xc0000005，读取地址 0；尚未证明该次崩溃与用户所述点击完全对应，根因未修复。
- 已实现 Go SDLogin 外层帧读取/校验与显式 observe/reject 模式，默认 off。reject 返回预设错误码 7，不是账号验证或成功登录。
- go test ./cmd/kungfu-mock-server 通过；原 32 位 SDLogin.dll 与新 Go 服务端实际 TCP 联调，结果回调为 7、0，退出码 0。已安装新 kungfu-mock-server.exe，旧版已备份。
- 104 字节加密请求已采集；明文拒绝响应格式已确认；请求内容、完整认证和成功会话仍未恢复。公钥不能替代私钥。
- 全部脚本、测试、原始帧、转储、备份和说明：research/2026-09-06/work/login-protocol/，先读 REPORT.md。转储仅本地保存。
- 下一步独立处理游戏点击崩溃，并继续恢复完整登录及新角色数据流程。原服务端、数据库或备份均不存在，无需再寻找。


## 2026-09-06 点击登录空指针修复

- 用户真实点击稳定复现 Client_CT.dll+0xce880e 读空指针。函数表页观察确认前一步读取 SPC32.dll+0x2094，即工厂返回表的 +4 空项。
- 隔离 SPC32.dll 新增表 +4 回调（返回 0、普通 ret），补齐重定位；保留原初始化接口。用户两次点击均越过崩溃点并连接 127.0.0.1:8094。
- 当前 DLL 哈希 d28b9517a73aadf441f365c789715c8f8990bdf95387b85bd7b056f7476aa66d；源码重建与实测逐字节一致。仅隔离副本已更新，正式安装目录未动。
- 修复包 research/2026-09-06/work/login-protocol/spc32-login-repair/；旧 DLL 在同级 SPC32.before-login-slot.dll。旧 spc32/outputs/spc32-repair 为历史版本，不覆盖它作为新修复。
- 真实请求并非此前独立 DLL 的 SDLogin 帧。第一次“通讯失败！”时诊断服务器按错误帧格式主动断连；切换原始采集后收到 128 字节请求，客户端等待 30 秒后断开，尚未实现正确响应。
- 真实请求头 d6 b3 d2 a5 80 00 00 00 57 00 00 00，消息字段含义与载荷尚待恢复。原始包在 game-raw-packets/；完整报告 LOGIN_CLICK_FIX_REPORT.md。
- 验证带只观察 hooks，尚未另做无观察器重启登录验证。原厂接口完整语义、其他表项、登录成功和游玩仍未恢复。
- 下一步围绕真实 128 字节首包定位收发函数，恢复本地握手及新账号角色流程。保留此修复，不再重复排查已经定位的 +4 空项。


## 2026-09-06 真实游戏帧处理已接入，业务响应待验证

- 新增 -game-framing，只在 8094 按真实包头读取完整帧并匹配显式响应规则；必须与 -sdlogin-mode=off 配合。默认配置未更改，没有默认登录成功包。
- 单元测试与本机 TCP 分段请求集成测试通过；真实请求可用 decode_game_packet.py --file 解码。
- 真实发送调用位置 Client_CT.dll+0x1339d；接收循环 +0x12f80 通过虚表 +0x88 回调。断线后对象可能失效，不从 socket-object.json 推导真实回调。
- 独立 response-probe-88.json 仅是未经验证的响应假设，正在等待真实游戏点击结果。不能将它当作登录成功或通讯修复。
- 代码、程序备份与报告 research/2026-09-06/work/login-protocol/NATIVE_PROTOCOL_PROGRESS.md。下一步验证真实接收路径与业务字段，不再使用 SDLogin 独立 harness 作为 Client 登录完成证据。


## 2026-09-06 type88 响应验证失败，已定位真实接收函数

- 用户仍提示“通讯失败”；wire-recv 已确认真实客户端完整收到 16 字节实验响应。不能说本轮已修复登录，也不能将未推进登录直接等同某个特定字段错误。
- 已撤下 type88 猜测响应，当前服务恢复 -game-framing + configs/responses.json 的无回包观察模式。
- 真实接收链：Socket 表 +0x88 → Client_CT+0x30f0 → 表 +0xa4 / +0x3280 → owner 表 +0xc / +0x3a50。owner 构造 +0x36c0，表 +0x4b964，socket 嵌在 owner+4。
- 已能独立创建接收对象并调用原回调；各试验返回 0、无对象字节变化，解析是否有效尚未证明，不能当成登录成功或拒绝码。
- 全路径追踪成本过高且脱离缓慢，助手已停止，游戏仍响应。证据与后续限制见 research/2026-09-06/work/login-protocol/RESPONSE_VALIDATION_FAILED.md。


## 2026-09-06 接收回调输入读取已验证

- 隔离独立回调确实读取输入首 DWORD：Client_CT+0xa2d87c。页边界 4、8、12 的测试未观察到后续字段访问，均返回 0；不代表已经恢复校验或验证正确登录响应。
- 脚本修正 NativeFunction 页异常处理后完成四个带偏移元数据的测试，游戏仍响应。合成对象状态与真实登录状态未等价验证。
- 继续从首字段后的判断及初始化条件分析；不再扩大未经验证的正文回包猜测。详见 research/2026-09-06/work/login-protocol/INPUT_ACCESS_VALIDATION.md。


## 2026-09-06 通讯回包方向修复，真实客户端显示服务端正文

- 确认入站登录文本响应标识为 0xff012cab，8 字节头后接正文；不能复用请求 0xa5d2b3d6 的 12 字节头。此前所谓 type88 实际变为正文字符 X，用户真实点击确认显示 X，越过原通讯失败路径。
- 固化 game_response_body_hex 编码器、单元测试、configs/native-login.json 及 tools/START_NATIVE_LOGIN_SERVER.bat。新程序已安装，当前运行本地端口 8094。
- 最终正文为“本地服务已连接，账号登录功能正在重建。”，原回调及实际 TCP 分段集成通过；最终中文 UI 待用户确认。
- 登录成功、UID 和角色流程尚未实现。通信响应修复不是游戏可玩。保留 SPC 点击崩溃修复与全部历史证据。详见 research/2026-09-06/work/login-protocol/COMMUNICATION_FIX.md。

- 最终 UI 验证补充：用户再次真实点击，确认显示完整中文提示。本轮通讯回包修复已通过真实客户端最终验证；尚不具备成功登录能力。


## 2026-09-06 新账号与角色存储组件

- backend/local_accounts.py 已实现 SQLite 新账号注册、密码派生验证、固定 UID、角色创建及查询；data/accounts.sqlite3 已初始化为空库。生命周期及重启持久化测试通过。尚未接入 Go 服务/游戏协议，不代表游戏可登录或创建角色。
- 硬件读取观察确认分隔符经 Client_CT+0x14dd3 读取，关联函数 +0x14d90；成功状态/UID 规则尚未恢复。进一步直接 Interceptor 加载失败且同期客户端退出，已停用该方式并重新启动隔离游戏。
- 详见 backend/README.md 与 research/2026-09-06/work/login-protocol/ACCOUNT_STORE_PROGRESS.md。


## 2026-09-06 登录推进至 10035（20:36 阶段交接）

- 真实文本响应 `登录成功|1001`（GBK，结尾 NUL，8 字节头）使客户端进入 8000。完整帧 `ab2c01ff16000000b5c7c2bcb3c9b9a67c3130303100`。常见英文/数字状态候选未通过；有效文本实验没有改写客户端返回值。
- 8000 确认为 SDLogin：opcode 1002、tag 1、两个长度前缀字符串及 8+8+32 字节合成会话字段被原 DLL 接受，回调 `0,0`，随后请求 opcode 1011。SDK 登录请求解密与账号验证仍未接通。
- opcode 1012 列表回复需要游戏专用 44 字节信息。当前 ID 0、127.0.0.1:10035、人数 0；附加块开头 uint16 LE 容量 1000、偏移 24 的 GBK 名称。实际 Client.exe 列表回调和自动选择代码已定位。
- lab-wire-v3.jsonl 记录 10035 首批数据及周期发包。游戏收发变换、消息边界、登录回复、角色列表和持久化业务仍待恢复。SDK 外层帧规则不能未经验证直接套到游戏包。
- 用户表示曾点击确认；撤回“提示消失必然由修复引起”的归因。仅凭 UI 变化不能认定成功，角色阶段没有完成证据。
- 当前服务是 research/2026-09-06/work/login-to-world/lab_server_v3.py，监听本机 8094/8000/10035/5136；20:36 PID 30564，游戏 PID 14936，观察器 PID 45012。原 Go 服务已在实验开始时停下；configs/native-login.json 和原启动 BAT 仍返回此前中文提示，不具有本轮成功流程。
- 当前原生实验 UID 为 100100（覆盖早期 DIAG_B 遗留的短复制残留），SDK 合成结构仍为 labuser01/1001，两阶段 ID 尚未统一。下一次应干净重启并统一账号和会话。
- 早期 Client_CT+0x14d90 的 split 命名不成立；+0x14dd3 是共享 VM 读取处理器。Client_CT 内部 Interceptor 曾导致退出；临时返回值/清输出/SPC 返回值实验未证明登录推进，未固化为客户端补丁。
- v2 实验服务曾错误重复发送登录成功响应，已停止并换为按消息类型分派的 v3。所有失败证据保留。SQLite 账号/角色组件仍未接入；不能把固定成功回包当完整认证服务。
- 详细过程、证据索引、复核/回退步骤和下次入口：research/2026-09-06/work/login-to-world/LOGIN_TO_WORLD_PROGRESS.md。文档保存时未停止游戏/服务，也未继续操作界面。


## 2026-09-06 IDA Pro MCP 已接入（21:35）

- 当前 IDA 目录为 `C:\baidunetdiskdownload\IDA94\IDA94\IDA94`；IDA 已能正常启动，`ida-pro-mcp` 插件随 IDA 内置 Python 环境加载。
- MCP 仅监听本机 `127.0.0.1:13337`。配置页为 `http://127.0.0.1:13337/config.html`，Codex 连接地址为 `http://127.0.0.1:13337/mcp`。
- 已实测配置页返回 HTTP 200；MCP `initialize` 成功，协议版本为 `2025-06-18`，服务端名称为 `ida-pro-mcp`、版本 `1.0.0`；`tools/list` 返回 66 个工具。以上只证明分析通道可用，不代表游戏协议或服务端逻辑已经恢复。
- Codex 全局配置已由 `[mcp_servers.ida-pro-mcp]` 更名为 `[mcp_servers.idapro]`，保留原 URL。这样工具前缀统一为 `idapro_*`，符合当前 IDA 逆向工作流约定。
- 使用前先在 IDA 打开待分析的 `Client.exe` 数据库，再通过 `Edit -> Plugins -> MCP`（快捷键 `Ctrl+Alt+M`）启动服务；配置入口为 `Edit -> Plugins -> MCP Configuration`。IDA 必须保持运行。
- 修改全局 MCP 配置后，当前已经打开的 Codex 任务通常不会动态刷新工具列表；完全退出并重新启动 Codex，或新建任务后再检查 `idapro_*` 工具。
- 下一步用 MCP 从 `Client.exe+0x62e130` 附近的发送包装函数开始，恢复 10035 游戏帧的边界/变换、接收分派和角色列表/创建/选择流程。MCP 用于加速静态分析，现阶段仍不能据此宣称游戏可玩。
