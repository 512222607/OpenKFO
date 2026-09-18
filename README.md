# OpenKFO / KFO Server Emulator

面向学习与技术研究的《功夫小子》兼容服务器模拟器项目，研究网络协议、服务端架构、数据持久化及客户端互操作，包含服务端、客户端配套工具和道具管理器源码。

> **非商业 · 学习研究 · 非官方项目**
>
> 本项目不以营利为目的，不收费、不投放广告、不接受捐赠或赞助，不提供充值、付费会员、付费道具或其他变相收费服务。请勿将本项目用于商业运营或未经授权的游戏服务。

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

账号通过 Go 服务端的 `-operation create-account` 创建，标准输入接收包含 `UID`、`Account`、`Password` 的 JSON。操作仍需同一数据库环境变量；请使用自己的测试账号，不把实际密码放入公开文档或命令历史。服务端还提供 `import`、`wallet`、`snapshot` 操作，见 `cmd/server/main.go`。

## 2. 构建并启动在线登录器

先构建 Go 桥接和 C++ 登录界面，再发布 C# 登录器：

```powershell
New-Item -ItemType Directory -Force runtime-local/go-online | Out-Null
Push-Location server/go-server
go build -o ../../runtime-local/go-online/online-launcher-dual.exe ./cmd/bridge
Pop-Location
.\client\client-adapter\build-login-skin.cmd
dotnet publish client/launcher-online/OnlineLauncher.csproj -c Release -o runtime-local/launcher-dotnet
```

每步成功后再执行下一步。C++ 构建脚本当前使用 VS 2022 Build Tools 的默认安装路径，安装位置不同时需调整脚本中的 `vcvars32.bat` 路径。

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
& '.\runtime-local\launcher-dotnet\功夫小子登录器.exe' --root $PWD.Path
```

`--root` 指向包含 `bridge.json` 的目录。登录器会准备各窗口的桥接组件；游戏登录使用 Go 服务端数据库中的测试账号。

## 3. 构建并启动道具管理器

```powershell
New-Item -ItemType Directory -Force runtime-local/item-manager-online | Out-Null
Push-Location server/go-server
go build -o ../../runtime-local/item-manager-online/kungfu-desktop-admin.exe ./cmd/desktop-admin
Pop-Location
Push-Location toosl/item-manager
flutter pub get
flutter build windows --release
Pop-Location
Copy-Item -Path 'toosl/item-manager/build/windows/x64/runner/Release/*' `
  -Destination runtime-local/item-manager-online -Recurse -Force
```

需复制完整 Release 目录内容，保留 DLL 和 `data` 等运行文件，不能只复制 EXE。

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
.\toosl\Start-ItemManager.cmd
```

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
