# GM 与客户端更新

Windows GM 使用独立的 `OpenKFO.Updater.exe`。从 GM 左侧点击 **检查 GM 更新**，查看说明后更新。更新程序从临时目录运行，因此能够替换自身；保留 `gm-settings.json`、`updater-settings.json` 和其他私有配置。发布包必须包含完整 Flutter 运行目录，不能只发主 EXE。

## 客户端更新

1. 在 GM 的 **武器招式配置** 编辑并保存方案。
2. 点击 **更新到线上**，填写给玩家看的武器名称、具体调整。
3. 确认后发布全部已保存方案及当前编辑内容，重启线上服务；在线玩家会断开。上传由现有 SSH 管理连接执行，不开放匿名上传接口。
4. 玩家使用新版登录器启动游戏时检查更新。更新窗口展示说明，先下载并校验，再关闭该客户端的游戏窗口和网络组件，替换 `Data/config.spf2`、同步登录器校验值。
5. 客户端资源更新界面和执行逻辑直接编入 C# 登录器。点击启动游戏时先检查，取消或失败则不启动；登录器提供“客户端更新说明”；登录界面 DLL 仅负责保留定制登录样式，不包含更新功能。GM 自身更新继续使用独立辅助 EXE。

下载失败不修改游戏文件；安装失败按日志回滚。更新期间不要手动启动旧登录器或游戏。正在运行的旧版登录器需要退出后再打开新版。首次接入本功能的玩家须先替换登录器，旧登录器不会自动获得此功能。

## 构建

项目根目录（Windows，安装 .NET 8 SDK）：

```text
dotnet publish tools/updater/Updater.csproj -c Release -o dist/updater
go -C server/go-server build -trimpath -o ../../dist/launcher-components/OnlineBridge.exe ./cmd/bridge
launcher/client-adapter/build-login-skin.cmd
dotnet publish launcher/launcher-online/OnlineLauncher.csproj -c Release -o dist/online-launcher-build
go -C server/go-server build -trimpath -o ../../dist/GM管理器/kungfu-desktop-admin.exe ./cmd/desktop-admin
```

在 `gm` 目录：

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

## 发布其他客户端资源

将本次要替换的资源放入独立目录，保持游戏内相对路径，并始终带上完整 `Data/config.spf2`。支持 Data、effect、GPK、HostWidgets、SDO、spdata、UI、Weapon 下的资源及根目录运行库 DLL。不覆盖 bridge.json、证书、账号记录和主程序 gfld.dat；主程序版本变更还需核对登录器的版本校验与多开兼容代码。

```text
go -C server/go-server run ./cmd/gm-release -kind client -root ../.. -directory ../../dist/client-update -notes "客户端资源更新说明"
```

新发布类型为 client，统一使用 `/updates/client.json`；GM 武器编辑仍使用兼容请求，由新版发布器合并后发布到这个清单。新版登录器仅在新清单返回 404 时回退旧 weapons.json，不在网络或校验失败时跳过更新。首次使用通用发布前需部署支持 client 类型的 server 和 update-publish，并更新 GM 管理后端；旧登录器需先更换。单包压缩上限 256 MiB、解压上限 512 MiB，适用于增量资源更新；超过限制需分版本或重新分发完整包。发布器会保留上一个客户端包的资源，将本次同路径文件替换后组成累计包，保证跳版本也能更新；暂不支持删除旧资源。

## 登录器自身更新

线上登录器打开时自动释放并运行独立 `OpenKFO.Updater.exe`，先读取 `/updates/launcher.json`。助手下载并校验后只关闭目标登录器，备份、替换该 EXE，再按原配置目录重新打开。失败回滚；不会为更新登录器而关闭游戏。本地调试入口不强制联网检查。首次清单尚未发布（404）时正常打开登录器，其他检查错误需重试。

将要发布的单个登录器 EXE 在发布目录中命名为 `launcher.exe`，不要放私有配置。助手安装时保留玩家原来的线上/本地 EXE 文件名。

```text
go -C server/go-server run ./cmd/gm-release -kind launcher -root ../.. -directory ../../dist/launcher-release -notes "登录器更新说明"
```

构建顺序为先 `dotnet publish tools/updater/Updater.csproj -c Release -o dist/updater`，构建登录界面组件后再构建登录器。更新助手嵌入登录器便于首次分发，运行时是独立进程；与客户端资源更新共用校验和回滚实现，不使用注入 DLL。
