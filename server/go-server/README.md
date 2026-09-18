# Go 服务端

支持 Linux、macOS、Windows，使用 Go 1.26.0 和 MySQL 8。运行不需要 Python、Flutter 或 PowerShell。以下命令均在 `server/go-server` 目录执行。

## 构建

Linux/macOS：

```sh
go build -o kungfu-server ./cmd/server
go build -o kungfu-admin ./cmd/admin
```

Windows CMD：

```bat
go build -o kungfu-server.exe ./cmd/server
go build -o kungfu-admin.exe ./cmd/admin
```

`kungfu-server` 提供游戏服务；`kungfu-admin` 是 GM 远程调用的管理程序，不是另一个常驻游戏服务。原生构建生成当前系统和架构的程序，Windows EXE 不能直接在 Linux 上运行。

## 准备数据库与配置

1. 在 MySQL 创建数据库及有权访问该库的用户。本地 GM 测试库名称使用 `openkfo_debug_` 前缀，例如 `openkfo_debug_local`。
2. 设置 `KK_MYSQL_DSN`，格式为 `用户:密码@tcp(主机:端口)/数据库`。服务器启动会初始化表，不会创建数据库。凭据不要提交 Git。
3. 在当前目录准备与自己的客户端匹配的 `config.json`。

配置字段对应 `internal/game/rooms.go` 的 `Config`：

| 字段 | 内容 |
| --- | --- |
| `config_hash` | 客户端 `Data/config.spf2` 的 SHA-256，64 位十六进制 |
| `pools` | `模式:人数` 为键、地图 ID 数组为值的对象，不能为空 |
| `groups` | 地图组 ID 对应地图 ID 数组 |
| `settlement` | 首次初始化奖励的 win/loss/draw_gold 和 win/loss/draw_experience；数据库已有奖励配置时不覆盖 |

地图编号和配置校验值必须从实际兼容客户端获取，不能随便填。仓库不附带原客户端、真实配置及角色数据；全新数据库也不会自动生成演示账号。

计算客户端配置文件 SHA-256 可使用系统工具：Linux `sha256sum Data/config.spf2`，macOS `shasum -a 256 Data/config.spf2`，Windows CMD `certutil -hashfile Data\config.spf2 SHA256`。取输出中的 64 位哈希并使用小写。

## 启动

Linux/macOS（bash/zsh）：

```sh
export KK_MYSQL_DSN='kfo:替换为自己的密码@tcp(127.0.0.1:3306)/openkfo_debug_local'
./kungfu-server -config config.json -cert-dir certificates -listen 127.0.0.1:19090 -tls-listen 127.0.0.1:19091
```

Windows CMD：

```bat
set "KK_MYSQL_DSN=kfo:替换为自己的密码@tcp(127.0.0.1:3306)/openkfo_debug_local"
kungfu-server.exe -config config.json -cert-dir certificates -listen 127.0.0.1:19090 -tls-listen 127.0.0.1:19091
```

也可在终端或服务管理器中预先注入环境变量。命令中的占位密码必须替换；含 shell 特殊字符时使用适合当前 shell 的转义，勿直接照搬真实凭据到公开脚本。

首次运行会在证书目录生成 `origin.crt` 和 `origin.key`。客户端只需固定校验用的 `origin.crt`；不要分发服务端私钥。相对路径按启动命令的当前目录解析。

健康检查：

```text
curl http://127.0.0.1:19090/health
```

正常返回包含 `"service":"kungfu-go"` 和 `"status":"ok"`。这只能证明 HTTP 服务可用，仍需客户端验证登录、房间与战斗。

上面的监听地址只允许本机访问。跨机器直连需要调整 `-tls-listen` 为实际监听地址并配置网络权限；经过反向代理或隧道时可以继续只监听回环。按 Ctrl+C 停止；长期部署可使用系统服务管理器，不要求保持某种特定 shell 运行。

## 账号管理

同样设置 `KK_MYSQL_DSN`，准备仅供管理员读取的 `account.private.json`，包含 `UID`、`Account`、`Password`。密码为 6–128 字节；文件中使用自己的测试账号。

Linux/macOS：

```sh
./kungfu-server -operation create-account < account.private.json
./kungfu-server -operation reset-password < account.private.json
```

Windows CMD：

```bat
kungfu-server.exe -operation create-account < account.private.json
kungfu-server.exe -operation reset-password < account.private.json
```

两条命令按需要选一条。重置密码不修改角色和道具。不要提交该私密 JSON；用完后妥善移除。其他管理操作见 `cmd/server/main.go`。

## 协议日志

在启动命令末尾追加以下参数即可在控制台打印并写入文件，Windows 与 Linux/macOS 使用相同参数：

```text
-trace-protocol -protocol-log protocol.log
```

日志包括时间、账号、角色名、UID、收发方向、通道、房间、协议号、长度和包体 hex；认证凭据脱敏。若指定 `logs/protocol.log`，需事先创建 `logs` 目录。`S->C queued` 表示进入发送队列，不保证客户端已处理。

桥接日志另由 `bridge.json` 中的 `trace_protocol: true` 控制，写入各窗口的 `online-client.log`。

## Windows 可选：双击本地调试控制台

这是一种额外启动模式，与上面的跨平台命令行模式分开。Windows EXE 无参数启动时，读取 EXE 同目录的 `settings.private.json`、`config.json` 和 `certificates/`，自动建立到远端独立测试库的 SSH 隧道，监听本机 19090/19091 并写入 `logs/`。

`settings.private.json` 示例（必须替换为自己的配置）：

```json
{
  "dsn": "kfo:替换为自己的密码@tcp(127.0.0.1:13316)/openkfo_debug_local",
  "database": "openkfo_debug_local",
  "ssh_config": "ssh.private.json"
}
```

`ssh.private.json` 需要 `host`、`port`、`user`、`key`，以及当前用户 `.ssh/known_hosts` 中已验证的主机记录。此模式将本机数据库端口转发到 SSH 服务器的 MySQL，需要网络；它不是离线数据库。若直接使用本机 MySQL，采用上面的显式参数启动方式，不需要这个 SSH 模式。

## 修改武器配置之后

GM 的“应用到游戏”会改变客户端 `Data/config.spf2`。目前不会自动修改服务器准入配置。需同步客户端文件、登录器 `bridge.json` 和服务器 `config.json` 的 `config_hash`，然后重启读取旧配置的服务器、登录器及游戏窗口。只更新其中一处会触发配置不匹配。

## 验证

```text
go test ./...
```

数据库集成测试需要 `KK_TEST_MYSQL_DSN` 指向独立测试库，否则相关测试跳过。普通构建及测试不会替你部署线上服务。

## GM HTTPS 管理接口

macOS/Android 线上版使用独立的 `gm-api` 服务，复用现有 GM 的校验、数据库事务与审计。它只允许线上账号、道具、商城、钱包、奖励操作，不开放武器文件编辑或本地环境访问。

在本目录构建（Linux/macOS）：

```sh
go build -o gm-api ./cmd/gm-api
```

Windows 构建：`go build -o gm-api.exe ./cmd/gm-api`。

先启动游戏服务器初始化数据库表。管理接口需有对应客户端目录 `运行目录/runtime-local/client`，用于读取道具配置；由管理员自行准备，不能将官方资源上传到 Git。服务器部署的是 Go API，手机不用安装客户端资源或 SSH。

通过部署环境设置 `KK_MYSQL_DSN` 和 `KK_GM_TOKEN`。令牌应是随机生成的至少 32 字节秘密，仅交给有全部 GM 权限的管理员，不要写进安装包、Git、URL 或公开文档。替换令牌并重启 API 可撤销旧凭据。

Linux/macOS 示例（地址、目录和令牌均为占位）：

```sh
export KK_MYSQL_DSN='kfo:替换为自己的密码@tcp(127.0.0.1:3306)/自己的数据库'
export KK_GM_TOKEN='替换为自己随机生成的至少32字节管理令牌'
./gm-api -root /srv/openkfo-runtime -listen 127.0.0.1:19092
```

Windows CMD 对应使用 `set "KK_MYSQL_DSN=自己的DSN"`、`set "KK_GM_TOKEN=自己的随机令牌"`，再运行：

```bat
gm-api.exe -root "C:\kfo-runtime" -listen 127.0.0.1:19092
```

将自己的 HTTPS 管理域名 `/gm/api` 代理到 `http://127.0.0.1:19092/gm/api`，保留 Authorization 请求头。也可直接用 `-tls-cert <证书文件> -tls-key <私钥文件>` 启用 HTTPS，证书须受终端系统信任并匹配管理域名。未配置 TLS 时仅允许监听明确的回环 IP，不能将明文管理接口直接暴露公网。API 不启用 CORS，不需要浏览器网页。

应用中填 `https://管理域名/gm/api`；仅接受 HTTPS，不跳过证书校验，不跟随重定向。管理令牌作为 Bearer 请求头传递。写入请求沿用操作 ID，超时后保持原内容重试可避免重复发放；规则版本冲突仍需重新读取。

部署 API 不等于已验证游戏功能。先用自己的测试服务验证访问、读取和写入，再决定是否连接正式数据库；此新增服务不会由构建命令自动部署到线上。
