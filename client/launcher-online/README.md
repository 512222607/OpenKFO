# 功夫小子在线登录器

C# / .NET 8 WinForms 登录器，内嵌 Go 网络桥接器和 C++ 登录界面组件。
支持多窗口客户端目录和端口隔离，读取运行目录下的 `bridge.json`。

完整构建步骤见仓库根目录 [README](../../README.md)。
运行仍需要自行提供游戏文件、连接配置及受信任证书。

开发参数：`--root <主配置目录>`、`--self-test`、`--preview <PNG路径>`、`--start 1,2`。
