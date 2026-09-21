# 返回大厅 3110 的静态恢复结论

范围沿用 ../scope.md；输入及导入证据沿用 ../evidence/E-imports.md。已读 ida-reverse 与 precedent-reverse；tool-index.md 缺失，仅找到 template，使用当前已证实可用的只读 IDA MCP。没有切库、修改 IDB、修改服务或重启进程。

## 结论
- 当前真实请求 3110/0 的成功回复应为 **3115/0（空 payload）**。
- 这已得到消息表、发送端和两个接收状态处理器的静态证据支持，仍需 TCP/真实 UI 验证。
- 不应发送 3130/8 冒充本人退出确认：3130 处理 QWORD 玩家身份并移除对应其他玩家，3115 才直接执行本地离房状态转换。

## Evidence → Finding
1. sub_91BC30（0x91bc57）在客户端 room/controller 对象存在时调用 sub_A2CA00(3110, 0)。这是返回大厅按钮的发送路径；四字节立即数扫描在其他位置的假命中 0x88b486 属于 CALL 字节，不是另一发送点。
2. 当前 raw dump IDB base=0，消息表每项为 opcode/kind/handler_va/0/0/0，24 字节：
   - table 0x12eeb08：3115 / 1 / VA 0x81ed00 → raw 0x80ed00；
   - table 0x12ed920：3115 / 1 / VA 0x82d920 → raw 0x81d920。
   绝对表指针减 0x10000；相对 CALL 已由 IDA 解析，不能再减。
3. sub_80ED00 不检查也不读取 payload 参数或长度，无需状态 DWORD、UID 或 room handle。它清 dword_17C86D0；若 dword_17C86CC 非零则清 P2P 相关对象并发送 21428/0；随后 sub_80BFE0 清房间玩家/成员；执行 sub_980070、sub_97FDE0(6)、当前场景虚表 +12，并调用 sub_91EC60 清房间界面资源。
4. sub_81D920 同样不读取 payload/length。清相同全局状态；处于可直接退出的游戏状态时调用 sub_81CF60，后者清 dword_17BAB78、房间成员和对象，调用 sub_97FDE0(6) 并切到外部 controller。另一分支延迟到 UI callback；仍由空包触发。
5. sub_80BFE0 遍历 8 个玩家槽并清空，保留本地角色身份关联（不等价于删除账户/持久角色）；清 room manager +304/+308，并清其 +152 集合。
6. 3130 的 raw 0x8107b0 与 0x81b080 都要求 8 字节 QWORD 玩家标识，并走玩家删除/通知链，区别于本地 3115。
7. 1300 后可能看到 1310；raw 0x816c30 按 339 字节记录解释背包/物品类列表。这不是已找到的离房 ACK，不建议作为修复本问题的必需响应扩张。

## 当前 Python 服务的最小修改建议
在 RoomSession.handle 加 3110 分支：
- 要求请求 payload 为空（真实发送路径为零字节）。
- self.entered = False。
- self.request = None，清掉当前房间创建原始包，禁止退出后旧 3070 重进已离开的房间。
- 本轮如新增 started/map-loaded/training 状态，一并重置。
- room_handle 是本地分配器默认值 1，可保留供下次创建复用；它不能单独证明房间仍有效。
- 返回 [response(3115, b'')]。
- 保持 RoleSession.logged_in、pending_create 及持久 SQLite 角色数据不变；不要断开 TCP/P2P 会话。退出成功后 2250/2260 应因 entered=False 再次返回 2270/2280 大厅轮询。
- 幂等地再次 ACK 已离开会话内的空 3110，可避免重复点击无响应。
- 21428 是客户端条件发送的通知；本静态链中未发现它是离房 ACK 前置条件，不应等它才发送 3115。

## 建议验证
1. 创建→进入→3110 返回且只有 3115/0，连接保持；随后2250/2260收到大厅响应。
2. 退出后旧3070被拒；再次3010/3070可建新房。
3. 退出保持角色 payload 与数据库记录一致。
4. UI 应实际回大厅；如发送21428，继续记录即可，不把仅socket回包宣称实机成功。

本目录 JSON 为本轮 IDA 输出原文（含带地址伪代码），table-entries.json 为限定表范围的只读扫描结果。
