# E-017 — 用户确认真实客户端重登恢复角色

- recorded_at: 2026-09-07 01:12 +08:00（记录时间，非精确登录时间）
- source_type: manual
- source_ref: 当前任务用户回复
- raw_excerpt: “可以直接恢复07，你记录一下吧”
- content_hash: n/a（用户对话确认；本文件校验见 SHA256.json）
- repro_command: 重新打开隔离客户端并登录，检查已有角色恢复；本次由用户实际操作并确认。

## 结论

在上一轮要求验证持久化角色 t07 的上下文中，用户确认重登后可以直接恢复“07”。据此将角色持久化的真实客户端重登验证标为通过；数据库和既有报告的角色名仍保留 t07，不据此重命名角色。

本次为用户实机确认，没有新增截图或独立抓包复核。E-016 合成 TCP 冒烟仍保持原有证据属性，不升级为真实客户端采集。

## F-018 更新

- severity: n/a_re
- evidence_ids: E-016, E-017
- confidence: high
- location: role_protocol.py / LabRoleStore / RoleSession 重连分支
- status: validated（合成 UID 1001 实验角色持久化与实机重登恢复）

P-003（callflow）现已验证到：创建角色 → 持久化 → 退出重登 → 恢复已有角色。完整账号认证、频道大厅、世界与战斗仍未完成；下一步继续频道连接，不再将重登恢复列为待验证。
