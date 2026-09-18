# 功夫小子道具管理器

Flutter Windows 管理界面，包含道具、武器、商城及钱包管理。

在源码根目录执行 `toosl/Build-Dist.ps1`，完整产物位于 `dist/item-manager`。
Go 后端位于 `../../server/go-server/cmd/desktop-admin`，构建步骤见根目录 README。
运行时通过向上查找 `runtime-local/online-admin.json` 定位配置，并调用
同目录的 `kungfu-desktop-admin.exe`。也可使用 `--root <运行配置目录>` 明确指定管理配置和资源位置。
配置、密钥和服务端账号数据需单独准备，不纳入仓库。
