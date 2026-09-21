"""Send one candidate loading-release notification to the current lab session.

The old running server has no push API. Temporarily dispatch on its next
loopback heartbeat and remove the fallback as soon as the wire records it.
This is a runtime handler probe, NOT evidence of a normal 4160 exchange.
"""
import json
from pathlib import Path
import time
import sys

CASE = Path(__file__).resolve().parent
LAB = Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\work\login-to-world')
target = LAB / 'lab-control.json'
wire = LAB / 'evidence/lab-wire-v4.jsonl'
before = target.read_bytes()
expected = (CASE / 'lab-control.live-probe.json').read_bytes()
if before != expected:
    raise SystemExit('Unexpected live control; not changing it')
control = json.loads(before.decode('utf-8-sig'))
phase = sys.argv[1] if len(sys.argv) > 1 else 'loading'
opcode, body = {'loading': (4180, ''), 'join': (8070, '010000000000000000000000')}[phase]
control['game']['0'] = {'message_id': opcode, 'payload_hex': body}
probe = json.dumps(control, ensure_ascii=False, indent=2).encode('utf-8')
events = []
with wire.open('r', encoding='utf-8') as log:
    log.seek(0, 2)
    target.write_bytes(probe)
    try:
        until = time.monotonic() + 6
        while time.monotonic() < until:
            line = log.readline()
            if not line:
                time.sleep(0.01)
                continue
            try:
                row = json.loads(line)
            except ValueError:
                continue
            if row.get('kind') == 'game-frame' and row.get('direction') == 'response' and row.get('message_id') == opcode:
                events.append(row)
                break
    finally:
        if target.read_bytes() == probe:
            target.write_bytes(before)
        else:
            raise RuntimeError('Concurrent control edit; not overwriting it')
(CASE / f'evidence/E-live-{phase}-release-probe.json').write_text(json.dumps({'mechanism': 'one temporary heartbeat fallback for current loaded isolated session', 'events': events, 'control_restored': True}, indent=2), encoding='utf-8')
print(json.dumps({'release_responses_observed': len(events), 'control_restored': True}))
