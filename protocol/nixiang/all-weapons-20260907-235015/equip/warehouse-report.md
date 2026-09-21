# 仓库空列表根因：68字节物品缺少剩余计数

2026-09-07补充；范围、工具、目标哈希与[穿戴协议报告](report.md)一致。flavor=null。

本轮用户重登仍看不到武器，主线程已确认真实wire发送1120/19040。静态核验找到独立且足以解释空仓库的条件：仓库仅加入剩余计数或剩余时长非零的武器。当前编码只在item+9写1，item+23及+13均为0，因此这些type25记录会全部被UI主动过滤。本次不需要假设另一个背包消息，也未修改代码、DB或客户端。

## 已确认过滤条件

仓库枚举函数raw89ADE0通过raw44E200获得全局角色管理器+3784，也就是946个DWORD偏移的库存集合。raw1120处理器812720清空并通过9BE710写入的是同一个集合。不存在本文这条UI路径从另一个未填充仓库读取的证据。

对于普通type25武器，加入当前页须同时满足：

1. uint16 item+17 == 0（未装备）。
2. int32 item+19 != -1。
3. item+4类型位于当前分类页的闭区间a2..a3。
4. item+5完整DWORD配置ID在A0E560可找到。
5. uint16 item+23 != 0 **或** uint32 item+13 != 0。

条件5不看item+9。type30有额外例外，不适用于武器。

UI结构转换raw893760的确切映射：

| 网络物品偏移 | 类型 | UI偏移 | 含义/证据 |
|---|---|---|---|
| +0 | uint32 | +8 | instance |
| +4 | uint8 | +0 | 物品type |
| +5 | uint32 | +12 | 配置ID |
| +9 | uint32 | +4 | 当前仍未恢复全部语义；先前命名quantity不能作为证据 |
| +13 | uint32 | +32 | 剩余时长相关；显示函数按小时/分钟模式格式化 |
| +17 | uint16 | +16 | 装备槽 |
| +19 | int32 | +28 | 时长状态/模式，-1排除 |
| +23 | uint16 | +20 | 剩余计数；非零计数且时长0显示十进制数 |
| +25 | uint32 | +24 | 额外字段，当前路径不以它判定显示 |
| +38 | uint32 | +120 | 额外字段 |

建议修复本地授予记录的item+23=1，保持item+13=0；这会满足静态条件且以一件计数显示。还需真实客户端确认，不能从静态代码声称已显示。旧item+9可暂时保留但应改变量名为未知元数据，避免继续误认为数量。

## Evidence

### E-warehouse-filter

- observed_at: 2026-09-07
- source_type: file
- source_ref: [warehouse-0x89ade0.json](warehouse-0x89ade0.json)、[warehouse-0x893760.json](warehouse-0x893760.json)、[warehouse-0x44e200.json](warehouse-0x44e200.json)
- artifact_path: 上述JSON
- content_hash: warehouse-hashes.json
- repro_command: 在现有IDB调用idapro_decompile(addr="0x89ade0")，其余同理
- linked_workitem: n/a
- supersedes: none
- raw_excerpt: raw89B0D2检查配置存在；89B0DB cmp [ebp-14Ch],1Eh；89B0E4 cmp [ebp-138h],0；89B0ED cmp [ebp-12Ch],0；满足后89B11D调用4F68B0 push到this+0x594。[ebp-14Ch]为UI base，所以这两个偏移分别为UI+20及+32。893760在8937B9将word[item+23]写UI+20，在8937AC将DWORD[item+13]写UI+32。

### E-warehouse-count-display

- observed_at: 2026-09-07
- source_type: file
- source_ref: [warehouse-0xa0ec20.json](warehouse-0xa0ec20.json)
- artifact_path: warehouse-0xa0ec20.json
- content_hash: warehouse-hashes.json
- repro_command: idapro_decompile(addr="0xa0ec20")；显示实参来源89CCF0中的A0EC20调用
- linked_workitem: n/a
- supersedes: none
- raw_excerpt: A0EC20(out, item+19, item+13, item+23)，在计数非零且时长0分支使用VA12180548→rawB8DC44字符串"%d"；时长分支格式化天/小时。证明+23是计数，不是+9。

### E-warehouse-insert

- observed_at: 2026-09-07
- source_type: file
- source_ref: [warehouse-0x9be710.json](warehouse-0x9be710.json)
- artifact_path: warehouse-0x9be710.json
- content_hash: warehouse-hashes.json
- repro_command: idapro_decompile(addr="0x9be710")
- linked_workitem: n/a
- supersedes: none
- raw_excerpt: 遍历this+946按instance覆盖68B，否则追加；对type25不做剩余计数过滤。这解释服务端已发送但仓库UI仍空的现象。

## Finding与Path

F-warehouse-empty：severity=n/a_re；category=reverse_algo；status=validated（静态）；confidence=high；evidence_ids=[E-warehouse-filter,E-warehouse-count-display,E-warehouse-insert]；location=89ADE0/893760；impact=未装备武器+23和+13均零时不会出现在仓库，即使1120已成功入库。repro_steps=核验转换字段与89B0D2..89B11D分支，再对照授予编码只写+9=1。remediation=补齐真实剩余计数并用实机重登验证。optional_attack=空。

P-warehouse，path_type=callflow：1120→812720→9BE710写角色+3784库存（E-warehouse-insert）→89ADE0复制同集合（E-warehouse-filter）→893760映射字段（E-warehouse-filter）→计数/时长均零则跳过push（F-warehouse-empty）。目标是恢复仓库列表；residual_risks=世界交接是否还会额外清空尚未动态采样，本条件本身已足以解释当前空列表。

时间线：用户第二次报告空仓库→主线程确认实际wire→独立枚举UI代码→核验+23计数与+13时长门槛→移交主线程补值与实机验证。
