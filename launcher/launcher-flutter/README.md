# Flutter Windows 启动器

独立 Flutter 项目，不使用 HTFlutter 业务项目，也不依赖 .NET。游戏联网仍由原有 OnlineBridge.exe 处理。

## 从构建到使用

1. 在仓库根目录运行 `python tools/Build-FlutterLauncher.py --version <新版本号>`。执行检查、测试、Windows Release 构建与 Go 辅助组件测试，生成完整 ZIP 和文件更新清单；不会上传。
2. 完整解压 ZIP 到游戏目录，与 Data/config.spf2 同级。不能仅复制启动器.exe，不要覆盖正在运行的程序。
3. 点击启动器.exe。自动准备登录组件、gfld.dat、连接配置和证书。现有连接配置保留，修改登录文件前备份；文件占用时提示，不强杀游戏。
4. 选择窗口，填写账号后启动。注册由服务器完成。账号按连接环境和窗口保存在本机用户目录，兼容旧版 AES-GCM / Windows DPAPI 记录。

## 文件职责

- 启动器.exe：Flutter Windows 入口；未完成的更新优先交给辅助程序恢复。
- data/app.so：Dart 界面和启动管理逻辑，可单独更新。
- flutter_windows.dll、其他运行 DLL：完整包附带 Flutter/VC 运行库。
- LauncherSupport.exe：Go Windows 辅助程序，提供加密账号存取、进程校验、账号填写和 FPS 窗口；复制为临时 UpdateHelper.exe 后替换更新文件。
- launcher-files/：待自动安装的登录组件、证书、gfld.dat 和默认配置。files.json 校验这些文件，不存玩家账号。
- launcher-components/：游戏目录下自动生成的工作组件、窗口状态、日志和备份。

## 更新发布

`dist/launcher-flutter-feed-<版本>/launcher-flutter.json` 是新清单，`files/<SHA256>.bin` 是文件内容。经过确认后，先上传 files 到配置的 updates/files/，最后原子替换 updates/launcher-flutter.json。

校验本地文件，只下载缺失或变化文件；全部下载校验成功才退出替换。更新助手在临时目录运行，保留备份和 journal。保留 .flutter-update-pending 和临时目录，可在下一次打开时恢复未完成更新。

旧 .NET 启动器读取 launcher.json，新 Flutter 使用 launcher-flutter.json，避免相互覆盖。首次迁移使用完整 Flutter ZIP；本次没有制作或发布旧 .NET 自动迁移包。

客户端资源兼容 client.json / weapons.json；更新前要求关闭全部游戏窗口。启动器更新可跳过；客户端资源更新需完成后再启动。

## 验证

自动测试覆盖组件恢复、选区保留、目录提示、小窗口布局、单文件下载、损坏文件拒绝、加密账号和历史 DPAPI 兼容。`dart run tool/smoke.dart <发布目录>` 验证真实服务 TLS 连接与本机账号读取，输出不包含密码。

游戏内登录、多开、FPS 画面和客户端更新后的完整游戏行为仍需游戏实测，编译成功不代替实测。

## 更新详情和日志

更新界面显示当前文件、文件数量、已下载字节/总字节，以及下载、校验、解压、安装阶段的进度。窗口日志可复制预览或选择保存位置导出完整 TXT；TXT 使用 UTF-8 BOM，导出保留中文并隐藏网络地址。
