# 单客户端多开

登录器配置启用 `shared_client: true` 后，各窗口共用 `client_directory`。源码仍兼容旧副本模式，但本机入口不再使用它。

实现位置：

- `launcher/launcher-online/InstanceManager.cs`：窗口独立保存账号，使用进程 ID 和创建时间识别窗口，向共享网络组件提交窗口启动请求。
- `server/go-server/internal/bridge/shared_windows.go`：以挂起状态创建经过校验的游戏进程，核对内存中的 `KungfuKid`，写入基于进程 ID 的独立名称，再恢复线程。失败时终止刚创建的进程，不修改游戏磁盘文件。
- `server/go-server/internal/bridge/bridge_windows.go`：共用本地监听端口，以经过校验的进程身份选择 TCP、UDP 和重新登录会话。

当前客户端核验记录：SHA-256 `98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b`；互斥名称位于虚拟地址 `0x00BD0210`，文件偏移 `0x007CE610`。创建互斥后，客户端将句柄保存到 `0x017C8BB4`，与参考代码 `GameMoreOpen()` 使用的句柄位置一致。版本变化后必须重新核验，不可直接沿用地址。

## 加载线程退出修正

2026-09-18 第二窗口卡死现场：主线程在 `98D679 → A69505 → 6452B1 → 648813 → quartz.dll` 等待媒体线程退出；媒体线程在 `SDError.dll` 的 CRT 退出清理中等待锁。该锁记录的拥有线程已不存在。此时客户端主时钟不再推进。

加载线程在 `A1661F` 设置 `17C87DC=1` 后返回，主线程 `98DE46` 等到该标记后却在 `98DE73` 调用 `TerminateThread`，可能在 DLL 线程退出清理期间强杀线程，遗留已占用的锁。

`internal/bridge/client_patch_windows.go` 在新游戏进程恢复执行前，核验并替换 `98DE6A` 的15字节块：将 `TerminateThread(handle,0)` 改为 `CloseHandle(handle)`，让已完成工作的线程正常退出。调用栈参数数量同步修正，并恢复内存保护、刷新指令缓存。原 DLL、磁盘上的游戏 EXE、音乐和地图资源不修改；已卡住的进程必须重新启动，不能靠这个补丁恢复遗留锁。

测试覆盖原字节不匹配时拒绝修改，以及实际 Windows 内存写入。双窗口实机加载仍需复测，单元测试不能替代此验证。

自动检查覆盖共享客户端不创建副本、不改写游戏文件、连接按进程生命周期隔离，以及旧连接关闭不影响另一个窗口。实际双开登录、进房和战斗需要运行游戏验证；编译通过不等于完成这些验证。
