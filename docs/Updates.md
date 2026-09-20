# GM 与武器配置更新

Windows GM 使用独立的 `OpenKFO.Updater.exe`。从 GM 左侧点击 **检查 GM 更新**，查看说明后更新。更新程序从临时目录运行，因此能够替换自身；保留 `gm-settings.json`、`updater-settings.json` 和其他私有配置。发布包必须包含完整 Flutter 运行目录，不能只发主 EXE。

## 武器更新

1. 在 GM 的 **武器招式配置** 编辑并保存方案。
2. 点击 **更新到线上**，填写给玩家看的武器名称、具体调整。
3. 确认后发布全部已保存方案及当前编辑内容，重启线上服务；在线玩家会断开。上传由现有 SSH 管理连接执行，不开放匿名上传接口。
4. 玩家使用新版登录器启动游戏时检查更新。更新窗口展示说明，先下载并校验，再关闭该客户端的游戏窗口和网络组件，替换 `Data/config.spf2`、同步登录器校验值。
5. 登录器内嵌的登录界面 DLL 加载到选定游戏进程，提供 **武器更新内容** 按钮。原游戏主程序不落盘修改。

下载失败不修改游戏文件；安装失败按日志回滚。更新期间不要手动启动旧登录器或游戏。正在运行的旧版登录器需要退出后再打开新版。首次接入本功能的玩家须先替换登录器，旧登录器不会自动获得此功能。

## 构建

项目根目录（Windows，安装 .NET 8 SDK）：

```text
dotnet publish toosl/updater/Updater.csproj -c Release -o dist/updater
go -C server/go-server build -trimpath -o ../../dist/launcher-components/OnlineBridge.exe ./cmd/bridge
client/client-adapter/build-login-skin.cmd
dotnet publish client/launcher-online/OnlineLauncher.csproj -c Release -o dist/online-launcher-build
go -C server/go-server build -trimpath -o ../../dist/GM管理器/kungfu-desktop-admin.exe ./cmd/desktop-admin
```

在 `toosl/item-manager` 目录：

```text
flutter build windows --release
```

将整个 `build/windows/x64/runner/Release` 目录放入 GM 发布目录，将主程序重命名为 `GM管理器.exe`，加入 Go 管理组件和 `dist/updater/OpenKFO.Updater.exe`。本机 `updater-settings.json` 填写公开 HTTPS 更新清单地址，字段为 `manifest`；此文件不放入公开发布包。

服务器（Linux）构建并安装 `cmd/server` 和 `cmd/update-publish`。发布器安装到 `/opt/kungfu-go/update-publish`，使用现有管理员 SSH 权限执行。服务环境变量 `OPENKFO_UPDATES_DIR=/opt/kungfu-go/updates`，反向代理将 `/updates/` 转发到 Go HTTP 服务。仅清单和按 SHA-256 命名的 ZIP 可公开读取；发布锁、历史清单和私有文件不对外提供。

发布 GM（项目根目录，SSH 配置沿用本机私有设置）：

```text
go -C server/go-server run ./cmd/gm-release -root ../.. -directory ../../dist/GM管理器 -notes "本次更新说明"
```

`gm-release` 只打包主程序、更新助手、Go 管理组件、根目录 DLL 和 Flutter 的 `data/`，不上传管理连接配置、密钥和日志。

## 校验

```text
go -C server/go-server test ./...
dist/updater/OpenKFO.Updater.exe --self-test
```

更新器测试覆盖文件校验、路径越界、实际替换、注入故障后的回滚和保留连接配置。真实游戏与多人退出/更新流程仍需在目标客户端上验证。
