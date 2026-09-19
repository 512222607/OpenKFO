# 功夫小子 GM管理器

Flutter GM 管理界面：Windows 完整版包含本地/线上管理及本机武器编辑；macOS、Android 使用 HTTPS 线上版入口。

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

## macOS / Android 线上版

在本目录执行 `flutter pub get` 后，选择目标平台命令：

```sh
# 在 Mac 上构建，需要 Xcode
flutter build macos --release --target lib/main_online.dart
```

产物：`build/macos/Build/Products/Release/OpenKFO-GM.app`。

```text
flutter build apk --release --target lib/main_online.dart
```

Android 可在 Windows/Linux/macOS 上构建，需要 Android SDK 和兼容 JDK（工程 Java 目标 17）。产物：`build/app/outputs/flutter-apk/app-release.apk`。AAB 命令为 `flutter build appbundle --release --target lib/main_online.dart`，产物在 `build/app/outputs/bundle/release/`。目前默认开发签名用于测试，正式分发前配置自己的签名；macOS 的签名与公证也需自行准备。

此入口不调用本机 Go EXE，不读取下述 Windows SSH 配置。先部署 [GM HTTPS API](../../server/go-server/README.md#gm-https-管理接口)，打开应用填写 `https://管理域名/gm/api` 和管理令牌。令牌只保留在当前会话；返回连接页可换服务器。

账号、背包、道具发放、商城、钱包、奖励表使用同一线上服务；不显示本地切换与武器编辑。商城图片由新版 GM API 按商品编号读取并返回，不暴露服务器文件路径；服务器需自行提供客户端图标资源，缺图显示占位图。道具文件导出停用，奖励 CSV 使用文本复制/粘贴。手机可横向、纵向滑动宽表格，建议横屏操作。macOS 工程需在 Mac 上完成实机构建验证。

以下运行配置适用于 Windows 完整版。

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

商城采用分类、连续滚动商品网格和右侧配置面板，不包含人物试穿。鼠标滚轮或拖动滚动条即可浏览全部商品；卡片只构建可见区域和少量预加载区域，不一次创建全部商品控件。商品图片按 `item.txt` 中的图标路径读取 `runtime-local/client/Data/UI`，按当前可见区域分批加载（单次最多 24 张），滚动停止后短暂合并请求，图片缓存最多保留 256 张。支持标准 PNG，以及能够唯一还原图片头的旧客户端 PNG；文件缺失或格式不确定时显示占位图。Windows 版使用本机客户端资源，HTTPS 线上版使用 GM API 所在机器的资源。原客户端图片不随源码或安装包分发。切换分类不会清空已勾选商品，批量操作前请核对已选数量。

武器动作名称：优先显示该武器的连招配置；没有匹配标签时读取原动画起始说明并标明“动画说明”。共享动作可能保留原开发名称与尾部数值，这不是完整按键或正式招式名；没有可靠说明时显示“按键映射待核实”。

## 武器连招分组

武器配置按客户端 `combotip.xml` 的完整按键路线分组（如 CCCXX）。展开路线后，点击“第 N 段”编辑该动作的命中伤害、BUFF与持续时间（毫秒，3000=3秒）。动作段不等于一次命中，一个动作可能引用多个命中属性。

不同路线引用同一状态时共用一份配置，切换路线不会生成重复规则。提示文件未覆盖的动作放在“其他动作”；提示中的状态若没有实际动作，则不能编辑。没有独立提示文件的武器仍保留全部动作，不根据动画注释猜测按键。保存/应用仍使用原状态编号，已有方案保持兼容。
