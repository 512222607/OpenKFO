# 永久所有权与客户端365+显示的边界

日期2026-09-08。范围、工具与目标哈希见[原报告](report.md)，flavor=null。用户要求永久武器；本次在3分钟限定范围检查了已知时长显示、365+判定及过期状态设置代码。没有找到正式“永久”字段或0xffffffff专用哨兵判定。可以在本地服务器实现永久所有权、无到期时间，并将客户端显示如实描述为365+。

已读的A0EC20只按模式和阈值显示：

- item+19=0：item+13按小时解释，达到8760后显示*365+。
- item+19=1：item+13按分钟解释，达到525600后显示365+。
- item+23非零且item+13为0：显示计数，因而此前“1个”来自这里。
- item+19=2：过期状态。

raw9BC4E0及9BF2F0也使用同样阈值，没有max_uint特判。0xffffffff在这些已读函数作为unsigned参与比较/除法，可以达到365+显示分支，但这不是官方永久哨兵证据，更不能证明整个客户端的所有后续运算安全。

建议服务器永久策略不要依赖未确认的max_uint值：持久化无到期时间，既不倒计时也不发送过期消息；wire用mode1、duration525600、count0作为已知365+显示编码，重连和实时更新继续序列化同值。这样“永久”是本地服务规则，“365+”是客户端可确认的显示。这个建议属于本地兼容实现选择，不应写成原服务器精确恢复。

## Evidence

E-permanent-threshold：
- observed_at: 2026-09-08
- source_type: file
- source_ref: [9BC4E0](permanent-0x9bc4e0.json)、[9BF2F0](permanent-0x9bf2f0.json)、[A0EC20](warehouse-0xa0ec20.json)
- artifact_path: 对应JSON
- content_hash: permanent-hashes.json及旧warehouse-hashes.json
- repro_command: 当前IDB idapro_decompile(addr="0x9bc4e0")，其余同理
- linked_workitem: n/a
- supersedes: none
- raw_excerpt: mode0 && duration>=8760，或mode1 && duration/60>=8760；无永久专用比较。

E-permanent-expiry：
- observed_at: 2026-09-08
- source_type: file
- source_ref: [9BD7C0](permanent-0x9bd7c0.json)、[8163A0](permanent-0x8163a0.json)
- artifact_path: 对应JSON
- content_hash: permanent-hashes.json
- repro_command: 当前IDB idapro_decompile(addr="0x9bd7c0")，其余同理
- linked_workitem: n/a
- supersedes: none
- raw_excerpt: 8163A0读取count+instance数组，逐一9BD7C0(instance,2)；后者按instance将item+19写2。

F-permanent-boundary：severity=n/a_re；category=reverse_algo；status=validated（已读静态路径）；confidence=high；evidence_ids=[E-permanent-threshold,E-permanent-expiry]；location=A0EC20/9BC4E0/9BD7C0；impact=可以可靠编码365+显示与识别过期状态，尚无证据恢复官方永久哨兵。repro_steps=对照三处阈值及过期handler。remediation=本地服务器用无到期规则履行永久要求，UI按365+说明。optional_attack=空。

P-permanent，path_type=callflow：服务器永久持久规则（实现选择）→wire mode1,duration525600,count0→A0EC20显示365+（E-permanent-threshold/F-permanent-boundary）；服务器不发过期名单→不触发9BD7C0写mode2（E-permanent-expiry）。residual_risks=未穷尽整个客户端，特别没有证明max_uint作为哨兵在所有路径安全；实际界面验证由主线程完成。

时间线：用户要求永久→检查时长显示与365+判定→检查到期状态设置→未发现正式永久哨兵→移交明确区分服务规则与UI表示的方案。
