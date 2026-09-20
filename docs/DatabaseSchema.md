# 数据库结构与初始化

以当前 Go 源码为准：[store.go](../server/go-server/internal/persistence/store.go) 的 schema、[admin.go](../server/go-server/internal/persistence/admin.go) 的 GM 审计表。下表和 SQL 是 2026-09-20 快照；修改源码结构时需同步更新。MySQL 8 / InnoDB。

## 先建库，再建表

在 MySQL 管理终端执行（替换密码；只用于自己的测试环境）：

```sql
CREATE DATABASE kungfu_game CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'kfo'@'localhost' IDENTIFIED BY 'REPLACE_WITH_PASSWORD';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, REFERENCES ON kungfu_game.* TO 'kfo'@'localhost';
```

用户已存在时不要重复CREATE USER；远程连接或容器部署需由管理员设置实际匹配的MySQL用户Host。数据库名与DSN必须一致。

在仓库根目录、CMD/bash/zsh执行：

```text
mysql -h 127.0.0.1 -u kfo -p kungfu_game < docs/database-schema.sql
```

然后按README启动服务。[database-schema.sql](database-schema.sql)包含全部表、字段类型、主键、索引和外键，按依赖顺序排列，不含用户数据。当前源码建表列表中stage_player_unlocks早于accounts，因此首次空库应先导入此结构，避免外键建表顺序错误。服务端Open会执行CREATE TABLE IF NOT EXISTS；GM本地OpenExisting不会建表，所以不要先开GM初始化空库。

这个SQL不是旧数据库迁移器；CREATE TABLE IF NOT EXISTS不会给已有表补列。升级已有库前先备份并比较SHOW CREATE TABLE与当前结构，不要删库重建。部分表ON DELETE CASCADE，部分外键没有级联；不要靠删除accounts一行来重置玩家。

## 表清单

| 表 | 用途 |
| --- | --- |
| `honour_rules` | 荣誉版本化配置 |
| `honour_rules_audit` | 荣誉配置变更审计 |
| `battle_reward_rules` | 战斗/成长奖励版本化配置 |
| `training_rules` | 训练版本化配置 |
| `weapon_rules` | 武器版本化配置 |
| `weapon_rules_audit` | 武器配置变更审计 |
| `talisman_rules` | 法宝版本化配置 |
| `talisman_rules_audit` | 法宝配置变更审计 |
| `task_rules` | 任务版本化配置 |
| `title_rules` | 称号版本化配置 |
| `title_rules_audit` | 称号配置变更审计 |
| `task_rules_audit` | 任务配置变更审计 |
| `training_rules_audit` | 训练配置变更审计 |
| `stage_access` | 全局关卡开放配置 |
| `stage_player_unlock_audit` | 地图解锁配置变更审计 |
| `stage_access_audit` | 全局关卡配置审计 |
| `battle_settlements` | 按战局serial保存战报和结果，防重复结算 |
| `accounts` | 账号、认证摘要、角色360B记录、金币和点券 |
| `offers` | 商城商品；108B展示记录、68B发放模板、上下架 |
| `item_definitions` | 统一发奖物品模板、版本及期限 |
| `counters` | UID/战局等命名计数器；具体名称见调用代码 |
| `training_claims` | 训练周期领奖回执 |
| `vip_shop_rules` | VIP商城版本化配置 |
| `vip_shop_rules_audit` | VIP商城配置变更审计 |
| `desktop_admin_operations` | GM写操作的请求摘要、修改前快照和结果 |
| `stage_player_unlocks` | 按玩家和客户端版本保存地图解锁 |
| `friends` | 单向好友关系；(uid,friend_uid)唯一 |
| `character_creations` | 取名创建请求及昵称唯一性 |
| `talisman_uses` | 法宝消耗请求回执 |
| `talisman_repairs` | 法宝修理请求回执 |
| `mailbox` | 邮件列表/详情与读取、删除、领取状态 |
| `gift_receipts` | 赠送请求摘要、收件人和邮件回执 |
| `honour_stats` | 按周期累计荣誉、场次和胜场 |
| `inventory` | 玩家背包；(uid,instance)唯一；物品记录68B |
| `weapon_upgrades` | 武器强化请求、概率、费用、前后物品记录 |
| `offer_lifetimes` | 购买后实际有效天数 |
| `tutorial_rewards` | 每个玩家的新手奖励领取记录 |
| `renewal_receipts` | 道具续期请求回执 |
| `level_reward_receipts` | 按玩家和等级保存升级发奖回执 |
| `purchases` | 购买请求摘要、扣款结果和发放记录 |
| `wallet_operations` | 钱包调整操作及结果 |
| `training_ranks` | 训练等级 |
| `task_progress` | 基础任务状态、统计基线与规则快照 |
| `extended_task_progress` | 周期任务进度、计数和规则快照 |
| `task_rewards` | 基础任务发奖回执 |
| `title_rewards` | 称号等级候选奖励及玩家选择 |
| `training` | 训练开始时间 |
| `consumption_events` | 战斗消耗品按玩家/战局/序号去重 |
| `mail_attachments` | 邮件附件、有效期及已领取实例 |
| `inventory_expirations` | 背包实例的服务器到期时间和处理状态 |
| `renewal_reminders` | 玩家忽略的到期提醒 |

## 读取数据时必须知道的区别

- accounts.account是登录账号，uid是内部玩家身份，nickname是角色名。profile是360B客户端兼容记录；经验、等级等并非独立SQL列，不要自造exp/lv列。修改通过RoleManager等业务入口。
- inventory.instance是玩家的物品实例；record中的模板ID不是instance。背包主键是(uid,instance)，不能只凭instance跨账号发放或装备。
- inventory.record为68B：+0实例u32，+4物品类型u8，+5模板ID u32，+13期限字段u32，+17装备槽u16，+19状态u32，+23类型相关数量u16。字段均按原生协议解释，+23并非所有物品都表示数量；实际到期由inventory_expirations控制。
- offers.catalog_key是商城商品键，不能与物品模板ID或背包instance混用。发奖应走统一物品/背包管理入口，避免只改某个BLOB而漏掉过期数据和回执。
- *_rules.rules等BLOB通常保存业务序列化配置；accounts.profile、inventory.record和商城record是原生二进制结构。不能把所有BLOB都当JSON。
- 配置revision用于并发修改检测；*_audit、*_receipts及结算/消费记录用于审计或防重复发放，不是可随意清理的临时数据。
- rooms/在线连接/当前动作主要在Go内存中，不存在一张覆盖所有房间实时状态的SQL表。

## 验证和备份

```sql
SHOW TABLES;
SHOW CREATE TABLE accounts;
SHOW CREATE TABLE inventory;
SHOW CREATE TABLE friends;
```

备份示例（仓库外保存，不提交Git）：

```text
mysqldump -h 127.0.0.1 -u kfo -p --single-transaction --no-tablespaces kungfu_game > backup.sql
```

本页结构来自源码静态核对；不表示已对任意旧库执行迁移，也不含线上数据库导出。
