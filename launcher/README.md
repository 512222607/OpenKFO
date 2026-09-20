# 登录器源码

- `launcher-online/`：当前本地和线上登录器，共用 C# / .NET 8 源码。
- `client-adapter/`：定制登录界面及客户端适配组件，C++；仅负责登录样式，更新由登录器和独立更新助手处理。
- `protocol-tester/`：独立协议测试 APP，C#。
- `launcher/`：历史启动器，仅保留参考。

构建命令见[仓库说明](../README.md#windows-登录器)。游戏资源由使用者自行准备，不放在此目录。网络桥接组件复用 `server/go-server` 的 Go 模块，避免复制协议实现。
