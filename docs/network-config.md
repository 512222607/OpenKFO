# 统一网络配置

首次使用先将 `config/network.example.json` 复制为 `config/network.json`，填写自己的服务器域名和连接参数。真实配置仅保留在本机，不提交 Git。之后在仓库根目录运行：

```powershell
./tools/Sync-NetworkConfig.ps1        # 预览
./tools/Sync-NetworkConfig.ps1 -Apply # 三次证书校验探测成功后备份并同步
```

`game_endpoint` 为当前游戏入口；`direct_endpoint` 和 `wss_endpoint` 为切换/对比测速用的候选入口。游戏使用 TLS 直连域名；下载使用独立的 HTTPS `update_base_url`。主域名走 CDN，不能直接用其 19091 端口代替直连子域名。HTTPS 是更新器的要求；游戏协议本身使用 TLS 或 WSS，不接受 `https://` 游戏地址。

`bridge_paths` 列出活动登录器和打包源配置，`gm_updater_paths` 列出已有 GM 更新配置，`admin_paths` 列出 SSH 配置。路径相对仓库根目录，必须存在；新安装目录在这里加一次。同步保留账号存储范围、证书、资源哈希、SSH 密钥等其他字段，不扫描备份和离线客户端。已有 `update_base_url` 会同步；没有该字段的直连登录器维持不自动更新，避免仅切换地址就启用发布通道。分发包继续携带独立 bridge.json，玩家不依赖维护者仓库。

`launcher_manifest_paths` 可列出待发布的登录器清单文件，同步其中 `game_endpoint` 和 `update_base_url`，不修改包哈希或版本。线上 `/opt/kungfu-go/updates/launcher.json` 是发布产物；修改地址后必须同步并按现有发布流程上传清单，不能只改本机。此命令不自动上传或重启线上服务。当前线上清单的域名地址已与本配置一致。

Windows GM 使用 SSH host/port；移动 GM 的 HTTPS API 地址仍由登录界面输入，目前未部署移动 GM API，不能将下载地址当 API 地址。服务器监听地址和证书由服务器部署配置维护，不属于客户端访问域名。

测速工具从此配置读取默认入口，`-direct` 对比两种入口，`-endpoint` 可临时覆盖：

```powershell
./runtime-local/go-online/latency-probe.exe -config config/network.json -count 3
```

登录器“连接准备”包含证书加载、TCP 建连和 TLS 握手；“请求往返”是之后的健康请求耗时。两者都不是完整的对战延迟。更换为指向同一服务器的域名不会消除 TLS 握手时间。
