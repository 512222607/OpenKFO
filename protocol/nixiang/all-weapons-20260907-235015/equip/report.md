# 本地武器穿戴协议静态核验

日期：2026-09-07（Asia/Shanghai）。flavor = null。范围见 [scope.md](../scope.md)，工具和导入等价证据见 [tool-index.md](../tool-index.md)、[E-imports.md](../evidence/E-imports.md)。

已经确认客户端穿戴请求和成功响应布局，可以据此实现本地物品切换。2080 请求 16 字节，2090 成功至少 84 字节；2300 请求 4 字节，2310 成功至少 72 字节。普通装备按钮直接发送 2080，服务端需更新被替换物品的状态。本文是静态代码证据，尚无本轮实机穿戴结果；失败码、额外前缀语义没有猜测。

## 协议布局

所有多字节整数均为 little-endian；偏移从网络消息的 payload 起算，不含现有外层封包。

| 类型 | 长度 | 布局与消费证据 |
|---|---:|---|
| 2080 A_EQUIP_ITEM | 16 | +0 uint32 instance ID；+4 uint32 装备槽；+8..15 在已观察的两个 UI 调用中没有初始化，服务端不可要求固定值 |
| 2090 A_RE_EQUIP_ITEM_SUCC | 至少84 | +0..15 前缀在已定位成功回调中不读取；+16 一条完整68字节物品，slot=8 |
| 2100 A_RE_EQUIP_ITEM_FAIL | 未核验 | 常量名和值已确认，payload不明确 |
| 2300 A_UNEQUIP_ITEM | 4 | +0 uint32 instance ID |
| 2310 A_RE_UNEQUIP_ITEM_SUCC | 至少72 | +0 uint32 被卸下instance；+4 完整68字节物品更新，通常是相同instance、slot=0 |
| 2320 A_RE_UNEQUIP_ITEM_FAIL | 未核验 | 常量名和值已确认，payload不明确 |

type25 的默认装备槽8由 raw650CE0 的两级查表核验：byte表raw650DA4[25-12]=8，dword表raw650D6C[8]指向VA660D34，即raw650D34，指令 mov eax,8。

建议本地武器切换：持久化时将原slot8物品置0，新物品置8；有旧武器时先发送2310旧物品更新，再发送2090新物品更新。2090前缀可规范化为 instance,slot,0,0；这属于本地服务实现选择，不能声称恢复了原服务器前缀的全部语义。客户端9C0E10只覆盖选中instance，并不将旧instance自动置0。

## Evidence

以下为同一个已打开的 game-runtime.bin.i64，x86 base0，SHA256 707450b209937b2d3e94a68ffe8f9841821ff048fd1cc0d8017d1fdddf493c3b。绝对表指针从VA减0x10000；已经解析的相对CALL目标不再减。

### E-equip-constants

- observed_at: 2026-09-07
- source_type: memory
- source_ref: IDA raw7922BD..7924F9
- content_hash: n/a（直接IDB观察，基准样本哈希如上）
- artifact_path: n/a
- repro_command: 在现有IDB的IDAPython执行下列片段
- linked_workitem: n/a
- supersedes: none

```python
import ida_bytes, struct
pairs = [
    ('A_EQUIP_ITEM', 0xBE98C0), ('A_RE_EQUIP_ITEM_SUCC', 0xBE98B8),
    ('A_RE_EQUIP_ITEM_FAIL', 0xBE98B0), ('A_UNEQUIP_ITEM', 0xBE9820),
    ('A_RE_UNEQUIP_ITEM_SUCC', 0xBE9818), ('A_RE_UNEQUIP_ITEM_FAIL', 0xBE9810)]
for name, va in pairs:
    print(name, struct.unpack('<d', ida_bytes.get_bytes(va - 0x10000, 8))[0])
```

- raw_excerpt: 按上述顺序返回2080、2090、2100、2300、2310、2320。注册字符串是rawBD0598、BD05A8、BD05C0、BD0738、BD0748、BD0760，实际代码引用加0x10000后的VA。

### E-equip-request

- observed_at: 2026-09-07
- source_type: file
- source_ref: [899700](0x899700.json)、[8560C0](0x8560c0.json)、[89FB80](0x89fb80.json)、[8962B0](0x8962b0.json)
- content_hash: 见本目录hashes.json
- artifact_path: 对应上述json
- repro_command: idapro_decompile(addr="0x899700")，其余文件名同理；需现有IDB
- linked_workitem: n/a
- supersedes: none
- raw_excerpt: raw899876令payload DWORD0=UI item+8的instance；raw899882令DWORD1=当前槽；raw8999B3 send(2080,0,payload,16)。raw8963B6 send(2300,0,&instance,4)。

raw89FB80普通装备路径直接到899700，没有先调用2300发送函数。899700在武器的特殊状态标志17C86CC非零时调用8939C0，这个函数发送21423/4值0，并非2300。899700检查角色+122的骨架/性别键与物品配置+32（A0E240匹配）；不兼容会弹窗并不发送2080。没有修改客户端限制。

### E-equip-success

- observed_at: 2026-09-07
- source_type: file
- source_ref: [819E70](0x819e70.json)、[8A3DC0](0x8a3dc0.json)、[9C0E10](0x9c0e10.json)
- content_hash: 见本目录hashes.json
- artifact_path: 对应上述json
- repro_command: idapro_decompile(addr="0x819e70")，其余文件名同理；需现有IDB
- linked_workitem: n/a
- supersedes: none
- raw_excerpt: 2090表项raw12EDC08，函数指针VA829E70→raw819E70，回调只把payload+16送入singleton的vtable+448；构造8A47B0写VA BBCB74，corrected表rawBACB74+448→VA8B3DC0→raw8A3DC0。后者调用9C0E10，按instance匹配库存并qmemcpy68，再调用9E4220刷新角色及9BDB60重建设备结构。回调首16字节未读取。

另一个2090表项raw12EDE48→VA826310→raw816310同样传payload+16到virtual+12；其基础类实现816300为空。不能把一个空基类误认为全局2090无效果。

### E-unequip-success

- observed_at: 2026-09-07
- source_type: file
- source_ref: [819E20](0x819e20.json)、[8A3D60](0x8a3d60.json)、[9C0A90](0x9c0a90.json)
- content_hash: 见本目录hashes.json
- artifact_path: 对应上述json
- repro_command: idapro_decompile(addr="0x819e20")，其余文件名同理；需现有IDB
- linked_workitem: n/a
- supersedes: none
- raw_excerpt: 2310表项raw12EDC20→VA829E20→raw819E20；传payload与payload+4进入singleton vtable+452→raw8A3D60；读取*payload作为旧instance，把payload+4交给9C0A90。后者按新记录instance复制68字节；若oldinstance不同还会删除旧记录，兼容合并堆叠语义。

## Findings

| Finding | severity | status | confidence | evidence_ids | location | 结论 |
|---|---|---|---|---|---|---|
| F-equip-layout | n/a_re | validated（静态） | high | E-equip-constants,E-equip-request,E-equip-success | 899700,819E70,9C0E10 | 2080/16与2090/84布局可实现；2090首16仅知当前回调不读 |
| F-unequip-layout | n/a_re | validated（静态） | high | E-equip-constants,E-equip-request,E-unequip-success | 8962B0,819E20,9C0A90 | 2300/4与2310/72布局可实现 |
| F-equip-replace | n/a_re | candidate（动态未验证） | medium | E-equip-request,E-equip-success,E-unequip-success | 89FB80→899700→9C0E10 | 新装备请求不先卸旧，服务端主动先旧2310再新2090可避免旧记录slot8残留 |

repro_steps：先核验常量注册，再核验请求长度及字段，最后按回调指针追到实际虚函数和库存复制。remediation：纯逆向无漏洞修复；本地服务按所有者/instance/允许槽校验后发送上述成功消息。impact：恢复本地物品切换并保持客户端库存和模型同步。optional_attack：空。

## Path 与时间线

P-equip，path_type=callflow：

1. 用户库存装备按钮89FB80→899700，校验兼容后2080/16 — E-equip-request / F-equip-layout。
2. 本地服务把旧物品slot改0、新物品slot改8并持久化 — 实现建议，待主线程验证。
3. 旧物品2310/72→819E20→8A3D60→9C0A90 — E-unequip-success / F-unequip-layout。
4. 新物品2090/84→819E70→8A3DC0→9C0E10→模型/UI刷新 — E-equip-success / F-equip-layout。

2026-09-07：复用现有IDB与E-imports；依次确认常量、穿戴请求/成功、卸装请求/成功；输出本文及原始反编译。residual_risks：尚未观察真实客户端切换；前缀和失败payload全部语义仍未恢复。本子任务只读静态分析，不运行/patch客户端，不改现役源码或DB。报告由主线程归档到原项目research。
