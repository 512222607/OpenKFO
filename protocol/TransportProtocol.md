# 传输与封包协议（TransportProtocol）

> 实现基线：`b74129b`，整理日期：2026-09-18。以当前 Go 实现为准，客户端笔记用于交叉参考；本轮未重新反编译或进行实机验证。偏移默认十进制，详见[总索引与约定](protocol.md)。

## 1. 数据如何到达服务器

```text
C 原生登录界面 → 本机 TLS 登录端口 → B 校验进程身份和客户端资源
B → 直连 TLS，或 WSS 内层 TLS → S 认证
C SDK TCP / 游戏 TCP / UDP → B 封装 JSON → S
S 处理 → JSON data/udp → B 解封装 → 对应本机连接 → C 原生 handler
```

默认本机端口：登录 TLS `18084`、SDK TCP `18000`、游戏 TCP/UDP `18001`。多窗口由登录器为每个实例分配独立端口。这里的本机端口与服务器公网监听端口不同。

### 1.1 本地登录与服务端认证

1. C 向 B 提交 JSON：`type="login"`、`username`、`password`。B 校验连接所属进程及资源就绪状态。
2. B 向 S 发送一行 JSON：`op="auth"`，携带 `account/password/config_hash/port`。
3. S 要求 account 长度不超过 20、password 长度为 64、配置哈希匹配；随后执行账号认证、限速、并发与重复在线检查。这里的 password 是现有登录链使用的 64 字符旧协议摘要，不能直接用普通明文密码代替。
4. 成功返回 `{"op":"auth","uid":...}`。失败返回 auth/error，如 `client_config_mismatch`、`invalid_credentials`、`account_already_online`、`rate_limited`、`busy`。
5. B 发 `ready`；向 C 返回现有格式 `{"code": 200, "token": "32位十六进制随机值", "msg": "OK"}`。此 token 不是可以另开隧道冒充账号的服务端凭据。

### 1.2 隧道 Frame

一行 UTF-8 JSON 对应一个 Frame，以换行结束。`data` 是 Go `[]byte` 的 JSON 表示，即 Base64；不是消息号和参数的明文 JSON。

| op | 方向 | 参数与行为 |
| --- | --- | --- |
| auth | B→S→B | 上述认证；必须在普通业务操作之前 |
| health | B/探针→S→B | 认证前独立探测；返回 value=1/0，之后结束连接 |
| ready | B→S | 标记客户端表已就绪；满足 bootstrap 条件后下发角色档案 |
| open | B→S | channel 非零且未占用，kind=`sdk` 或 `game`；每会话最多 8 个 channel |
| data | 双向 | channel + data；一个 data 可以包含半个或多个原生包，服务端增量解帧 |
| close | B→S | 关闭对应 channel；关闭当前游戏 channel 会退房并清除绑定 |
| udp | 双向 | port + data；port 为本机端点关联，不能据此指定任意远端接收人 |
| ping / pong | B→S / S→B | B 每 15 秒发送 ping；S 回 pong |

S 认证首帧上限 8192 字节，认证后的单行上限 100000 字节，`data` 解码后不超过 65536 字节。连接读超时为 75 秒。`Handle` 返回错误会结束整个已认证隧道，而不只是丢弃这一个原生包；但若分支返回 nil，则可能是明确静默忽略。

### 1.3 游戏 TCP 二进制封包

`wire.go` 的 `Encode/Decoder.Feed`：

| 层 | 偏移 | 类型/长度 | 含义 |
| --- | --- | --- | --- |
| 外头 | 0 | u16 | `0xAAEE` |
| 外头 | 2 | u16 | `(innerLength XOR 0xBBCC) AND 0x88AA` |
| 外头 | 4 | u32 | 编码后的内块长度 |
| 内块解码后 | 0 | u32 | opcode |
| 内块解码后 | 4 | u16 | payload 编码 key index；服务端发送固定 0 |
| 内块解码后 | 6 | u32 | 原始 payload 长度 L |
| 内块解码后 | 10 | align8(L) | 再单独解码的 payload，尾部补零不属于原始参数 |
| 内块尾部 | 10+align8(L) | 6B | 当前发送为零 |

内块总长 `16+align8(L)`，整个帧长 `24+align8(L)`，最大 1 MiB。8 字节分组变换：编码为 `ROL64(value,3) XOR key`，解码反向；内块使用 key 0，payload 使用内块指定索引。该历史变换不代替传输层 TLS。

SDK 登录使用另一种 8B 外头，body 中 opcode 为 u16；`header[6]` 为 flags，`header[7]` 为前置 padding。长度和检验规则见 `ReadLogin`，不能把 SDK 包送进游戏 Decoder。认证后的 SDK 首次 flags=1 请求，S 回 1002；随后 flags=0/opcode=1011，S 回 1012。登录应答中部分字符串长度、目录字段使用大端，见 `LoginAck/LoginDirectory`。

## 2. SDK UDP

UDP通过Frame.data透传。当前基本头24B：+0 u16=1、+2 u16消息号、+4 u32端点标识、+12 u32源标识、+16 u32目标标识、+23 u8扩展头长度。除1001内部名字长度明确大端外，不推测其他未说明字节。

- 1001→1002：body至少141B；首u16为大端名字长度，要求body=141+名字长度、名字≤20、无扩展头。首次分配P2P ID。
- 1013→1014：body=4B；头+4/+12必须匹配已分配P2P ID。
- 上述成功后绑定UDP端口，P2P有效期更新为1分钟。
- 1008→1009：要求已绑定、有效P2P、正确本机UDP端口；扩展头是4B目标ID列表，长度非零且≤128。仅中继给同房且绑定有效的其他目标，去重并跳过自己；下行去掉扩展列表，改消息号为1009、+4/+16写接收者P2P ID，保留原始内容。
