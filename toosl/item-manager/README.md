# 功夫小子 GM管理器

Flutter Windows 管理界面，包含道具、武器、商城、钱包及战斗奖励管理。

左侧选择“本地测试服”或“线上服务器”，账号、背包、商城、钱包、战斗奖励请求统一使用所选环境。默认本地；切换时清空所选账号和待提交操作。武器配置仍只修改本机客户端资源。

“战斗奖励”分别设置胜利、失败、平局的经验和金币，0 表示不发放，范围 0–1000000。读取失败不能保存；配置版本冲突必须重新读取。保存至对应 MySQL 的 `battle_reward_rules` 表，新版 Go 服务器在下一次结算读取，不需要重启；历史对局不补发。首次启动新版服务器仅在数据库没有配置时导入 `config.json` 的 `settlement`，以后 GM 配置优先。升级默认关闭，填写曲线后可启用；掉落与称号未启用。

本地模式连接回环地址的 `openkfo_debug_` 独立测试库；线上模式使用 SSH。两种模式的配置见下文，连接失败不会自动切换环境。

## 直接构建（Windows x64）

在本目录执行，不需要 PowerShell 打包脚本：

```text
flutter pub get
flutter build windows --release
```

输出：`build/windows/x64/runner/Release/kungfu_item_manager.exe`。需要 Flutter SDK（Dart ^3.13.2）和 Visual Studio 的 C++ 桌面开发工具；建议使用英文源码路径。

界面调用 Go 管理后端，从仓库根目录执行：

```text
cd server/go-server
go build -ldflags "-H windowsgui" -o ../../toosl/item-manager/build/windows/x64/runner/Release/kungfu-desktop-admin.exe ./cmd/desktop-admin
```

把整个 `Release` 目录复制为仓库根目录 `dist/GM管理器`，可把 `kungfu_item_manager.exe` 改名为 `GM管理器.exe`。保留所有 DLL、`data/` 和 `kungfu-desktop-admin.exe`，直接双击打开。

当前只有 Windows 工程，Go 后端路径也使用 `.exe`，**尚不支持直接执行 `flutter build linux` 或 `flutter build macos`**。Linux/macOS 可以运行 Go 服务器，GM 在 Windows 上连接该服务器。

## 运行配置

在 EXE 同目录创建 `gm-settings.json`，将示例路径替换为自己的路径：

```json
{
  "root": "C:/kfo-runtime",
  "local_settings": "C:/kfo-runtime/settings.private.json"
}
```

`root` 中需有 `runtime-local/client`，供读取客户端的道具与武器配置。若不写 gm-settings.json，可用 `--root <目录>`、`--local-settings <文件>` 指定；自动查找模式依赖上级目录的 `runtime-local/online-admin.json`，仅用本地模式也建议显式配置 root。

本地模式的 `settings.private.json` 至少包含：

```json
{
  "dsn": "kfo:替换为自己的密码@tcp(127.0.0.1:3306)/openkfo_debug_local",
  "database": "openkfo_debug_local"
}
```

先启动 Go 服务器初始化表。可以使用本机 MySQL，或已经建立的本机 SSH 转发；GM 不负责建立数据库隧道。本地库名必须以 `openkfo_debug_` 开头，连接地址必须为回环地址。Windows 服务器双击模式额外需要 `ssh_config`，见 [Go 服务端说明](../../server/go-server/README.md)。

线上模式在 `root/runtime-local/online-admin.json` 中填写：

```json
{
  "host": "your-server.example",
  "port": 22,
  "user": "your-admin-user",
  "key": "C:/Users/your-user/.ssh/kfo_admin"
}
```

需要本机 OpenSSH 客户端、已验证的 SSH 主机密钥、服务端 `/opt/kungfu-go/kungfu-admin`；服务器 `/etc/kungfu-go/game.env` 提供 `KK_MYSQL_DSN`，SSH 账号须具备后端所需的 `sudo -n` 权限。配置和密钥不要提交仓库。

## 1–150 级成长与奖励（2026-09-18）

GM 直接双击 `dist/GM管理器/GM管理器.exe`；整个文件夹保留，不需要 CMD。
本地与线上分别存储在各自数据库的 battle_reward_rules，revision 防止覆盖并发修改。
旧六项奖励首次读取时展开为 150 行，金额保持原值，自动升级默认关闭。

每行：level、next_experience、win_experience、win_gold、loss_experience、loss_gold、draw_experience、draw_gold。
单局奖励 0–1000000，升级所需经验 0–2147483647。150 级升级经验必须为 0。
启用自动升级前必须填写 1–149 级所需经验；这是自定义曲线，不是原版规则。
批量编辑留空保持原值，0 清零；编辑或导入只改草稿，点击保存才写入当前环境。
CSV 使用 UTF-8 BOM，可用 Excel 打开；先导出模板，编辑后以 UTF-8 CSV 保存，导入时填文件完整路径。
CSV 不包含自动升级开关。复制线上使用本地已保存配置（包括开关），展示所有差异并确认后才写入，线上 revision 变化会拒绝保存。

奖励按 4080 发送前快照的等级选择；旧角色等级 0 按 1 级奖励处理。结算事务内发奖、扣除升级所需经验、连续升级至最多 150 级。满级仍可获得金币与经验，经验字段上限为有符号 32 位整数。重复结算按 battle_settlements 日志返回原结果，不重复发奖。
GM 保存从下一次结算生效。武器掉落和称号未启用。
客户端经验条分母来自客户端自己的等级表；自定义曲线暂未同步到客户端资源，进度条比例可能不同，等级和服务端经验按本表执行。

### 武器动作完整读取（2026-09-18）

招式来源改为 itemact.txt 全部非零动作，combotip.xml 仅用于按键标签，不再决定招式是否显示。
读取动作所属的 animation/*.xml，处理带前导零的动作编号；默认显示战斗招式和可编辑动作，可勾选显示移动、受击等其他动作。
没有连招提示文件时显示状态编号，不猜测原版按键。没有直接命中属性、定义不唯一或含非敌方效果时显示原因，不强行写入。
多个武器或招式共用的动作在应用时复制为独立动作，只修改当前武器对应状态的 itemact 映射，命中属性也复制，避免影响原动作及其他武器。优先使用动画表中未使用的三位动作编号；空间不足会拒绝写入。
伤害、BUFF 等仍只修改本机客户端配置；保存方案不等于应用，游戏须关闭后才能应用。配置包有备份及无关文件校验。新增招式实战表现仍需测试。

商城批量改价：勾选商品（可先搜索，再选择搜索结果），点击“批量改价”，选择金币或点券并填写统一售价。仅更新已有销售记录，保留期限、数量、上下架及其他标记；同一商品的多条规格统一改价，未配置商品跳过并显示数量。本地和线上使用相同操作，确认框显示目标环境。推荐／优惠标记待客户端协议核实后接入。

武器动作名称：优先显示该武器的连招配置；没有匹配标签时读取原动画起始说明并标明“动画说明”。共享动作可能保留原开发名称与尾部数值，这不是完整按键或正式招式名；没有可靠说明时显示“按键映射待核实”。
