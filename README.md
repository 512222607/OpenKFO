# OpenKFO / KFO Server Emulator

面向学习与技术研究的《功夫小子》兼容服务器模拟器项目，研究网络协议、服务端架构、数据持久化及客户端互操作，包含服务端、客户端配套工具和GM管理器源码。

> **非商业 · 学习研究 · 非官方项目**
>
> 本项目不以营利为目的，不收费、不投放广告、不接受捐赠或赞助，不提供充值、付费会员、付费道具或其他变相收费服务。请勿将本项目用于商业运营或未经授权的游戏服务。

## 项目来源与致谢

OpenKFO 基于 [liuyangyi0/kungfukid-local-server](https://github.com/liuyangyi0/kungfukid-local-server) 修改和扩展，感谢原项目作者开源并提供基础实现。

特别感谢 **QQ：512222607 348159579。

本仓库在原项目基础上进行了目录整理、Go 服务端扩展、登录器与GM管理器集成，以及构建打包流程调整。原项目已有实现的贡献归原作者，OpenKFO 的后续修改不代表原作者的观点或背书。

## 项目定位与使用边界

- **学习与研究**：面向个人学习、协议兼容性研究和获得必要授权的测试，不以替代官方服务或招揽玩家运营为目标。道具、商城与钱包管理功能用于开发测试，不用于真实货币交易。
- **独立实现原则**：服务端以独立实现为原则；不引入泄露的官方服务端源码、商业秘密或来源不明的代码。第三方依赖应保留其许可和署名，贡献代码需说明来源并具有相应提交权限。
- **不分发官方内容**：本仓库不提供原游戏客户端、官方美术、音频、地图等资源的下载或镜像。请勿在提交、Issue、附件或 Release 中上传未经授权的程序和素材。
- **客户端自行合法取得**：研究者需自行通过合法渠道取得客户端，并确认相应使用权限；项目仅在必要权限范围内提供兼容代码、连接配置与补丁使用说明，不授予原客户端或游戏素材的使用、复制或传播权利。
- **非官方、无隶属关系**：OpenKFO 并非官方产品，与原游戏的开发商、发行商及运营方无隶属、合作或背书关系。《功夫小子》及相关名称、商标和作品的权利归各自权利人所有，文中提及仅用于说明兼容研究对象。
- **尊重权利与技术措施**：请勿利用本项目未经许可复制、传播第三方软件或素材，或违法规避、破坏著作权保护技术措施。开展研究及公开测试前，应确认必要授权与适用的使用条件。

**“免费”“非商业”或“仅供学习”并不当然意味着合法，也不构成免责或权利人的授权。** 本声明说明项目定位和维护原则，不代替源代码许可证或第三方许可，也不构成对任何具体使用方式合法性的保证。

如权利人认为仓库中的具体内容涉及其权利，请通过 [GitHub Issue](https://github.com/ydisk3528/OpenKFO/issues) 提供文件路径、权利依据及问题说明；维护者将核查并根据情况处理。请勿公开提交身份证件、密钥或其他敏感材料。

法律参考：[2025 年“两高”《关于办理侵犯知识产权刑事案件适用法律若干问题的解释》](https://www.court.gov.cn/zixun/xiangqing/463291.html)。本项目不将其中的入罪数额标准视为允许侵权的范围。


## 当前版本与目录

**当前运行链路不依赖 Python**：Go + MySQL 服务端、C# 在线登录器（内嵌 Go 桥接与 C++ 登录界面）、Flutter GM管理器（调用 Go 管理后端）。

- `server/go-server`：当前 Go 服务端、协议、数据库访问、客户端桥接和管理后端，共用一个 Go 模块。
- `toosl/item-manager`：Flutter GM 管理器，含 Windows 完整版及 macOS/Android 线上入口。
- `client/launcher-online`：当前 C# 在线登录器。
- `client/client-adapter`：C++ 登录界面与客户端适配代码。
- `dist/GM管理器/GM管理器.exe`：构建后直接双击的 GM管理器入口。
- `docs`：协议与开发参考，其中部分文档描述旧本地实现。

`toosl` 为本仓库约定目录名。`server/kk_local`、`server/tests`、`requirements.txt`、`client/launcher`、旧本地启动/账号脚本以及 Go 模块中的 Python 迁移工具仅保留作历史参考；**使用当前版本无需安装 Python、创建 `.venv` 或启动旧 Python 服务**。旧迁移工具不属于下述运行流程。

## 构建与运行

各部分独立构建，不需要先运行 PowerShell 脚本。以下 `cd` 均以仓库根目录为起点；执行另一组命令前回到仓库根目录。

| 程序 | 当前支持平台 | 构建环境 |
| --- | --- | --- |
| Go 服务器、服务端管理程序 | Linux / macOS / Windows | Go 1.26.0（见 go.mod）、MySQL 8 |
| GM 完整桌面版 | Windows x64 | Flutter（Dart ^3.13.2）、Visual Studio C++、Go |
| GM 线上版 | macOS / Android（也可构建 Windows） | Flutter、各平台工具链；服务器部署 GM HTTPS API |
| 游戏登录器 | Windows | .NET 8 SDK、VS 2022 x86 C++ 工具链、Go |

Go 服务器可在非 Windows 系统运行。GM 的 Windows 完整版仍可切换本地/线上；macOS、Android 使用独立线上入口 `lib/main_online.dart`，通过 HTTPS 管理接口连接，不依赖本机 Go EXE 或 SSH。macOS 工程需在 Mac 上构建验证。

### GM 管理器：直接打包

在 Windows 的普通终端（CMD 等）执行：

```text
cd toosl/item-manager
flutter pub get
flutter build windows --release
```

界面产物位于 `toosl/item-manager/build/windows/x64/runner/Release/`，入口为 `kungfu_item_manager.exe`。建议将仓库放在英文路径（例如 `C:/src/OpenKFO`），避免 Flutter/MSBuild 的中文路径问题。

GM 还需要 Go 管理后端。从仓库根目录执行：

```text
cd server/go-server
go build -ldflags "-H windowsgui" -o ../../toosl/item-manager/build/windows/x64/runner/Release/kungfu-desktop-admin.exe ./cmd/desktop-admin
```

将 **整个 Release 文件夹**复制到仓库根目录 `dist/GM管理器`，可将 `kungfu_item_manager.exe` 重命名为 `GM管理器.exe`。保留 DLL、`data/`、Go 后端和其他生成文件；单独复制 EXE 无法运行。配置好后直接双击，无需 CMD 启动脚本。

运行配置、同一个 EXE 切换本地/线上、奖励表和商城操作见 [GM 管理器说明](toosl/item-manager/README.md)。

### GM 线上版：macOS / Android

以下均在 `toosl/item-manager` 目录执行，首次先运行 `flutter pub get`：

| 目标平台 | 构建所用环境 | 命令 | 输出 |
| --- | --- | --- | --- |
| macOS | Mac、Flutter、Xcode 与命令行工具 | `flutter build macos --release --target lib/main_online.dart` | `build/macos/Build/Products/Release/OpenKFO-GM.app` |
| Android APK | Windows/Linux/macOS、Flutter、Android SDK、JDK 17 或兼容版本 | `flutter build apk --release --target lib/main_online.dart` | `build/app/outputs/flutter-apk/app-release.apk` |
| Android AAB | 同上，发布前配置自己的签名 | `flutter build appbundle --release --target lib/main_online.dart` | `build/app/outputs/bundle/release/app-release.aab` |
| Windows 线上版 | Windows、Flutter、Visual Studio C++ | `flutter build windows --release --target lib/main_online.dart` | `build/windows/x64/runner/Release/` 完整目录 |

Android 工程默认使用开发签名用于测试；正式分发前需配置自己的签名。macOS 签名、公证需在自己的 Mac/Apple 开发环境处理。不同入口的构建会复用同一输出目录，分别发布时请各自保存完整产物。

线上版启动后填写自己的 `https://管理域名/gm/api` 和管理令牌。服务端需先部署 [GM HTTPS 管理接口](server/go-server/README.md#gm-https-管理接口)，不能把游戏 `/kk/tunnel` 地址当成管理接口。

支持账号背包、发放道具、商城、钱包、奖励表；不提供本机武器资源编辑、本地数据库切换。手机采用可滚动的宽表格，建议横屏；奖励 CSV 支持粘贴导入与复制导出。令牌仅保留在本次会话，不内置个人域名、IP、数据库密码或 SSH 密钥。

### Go 服务器：直接构建与启动

Linux/macOS，从仓库根目录执行：

```sh
cd server/go-server
go build -o kungfu-server ./cmd/server
go build -o kungfu-admin ./cmd/admin
export KK_MYSQL_DSN='kfo:替换为自己的密码@tcp(127.0.0.1:3306)/openkfo_debug_local'
./kungfu-server -config config.json -cert-dir certificates -listen 127.0.0.1:19090 -tls-listen 127.0.0.1:19091
```

Windows CMD，从仓库根目录执行：

```bat
cd server/go-server
go build -o kungfu-server.exe ./cmd/server
go build -o kungfu-admin.exe ./cmd/admin
set "KK_MYSQL_DSN=kfo:替换为自己的密码@tcp(127.0.0.1:3306)/openkfo_debug_local"
kungfu-server.exe -config config.json -cert-dir certificates -listen 127.0.0.1:19090 -tls-listen 127.0.0.1:19091
```

**先创建数据库并准备匹配客户端的 `config.json`，再启动。** 上面的密码仅是占位文字。源码仓库不提供实际账号、客户端或可直接游玩的完整配置；Go 程序会建表，但不会创建数据库。

`config.json` 的必需信息：客户端 `Data/config.spf2` 的 SHA-256（`config_hash`）、按 `模式:人数` 对应地图 ID 列表的 `pools`（非空）；还可配置地图 `groups` 与首次初始化奖励 `settlement`。详细准备、账号管理、日志及 Windows 双击调试模式见 [Go 服务端说明](server/go-server/README.md)。

### Windows 登录器

登录器依赖 Windows 客户端与原生组件，不能在 Linux/macOS 上直接运行。先在仓库根目录准备 `dist/launcher-components` 文件夹，然后执行以下 Windows CMD 命令：

```bat
cd server/go-server
go build -o ../../dist/launcher-components/OnlineBridge.exe ./cmd/bridge
cd ../..
client\client-adapter\build-login-skin.cmd
dotnet publish client/launcher-online/OnlineLauncher.csproj -c Release -o dist/launcher
```

C++ 脚本使用 VS 2022 Build Tools 默认安装路径；安装位置不同时调整 `vcvars32.bat` 路径。组件源码和构建依赖见 [登录器说明](client/launcher-online/README.md)。

将发布的登录器放到游戏目录，并在同目录准备 `bridge.json`：

| 字段 | 含义 |
| --- | --- |
| `url` | 本地 `tls://127.0.0.1:19091`；线上示例 `wss://域名/kk/tunnel` |
| `client_directory` | 自行准备的兼容客户端目录 |
| `client_sha256` | 客户端 `gfld.dat` 的 SHA-256 |
| `config_hash` | 客户端 `Data/config.spf2` 的 SHA-256，须与服务器一致 |
| `server_certificate` | 固定校验用的 `origin.crt` 路径 |
| `login_certificate`、`login_key` | 本地登录接口所需的匹配证书与私钥，不是服务端私钥 |
| `trace_protocol` | `true` 时将协议跟踪写入各窗口的 `online-client.log` |

路径相对 `bridge.json` 所在目录解析。双击运行，或在 CMD 中指定配置目录：

```bat
"dist\launcher\功夫小子登录器.exe" --root "C:\kfo-runtime"
```

Cloudflare 部署见 [隧道说明](docs/CloudflareTunnel.md)。修改武器资源后，必须同步客户端、登录器与服务器允许的配置校验值，并重启读取旧配置的程序；只在 GM 应用资源不会自动完成服务端更新。

### 可选的一键整理脚本

`toosl/Build-Dist.ps1` 和 `toosl/Install-Dist.ps1` 是 Windows 上可选的批量构建、安装工具，不是 Go 服务器或 GM 的必需构建步骤。前者会将发布包整理到 `dist/launcher`、`dist/launcher-components`、`dist/server`、`dist/GM管理器`；也可按上面的命令独立构建、手动复制完整产物。

### 开发验证

在 `server/go-server` 运行：

```text
go test ./...
```

在 `toosl/item-manager` 运行：

```text
flutter analyze
flutter test
```

真实数据库测试需设置 `KK_TEST_MYSQL_DSN` 指向独立测试库，否则相应用例跳过。测试或构建通过不等于实机游戏和线上部署验证。运行配置、客户端资源、数据库、私钥、日志和构建产物不提交 Git；当前运行链路不依赖 Python。
