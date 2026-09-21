"""Build a portable online client archive without credentials, logs or backups."""
import hashlib
import json
from pathlib import Path
import zipfile

ROOT = Path(__file__).resolve().parents[3]
CLIENT = ROOT / "runtime-local/client"
ONLINE = ROOT / "runtime-local/go-online"
OUTPUT = ROOT.parent / "功夫小子-线上测试客户端.zip"

config = json.loads((ONLINE / "bridge.json").read_text(encoding="utf-8"))
network = json.loads((ROOT / "config/network.json").read_text(encoding="utf-8-sig"))
if config["url"] != network["game_endpoint"]:
    raise SystemExit("Run tools/Sync-NetworkConfig.ps1 -Apply before packaging")
config.update(client_directory="client", server_certificate="origin.crt",
              login_certificate="loopback-cert.pem", login_key="loopback-key.pem")
blocked_directories = {"temp", "SD_Log", "Sky_Log", "SP_Log"}

def included(path):
    relative = path.relative_to(CLIENT)
    if any(part in blocked_directories for part in relative.parts):
        return False
    name = path.name.lower()
    return not (".before-" in name or ".backup" in name or name.endswith((".log", ".dmp", ".sgz", ".bak", ".rep"))
                or name.startswith("kk-roleprop-ready") or name in {"thumbs.db", "cache.dat", "sd oa_log.txt", "sdoa_log.txt"})

readme = f"""功夫小子 · Go 线上测试

完整解压本 ZIP，双击“功夫小子线上登录器.exe”。不要单独移动 EXE。
服务器：{config['url']}。联网后在原游戏窗口填写测试账号和密码。
每台电脑只打开一个客户端；两位玩家使用不同账号。
两人选择相同对战模式，一人建房，另一人加入并准备，房主开始。

本包使用固定游戏配置。武器配置修改需要统一发布给所有玩家。
日志：online-client.log。关闭游戏后若登录器仍在后台，请先退出再重开。
测试版仍需两台真实电脑验证同房对战；后端尚未实现权威物理或伤害裁决。
"""

temporary = OUTPUT.with_suffix(".partial.zip")
count = 0
with zipfile.ZipFile(temporary, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=2, allowZip64=True) as archive:
    archive.write(ONLINE / "功夫小子线上登录器.exe", "功夫小子线上登录器.exe")
    archive.write(ONLINE / "origin.crt", "origin.crt")
    archive.write(ROOT / "runtime-local/legacy-tls/cert.pem", "loopback-cert.pem")
    archive.write(ROOT / "runtime-local/legacy-tls/key.pem", "loopback-key.pem")
    archive.writestr("bridge.json", json.dumps(config, indent=2))
    archive.writestr("使用说明.txt", readme)
    for path in CLIENT.rglob("*"):
        if path.is_file() and included(path):
            archive.write(path, "client/" + path.relative_to(CLIENT).as_posix())
            count += 1
            if count % 5000 == 0:
                print(f"Packaged {count} client files", flush=True)
temporary.replace(OUTPUT)
digest = hashlib.sha256()
with OUTPUT.open("rb") as source:
    for block in iter(lambda: source.read(1024 * 1024), b""):
        digest.update(block)
OUTPUT.with_suffix(".zip.sha256").write_text(digest.hexdigest() + "\n", encoding="ascii")
print(f"Completed: {count} files, {OUTPUT.stat().st_size} bytes, SHA256 {digest.hexdigest()}", flush=True)
