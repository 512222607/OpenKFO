# 仓库slot0穿戴请求及友好失败回复

日期2026-09-08，范围与[原报告](report.md)一致，flavor=null。用户实际请求2080/16的instance165、slot0已由主线程记录；本补充找到普通仓库动作必然能够产生slot0的路径。它不是需要断线处理的格式错误。本地服务可以在确认owner与type25后把slot0规范化为主武器槽8，同时保持副武器功能范围不变。

## slot0实际来源

raw8A3890从选中仓库UI记录v26取值。对于type25走default分支，在raw8A3956执行this[396]=v26[4]，也就是UI+16。前文raw893760已确认UI+16来自uint16 item+17，所以未装备仓库物品就是0。接着raw8A3CC3调用899700，后者将this[396]原样写入2080 payload+4并发送16字节。

这条路径与另一个装备按钮89FB80不同：后者8939F0(type)查槽；8560C0也经650CE0(type)查槽，type25默认值已证实是8。既然用户发的是2080装备请求，且主武器物品来自未装备仓库，服务端以当前物品type确定默认槽8是有客户端证据支持的本地兼容策略。尚不能单凭这点声称原服务器把所有类型的0都正式命名为AUTO。

## 2100失败回复

A_RE_EQUIP_ITEM_FAIL=2100。通用表raw12EC738保存handler VA A29E30，对应rawA19E30。

handler严格要求payload非空且长度2，读取little-endian uint16。小于130的值查表raw12D2824+104*code，显示模态提示；超出范围显示“未知的错误！”。没有断开网络操作。

已直接读取的可用文案：

| code | 客户端文案 |
|---:|---|
| 38 | 装备道具失败！ |
| 72 | 装备失败，没有该道具。 |
| 73 | 装备失败，没有该角色。 |
| 74 | 装备失败，道具不能重复装备。 |
| 75 | 装备失败，道具过期。 |
| 76 | 装备失败，该道具已经被丢弃。 |
| 77 | 装备失败，道具不能装备。 |

本轮对格式有效但尚未支持的装备槽，可返回2100/2码38并保持连接。对未知instance可以用72。这些值的显示文案已核验；原服务器针对每种后台失败选择哪个码不在本证据范围内。

2320只有协议常量确认，本轮未找到native注册消费者，不能照搬2100的长度或错误码。

## Evidence → Finding → Path

### E-slot-zero-path

- observed_at: 2026-09-08
- source_type: file
- source_ref: [8A3890](slot-zero-0x8a3890.json)、[893760](warehouse-0x893760.json)、[899700](0x899700.json)
- artifact_path: 上述JSON
- content_hash: slot-zero-failure-hashes.json（新文件），旧文件原hash清单
- linked_workitem: n/a
- supersedes: 原报告中slot0未知的描述
- repro_command: 现有IDB idapro_decompile(addr="0x8a3890")，并对照893760、899700。
- raw_excerpt: raw8A3956 this[396]=v26[4]；raw8A3CC3调用899700；899882写payload DWORD1=this[396]。

### E-equip-failure

- observed_at: 2026-09-08
- source_type: file
- source_ref: [A19E30](equip-failure-0xa19e30.json)、[文案表读取结果](equip-failure-messages.json)
- artifact_path: 上述JSON
- content_hash: slot-zero-failure-hashes.json
- linked_workitem: n/a
- supersedes: 原报告中2100长度/错误码未知的描述
- repro_command: idapro_decompile(addr="0xa19e30")，并在IDAPython用下列片段读表。
- raw_excerpt: if(payload != null and length==2)，code<130时显示raw12D2824+104*code处GBK文案。

```python
import ida_bytes
for code in [38,72,73,74,75,76,77]:
    text = ida_bytes.get_bytes(0x12D2824 + 104*code,104).split(b'\0',1)[0]
    print(code,text.decode('gb18030'))
```

F-slot-zero：severity=n/a_re；category=reverse_algo；status=validated（静态）；confidence=high；evidence_ids=[E-slot-zero-path]；location=8A3890→899700；impact=未装备仓库物品能够发出合法2080 slot0。repro_steps=先映射UI+16再追请求字段。remediation=owner和type25通过后0归一到8，其余未支持槽友好失败。

F-equip-fail-layout：severity=n/a_re；category=reverse_algo；status=validated（静态）；confidence=high；evidence_ids=[E-equip-failure]；location=A19E30；impact=可用2100/2明确提示失败而不关闭连接。repro_steps=核验长度门及错误文案表。remediation=合法不支持操作返回通用码38。optional_attack=空。

P-slot-zero，path_type=callflow：未装备记录item+17=0→893760映射UI+16→8A3890写当前槽0→899700发送2080/16（E-slot-zero-path/F-slot-zero）→本地type25默认8兼容；unsupported槽→2100/2码38→A19E30提示（E-equip-failure/F-equip-fail-layout）。residual_risks=主线程实际装备/错误提示动态验证另存，本文未运行客户端。

时间线：用户真实slot0请求导致旧服务断线→主线程支持0归一化并通过回归→本子任务证明仓库路径确实产生0→识别2100/2与错误表→移交主线程保持连接的友好失败处理。
