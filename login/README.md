# OpenKFO 本地登录器（server/login）-适用于SD端，老登端不确定是否可用

一个独立的 Windows 图形登录器（.NET 10 WinForms），替代 `client/tools/kfo_launcher.py` +
`patch_kfo_client.py`：**选目录 → 输账号密码 → 点登录**，自动完成「打 GPK 补丁 → 服务端认证 →
注入 session → 起桥 → 拉起客户端」。

## 它能做什么

1. **选择客户端目录**：任意一份 1.13.0.594 的 `gfxz.dat` 客户端目录。
2. **打 GPK / 更新绕过补丁**（幂等，自动备份 `*.pregpk.bak` / `*.orig` / `*.bak`）：
   - `gfxz.dat`：P1 掐死 GPK 初始化、P2–P5 观察者守卫 `je→jmp`、P6 会话注入跳转 + 代码洞；
   - `gpk/fuc.A` 三字节清零、`gpk/ver → 0006`（阻断在线回滚）；
   - `AutoPatch.ini` / `check.ini` / `gpkupdate.ini` / `Data/config.xml` 指向 `127.0.0.1`（含登录服）；
   - `SGDP.dat` 崩溃上报 / 远端日志主机 → `127.0.0.1`。
3. **服务端认证**：本机 TLS 隧道（默认 `127.0.0.1:19091`，`op=auth`），证书按本机
   `dist/local-server/certificates/origin.crt` **指纹钉扎**。
4. **注入 session**：把本轮 `KKSESSION…`（定长 40 字节）写入所选客户端
   `gfxz.dat` 代码洞偏移 `0x730DBC`。
5. **起桥 + 拉起客户端**：本机 `8000`(SDK)/`8001`(游戏 TCP+UDP) ↔ 隧道 channel，
   另起 `8088` 假更新应答；随后以所选目录为工作目录拉起 `gfxz.dat` 并保活。

## 构建

```bat
cd server\login
dotnet build -c Release
:: 产物：bin\Release\net10.0-windows\KfoLogin.exe
```

发布单文件（可选，需本机 .NET 10 桌面运行时）：

```bat
dotnet publish -c Release -r win-x64 --self-contained false -p:PublishSingleFile=true
```

## 运行

```bat
:: 图形界面
bin\Release\net10.0-windows\KfoLogin.exe

:: 无界面自检（认证 → 打补丁 → 注入 session，不起桥、不拉客户端）
KfoLogin.exe --selftest <账号> <密码> --client <客户端目录> --server <服务端目录>
:: 追加 --launch 即可跑完整链路（起桥并拉起客户端）
KfoLogin.exe --selftest <账号> <密码> --launch
```

自检默认从可执行文件所在目录**逐级向上**查找 `dist/local-server/config.json`（服务端）与
`client/gfxz.dat`（客户端），也可用 `--client` / `--server` / `--endpoint host:port` /
`--log <路径>` 显式指定。

## 界面字段

| 字段 | 说明 |
|---|---|
| 客户端目录 | 含 `gfxz.dat` 的目录（必填，可“浏览…”选择） |
| 服务端目录 | 含 `config.json` 与 `certificates/origin.crt` 的目录（默认自动定位） |
| 账号 / 密码 | 3–20 位字母或数字；密码走 legacy 摘要，服务端首次登录自动建号 |
| 服务端地址 | 隧道 `host:port`，默认 `127.0.0.1:19091` |

## 依赖与约定

- 服务端需先启动（`server/dist/local-server`，监听 `19090/19091`），其 `config.json`
  的 `config_hash` 与证书会用于隧道握手。
- 与客户端 / 服务端的接口约定（摘要盐、session 形态、补丁点、代码洞偏移）逐一对照
  `gpk-bypass-patch-guide.md` 与 `client/tools/*.py`，保持一致。
- 关闭登录窗口会一并停止客户端与桥；界面上的“停止客户端”按钮同理。
