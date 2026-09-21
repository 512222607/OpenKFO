from pathlib import Path
from datetime import datetime,timezone,timedelta
import json,shutil,subprocess,hashlib
P=Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
L=P/'research/2026-09-06/work/login-to-world'
O=P/'research/2026-09-07/role-create'
H=Path(__file__).resolve().parent
for name in ('2026-09-07_逆向-role-create-report.md','role-decompilation.json','test_role_protocol.py','live_v4_smoke.py','archive_role_progress.py'):
    shutil.copy2(H/name,O/name)
shutil.copy2(H/'START_ROLE_LAB.ps1',P/'tools/START_ROLE_LAB.ps1')
tests=[]
for script in (O/'test_role_protocol.py',L/'test_game_protocol.py'):
    r=subprocess.run([str(P/'toolchain/python313/python.exe'),str(script),'-v'],capture_output=True)
    tests.append(r.stdout.decode('utf-8',errors='replace')+r.stderr.decode('utf-8',errors='replace'))
    if r.returncode:raise RuntimeError(tests[-1])
(O/'test-results.txt').write_text('\n'.join(tests),encoding='utf-8')
entries=[]
for line in (O/'E-014-wire-snapshot.jsonl').read_text(encoding='utf-8').splitlines():
    r=json.loads(line)
    if r.get('time',0)>=1788713190 and r.get('message_id') in (1150,1151,3320,3330,1130,20432,20436,20440):
        when=datetime.fromtimestamp(r['time'],timezone(timedelta(hours=8))).isoformat()
        entries.append(f"- {when}: {r.get('direction')} {r['message_id']}/{r.get('payload_len')}")
(O/'timeline.md').write_text('# 本轮时间线\n\n'+'\n'.join(entries)+'\n\n- v3 正常停服，v4 PID 10956 启动；t07 已保存到独立实验数据库。\n- 7 项新测试和 6 项原有测试通过。真实客户端重登待用户完成。\n',encoding='utf-8')
(O/'field-journal.md').write_text('''# 本轮记录

- 只填 ID 的 1130 失败，不代表 1130 消息类型错误。补齐有效性别/骨架键 +122、属性变体 +124、昵称及外部装备记录后，实机进入频道选择。
- 1151 后的第一条 3320 是对象 +340 值；后续选择角色的 3320 才是角色 ID，不可一概校验为 UID。
- SDK、原生登录与游戏 UID 仍是实验结构；单独的角色持久化不等于完整账号认证。
- sqlite3 的连接上下文负责事务，不负责关闭连接；Windows 测试发现数据库文件占用，改用 contextlib.closing 后通过。
- 此旧游戏不接收 computer-use 的 Unicode type_text；实体按键有效，中文输入法需切到英文。UI 中出现文本才视为填写成功。
- skill 的 tool-index.md 缺失；已查看模板说明并现场核对项目 Python 路径、IDA MCP 健康和现有 IDB，没有重新安装或改动全局工具配置。
''',encoding='utf-8')
now=datetime.now(timezone(timedelta(hours=8))).strftime('%Y-%m-%d %H:%M')
status=P/'CURRENT_STATUS.md'
previous=status.read_text(encoding='utf-8-sig')
backup=O/'CURRENT_STATUS.before-role-create.md'
if not backup.exists():backup.write_text(previous,encoding='utf-8')
first,rest=previous.split('\n',1)
summary=f'''> 最新状态（{now}，Asia/Shanghai）：真实隔离客户端已完成非零外观 1150 采集，接受 1151/836（360 字节角色 + 七条 68 字节物品），发出 3320，并在收到有效 1130 后进入“频道选择”，显示 t07 和正确外观。已新增 role_protocol.py 与 lab_server_v4.py，SQLite 保存 t07；7 项角色/TCP 测试及原有 6 项协议测试通过。v3 已正常停止，当前 v4 PID 10956 监听本机 8094/8000/10035/5136。新入口 tools/START_ROLE_LAB.ps1，客户端入口仍为 tools/START_ISOLATED_GAME.bat。**当前等待真实客户端重新登录验证持久化；点击频道仍仅出现“祝您玩得开心”，尚未进入大厅/世界。** 先读 research/2026-09-07/role-create/2026-09-07_逆向-role-create-report.md。旧全零 1130 保持禁用，v4 从已验证字段生成有效角色记录；不能照搬旧固定回包配置。

> 以下上一阶段顶部摘要及历史章节保留作证据，以本段与本轮报告为准。
'''
status.write_text(first+'\n\n'+summary+rest,encoding='utf-8')
for doc in ('LOGIN_TO_WORLD_PROGRESS.md','timeline.md'):
    with (L/doc).open('a',encoding='utf-8') as f:
        f.write(f'\n\n## {now} 建角推进到频道选择\n\n真实客户端 1150/68 非零外观 -> 1151/836 -> 3320 -> 3330/1130，已显示 t07 和七件装备。角色保存到 data/lab-roles.sqlite3；v4 已取代 v3。详情：../../../2026-09-07/role-create/2026-09-07_逆向-role-create-report.md。新旧测试共 13 项通过；真实重登和进入世界待验证。\n')
manifest={}
for p in O.iterdir():
    if p.is_file() and p.name!='SHA256.json':manifest[p.name]=hashlib.sha256(p.read_bytes()).hexdigest()
for name in ('role_protocol.py','lab_server_v4.py'):
    manifest['../../2026-09-06/work/login-to-world/'+name]=hashlib.sha256((L/name).read_bytes()).hexdigest()
(O/'SHA256.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
print('Archived report, evidence, tests and updated CURRENT_STATUS.md')
