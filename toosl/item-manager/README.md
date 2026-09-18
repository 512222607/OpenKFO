# 功夫小子道具管理器

Flutter Windows 管理界面，包含道具、武器、商城及钱包管理。

在本目录执行 `flutter pub get`、`flutter test`、`flutter build windows --release`。
Go 后端位于 `../../server/go-server/cmd/desktop-admin`，构建步骤见根目录 README。
运行时通过向上查找 `runtime-local/online-admin.json` 定位配置，并调用
`runtime-local/item-manager-online/kungfu-desktop-admin.exe`。
配置、密钥和服务端账号数据需单独准备，不纳入仓库。
