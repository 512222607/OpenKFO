# 协议对照与本次补齐（2026-09-22）

## 本轮修复状态（代码与候选构建，未部署）

以下状态覆盖本文早期核对快照中的“待修复/未实现”。本轮没有修改数据库、线上配置或替换运行中的服务。

| 项目 | 已落地处理 | 验证与边界 |
|---|---|---|
| 开战网络探测 | 4150/4140只等待参战者；超时记录未回包玩家、账号、房间和耗时 | 保留10秒超时及加载屏障；不宣称解决了现场所有迟到回包 |
| 8150 BUFF | 不再把未确认的+67字段强解为浮点；清除仅检查已知字段；操作限定0/1；相同序号不能换内容重放 | 保留266等既有BUFF编号和跨已知角色兼容；无效游戏包仍走审计丢弃、保留连接 |
| 8126效果重复 | 同一发送者/实体/事件的相同序号不能换内容重复生效 | 未交换+47/+55字段；未照搬参考的命中关联队列，消费者证据存在差异 |
| UDP旁路观察 | 增加宠物/法宝、PVE对象、方块、位置、结束、Foster移动/伤害和团队回合观察 | 只在转发至少成功入队给一个接收者后观察；入队不等于客户端已收到。不再追加一份相同TCP广播；碎片/超限数据保持不观察 |
| PVE伤害去重 | 同一发送者/目标的伤害序号在TCP与UDP观察间共享去重；场次与对象重建时清理 | 避免重复更新服务端HP投影，不宣称已替代客户端全部伤害计算 |
| 宠物/法宝消耗 | 记录UDP已入队对象；4201成功扣费后的事件不再重复发给这些对象 | 原库存事务和幂等扣费保留；本轮未做真实数据库扣费验收 |
| 团队多回合 | 增加8294–8297状态、TCP/UDP观察、4111校验及4112结果；服务端重写身份/名字、奖励为零 | 实验开关默认关闭，最多6人、每队最多3人；成员中途离开中止系列；普通团战继续沿用原退出规则。原生结果界面/观战仍待实机验证 |
| 等待房退出/装备刷新 | 保留其余成员准备状态；装备使用3105刷新，不再伪装3090新进房 | 一并包含在候选构建中；新成员真正加入仍按原流程处理 |

配置 `team_series_rounds` 位于游戏 Config，允许 `0/1/3/5/7`，`0`表示关闭，其他值为总局数。没有自动开启，也不改变普通团队生存默认行为；无需数据库迁移。

主要代码：`internal/game/battle.go`、`network_delay.go`、`team_series.go`、`udp_observation.go`、`session.go`、`talisman.go`、`pve_actors.go`、`pve_blocks.go`、`pve_finish_event.go`、`rooms.go`。

验证：Go `test ./...`通过，候选服务器构建成功；针对性测试覆盖BUFF不透明字段/重复序号、观战探测、UDP/PVE去重、队列失败、多回合顺序及畸形结算。需要数据库环境的可选测试不能视作本轮数据库集成验证；尚无客户端实机验收。

候选文件：`E:\功夫小子\server\dist\local-server\kungfu-server-battle-review.exe`。
测试日志：`E:\功夫小子\server\runtime-local\battle-fix-tests.log`。

仍待证据：双武器不能防御的根因；8126完整命中关联；BUFF活动效果账本；8142/8276/8282/8288/8290未知对象生命周期。参考中仅有解码器的编号没有伪造成功回包。未部署、未重启、未提交推送。

## 早期核对快照：对照来源与结论

前面的观战、目录筛选、计分结算和战斗事件修改确实参考了此仓库，不是只看协议编号。

- 参考仓库：https://github.com/liuyangyi0/kungfukid-local-server
- 固定提交：`e2c61c4c64000d2a2ac8746233e13fa59d354d3f`。本次核对时远端 main 与独立克隆一致。
- 独立克隆：`E:\功夫小子\protocol-reference-kungfukid-20260922`，主要读取 `server/kk_local`。
- 本项目：`E:\功夫小子\server\server\go-server`。
- 前一轮记录：`docs/protocol-comparison-20260922.md`；其前半部分是修改前快照，文末记有上一轮实现和部署。
- 当前补充了邀请、等待超时、死亡提示、拾取互斥、独立任务查询、过期物品查询，以及默认关闭的 Mode16 专用积分链。
- **没有声称全部协议均已实机对齐。** 团队多回合已补实验实现、默认关闭（见文首）；未知对象事件仍不能靠猜字段开放。

参考项目也是模拟服务器，部分规则明确标注 local policy / provisional。它的源码和单元测试是对照证据，不等于原版服务器行为证明。当前 gfld 的反汇编证据优先于另一实现的字段命名。

## 状态定义

- **本次补齐**：本轮有代码、针对性测试；尚未运行玩家客户端验证。
- **前轮已接通**：上一轮已有代码、协议测试，部分另有独立数据库验证；本轮保留。
- **已有入口**：入口与相关参考模块已核查，复用当前实现；不意味着本轮逐字段重写或对所有客户端实测。
- **保留差异**：有现有客户端证据或用户要求，不照搬参考的限制/策略。
- **未接通/未开放**：明确剩余工作，不能把解码器、枚举或日志识别当成功能完成。

## 登录、大厅、账号与物品

以下参考路径相对 `server/kk_local`；Go 路径相对 `server/go-server/internal`。

| 功能 / 协议 | 参考实现 | Go 实现 | 当前结论 |
|---|---|---|---|
| 登录、选区、交接：1010 / 2010 / 3320→3330、1201 | handlers/session.py | game/session.go、relogin.go | 已有入口；保留本项目多窗口和旧凭据恢复逻辑，不退回参考的单 adapter 限制 |
| 返回选区 2060→2070；目录1157 | handlers/session.py | game/session.go、lobby_catalog.go | 已有入口；仅当前连接的合法阶段可以切换 |
| SDK/原生 relay：1001 / 1003 / 1006 / 1008 / 1012 / 1013 | native_relay.py、sdp_peer.py、service.py | bridge、tunnel 与 game/session.go | 架构不同：本项目使用已认证桥接通道；不能把原生 relay 编号直接挂到游戏路由。不是战斗功能缺包 |
| 角色创建 1150 / 1156 | engine.py | game/character.go、session.go | 已有入口；使用服务端创建目录与已发放选项校验 |
| 玩家列表2250→2270、预览2420/2430 | handlers/directory.py | game/player_directory.go、player_details.go | 已有入口；分页、在线状态、角色与武器资料分开 |
| 公聊/私聊5002/5000 | handlers/social.py、chat.py | game/session.go | 已有入口；接收者由服务端身份/名字解析，不使用客户端声明的发送者 |
| 好友8020内层203/207/213/225 | 参考 social.py 主要实现聊天，无同等好友链 | game/friends.go | 本项目已有更完整实现，不能按参考覆盖删除 |
| 装备2080→2090、卸装2300→2310、1120刷新 | handlers/equipment.py | game/session.go、inventory_refresh.go；persistence/inventory_equipment.go | 已有入口；保留此前穿戴、卸装、原生装备页刷新修复 |
| 过期查询2110→2120 | handlers/equipment.py | game/expired_items.go、protocol/inventory_queries.go | **本次补齐**。读取服务端已处理的过期状态；返回count32+instance32列表。永久物品和365+不当作过期，丢弃状态不混入 |
| 丢弃2130→2162 | 无同等完整处理入口 | game/session.go、persistence/inventory_discard.go | 本项目已有；所有权、装备状态、必需装备规则保留 |
| 道具消耗4200 / 内层8289 | handlers/consumption.py | game/consumption.go、persistence/consumption.go | 已有入口；校验背包与消耗事务，不因参考允许转发就跳过库存 |
| 武器切换4082/4083 | handlers/single_room.py、features/inventory.py | game/weapon_switch.go | 已有入口；保留背包、切换卡、原生动作完成与观战禁用逻辑 |
| 宠物/法宝4201 / 内层8291、8292 | talisman.py、sdp_peer.py | game/talisman.go、udp_observation.go | 修正此前误标为武器切换；增加UDP投递观察和成功扣费后的转发去重 |
| 修理4202 / 4204；升级21410 / 21412 | handlers/lobby.py、talisman_repair.py、weapon_upgrade.py | game/talisman.go、weapon_levels.go、session.go | 已有入口；持久化与幂等收据复用当前实现 |
| 商店列表9070 / 1500 / 1540、购买9040 | handlers/lobby.py、shop.py | game/session.go、persistence/shop_purchase.go | 已有入口；服务端目录/价格/余额校验，不信任客户端金额 |
| 替代购买9041、替代赠送9091 | handlers/lobby.py | game/session.go | 参考本身拒绝。9041已有拒绝；**本次给9091补9110/error56**，避免默默忽略被误以为成功 |
| 赠送9090、邮件1300/1320/1340/2171 | shop.py、mailbox.py | game/mail.go、session.go | 已有入口；数据库幂等发信/领取，不能重复领 |
| 续费1400/1420/1440 | renewal.py | game/renewal.go | 已有入口；原生报价、服务端有效期与续费收据独立 |
| 普通任务6000、6050/6080；每日/新手操作6051/6052/6081/6082、6311/6312 | quests.py、ordinary_quests.py、quest_rewards.py | game/tasks.go、extended_tasks.go | 已有入口；奖励使用服务器规则和进度，不以客户端查询直接发奖 |
| 每日/新手独立查询6001/6002→6041/6042 | quests.py | game/session.go、extended_tasks.go | **本次补齐**。只刷新请求的列表，不误标另一列表的完成通知；6000仍保持原总刷新行为 |
| 训练21000/21002/21006 | handlers/training.py | game/training.go、session.go | 已有入口；训练奖励和领取记录保持现有实现 |
| 排名2540/2560；荣誉20360 | rankings.py、handlers/lobby.py | game/honour.go、session.go | 已有入口；本项目服务端配置与持久化比参考的部分空响应更完整 |
| 财富相关20561/20563/20565 | handlers/lobby.py | game/session.go | 保持未开放响应；不能因存在编号就宣称玩法可用 |
| 1401/1402/6003/6225等 | engine.py record_unknown、menu_layouts.py | 无相同完整业务 | **参考也主要是观测/解码，不是可照搬的完整处理链**；列为待证据，不制造成功回包 |

## 房间与观战

| 功能 / 协议 | 参考实现 | Go 实现 | 当前结论 |
|---|---|---|---|
| 2260→2280房间目录；3075自动加入 | room_requests.py | game/rooms.go、room_packets.go | **前轮已接通**等待/全部筛选、136全模式；0保留为个人生存 |
| 3010创建、3070加入、3080错误、3100/3090/3105成员同步 | room_requests.py、packets.py | game/rooms.go、room_packets.go | 已有入口；容量、密码、地图准入在服务端核验 |
| 3070 mode1观战、3091/3092身份切换 | room_requests.py | game/spectators.go、rooms.go | **前轮已接通**。限Mode1等待房间，独立观战槽位和容量；不支持战斗途中加入 |
| 3200/3220设置；3230/3250换队；3260/3262/3263换位置 | room_requests.py、seat_exchange.py | game/rooms.go、team_positions.go、seat_exchange.go | 已有入口；交换绑定当前房间和连接，不是单向改客户端显示 |
| 3140踢人、4051/4052转房主 | room_requests.py | game/room_kick.go、room_owner.go | 已有入口；错误提示/通知对象有本地策略差异，不以参考覆盖当前客户端兼容路径 |
| 邀请3500、接受3501、拒绝3502 | room_requests.py handle_invitation | game/room_invitation.go | **本次补齐**。60秒有效期，同一大厅，真实名字，双端连接+房间对象+场次绑定；满员、重连、房间复用、过期均不加入 |
| 邀请接受时密码 | room_requests.py | game/room_invitation.go | 参考的一次性明确授权：仅接受当前有效邀请可跳过此房间密码；普通3070仍查密码；地图条件和网络就绪仍检查 |
| 等待超时4031→4032 | room_requests.py | game/rooms.go leaveWithNotice | **本次补齐**。只退出当前请求者；过期的等待计时包不能中止已经开始的战斗；自己和其他成员收到对应离开通知 |
| 准备4030/4060、探测4140/4150/4160相关阶段 | room_flow.py、room_requests.py | game/network_delay.go、rooms.go | 已有入口；保留实际加载阶段分工，观战者不计准备票 |
| 加载4080/4160/4170、初始化4180/8040、开战8070 | room_flow.py | game/spectators.go、rooms.go | **前轮已接通**全部视角加载、仅参战者初始化；避免等不到观战者的8040 |
| 4115、3550结果确认/返回 | room_flow.py、battle_results.py | game/spectators.go、settlement.go | **前轮已接通**视角确认屏障；兼容既有返回入口 |
| 3110/3130离开、房主转交 | room_lifecycle.py | game/rooms.go、settlement.go | **保留差异**：观战者离开不结束战斗；普通团队中参战者退出也不把其他所有人踢走，这是用户已要求的修复 |
| 20571与延迟探测 | rooms.py、lab_network.py | game/rooms.go、network_delay.go、peer_probe_log.go | 已有入口与日志；不能把建连耗时当头顶玩家间往返 |

## 战斗、PVE与结算

8071是外层消息，下列812x/82xx/84xx等主要为其内层事件，不能直接注册成独立游戏TCP消息。

| 协议/功能 | 参考实现 | Go 实现 | 当前结论 |
|---|---|---|---|
| 8120移动、8121受伤/治疗、8122状态 | layouts.py、battle_relay.py、pve.py | game/battle.go、pve_actors.go、foster_health.go | 已有入口；保留PVE控制权与NPC按事件/实体去重，不照搬全发送者单序号 |
| 8127 MP、8090时钟/被动气量驱动 | layouts.py、engine.py | game/battle.go、battle_clock.go | 已有入口。MP进度与整格气不能混为一谈；1秒tick及起始值属于本地策略，需实际客户端复测 |
| 8125、8143目标选择、8144成对变换 | layouts.py、battle_pairs.py | game/battle.go、battle_extended.go | **前轮已接通**。8144依赖已确认的8143选择及15秒有效期；UDP实际转发到目标后也能建立记录 |
| 8270、8280、8284、8293 | layouts.py、battle_relay.py | game/battle.go、battle_extended.go | **前轮已接通**已知布局、角色权属、有限浮点、房间场次及重放校验 |
| 8278死亡倒计时UI | battle_receipts.py | game/battle_death.go | **本次补齐**。房主只能发给另一个当前参战者，定向给目标；不是服务端复活/加分指令 |
| 8286死亡终态 | battle_receipts.py | game/battle_death.go | **本次收紧**。原通用转发未校验+47目标；现在只允许本人或房主发给当前参战者，禁止外部/观战目标，重复序号不转发 |
| 8287掉落生成；8400–8404投射物 | layouts.py、battle_relay.py | game/battle_extended.go | **前轮已接通**。拥有者、命中见证、对象登记/删除墓碑；不自动发放永久物品 |
| 9000–9002拾取；9500–9502箱子 | battle_receipts.py | game/reliable_event.go | **本次修复差异**：申请只给房主，不覆盖待处理申请，同一物体不能同时批准给多个角色；房主自己的快速路径也不能抢已有预约；完成/取消释放预约 |
| 8126技能效果回执 | battle_receipts.py、layouts.py | game/battle.go | **保留有证据的差异**：当前gfld +47来源/+55目标；参考标签相反。依据本项目0082B8D0反汇编，不盲目交换 |
| 8150 BUFF | battle_relay.py | game/battle.go、security_rejection.go | **保留用户要求**的已认证跨角色兼容转发和审计，不能恢复“验证失败就掉线”；未知对象不等于自动授权 |
| 8155整表积分 | battle_relay.py | game/battle.go | 已有房主与8槽身份验证。参考仅Mode16；保留当前其他模式兼容范围，Mode16要求已知头标记 |
| 8157 Mode16专用事件 | battle_relay.py | game/reborn.go | **本次补齐，默认未开放**。限房主、当前参战者、已知code/value组合，重复事件不重复转发 |
| 4110/4120 Mode0/1生存、Mode2/3击杀计分 | lab_settlement.py、battle_results.py | game/battle_outcomes.go、settlement.go | **前轮已接通**。全体报告一致才确认胜负；4120只给接收者自己的行带档案，观战者不发奖 |
| 4110/4120 Mode16积分、计数、名次 | lab_settlement.py | protocol/battle_report.go、game/reborn.go、battle_outcomes.go、settlement.go | **本次补齐，默认未开放**。读取+37有符号积分、+45/+47计数；一致性判定；结果+67/+71/+73/+75/+79/+83按参考布局填写；至多6人 |
| 8294–8297回合事件、4111/4112团队系列结果 | team_series.py、battle_results.py、room_flow.py | game/team_series.go、udp_observation.go | 已补实验实现，默认关闭；状态/报告/无奖励结果见文首，尚未实机验收 |
| 20400/20401/20403/20404/20405/20407、8394等PVE事件 | pve.py、layouts.py | game/pve_actors.go、pve_blocks.go、foster_*、stage_* | 已有分模式处理与配置准入；脚本PVE和波次PVE不能混用完成/奖励路径；需要当前地图配置与实际客户端复测 |
| 8440/8441/8450/8451等已有兼容事件 | layouts.py及相关消费者证据 | game/battle.go | 保留当前处理，不因参考入口不一致删除；并非新增一套战斗模拟器 |
| 8142/8276/8282/8288/8290等对象事件 | layouts.py（多为字段解码） | 没有完整对象生命周期处理 | **未开放**。参考解码器不等于已经可转发；不能整体广播未知对象/操作号 |

## 还需要什么

1. **团队多回合**：需要独立实现参考的回合状态、8294–8297的TCP/UDP观察与顺序、4111报告校验和4112无奖励结果、回房屏障与离线处理。现已实现代码和协议测试，默认关闭；客户端实机验收仍未完成（见文首）。
2. **Mode16实际开放**：代码已补但配置默认false。需明确当前客户端的Mode16地图与入口，配置 `reborn_enabled: true` 和对应 `pools`（容量2/4/6），再做原生界面测试；没有凭空给现有地图改模式，没有调整玩家奖励。
3. **未知对象事件**：先补当前客户端消费者与实际包证据，再确定角色/对象拥有者、去重和生命周期。参考也只有decoder的编号不算可直接移植的功能。
4. **实机回归**：邀请接受/拒绝/超时、退出再邀请、观战完整一局、拾取争抢、死亡倒计时、NPC血量、怒气和BUFF仍需游戏测试。自动化测试不是视觉及原版服务器行为证明。

## 数据库、配置、构建与验证

- 不需要数据库迁移。邀请、拾取预约、死亡提示、复活模式战报均为当前房间的内存状态；过期查询复用已有库存和过期表，任务查询复用已有持久化任务结构。
- 新增配置 `reborn_enabled`，默认为false。本次没有修改线上配置，也没有替换本地正在运行服务的配置。
- `go test ./...` 通过。数据库用例默认会跳过，因此另在本机独立 `kungfu_game_test` 显式执行双人事务、普通结算、观战结算三个集成测试，全部通过。
- 新增测试：`room_invitation_test.go`、`battle_death_test.go`、`reborn_test.go`、`catalog_queries_test.go`；扩充 `reliable_event_test.go`。覆盖重连、房间ID复用、过期邀请、满员、假身份、非房主发死亡提示、观战目标、同一物品预约互斥、任务列表互不干扰、永久物品不误过期、Mode16负积分和不同步计数等。
- 测试日志：`runtime-local/protocol-review-20260922/protocol-audit-all-tests.txt`、`protocol-audit-db-tests.txt`。
- 已构建本地候选：`E:\功夫小子\server\dist\local-server\kungfu-server-protocol-audit.exe`。
- SHA256：`44340E771BA4F5598D28B29BB4E35335AFF7F67A282B075AA494ED35BF17C0D6`。
- **本次只生成候选文件，没有替换或重启正在运行的本地服务，没有更新线上，没有提交推送Git。** 当前运行服务仍是前一轮本地部署版本；不能用它来验证本轮新增协议。

## 可复查的编号索引

`docs/protocol-reference-index-20260922.csv` 收录参考源码条件表达式中的 **204个编号**，含请求、输出解析、嵌套事件、观测日志和编解码分支；该数量不是“204个功能全部完成”。CSV给出参考文件行号和Go中直接出现编号的候选行；符号常量、范围分派与派生ID仍需人工沿调用链核对，上面的分组表才是语义结论。

重建命令（只读源码并写CSV，不连数据库/服务器）：

```powershell
C:\Python314\python.exe E:\功夫小子\server\tools\Audit-ReferenceProtocols.py --reference E:\功夫小子\protocol-reference-kungfukid-20260922\server\kk_local --go E:\功夫小子\server\server\go-server\internal --output E:\功夫小子\server\docs\protocol-reference-index-20260922.csv
```


## 后续：线下闯关列表及GM（2026-09-22）

修正 `sendStageSelection` 只查询普通对战地图池的问题。`StagePlayerView` 保留同一数据库快照的计划；列表复用实际开战计划校验，将已配置的事件/波次地图加入候选，再与玩家可进入地图相交。没有计划、计划失效或地图被关闭时不新增开放。

使用线下真实test003进行只读验证，可选列表由空变为 `[8110,9170]`。新增测试覆盖PVE两种计划、玩家限制、关闭和版本不符；Go全量测试通过。

线下 `kungfu_game` 奖励配置revision7已保存：8110、9170通关500经验/100金币，失败100经验/20金币，均无点券/道具。修改前备份为 `runtime-local/protocol-review-20260922/rewards-before-local-stage.json`。其余奖励和地图配置保留。

GM Windows默认本地，独立线上入口仍保持线上。关卡页显示计划是否存在并添加同环境奖励入口。此次线下构建关闭启动自动更新，防止被线上正式包替换。GM相关7项测试和Windows构建通过。

**替换状态：没有安装成功。** 首次替换遇到Windows映像锁；后续替换/启动组合命令被自动审批以 `blocked by policy` 拦截，无进一步原因。旧EXE未变，已恢复运行，PID33256，health为ok。因此当前服务仍是旧版，不能用于验证新版列表。线上未操作。

已准备供用户手动检查执行的 `tools/Install-LocalStageFix.ps1`，尚未执行。候选服务器 `dist/local-server/kungfu-server-stage-fix.exe` SHA256 `27C4CD9827E383D8354BA69832473CE9AC1031763AF73DE5D298C20D0BCC430B`；GM完整构建在 `%TEMP%/openkfo-gm-local-stage-20260922/build/windows/x64/runner/Release`，尚未复制到原GM目录。
