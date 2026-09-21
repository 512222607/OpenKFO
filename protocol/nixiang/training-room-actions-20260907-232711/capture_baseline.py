from pathlib import Path
import hashlib
import json

PROJECT = Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
CASE = Path(__file__).resolve().parent
LAB = PROJECT / 'research/2026-09-06/work/login-to-world'
manifest = {}
for name in ('room_protocol.py', 'test_room_protocol.py', 'lab_server_v4.py', 'role_protocol.py', 'lab-control.json'):
    raw = (LAB / name).read_bytes()
    manifest[name] = {'sha256': hashlib.sha256(raw).hexdigest(), 'bytes': len(raw)}
(CASE / 'baseline-manifest.json').write_text(json.dumps(manifest, indent=2), encoding='utf-8')
rows = []
for line_number, line in enumerate((LAB / 'evidence/lab-wire-v4.jsonl').open(encoding='utf-8'), 1):
    if line_number < 98842:
        continue
    try:
        row = json.loads(line)
    except ValueError:
        continue
    if row.get('kind') in ('game-frame-error', 'end') or (row.get('kind') == 'game-frame' and row.get('message_id') != 0):
        rows.append({'source_line': line_number, **row})
(CASE / 'evidence/E-before-fix.json').write_text(json.dumps(rows, indent=2), encoding='utf-8')
sample = next(row for row in rows if row.get('message_id') == 3010 and row.get('direction') == 'request')
(CASE / 'candidate/training-create-captured.json').write_text(json.dumps(sample, indent=2), encoding='utf-8')
print(json.dumps({'baseline_files': len(manifest), 'wire_events': len(rows), 'training_request_source_line': sample['source_line']}))
