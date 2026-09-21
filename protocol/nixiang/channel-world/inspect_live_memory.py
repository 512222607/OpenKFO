"""Read-only memory probe for the currently recorded isolated Client.exe."""
import ctypes as C
import json
from pathlib import Path
import sys

PROJECT = Path(__file__).resolve().parents[3]
CONTEXT = PROJECT / 'research/2026-09-06/work/login-to-world/live-context.json'
EXPECTED = PROJECT / 'research/2026-09-06/spc32/work/client-test/Client.exe'

ctx = json.loads(CONTEXT.read_text(encoding='utf-8-sig'))
pid = int(ctx['pid'])
address = int(sys.argv[1], 0)
size = int(sys.argv[2], 0)
if not 0 < size <= 4096:
    raise SystemExit('size must be 1..4096')

kernel32 = C.windll.kernel32
PROCESS_QUERY_INFORMATION = 0x0400
PROCESS_VM_READ = 0x0010
handle = kernel32.OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, False, pid)
if not handle:
    raise C.WinError()
buffer = C.create_string_buffer(size)
received = C.c_size_t()
try:
    if not kernel32.ReadProcessMemory(handle, address, buffer, size, C.byref(received)):
        raise C.WinError()
finally:
    kernel32.CloseHandle(handle)

print(json.dumps({
    'pid': pid,
    'expected_image': str(EXPECTED),
    'address': hex(address),
    'size': received.value,
    'hex': buffer.raw[:received.value].hex(),
}, ensure_ascii=False))
