"""Instrument-assisted diagnostic: invoke the client's own role-0 select helper once."""
import json
from pathlib import Path
import threading

import frida

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parents[2]
CONTEXT = PROJECT / "research/2026-09-06/work/login-to-world/live-context.json"

ctx = json.loads(CONTEXT.read_text(encoding="utf-8-sig"))
pid = int(ctx["pid"])
done = threading.Event()
session = frida.get_local_device().attach(pid)
source = r"""
'use strict';
const base = Process.getModuleByName('Client.exe').base;
const selectRole0 = new NativeFunction(base.add(0x8F6180), 'int', []);
setImmediate(() => {
  try { send({kind: 'trigger-result', retval: selectRole0()}); }
  catch (error) { send({kind: 'trigger-error', error: String(error)}); }
});
"""

def receive(message, _data):
    print(json.dumps(message.get("payload", message), ensure_ascii=False), flush=True)
    done.set()

script = session.create_script(source)
script.on("message", receive)
try:
    script.load()
    if not done.wait(10):
        raise SystemExit("role-select helper timed out")
finally:
    try:
        script.unload()
    except Exception:
        pass
    session.detach()
