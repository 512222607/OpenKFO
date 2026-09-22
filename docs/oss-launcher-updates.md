# OSS 登录器更新与 GM 版本校验

## 当前地址

- Bucket：`openkfo`，地域：`cn-hangzhou`。
- 下载入口：`https://openkfo.oss-cn-hangzhou.aliyuncs.com/version/version.json`。
- 当前使用 OSS 直连。将来接 CDN 只需更换 `bridge.json` 的 `update_version_url`，并以 CDN 域名重新生成清单。
- 发布凭据仅配置在发布机器，不能写入客户端、清单或 Git。

## 发布顺序

1. 构建完整 Flutter 启动器目录（包含 `LauncherSupport.exe`、DLL、`data`、`launcher-files`）。
2. 执行 `tools/Prepare-OssRelease.py --launcher <完整目录> --version <新版本> --output <新输出目录>`。
3. 在 OSS 控制台上传输出目录中的 `releases`、`updater`、`manifest`，保持目录结构不变。更新对象设为公共读，Bucket 可以继续私有（如果启用了阻止公共访问，需要先允许这些发布对象的公共读取）。
4. 验证清单列出的 URL 可以匿名下载，再最后上传 `version/version.json`。
5. `version/version.json` 设置 `Cache-Control: no-cache`。版本化目录内容发布后不再覆盖，可设置 `Cache-Control: public,max-age=31536000,immutable`。
6. 启动器会显示更新提示，可跳过启动器更新；需要客户端资源更新时仍先检查游戏窗口已关闭。

不要一次先覆盖版本入口再慢慢上传文件。回滚时只需重新上传之前的版本入口，保留旧版本文件。

生成器可用 `--previous-launcher <旧清单>` 复用未变文件的旧 URL，避免重复上传；清单始终描述完整安装状态。
`--client <客户端补丁目录> --config-hash <Data/config.spf2的SHA256>` 同时生成客户端资源清单。
后续资源补丁加 `--previous-client <旧客户端清单>`，保留此前文件，使跨版本更新完整。
每个文件最多256 MiB，每个清单总文件大小最多512 MiB；大资源应拆分发布，不能把整个游戏无检查地塞进单个 ZIP。
文件清单中的 ZIP 不会自动解压。客户端资源按真实相对路径发布（例如 `Weapon/xx.dat`、`Data/config.spf2`）；完整启动器 ZIP 用于首次安装。

## 清单格式

`version/version.json`：
```json
{
  "version": "2026.09.22-oss.1",
  "manifest": "https://openkfo.oss-cn-hangzhou.aliyuncs.com/manifest/2026.09.22-oss.1/launcher.json"
}
```
若有游戏资源更新，另加 `client_manifest`，指向同版本的 `client.json`。
清单包含 `version`、`target`（`launcher` 或 `client`）、`notes` 和 `files` 数组。每个文件包含 `path`、`url`、`sha256`、`size`；客户端清单还需 `config_hash`。
下载器校验 HTTPS、路径、重复文件名、体积和 SHA256，损坏文件不会替换当前文件。更新时仍自动准备登录组件。
`updater/<版本>/updater.exe` 是发布用的辅助程序副本；正常客户端使用已安装并随清单校验更新的 `LauncherSupport.exe` 完成替换，不从未校验地址直接执行程序。

## GM 不走 OSS 更新

GM 不再检查下载更新、调用更新 EXE 或提供自动更新菜单。
当前 GM 管理版本为 `1.1.0`（Dart `gm/lib/gm_version.dart` 与 Go `internal/gmversion/version.go` 必须同步）。

- 启动先请求 `gm_version`，版本不一致不显示管理操作页面。
- 每条命令附带 `gm_version`，HTTP `/gm/api` 与 SSH `kungfu-admin` 在执行前检查；缺失或不同均拒绝。
- 本地 `kungfu-desktop-admin.exe` 同样检查输入版本。
- 提示：版本不符合，请更新代码并编译最新版本。
- 版本号是兼容性检查，原来的 SSH/HTTP 管理认证仍然保留。
- 升级时需要配套替换 GM UI、`kungfu-desktop-admin.exe` 和线上 `kungfu-admin`；使用 HTTP 的还需更新 `kungfu-gm-api`。本次仅构建，未部署线上。
- 手动调用管理 CLI 时也必须附带 `"gm_version":"1.1.0"`。版本查询不需要数据库连接，也不执行修改操作。

阿里云参考：
- https://www.alibabacloud.com/help/en/oss/user-guide/cdn-acceleration
- https://www.alibabacloud.com/help/en/oss/developer-reference/upload-objects-6
