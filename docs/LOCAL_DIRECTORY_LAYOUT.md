# 本地目录

工作目录下只保留两个文件夹：

```text
client/                  游戏客户端，唯一一份
server/                  OpenKFO 仓库
  client/                登录器等客户端工具的源码，不是游戏资源
  server/go-server/      Go 服务端源码
  toosl/item-manager/    GM 管理器源码
  protocol/             协议资料
  dist/                 构建后的程序与运行配置
  runtime-local/        本机工具、证书、管理配置和武器编辑状态
  runtime-backups/      整理前差异文件、旧工程与历史备份
```

使用 `server` 下的「本地测试」「GM管理器」「线上登录器」「启动本地服务器」快捷方式。实际程序在 `dist` 内，不要单独移动 EXE。

本机登录器的 `bridge.json` 使用 `shared_client: true`，最多开启八个游戏窗口，所有窗口启动同级 `client` 内的同一个程序，不创建客户端副本。每个进程启动前使用独立互斥名称，磁盘上的游戏文件保持原样。共享网络组件按进程及创建时间区分会话；窗口账号仍分别保存。切换本地与线上环境前，应退出当前游戏窗口及网络组件。

GM 使用 `runtime-local/client-path.json` 的 `client_directory` 指定游戏目录，相对路径以仓库目录为基准；本机设置为 `../client`。武器编辑状态仍集中保存到 `runtime-local/weapon-config`，不放进游戏目录。未配置此文件时，兼容已有的 `runtime-local/client` 布局。

游戏资源、证书、私有配置和历史备份不提交 Git。目录整理只调整本机路径，不代表已部署线上服务。
