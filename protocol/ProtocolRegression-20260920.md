# 协议 TLS 回归（2026-09-20）

代码基线：`529a0e5d2242b81e972d83e774ca24e727b56b13`。

本轮以独立调试库、临时账号和测试进程运行 `cmd/protocol-tester` 中名称以 `TLS` 结尾的全部测试。每个场景通过实际 TLS 连接认证并收发协议；不是向正在运行的游戏窗口注入操作。配置改动使用连接内临时表，赠送场景的临时商品按生成键清理。没有重置既有玩家或部署线上。

命令（需在进程环境中提供独立调试库的 `OPENKFO_DEBUG_DSN`，不要把凭据写入文档）：

```sh
go -C server/go-server test ./cmd/protocol-tester -run 'TLS$' -count=1 -v
```

14个顶层测试全部通过，总耗时193.338秒：

| 测试 | 验证范围 |
| --- | --- |
| TestCharacterCreationTLS | 创建角色及后续账号查询、频道流程 |
| TestExtendedTaskActionsTLS | 每日/新手任务列表、接取/放弃重试、进度保留及领奖 |
| TestGiftTLS | 在线、离线赠送 |
| TestVIPGiftTLS | VIP赠送价格及投递 |
| TestRenewalTLS | 物品续期查询、购买及库存更新 |
| TestStageGateTLS | 关卡目录、个人授权及权限变更 |
| TestTalismanRepairTLS | 法宝修复报价、材料校验和库存同步 |
| TestTalismanTLS | 法宝使用及战斗对象事件 |
| TestTasksTLS | 对局、任务计数、奖励、回房及房间状态约束 |
| TestTitlesTLS | 称号奖励目录、选择和领取 |
| TestTrainingTLS | 名侠训练预览、启动、领奖和重试 |
| TestVIPTLS | VIP状态同步 |
| TestVIPShopTLS | VIP商品报价和购买 |
| TestWeaponUpgradeTLS | 武器升级配置及操作 |

完整本地输出：`dist/all-tls-regression.log`。该日志包含临时账号与原始协议，不随源码提交。

本结果证明上述测试覆盖的协议链通过，不证明原生游戏所有画面、客户端动画、完整PVE、观战或锁位已实现。3430发送结构仍未恢复，3440仅有已验证的下行解析。未据此开放未知请求或任意事件广播。

`.NET`日志窗口更新包已同步到上述代码基线，包含窗口EXE、Go服务EXE、更新说明与SHA256清单，压缩包逐文件校验通过。它是已有本地服务的更新包，未替换仍在运行的服务。
