from pathlib import Path
import hashlib
import json
import shutil
from datetime import datetime
import sys

CASE = Path(__file__).resolve().parent
PROJECT = Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
installed = json.loads((CASE / 'installed-manifest.json').read_text(encoding='utf-8-sig'))
target = Path(installed['case_directory']).resolve()
assert target.is_relative_to((PROJECT / 'research/2026-09-07').resolve())
assert target.name.startswith('training-room-actions-')
ui = sys.argv[1] if len(sys.argv) > 1 else 'pending'
assert ui in ('pending', 'confirmed')
status = ('安装后用户已确认返回大厅和重新开始训练均正常。' if ui == 'confirmed'
          else '首次临时推送实机已由用户确认能移动攻击；正式服务完整自动握手和退出通过socket，重登后的返回大厅及训练UI复测待用户反馈。')
report = CASE / '2026-09-07_逆向-training-room-report.md'
text = report.read_text(encoding='utf-8')
marker = '\n## 正式安装与最终验证\n'
text = text.split(marker)[0]
text += marker + '\n'
text += f'- 已安装至原项目，阶段目录：`{target.name}`，备份位于其 `backup/`。\n'
text += '- 当前v4 PID22820，正式目录44项协议/房间/P2P测试加9项角色测试共53项通过。\n'
text += '- 独立socket在正式10035端口验证完整8组请求响应，同连接退出后恢复大厅响应，角色库SHA256前后一致。见evidence/E-installed-socket-smoke.json。\n'
text += f'- {status}\n'
report.write_text(text, encoding='utf-8')

for path in CASE.rglob('*'):
    if path.is_file() and '__pycache__' not in path.parts:
        dest = target / path.relative_to(CASE)
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, dest)

status_path = PROJECT / 'CURRENT_STATUS.md'
prior = status_path.read_text(encoding='utf-8-sig')
heading = '# 功夫小子 mock server 交接状态'
stamp = datetime.now().strftime('%Y-%m-%d %H:%M')
note = (f'> 最新状态（{stamp}，Asia/Shanghai）：**自由训练开始与返回大厅处理已补齐**。'
        '实机4030/0→4080/53进入加载，4160/0→4180/0进入场景但尚不能动；'
        '继续8040/14→8070/12后用户明确确认“现在可以正常移动和攻击”。'
        '新RoomSession按该三阶段自动分派，3110/0→3115/0并清entered/started/loading_complete/active/request，恢复大厅2250/2260响应。'
        '8070末8字节复用4080的本局标识，不是UID；4100是结算请求，不用于开局。'
        '原项目源码已更新，正式v4 PID22820；53项测试和完整正式端口socket链通过，原角色库哈希未变。'
        f'{status} '
        f'源码、旧版备份、证据、安装清单、测试和报告位于research/2026-09-07/{target.name}/。'
        '仍只实现本地单人自由训练，非完整多人或原厂源码恢复。\n\n')
if prior.startswith(heading):
    prior = heading + '\n\n' + note + prior[len(heading):].lstrip('\r\n')
else:
    prior = note + prior
status_path.write_text(prior, encoding='utf-8')

manifest = []
for path in sorted(target.rglob('*')):
    if path.is_file() and path.name != 'SHA256.json' and '__pycache__' not in path.parts:
        manifest.append({'path': path.relative_to(target).as_posix(), 'sha256': hashlib.sha256(path.read_bytes()).hexdigest()})
(target / 'SHA256.json').write_text(json.dumps(manifest, indent=2), encoding='utf-8')
out = CASE.parents[1] / 'outputs'
out.mkdir(exist_ok=True)
shutil.copy2(report, out / report.name)
print(json.dumps({'case': str(target), 'status_updated': True, 'ui': ui, 'hashed_files': len(manifest), 'report': str(out / report.name)}))
