from pathlib import Path
from datetime import datetime
import hashlib
import json
import shutil

SOURCE = Path(__file__).resolve().parent
PROJECT = Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
LAB = PROJECT / 'research/2026-09-06/work/login-to-world'
CASE = PROJECT / 'research/2026-09-07/room-enter-recovery'
OUTPUT = SOURCE.parents[1] / 'outputs'
OUTPUT.mkdir(exist_ok=True)

# Preserve only the bounded real-client packet sequence; original wire is untouched.
rows = []
with (LAB / 'evidence/lab-wire-v4.jsonl').open(encoding='utf-8') as handle:
    for line in handle:
        row = json.loads(line)
        if 1788793109.5 <= row.get('time', 0) <= 1788793110:
            if row.get('kind') in ('game-frame', 'game-frame-error', 'end'):
                rows.append(row)
(CASE / 'E-real-client-enter.json').write_text(json.dumps(rows, ensure_ascii=False, indent=2), encoding='utf-8')
(CASE / 'E-user-confirmation.md').write_text(
    '# 实机确认\n\n用户在收到重启客户端、创建团队战房间并点确定的复测请求后回复：\n\n'
    '> 已经进入房间\n\n'
    '对应真实wire为22:58:29的3010/81→3020/83→3550/12→3070/14→3100/245。'
    '同一连接后续opaque 3550触发旧的过严UID检查；已增加真实包回归测试并移除此身份检查。'
    '最终修复后已进行独立socket验证，特殊3550和随后的2250都正常响应。'
    '用户确认对应第一次修正版的可见房间；最后一处3550兼容修复以socket和单测验证，尚未声称完成完整战斗。\n', encoding='utf-8')
for name in ('E-live-status-smoke.json', 'smoke_status_fix.py', 'summarize_latest.py', 'install_status_fix.ps1', 'finalize_success.py'):
    shutil.copy2(SOURCE / name, CASE / name)

report_path = CASE / '2026-09-07_逆向-room-enter-report.md'
report = report_path.read_text(encoding='utf-8')
report = report.replace('源码测试和本地 TCP 测试通过；真实客户端结果以本文件后续验证记录和根目录 CURRENT_STATUS.md 最新段落为准。',
                        '真实客户端已发出3070并收到3100，用户明确确认“已经进入房间”。随后发现的3550状态包过严UID校验也已修复，最终服务通过保持连接的socket验证。')
report += '''
## 实机成功与最终修复

E-07：`E-real-client-enter.json` 记录22:58:29真实创建请求后的83字节3020和245字节3100。E-08：`E-user-confirmation.md`记录用户明确回复“已经进入房间”，因此建房与可见进房已经获得实机确认。

第一次3100之后，客户端发送 `ed0704040004040404040404` 的3550/12。该包不应当作为身份认证请求；原检查因QWORD不等于1001而关闭连接，导致同一缓冲区后续包无法处理。最终修改仅保留12字节长度检查，原样回显状态通知。新增真实包回归，源码测试变为20项游戏/房间/P2P + 9项角色测试，共29项通过。

E-09：`E-live-status-smoke.json` 在最后启动的PID38572上以独立socket发送该特殊3550，收到3550/12，再在同一连接发送2250，收到2270/8，证明连接不再被这个检查误关。该烟测没有操作用户的客户端会话或角色库。

最终状态：建房和进房已打通；单用户本地实验服务PID38572。用户需重新登录使用最后修正版。149字节扩展属性的完整语义、多玩家和战斗仍不在本轮已验证范围。下一步应在房间内的实际操作和新wire基础上推进，不能再从旧205xx/25xx错误路径推断进度。
'''
report_path.write_text(report, encoding='utf-8')

status_path = PROJECT / 'CURRENT_STATUS.md'
status = status_path.read_text(encoding='utf-8')
heading = '# 功夫小子 mock server 交接状态'
stamp = datetime.now().strftime('%Y-%m-%d %H:%M')
note = (
    f'> 最新状态（{stamp}，Asia/Shanghai）：**创建团队战房间→进入房间已获真实客户端确认**，用户原话“已经进入房间”。'
    '22:58:29 wire确认3010/81→3020/83→3550/12→3070/14→3100/245。'
    '本轮根因是IDA raw镜像表指针到文件地址需减0x10000，旧3020/4、3030/196、205xx/25xx“房间推进”结论均已纠正。'
    '当前room_protocol.py使用WORD房间handle1并回显原81字节请求，3070回3100/245；2250回2270/8、2260回2280/8。'
    '实机进房后发现特殊3550/12被过严UID检查误关连接，已修复为仅校验长度并保留原包；最后socket实测在同连接收到3550与下一条2270，确认该断线问题已排除。'
    '最终服务PID38572；20项协议/P2P/房间测试+9项角色测试共29项通过。'
    '源码、旧版备份、实机wire切片、用户确认、静态分析和哈希均在research/2026-09-07/room-enter-recovery/。'
    '原角色数据库未替换。请重登使用最后修正版；下一阶段再继续房间内操作与战斗，尚不能称完整游戏服务端已恢复。\n\n'
)
if status.startswith(heading):
    status = heading + '\n\n' + note + status[len(heading):].lstrip('\r\n')
else:
    status = note + status
status_path.write_text(status, encoding='utf-8')

manifest = {}
for folder in ('room-handlers', 'avatar', '21410', 'candidate'):
    for path in (CASE / folder).rglob('*'):
        if path.is_file() and path.suffix not in ('.sqlite3', '.pyc'):
            manifest[path.relative_to(CASE).as_posix()] = hashlib.sha256(path.read_bytes()).hexdigest()
for name in ('E-real-client-enter.json','E-user-confirmation.md','E-live-status-smoke.json'):
    manifest[name] = hashlib.sha256((CASE / name).read_bytes()).hexdigest()
(CASE / 'SHA256.json').write_text(json.dumps(manifest, indent=2), encoding='utf-8')
installed = []
for name in ('room_protocol.py','role_protocol.py','test_room_protocol.py','test_game_protocol.py','room-create-captured.json','lab-control.json'):
    path = LAB / name
    installed.append({'path': name, 'size': path.stat().st_size,
                      'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})
(CASE / 'installed-manifest.json').write_text(json.dumps(installed, indent=2), encoding='utf-8')
validation = {'timestamp': datetime.now().isoformat(), 'server_pid': 38572,
              'tests': {'game_room_p2p': 20, 'role': 9}, 'all_passed': True,
              'real_client': 'user confirmed room entry', 'final_3550_fix': 'unit and live socket verified'}
(CASE / 'validation.json').write_text(json.dumps(validation, ensure_ascii=False, indent=2), encoding='utf-8')
shutil.copy2(report_path, OUTPUT / '建房进房恢复报告.md')
print(json.dumps(validation, ensure_ascii=False))
print('Report copy:', OUTPUT / '建房进房恢复报告.md')
