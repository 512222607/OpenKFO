"""Attach a read-only Frida trace to the isolated client and archive JSONL."""
import argparse
import json
from pathlib import Path
import threading
import time

import frida

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parents[2]
CONTEXT = PROJECT / 'research/2026-09-06/work/login-to-world/live-context.json'

parser = argparse.ArgumentParser()
parser.add_argument('--seconds', type=int, default=180)
args = parser.parse_args()

ctx = json.loads(CONTEXT.read_text(encoding='utf-8-sig'))
pid = int(ctx['pid'])
output = HERE / f'E-030-channel-connect-trace-{time.strftime("%H%M%S")}.jsonl'
finished = threading.Event()
session = frida.get_local_device().attach(pid)

with output.open('x', encoding='utf-8') as handle:
    def receive(message, data):
        record = message.get('payload', message)
        handle.write(json.dumps(record, ensure_ascii=False, default=str) + '\n')
        handle.flush()
        print(json.dumps(record, ensure_ascii=False, default=str), flush=True)

    session.on('detached', lambda *_: finished.set())
    script = session.create_script((HERE / 'trace_channel_container.js').read_text(encoding='utf-8-sig'))
    script.on('message', receive)
    try:
        script.load()
        finished.wait(args.seconds)
    finally:
        try: script.unload()
        except Exception: pass
        try: session.detach()
        except Exception: pass

print(output, flush=True)
