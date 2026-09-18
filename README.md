# OpenKFO / KFO Server Emulator

面向学习与技术研究的《功夫小子》兼容服务器模拟器项目，研究网络协议、服务端架构、数据持久化及客户端互操作，包含服务端、客户端配套工具和道具管理器源码。

> **非商业 · 学习研究 · 非官方项目**
>
> 本项目不以营利为目的，不收费、不投放广告、不接受捐赠或赞助，不提供充值、付费会员、付费道具或其他变相收费服务。请勿将本项目用于商业运营或未经授权的游戏服务。

## 项目来源与致谢

OpenKFO 基于 [liuyangyi0/kungfukid-local-server](https://github.com/liuyangyi0/kungfukid-local-server) 修改和扩展，感谢原项目作者提供的基础实现。

本仓库在原项目基础上进行了目录整理、Go 服务端扩展、登录器与道具管理器集成，以及构建打包流程调整。原项目已有实现的贡献归原作者，OpenKFO 的后续修改不代表原作者的观点或背书。

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

**当前运行链路不依赖 Python**：Go + MySQL 服务端、C# 在线登录器（内嵌 Go 桥接与 C++ 登录界面）、Flutter 道具管理器（调用 Go 管理后端）。

- `server/go-server`：当前 Go 服务端、协议、数据库访问、客户端桥接和管理后端，共用一个 Go 模块。
- `toosl/item-manager`：当前 Flutter Windows 道具管理器。
- `client/launcher-online`：当前 C# 在线登录器。
- `client/client-adapter`：C++ 登录界面与客户端适配代码。
- `toosl/Start-ItemManager.cmd`：道具管理器启动入口。
- `docs`：协议与开发参考，其中部分文档描述旧本地实现。

`toosl` 为本仓库约定目录名。`server/kk_local`、`server/tests`、`requirements.txt`、`client/launcher`、旧本地启动/账号脚本以及 Go 模块中的 Python 迁移工具仅保留作历史参考；**使用当前版本无需安装 Python、创建 `.venv` 或启动旧 Python 服务**。旧迁移工具不属于下述运行流程。

## 使用前准备

本仓库提供源码，不包含可直接游玩的整包。运行前需自行准备已获必要授权的客户端、匹配的配置、证书及数据库。

| 用途 | 所需环境 |
| --- | --- |
| 构建 Go 程序 | Go 1.26.0 或满足 `server/go-server/go.mod` 的工具链 |
| 运行服务端 | MySQL 8、Go 编译产物、服务配置和 TLS 证书目录 |
| 构建 Windows 登录器 | Windows、.NET 8 SDK、Visual Studio 2022 Build Tools 的 x86 C++ 工具链 |
| 构建道具管理器 | Windows、支持 Dart `^3.13.2` 的 Flutter SDK、Windows 桌面构建工具链 |
| 使用远程道具管理器 | Windows OpenSSH 客户端、SSH 管理权限及已部署的 Go 管理后端 |

以下 PowerShell 命令均从仓库根目录执行，各步骤结束后回到根目录。只运行已构建的程序无需安装 Go、Flutter 或 Python 开发环境。

## 1. 构建并启动 Go 服务端

```powershell
New-Item -ItemType Directory -Force runtime-local/go-online | Out-Null
Push-Location server/go-server
go build -o ../../runtime-local/go-online/kungfu-server.exe ./cmd/server
go build -o ../../runtime-local/go-online/kungfu-admin.exe ./cmd/admin
Pop-Location
```

先在 MySQL 中创建独立数据库和可访问该库的账号；程序会创建所需表，不会替你创建数据库。通过当前进程的 `KK_MYSQL_DSN` 环境变量提供连接信息，格式为 `用户:密码@tcp(主机:3306)/数据库`。实际凭据不写入仓库。

准备 `runtime-local/go-online/config.json`，字段对应 `server/go-server/internal/game/rooms.go` 中的 `Config`：

- `config_hash`：客户端 `Data/config.spf2` 的 SHA-256，64 位十六进制字符串。
- `pools`：以 `模式:人数` 为键、可用地图 ID 数组为值的对象，不能为空。
- `groups`：以地图组 ID 为键、地图 ID 数组为值的对象。

这些值必须与实际客户端匹配。仓库未附带真实配置；可使用已有兼容部署的配置，首次适配新的客户端需先准备对应地图数据，不能用占位值直接启动游戏。

设置好 `KK_MYSQL_DSN` 后启动：

```powershell
.\runtime-local\go-online\kungfu-server.exe `
  -config runtime-local/go-online/config.json `
  -cert-dir runtime-local/go-online/certificates `
  -listen 127.0.0.1:19090 `
  -tls-listen 127.0.0.1:19091
```

这是本机测试监听地址。跨机器测试时，将 `-tls-listen` 改成实际需要的监听地址并配置网络访问权限。`/health` 由 HTTP 监听端口提供；游戏客户端可连接直连 TLS 端口。服务首次运行会在证书目录生成 `origin.crt` 和 `origin.key`，客户端只需要服务端证书 `origin.crt`，服务端私钥不分发。

Linux 部署时，在 Linux 下进入 `server/go-server`，执行 `go build -o kungfu-server ./cmd/server` 和 `go build -o kungfu-admin ./cmd/admin`；使用相同参数及环境变量启动。Windows `.exe` 不能直接用于 Linux。

账号通过 Go 服务端的 `-operation create-account` 创建，标准输入接收包含 `UID`、`Account`、`Password` 的 JSON。密码长度支持6～128字节。重置密码使用 `-operation reset-password`，标准输入提供同样的UID、Account、Password，仅更换密码，不修改角色和道具。操作仍需同一数据库环境变量；请使用自己的测试账号，不把实际密码放入公开文档或命令历史。服务端还提供 `import`、`wallet`、`snapshot` 操作，见 `cmd/server/main.go`。

## 2. 构建并启动在线登录器

在源码根目录统一构建 Windows 发布包：

```powershell
.\toosl\Build-Dist.ps1
```

Go 未加入 PATH 时可传入 `-Go "Go 安装目录/bin/go.exe"`。脚本构建 Go、C++、C# 和 Flutter，全部发布产物归档到源码根目录 `dist`；Flutter 使用英文临时目录编译以避开中文路径问题。

```text
dist/
  launcher/                 # 中文名登录器 EXE
  launcher-components/      # OnlineBridge.exe、LoginSkin.dll、LoginSkinHost.exe
  item-manager/             # 道具管理器完整目录，含 Go 后端、DLL 和 data
```

登录组件源码均在仓库内：Go 桥接为 `server/go-server/cmd/bridge`，C++ 登录界面为 `client/client-adapter/src/kk_login_skin*.cpp`；构建时嵌入 C# 登录器。运行时目录统一使用 `launcher-components/window-N` 和 `launcher-components/login-skin`，界面名称保留中文。

C++ 构建脚本当前使用 VS 2022 Build Tools 的默认安装路径，安装位置不同时需调整 `vcvars32.bat` 路径。

在仓库根目录准备 `bridge.json`，字段如下，实际值按自己的测试环境填写：

| 字段 | 含义 |
| --- | --- |
| `url` | `tls://服务器地址:19091`；已有 WSS 部署也可填写对应 WSS 地址 |
| `client_directory` | 已准备的客户端目录，例如 `runtime-local/client` |
| `client_sha256` | 客户端 `gfld.dat` 的 SHA-256，小写十六进制 |
| `config_hash` | 客户端 `Data/config.spf2` 的 SHA-256，与服务端配置一致 |
| `server_certificate` | 用于固定校验的服务端 `origin.crt` 路径 |
| `login_certificate`、`login_key` | 客户端本地登录接口使用的证书与私钥路径，需自行准备匹配的证书对；不是服务端私钥 |
| `login_port`、`sdk_port`、`game_port` | 可省略，默认分别为 `18084`、`18000`、`18001` |

路径相对于 `bridge.json` 所在目录解析。客户端需满足现有桥接实现要求，不能保证任意版本均兼容。准备好配置和客户端后：

```powershell
& '.\dist\launcher\功夫小子登录器.exe' --root $PWD.Path
```

`--root` 指向包含 `bridge.json` 的目录。登录器会准备各窗口的桥接组件；游戏登录使用 Go 服务端数据库中的测试账号。

## 3. 构建并启动道具管理器

运行 `toosl/Build-Dist.ps1` 后，道具管理器位于 **`dist/item-manager/kungfu_item_manager.exe`**。同目录包含 `kungfu-desktop-admin.exe`、Flutter DLL 和 `data`，发布时复制整个目录。

在 `runtime-local/online-admin.json` 中填写自己的 SSH 配置，例如：

```json
{
  "host": "your-server.example",
  "port": 22,
  "user": "your-admin-user",
  "key": "C:/Users/your-user/.ssh/kfo_admin"
}
```

当前 Go 管理后端通过 SSH 调用 Linux 服务端，要求：

- 服务端管理程序位于 `/opt/kungfu-go/kungfu-admin`。
- `/etc/kungfu-go/game.env` 保存一行 `KK_MYSQL_DSN=实际连接信息`，由服务器端读取。
- SSH 账号具备执行当前后端所需 `sudo -n` 管理命令的权限；本机已验证并记录服务器 SSH 主机密钥（程序启用严格校验）。
- 仓库根目录的 `runtime-local/client` 包含匹配的客户端配置资源，供 Go 管理后端读取道具与武器数据。

管理器不会回退到旧 Python 服务或本地 SQLite。上述配置准备好后，在根目录运行：

```powershell
.\toosl\Start-ItemManager.cmd --root "包含 runtime-local 的目录"
```

## 4. 安装到游戏目录

先完成构建和运行配置，再将发布产物安装到游戏根目录。例如当前本机：

```powershell
.\toosl\Install-Dist.ps1 -GameDirectory 'E:\功夫小子' `
  -RuntimeRoot 'E:\功夫小子\kungfukid-local-server'
```

`RuntimeRoot` 只指定现有管理配置和客户端资源的位置，不会启动其中的历史 Python 服务。其他机器请改成自己的配置目录。

安装后：

```text
功夫小子/
  功夫小子登录器.exe
  bridge.json
  launcher-components/
  item-manager/             # 完整道具管理器发布包
  打开道具管理器.cmd
  package-backups/          # 替换前的旧发布包
```

安装脚本备份原发布文件，不改数据库、游戏资源和连接配置。已运行的旧登录器需退出后重新打开，才会使用新版代码。

## 开发验证

```powershell
Push-Location server/go-server
go test ./...
Pop-Location
Push-Location toosl/item-manager
flutter test
Pop-Location
```

需要真实数据库的 Go 测试通过 `KK_TEST_MYSQL_DSN` 指向独立测试库；未配置时相关用例会跳过。测试通过不等同于客户端实机或线上部署验证。

运行配置、客户端资源、数据库、证书私钥、日志和编译产物均不提交 Git。历史 Python 代码的存在不代表它是当前版本的运行依赖。


## 本地协议调试控制台

在Windows的 `server/go-server` 目录执行 `go build -o ../../dist/local-server/kungfu-server.exe ./cmd/server`。直接双击构建的EXE即可打开服务端控制台；无需PowerShell、启动脚本或外部ssh.exe。无参数时启用本地调试模式，显式传参时仍保留原服务端/管理命令行为；Linux启动行为不变。

EXE按自身所在目录读取 `settings.private.json`（dsn、ssh_config、database）、兼容客户端的 `config.json` 和证书目录。SSH密钥来自ssh_config指向的配置文件，主机身份使用当前用户`.ssh/known_hosts`验证。Go内部建立到独立调试库的SSH隧道，DSN只能使用127.0.0.1的TCP地址，游戏服务监听本机19090/19091。数据库需要提前单独创建；此模式需要网络，不是离线数据库。Ctrl+C或关闭窗口会释放服务及隧道端口。

日志自动写入 `logs/protocol-年月日-时分秒.log`，并打印到控制台。内容包括时间、账号、角色名、UID、方向、通道、房间、状态、协议号、长度、完整hex和可解码GBK文本。TCP按完整协议包重组，UDP按完整数据报记录，广播标注各接收者。`S->C queued`只表示进入发送队列；认证凭据脱敏，认证前身份尚未确认。

命令行方式可显式使用 `-trace-protocol -protocol-log <文件>`。配置、数据库凭据、密钥和原始客户端资源均不编译进EXE或提交仓库，交付时保留对应配置文件。
