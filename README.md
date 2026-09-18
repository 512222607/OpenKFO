# OpenKFO

功夫小子服务端、客户端配套代码及道具管理器源码。

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
