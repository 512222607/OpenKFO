# 大厅中原地更新库存记录：2161/68

范围、哈希及工具见[原报告](report.md)。日期2026-09-07，flavor=null。主线程报告修复+23后在大厅推送1120仍未改变可见库存；本补充定位通用物品更新消息，可更新已经存在的instance而不切换武器。所有结论仅来自静态代码，真实接收由主线程验证。

## 使用条件

- 消息2161，A_NOTIFY_UPDATE_ITEM。
- payload恰为一条完整68字节物品，从+0 instance开始，无额外前缀。
- 9BE660按instance查找角色管理器this+946库存，并memcpy68。不存在该instance时不新增。
- type25不会走模型装备更新，不会把slot0变8。
- 回调会计算新旧+23计数差；差值大于0会调用7E3FD0显示物品获得通知。批量修正274把武器可能产生相应通知。
- 在已找到的回调中没有登录/大厅状态判断，位于通用12EC消息表。是否当前大厅实际分发仍需现场消息验证。
- 更新后重新打开仓库，可使89ADE0重建分类列表。

2090不适合做slot0记录修正：9C0E10调用9E4220，后者对type25的非8/9/20/21/22槽会写slot8再调用9E00A0，因此存在强制装备副作用。

2121为过期处理，回调8166E0把列出的instance通过9BD7C0设状态2，不适合作为普通数量刷新。2160为新增消息，但本轮没有恢复完整回调；不需要在已有instance场景猜测它。

## Evidence

### E-live-update-constant

- observed_at: 2026-09-07
- source_type: memory
- source_ref: IDA raw7923C1/7923DB/7923F5及rawAE2365..AE23A7
- content_hash: n/a，复用报告基准样本hash
- artifact_path: n/a
- linked_workitem: n/a
- supersedes: none
- repro_command: 现有IDB的IDAPython执行下列代码
- raw_excerpt: ADD=2160，UPDATE=2161，DELETE=2162；raw12EC948对应2161，+8函数VA A2BD60→rawA1BD60。

```python
import ida_bytes, struct
for name, va in [('ADD',0xBE9870),('UPDATE',0xBE9868),('DELETE',0xBE9860)]:
    print(name, struct.unpack('<d', ida_bytes.get_bytes(va-0x10000,8))[0])
print(ida_bytes.get_dword(0x12EC948), hex(ida_bytes.get_dword(0x12EC950)-0x10000))
```

### E-live-update-copy

- observed_at: 2026-09-07
- source_type: file
- source_ref: [A1BD60](live-update-0xa1bd60.json)、[9BE660](live-update-0x9be660.json)、[7E3FD0](live-update-0x7e3fd0.json)
- content_hash: live-update-hashes.json
- artifact_path: 上述JSON
- linked_workitem: n/a
- supersedes: none
- repro_command: idapro_decompile(addr="0xa1bd60")，其余同理
- raw_excerpt: A1BD60先9BD840获得旧68B记录，再9BE660(*payload,payload)按instance整条覆盖。9BE660仅type50触发额外更新，type25直接返回。之后A1BD60比较uint16 payload+23与旧值，正差时7E3FD0显示物品计数或时长通知。

### E-live-expiry-not-update

- observed_at: 2026-09-07
- source_type: file
- source_ref: [8166E0](live-update-0x8166e0.json)
- content_hash: live-update-hashes.json
- artifact_path: live-update-0x8166e0.json
- linked_workitem: n/a
- supersedes: none
- repro_command: idapro_decompile(addr="0x8166e0")
- raw_excerpt: 2121表raw12EDEC0指针VA8266E0→raw8166E0，读取DWORD count及其后的instance数组，逐一9BD7C0(instance,2)并显示过期信息。

## Findings 与路径

F-live-update：severity=n/a_re，category=reverse_algo，status=validated（静态），confidence=high，evidence_ids=[E-live-update-constant,E-live-update-copy]，location=A1BD60→9BE660，impact=已有物品的完整68B记录可通过2161更新且不强制装备。repro_steps=复现常量与表指针，再核验68B memcpy及type25返回。remediation=本地现会话可逐条2161发送修正后的记录并观察仓库。optional_attack=空。

P-live-update，path_type=callflow：2161/68（E-live-update-constant）→A1BD60读旧记录→9BE660按instance覆盖（E-live-update-copy / F-live-update）→正计数增量触发获得通知→重新打开仓库89ADE0按count/time过滤构建列表。residual_risks=大厅当前dispatcher是否注册此通用表尚无本轮动态证据；不存在的instance不会被2161添加。

时间线：大厅1120热推未见效→排除2090副作用→识别2161常量与回调→核验原地memcpy且不换装备→移交主线程动态验证。
