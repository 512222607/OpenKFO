# 配置填写：按运行模式选，不要全部照抄

与根目录[运行步骤](../README.md)配合使用。示例不含真实连接信息；`REPLACE_...`、密码、哈希、客户端物品/地图编号必须替换。JSON不要写注释，Windows路径使用`/`或双反斜杠。

## 1. 先选模式

| 模式 | 需要的配置 | 启动方式 |
| --- | --- | --- |
| 本机MySQL，普通命令运行服务器 | 环境变量KK_MYSQL_DSN、config.json、服务器证书目录 | 运行带-config等参数的Go服务器 |
| Windows日志窗口一键启动，SSH连接远端独立测试库 | settings.private.json、ssh.private.json、config.json、服务器证书目录 | 窗口启动无参数Go工作进程 |
| Windows GM本地模式 | gm-settings.json、含dsn/database的settings.private.json、客户端资源 | 先运行服务器建表，再开GM |
| Windows GM线上模式 | gm-settings.json、root/runtime-local/online-admin.json | 通过SSH运行远端kungfu-admin |
| 游戏登录器 | bridge.json；可选bridge.local.json；引用的证书和游戏目录 | 双击登录器 |
| GM手机/Mac线上模式 | 应用内填写HTTPS API和令牌 | 先部署GM API，不使用本机SSH配置 |

**服务器和GM共用dsn/database；ssh_config仅在服务器需要SSH转发时填写。** 本机MySQL不需要SSH，支持普通命令或Windows日志窗口启动。

本地和线上统一使用`kungfu_game`，数据隔离依靠不同MySQL实例。不同域名、端口转发如果最终指向同一实例，并不会隔离数据。自动化数据库测试仍使用专用`openkfo_debug_`库，以防测试清理业务数据。

## 2. 数据库连接：KK_MYSQL_DSN

```text
kfo:REPLACE_WITH_PASSWORD@tcp(127.0.0.1:3306)/kungfu_game
```

`kfo`是MySQL用户，不是游戏账号；密码是数据库密码；括号内是数据库地址；最后是数据库名。创建方法见[数据库说明](DatabaseSchema.md)。命令行服务器读取环境变量，不会自动读取GM的settings.private.json。

Windows CMD：

```bat
set "KK_MYSQL_DSN=kfo:REPLACE_WITH_PASSWORD@tcp(127.0.0.1:3306)/kungfu_game"
```

bash/zsh：

```sh
export KK_MYSQL_DSN='kfo:REPLACE_WITH_PASSWORD@tcp(127.0.0.1:3306)/kungfu_game'
```

## 3. settings.private.json

### 本机MySQL，供服务器和GM本地模式读取

Windows无参数启动时保存到kungfu-server.exe同目录，再让gm-settings.json的local_settings指向它：

```json
{
  "dsn": "kfo:REPLACE_WITH_PASSWORD@tcp(127.0.0.1:3306)/kungfu_game",
  "database": "kungfu_game"
}
```

`database`必须与DSN最后一段相同；GM要求回环连接地址，不限制库名前缀。Windows服务器无参数启动时，不填`ssh_config`就直连此数据库；填写则建立SSH转发。

### Windows日志窗口一键启动，远端独立测试库

将以下文件保存到`kungfu-server.exe`同目录：

```json
{
  "dsn": "kfo:REPLACE_WITH_PASSWORD@tcp(127.0.0.1:13316)/kungfu_game",
  "database": "kungfu_game",
  "ssh_config": "ssh.private.json"
}
```

- `13316`是本机SSH隧道监听端口，需空闲；目标数据库在SSH服务器的回环3306端口。
- `ssh_config`相对服务器EXE目录解析；`config.json`、`certificates/`也放该目录。
- GM可引用同一个settings文件，但必须先启动服务器建立隧道；GM不会建立隧道。
- 不要同时让另一个SSH进程占用13316，重复启动会报端口占用。

对应`ssh.private.json`：

```json
{
  "host": "your-server.example",
  "port": 22,
  "user": "your-ssh-user",
  "key": "C:/Users/your-user/.ssh/openkfo_debug"
}
```

`host/user/port`是SSH连接，不是MySQL账号。`key`指向SSH私钥；此启动器支持相对ssh.private.json目录解析的密钥路径，建议写绝对路径。当前读取的是可直接解析的私钥，未提供口令交互。

先用系统SSH连接并核对服务器指纹，写入当前用户的`.ssh/known_hosts`。程序严格校验known_hosts，不能把关闭校验当成配置修复。SSH账号需允许转发到服务器的数据库端口。测试库与线上正式库必须分开。

## 4. config.json：客户端匹配配置

命令行通过`-config`指定；Windows双击模式读取服务器EXE同目录文件。

下面是**待补全的结构模板，不能直接运行**：

```json
{
  "config_hash": "REPLACE_WITH_64_LOWERCASE_HEX_SHA256",
  "pools": {},
  "character_choices": [],
  "groups": {},
  "settlement": {
    "win_gold": 0,
    "loss_gold": 0,
    "draw_gold": 0,
    "win_experience": 0,
    "loss_experience": 0,
    "draw_experience": 0
  }
}
```

填写顺序：

1. 计算客户端`Data/config.spf2`的SHA-256并填config_hash。Windows CMD用`certutil -hashfile Data\config.spf2 SHA256`；Linux用`sha256sum`；macOS用`shasum -a 256`。命令在客户端目录执行。
2. pools填`"模式:人数": [地图ID]`，模式和地图必须经过该客户端验证；不能为空。groups是可选地图分组。
3. character_choices是记录数组，每条含`gender`（1或2）、`slot`（0–6）、`choice`（非零候选编号）、`item`（非零客户端物品模板ID）。同一gender/slot/choice不能重复；每种开放性别应配置完整七槽供创建角色。choice和item不是同一概念，不要把背包实例号填进来。
4. 七槽按创建协议为头发/帽子、脸型、上衣、手套、裤子、鞋子、武器；注意这是创建候选的0–6序号，不是背包装备槽2–8。
5. settlement仅用于首次初始化数据库奖励规则；之后GM保存的数据库配置优先。其他高级字段以[Config](../server/go-server/internal/game/rooms.go)及对应Validate方法为准。

可从已验证、与客户端版本一致的部署配置开始修改；没有这些资料时，应先提取并核对客户端配置，不能用示例数字假装可运行。

## 5. bridge.json：登录器连接

放在登录器EXE同目录。以下是本地连接模板（替换哈希，准备证书）：

```json
{
  "url": "tls://127.0.0.1:19091",
  "client_directory": ".",
  "shared_client": true,
  "client_sha256": "REPLACE_WITH_GFLD_DAT_SHA256",
  "config_hash": "REPLACE_WITH_CONFIG_SPF2_SHA256",
  "server_certificate": "certificates/origin.crt",
  "login_certificate": "certificates/login.crt",
  "login_key": "certificates/login.key",
  "trace_protocol": true
}
```

- client_directory相对配置目录；同目录游戏填`.`。完整游戏目录必须包含gfld.dat和Data资源。
- server_certificate为第3步服务器生成的公有证书；**不要把服务器origin.key复制给玩家**。
- login_certificate/login_key是桥接本地HTTPS登录服务专用的匹配PEM证书和私钥，不与服务器私钥混用。登录器自动将登录证书准备为游戏需要的zz.crt。准备方法和代码见[登录器](../launcher/launcher-online/README.md)、[InstanceManager](../launcher/launcher-online/InstanceManager.cs)。
- 线上修改url为自己的`tls://游戏主机:端口`或`wss://域名/kk/tunnel`，并使用匹配的服务器证书。不要同时改成本地数据库地址。
- 线上入口读取bridge.json；名含“本地”/“线下”的登录器优先读取bridge.local.json，缺失时回退bridge.json。两份文件可共用同一游戏目录。
- 登录器为每个窗口生成桥接端口/控制目录；普通用户不需要手填login_port/sdk_port/game_port。
- `tls`和`wss`的更新行为不同：当前登录器的在线自动更新检查针对非回环wss入口，由代码推导同主机HTTPS更新地址，不应假设所有入口都会检查更新。

## 6. gm-settings.json：GM找到资源与本地库

放在GM管理器EXE同目录：

```json
{
  "root": "C:/openkfo-runtime",
  "local_settings": "C:/openkfo-runtime/settings.private.json"
}
```

root是管理资源根目录，不是Go源码目录，也不是服务器网址。准备：

```text
C:/openkfo-runtime/
  settings.private.json
  runtime-local/
    client/                     # 指向合法取得的客户端，含Data/config.spf2
    online-admin.json           # 仅Windows GM线上模式需要
```

可将runtime-local/client链接到已有客户端，避免复制多份。示例绝对路径可改成自己电脑的路径；GM也支持相对EXE目录解析root/local_settings。客户端图标缺失会显示占位图。

## 7. online-admin.json：Windows GM线上管理

放到`root/runtime-local/online-admin.json`：

```json
{
  "host": "your-server.example",
  "port": 22,
  "user": "your-admin-user",
  "key": "C:/Users/your-user/.ssh/openkfo_admin"
}
```

这里建议key使用绝对路径：GM远程实现直接交给SSH检查，不套用服务器ssh.private.json的相对路径规则。Windows需可用的ssh命令、已核实的known_hosts及可非交互使用的密钥。

当前Go管理后端固定远端入口：`/opt/kungfu-go/kungfu-admin`，环境文件`/etc/kungfu-go/game.env`，文件中设置`KK_MYSQL_DSN=自己的正式库DSN`。SSH用户需要与部署策略匹配的非交互sudo权限；这些路径不是online-admin.json中的可配置字段。不要把SSH密钥、此文件或game.env打进玩家包。

## 8. 更新与GM HTTPS API

GM的`updater-settings.json`放EXE同目录，启用自己的HTTPS更新服务时才需要：

```json
{
  "manifest": "https://updates.example/gm.json"
}
```

同目录要有OpenKFO.Updater.exe。地址必须返回更新清单，不是ZIP或游戏接口。更新清单格式由[UpdateEngine.cs](../tools/updater/UpdateEngine.cs)定义，应使用项目发布工具生成，不能只上传一个EXE就填写地址。

当前登录器非回环wss入口自动推导同主机`/updates/launcher.json`、`/updates/client.json`；此行为不由GM的updater-settings.json控制。详细限制以[InstanceManager.cs](../launcher/launcher-online/InstanceManager.cs)为准。

手机/Mac GM在应用内填写管理API地址和令牌，不读取上述SSH文件。API环境变量及启动方式见[GM HTTPS API](../server/go-server/README.md#gm-https-管理接口)。

## 9. 出错时先核对这几项

| 现象 | 先查 |
| --- | --- |
| unknown database / access denied | MySQL库是否创建、用户权限、DSN密码和库名 |
| 空库建表外键失败 | 先按DatabaseSchema说明导入有依赖顺序的SQL |
| debug DSN被拒绝 | 回环地址、database非空且与DSN一致 |
| SSH handshake / known_hosts错误 | SSH主机、端口、密钥和已核实指纹，不是游戏密码 |
| 本机隧道端口占用 | 是否已有同端口的服务器/SSH隧道 |
| invalid game configuration | config_hash、非空pools及有效character_choices |
| client file mismatch | gfld.dat/config.spf2的实际哈希和配置一致性 |
| 游戏登录失败但服务器健康 | 游戏登录证书、zz.crt、桥接日志、账号认证链 |
| GM能打开但读不到数据 | Go后端EXE、gm-settings路径、目标库、服务端是否已建表 |

真实配置、密码和密钥只保存在运行目录；提交Git前核对文件清单。本说明不会创建或修改线上账号、数据库或服务。


## 登录器记住账号与更新

账号记录存于 `%LOCALAPPDATA%/OpenKFO/Launcher/<服务器地址摘要>/window-N/credentials.bin`，本地与线上隔离，不随游戏包分发。旧的 `launcher-components/window-N/credentials.bin` 首次读取时迁移，校验成功才移除旧文件。

服务器 `config.json` 可设置 `launcher_credentials_key`：16位可打印ASCII字符，例如 `ExampleKey123456`（示例必须自行替换为16位值）。不配置时登录器使用EXE内置随机默认值。该配置经HTTPS或校验证书的TLS健康接口下发，是客户端分发密钥，不是服务器认证凭据。保存采用AES-128-GCM随机nonce，密钥由Windows当前用户DPAPI保护；更改服务器密钥不影响旧记录读取。记录无法跨Windows用户直接搬迁。

线上WSS登录器通过同域名HTTPS检查 `/updates/launcher.json`、`/updates/client.json`。TLS直连登录器保留原有不自动检查HTTPS更新的行为，避免更新网络不可用导致游戏无法打开；升级可用独立更新助手（需要HTTPS更新地址可达）：同目录 `launcher-update.json` 指定 `launcher`（待更新EXE）、`root`（bridge配置目录）、`manifest`（HTTPS清单URL），双击助手后确认下载更新。助手保留原文件名及连接配置，并在替换后重新打开登录器。

### 游戏直连与更新入口分离

登录器 `bridge.json` 支持独立的 HTTPS 更新目录：

```json
{
  "url": "tls://game.example:19091",
  "update_base_url": "https://updates.example/updates/"
}
```

这是配置片段，应合并到现有配置中，保留客户端路径、证书和资源校验等字段。`update_base_url` 必须以 `/` 结尾。配置该字段后，线上 TLS 登录器也会检查登录器及客户端更新；本地回环服务器不启用。游戏域名使用直连解析，更新域名可以使用 HTTPS 下载服务或代理，两者无需共用入口。

发布清单可携带 `game_endpoint` 和 `update_base_url`，让新版更新助手在替换登录器时同步迁移连接配置；配置与 EXE 一起备份、失败一起回滚。迁移保留 `credentials_scope`，避免换域名后丢失已保存账号。本地登录器拒绝此线上配置迁移。

网络更新不可达时，在助手选择“本地更新清单”，清单 JSON 和其中引用的 SHA-256 文件名 ZIP 必须在同一目录。仍会校验长度、包哈希、EXE 哈希和允许替换的路径，校验完成后才关闭旧登录器。只接受可信发布者提供的完整更新包；本地清单不是数字签名。也可在助手的 `launcher-update.json` 增加 `offline_manifest`，双击直接读取该本地清单，无需联网。

失败诊断日志保存在 `%LOCALAPPDATA%/OpenKFO/Updater/update.log`。证书有效不代表下载入口可达；需要从玩家网络实际验证清单与完整 ZIP 下载，而不仅是服务器本机测试。
