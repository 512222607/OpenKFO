import ctypes as C
import ctypes.wintypes as W
import json, struct, sys

pid = int(sys.argv[1])
k = C.WinDLL('kernel32', use_last_error=True)
k.OpenProcess.argtypes=[W.DWORD,W.BOOL,W.DWORD]
k.OpenProcess.restype=W.HANDLE
k.ReadProcessMemory.argtypes=[W.HANDLE,C.c_void_p,C.c_void_p,C.c_size_t,C.POINTER(C.c_size_t)]
k.ReadProcessMemory.restype=W.BOOL
k.QueryFullProcessImageNameW.argtypes=[W.HANDLE,W.DWORD,W.LPWSTR,C.POINTER(W.DWORD)]
k.CloseHandle.argtypes=[W.HANDLE]
h=k.OpenProcess(0x410,False,pid)
if not h: raise C.WinError(C.get_last_error())
try:
    path=C.create_unicode_buffer(32768); size=W.DWORD(len(path))
    if not k.QueryFullProcessImageNameW(h,0,path,C.byref(size)): raise C.WinError(C.get_last_error())
    assert path.value.lower().endswith('kungfu-mock-server\\research\\2026-09-06\\spc32\\work\\client-test\\client.exe'),path.value
    def read(a,n):
        b=C.create_string_buffer(n); received=C.c_size_t()
        if not k.ReadProcessMemory(h,a,b,n,C.byref(received)): raise C.WinError(C.get_last_error())
        return b.raw[:received.value]
    def u32(a): return struct.unpack('<I',read(a,4))[0]
    manager=u32(0x17C8964)
    result={'pid':pid,'image':path.value,'manager':hex(manager)}
    if manager:
        result['manager_words']=[hex(x) for x in struct.unpack('<23I',read(manager,92))]
        sentinel=u32(manager+52)
        pending=[u32(sentinel+4)]; visited=set(); nodes=[]
        while pending:
            node=pending.pop()
            if node==sentinel or node in visited: continue
            if len(visited)>256: raise RuntimeError('map tree size limit')
            visited.add(node); data=read(node,104)
            left,parent,right,key=struct.unpack_from('<4I',data)
            if data[101]: continue
            pending.extend((left,right))
            values=struct.unpack_from('<22I',data,16)
            texts=[]
            for p in values[7:12]:
                try: texts.append(read(p,180).split(b'\0')[0].decode('gbk','replace'))
                except OSError: texts.append(None)
            nodes.append({'node':hex(node),'key':key,'fields':values[:7],'texts':texts,'hex':data[16:100].hex()})
        result['nodes']=sorted(nodes,key=lambda n:n['key'])
    if len(sys.argv)>2:
        a=int(sys.argv[2],0); n=int(sys.argv[3],0)
        result['read']={'address':hex(a),'hex':read(a,n).hex(),'words':[hex(x) for x in struct.unpack('<'+'I'*(n//4),read(a,n//4*4))]}
    print(json.dumps(result))
finally:
    k.CloseHandle(h)
