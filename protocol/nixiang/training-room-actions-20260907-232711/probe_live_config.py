"""Prepare/apply/restore a single room-start fallback for the current live lab.

The running v4 already reloads lab-control.json on each frame. This lets the
current isolated session test the recovered 4080 handler without reconnecting.
The source implementation remains stateful; this temporary fallback is removed
before installing and restarting it. No role database writes are performed.
"""
import hashlib
import json
from pathlib import Path
import sys

CASE = Path(__file__).resolve().parent
LAB = Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\work\login-to-world')
sys.path.insert(0, str(CASE / 'candidate'))
from room_protocol import build_start_ack

original = CASE / 'lab-control.before-live-probe.json'
prepared = CASE / 'lab-control.live-probe.json'
target = LAB / 'lab-control.json'
mode = sys.argv[1]
if mode == 'prepare':
    raw = target.read_bytes()
    if original.exists():
        raise SystemExit('A probe baseline already exists; refusing to replace it')
    original.write_bytes(raw)
    control = json.loads(raw.decode('utf-8-sig'))
    control['game']['4030'] = {'message_id': 4080, 'payload_hex': build_start_ack(1).hex()}
    prepared.write_text(json.dumps(control, ensure_ascii=False, indent=2), encoding='utf-8')
elif mode == 'apply':
    if target.read_bytes() != original.read_bytes():
        raise SystemExit('Live configuration changed; probe not applied')
    target.write_bytes(prepared.read_bytes())
elif mode == 'restore':
    if target.read_bytes() != prepared.read_bytes():
        raise SystemExit('Live configuration changed; refusing to overwrite it')
    target.write_bytes(original.read_bytes())
else:
    raise SystemExit('Expected prepare, apply, or restore')
print(json.dumps({'mode': mode, 'target': str(target), 'sha256': hashlib.sha256(target.read_bytes()).hexdigest()}))
