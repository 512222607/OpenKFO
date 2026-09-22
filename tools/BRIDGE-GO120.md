# 网络桥 Go 1.20 构建

仅 `OnlineBridge.exe` 使用 Go 1.20.14，游戏服务器保留主模块工具链。

1. 从 Go 官方下载 `go1.20.14.windows-amd64.zip`，校验官方 SHA-256，解压到 `runtime-local/go120`（应存在 `go/bin/go.exe`）。
2. 在仓库根目录执行 `powershell -NoProfile -ExecutionPolicy Bypass -File tools/Build-BridgeGo120.ps1`。
3. 输出为 `dist/launcher-components/OnlineBridge.exe`，随后重新打包启动器，才能更新其内置组件与文件校验清单。

构建固定 windows/amd64、CGO_ENABLED=0，使用独立的 `server/go-server/bridge-go120.mod` 和 `.sum`，不降低游戏服务器依赖。编译器版本不匹配直接失败。Build-Dist 和 Build-FlutterLauncher 均调用此流程。

这是 Win7 **64 位网络桥**的兼容构建，不等于整个启动器已通过 Win7 验证。Flutter 引擎、.NET 启动器、更新器、登录组件需要分别验证。32 位 Windows 不能运行该 EXE。仍需 Win7 实机验证启动、TLS 登录、TCP/UDP 和多开；不要仅凭编译成功宣称全功能兼容。

## Flutter Win7 测试包

Flutter 启动器固定使用 3.16.9 / Dart 3.2.6，插件版本与 pubspec.lock 一起保存。默认工具链目录是 `E:/OpenKFO-Flutter3169/flutter`，也可用 `--flutter` 指定其他目录，但必须是 3.16.9。

`python tools/Build-FlutterLauncher.py --version <新版本号> --config-hash <服务器接纳的客户端SHA256>`

LauncherSupport（含辅助更新功能）同样用 Go 1.20.14；窗口程序、文件选择插件采用静态 CRT。原生登录 OpenSSL 的 x86 运行库单独放在 `launcher-files/runtime-x86`，启动前校验并释放到游戏目录。VC 运行库来源为微软签名的 VS2019 x86 redist（14.29.30157），UCRT 为 Windows SDK 的 app-local 10.0.10240.16384。不得换成仅支持新系统的 VC redist。

构建准备：从 https://aka.ms/vs/16/release/vc_redist.x86.exe 下载并核对微软签名，从包中提取 vcruntime140.dll 到 `runtime-local/vc2019-minimum/`；UCRT 取自 `C:/Program Files (x86)/Windows Kits/10/Redist/ucrt/DLLs/x86`。组件与完整包均生成哈希清单。

2026-09-22：代码检查、8 项 Flutter 测试、Go 网络桥及辅助程序测试、54 个组件哈希、ZIP CRC、常见新版 Windows API 静态导入检查通过。未在 Win7 实机运行；未发布线上。此次不修改游戏服务器。
