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


## 目录

- `server/kk_local`、`server/tests`：Python 本地服务端及测试，保留 `server.kk_local` 模块路径。
- `server/go-server`：Go 在线服务端、协议、数据库访问，以及共用同一 Go 模块的客户端桥接和道具管理器后端。
- `toosl/item-manager`：Flutter Windows 道具管理器源码及测试。
- `toosl/*.ps1`、`toosl/*.cmd`：启动、账号管理及部署脚本。
- `client/client-adapter`：C++ 客户端适配和登录界面。
- `client/launcher`、`client/launcher-online`：本地及在线 C# 登录器。
- `docs`：协议和开发参考。

`toosl` 为本仓库约定目录名。Go 桥接和管理器后端保留在 Go 模块内，以保持 internal 包访问规则和构建方式。

## 验证与构建

在仓库根目录执行 Python 检查：

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -m unittest discover -s server/tests
```

Go 版本见 `server/go-server/go.mod`：

```powershell
cd server/go-server
go test ./...
go build ./cmd/server
```

道具管理器：

```powershell
cd toosl/item-manager
flutter pub get
flutter test
flutter build windows --release
```

在线登录器需要先从源码构建嵌入组件。在仓库根目录执行：

```powershell
New-Item -ItemType Directory -Force runtime-local/go-online
Push-Location server/go-server
go build -o ../../runtime-local/go-online/online-launcher-dual.exe ./cmd/bridge
Pop-Location
.\client\client-adapter\build-login-skin.cmd
dotnet publish client/launcher-online/OnlineLauncher.csproj -c Release -o runtime-local/launcher-dotnet
```

道具管理器使用的 Go 后端可在 `server/go-server` 下执行：

```powershell
go build -o ../../runtime-local/item-manager-online/kungfu-desktop-admin.exe ./cmd/desktop-admin
```

运行时资源和配置需自行准备于根目录 `runtime-local`。脚本从自身位置定位仓库根目录。仓库不包含游戏安装包、资源包、数据库、账号数据、私钥、日志或编译产物；Windows 工程保留必要的应用图标。提交源码不代表已经完成客户端游戏运行或线上部署验证。
