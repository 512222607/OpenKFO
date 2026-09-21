# 玩家启动器发布包

本项目仅支持经过校验的老登客户端 `gfld.dat`，不再支持 `gfxz.dat`。`login/` 是另一套独立项目，源码与构建产物不要混用。

玩家将 ZIP 内的 `启动器.exe` 放到已有游戏目录（与 `Data` 文件夹同级）即可打开；首次打开自动准备连接配置、证书及内置 `gfld.dat`（仅缺失时释放，现有文件不匹配则报错，不覆盖），启动游戏时释放登录界面 DLL、网络组件，更新时释放辅助更新 EXE。无需另装 .NET，也无需手动复制 DLL。

## 发布顺序

先用一份已验证的线上客户端配置准备嵌入资源（只提取连接字段和必要证书，不带账号记录）：

```powershell
./tools/Prepare-LauncherBundle.ps1 -ClientDirectory /path/to/verified-client
```

这里的 `login.key` 是客户端回环登录桥使用的配套密钥，不是线上服务器 TLS 私钥。不要提供服务器或管理端配置。

在 `server/go-server` 下构建网络组件，再回到仓库根目录构建更新助手和启动器：

```sh
go build -o ../../dist/launcher-components/OnlineBridge.exe ./cmd/bridge
```

```sh
dotnet publish tools/updater/Updater.csproj -c Release -o dist/updater
dotnet publish launcher/launcher-online/OnlineLauncher.csproj -c Release -o dist/launcher
```

`LoginSkin.dll` 与 `LoginSkinHost.exe` 也需先按 `launcher/client-adapter/build-login-skin.cmd` 构建到 `dist/launcher-components`。全部组件嵌入启动器，不需要散放在分发 ZIP 中。准备脚本还会提取并校验自定义登录所需的 `SDError.dll`、`libssl-1_1.dll`、`libcrypto-1_1.dll`；只包含 LoginSkin 外观 DLL 不足以替换盛大登录。

启动游戏前会按哈希修复这三份组件，原 DLL 保存到游戏目录下 `launcher-components/native-login-backups/原文件哈希/`。如果游戏正在占用文件，先退出游戏再重试。

## 行为与边界

- 缺失默认配置、证书时自动恢复；已有本地或自定义配置保留。
- 账号仍保存在系统 LocalAppData 下，不进入发布包。
- 同一游戏目录可以多窗口运行，不复制多份客户端。
- GPK 兼容处理仅在已校验客户端的挂起进程内执行；失败则终止本次新建进程，不修改磁盘上的游戏主程序。
- GPK 初始化参数和调用一起跳过，四处对象回调同时跳过。仍保留原有登录认证、重登和端口配置；不搬用 `gfxz.dat` 的 session 代码洞。
- `GPKitClt.dll` 是原客户端导入依赖，不能因此删除；当前处理阻止的是初始化及对象回调，并不声称阻止 DLL 被 Windows 装载。
- 不把新的主程序 ZIP 上传成客户端资源更新；通过登录器发布通道发布，避免下次启动被旧版覆盖。

## 客户端连接配置

`Resources/client-config.xml` 作为资源嵌入启动器。启动游戏前统一生成 `Data/config.xml` 与 `server.ini`，本机地址固定为 `127.0.0.1`，端口与该窗口网络桥一致。已有不同配置先备份到 `launcher-components/connection-backups/<SHA256>/`，再原子替换；不改动资源包 `config.spf2` 或线上地址配置 `bridge.json`。共享多开使用同一组监听端口，并按进程身份关联各自会话。

内置区服表只有一个区，因此同时把 `Settings.xml` 的 `LoginServer Index` 归零，避免原客户端保留的索引 2 导致空地址和端口 0。只修改选区字段，其他用户设置保留；旧设置同样按哈希备份。
