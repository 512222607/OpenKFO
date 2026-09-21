import ctypes as C,json,sys
from pathlib import Path
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
R=Path(__file__).resolve().parent;c=json.loads((R/'live-context.json').read_text(encoding='utf-8-sig'));a=int(sys.argv[1],0);n=int(sys.argv[2],0)
k=C.windll.kernel32;k.OpenProcess.restype=C.c_void_p;k.ReadProcessMemory.argtypes=[C.c_void_p,C.c_void_p,C.c_void_p,C.c_size_t,C.POINTER(C.c_size_t)];k.CloseHandle.argtypes=[C.c_void_p]
h=k.OpenProcess(0x410,False,c['pid']);buf=C.create_string_buffer(n);got=C.c_size_t()
try:
 if not h or not k.ReadProcessMemory(h,a,buf,n,C.byref(got)):raise C.WinError()
finally:
 if h:k.CloseHandle(h)
b=buf.raw[:got.value];(R/'evidence'/f'live-{a:x}.bin').write_bytes(b)
lines=[f'{i.address:08x} {i.mnemonic:8} {i.op_str}' for i in Cs(CS_ARCH_X86,CS_MODE_32).disasm(b,a)]
(R/'evidence'/f'live-{a:x}.txt').write_text('\n'.join(lines),encoding='utf-8')
print('\n'.join(lines))
