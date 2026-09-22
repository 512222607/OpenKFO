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

## 本地高帧试验版

`dotnet publish launcher/launcher-online/OnlineLauncher.csproj -c Release -p:DefineConstants=LOCAL_FRAME_PREVIEW -o dist/launcher-fps-preview` 构建本地试验入口；该编译标记仅跳过启动器自身的线上更新检查，避免被线上旧版替换。客户端资源更新检查仍保留。正式发布不得使用此标记。

- 默认普通模式，可勾选高帧模式（8ms × RenderIntervel，上限约 125 FPS）。只修改新建挂起进程的已验证指令，不改磁盘 gfld.dat，也不修改 QPC 时间倍率。
- 高帧模式在游戏主循环起止配对调用 timeBeginPeriod(1)/timeEndPeriod(1)。后台遮挡、显示驱动及实际渲染耗时仍可能限制帧率。
- FPS 统计 Direct3D9 device/swap-chain Present 成功返回次数，每半秒刷新。窗口模式顶部居中、点击穿透，跟随游戏窗口显示和最小化；不是显示目标帧率。
- FPS 显示使用启动器自带的 `--fps-overlay` 子进程，关闭启动器不会关闭它；游戏退出时自动退出。无额外 DLL 或运行库安装。
- 两个开关对新启动窗口生效；已打开的游戏需退出后重新启动。此实验依赖共享多开路径，旧复制目录模式不启用。
- 原生计数器执行验证：先以 `KFO_FRAME_CODE_FILE` 指定输出路径运行 Go `TestPresentCounterCode`，再用 MSVC x86 编译并运行 `launcher/client-adapter/src/kk_frame_counter_test.cpp`，参数为输出文件。
- 显式真实启动测试：设置 `KFO_FRAME_SMOKE_IMAGE` 为已校验的本地 gfld.dat，运行 Go `TestPerformanceClientSmoke`；只终止测试自身创建的进程，不登录账号。
