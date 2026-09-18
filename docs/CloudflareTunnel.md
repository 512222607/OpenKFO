# Cloudflare Tunnel 部署

目标游戏入口为 `wss://jrnygtxy.top/kk/tunnel`，健康检查为 `https://jrnygtxy.top/health`。登录器与 Go 桥接已支持 WSS；隧道内部继续校验现有 `kk-origin` 固定证书，不能关闭证书校验。Cloudflare Tunnel 支持 WebSocket，玩家不需要安装 cloudflared。

## 账户配置

在 Cloudflare One → Networks → Connectors → Cloudflare Tunnels 创建 remotely managed Cloudflared 隧道 `openkfo`。安装令牌作为私密文件保存，禁止提交到 Git、写入文档或玩家安装包。

发布应用路由：域名 `jrnygtxy.top`，子域名和路径留空，服务类型 HTTP，URL `127.0.0.1:19090`。同一主机名现有 A 记录与隧道 CNAME 冲突，需要在准备切换时替换为该隧道生成的 DNS 记录，不能继续指向源站 A 记录。游戏路由不能套浏览器交互登录或验证码；游戏仍由服务端验证账号密码。

## 服务器

安装官方 cloudflared Linux amd64 二进制，校验官方发布的 SHA-256。服务模板为 `server/deploy/openkfo-tunnel.service`，使用 systemd credential 将 `/etc/openkfo-tunnel/token`（root 0600）传入进程，不将令牌写在命令行中。创建 `/etc/openkfo-tunnel` 时使用 root 0700。

模板安装至 `/etc/systemd/system/openkfo-tunnel.service`，执行 `systemctl daemon-reload`；令牌和路由就绪后执行 `systemctl enable --now openkfo-tunnel`。需要服务器允许 cloudflared 所需的出站连接。不要向公网开放 19090。

## 验证与切换

1. 本机回环 `/health` 返回 `kungfu-go` / `ok`。
2. 隧道已连接，公网 HTTPS `/health` 返回同样结果。
3. 使用 `dist/server/latency-probe.exe` 对 WSS 入口验证固定证书和加密后的源站应答。
4. 执行 `toosl/Switch-WssServer.ps1 -ConfigPaths <全部线上 bridge.json 路径> -CertificatePath <origin.crt 路径>`。脚本只有健康检查和三次 WSS 内层 TLS 检测全通过才备份并更新配置。本地调试 `bridge.json` 不参与切换。
5. 用真实客户端验证登录、双人进房和战斗；不能用健康检查代替游戏测试。

## 管理入口及源站收口

管理器现有 SSH 是管理员专用链路，尚需迁移到受 Cloudflare Access 保护的独立 SSH 隧道或私有网络。必须先配置允许的管理员身份、验证管理员可以访问，并保持 SSH 主机密钥检查；不能把 SSH 直接作为无需 Access 限制的公共应用发布，也不能将管理员凭据放入玩家包。

新游戏路径及管理员备用访问均验证通过后，再限制源站公网 19091、HTTP 80 和管理入口的来源；同时停用旧域名/旧中继。迁移过程中保留现有管理连接，避免锁死服务器。历史公开的源站 IP 无法通过改域名消除，隐藏历史地址需要更换源站 IP。

参考：https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/
