"""Synthetic TCP smoke check, explicitly NOT a real client relogin."""
import sys,json,socket,time
from pathlib import Path
P=Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
L=P/'research/2026-09-06/work/login-to-world'
O=P/'research/2026-09-07/role-create'
sys.path.insert(0,str(L))
from game_protocol import encode_frame,decode_frame,GameFrameStream
from role_protocol import LabRoleStore
sample=None
for line in (O/'E-014-wire-snapshot.jsonl').read_text(encoding='utf-8').splitlines():
    r=json.loads(line)
    if r.get('direction')=='request' and r.get('message_id')==1010:sample=r
started=time.time()
with socket.create_connection(('127.0.0.1',10035),timeout=4) as sock:
    peer=sock.getsockname()
    sock.sendall(encode_frame(1010,bytes.fromhex(sample['payload_hex'])))
    parser=GameFrameStream(); frames=[]
    while len(frames)<3:
        block=sock.recv(8192)
        if not block:raise RuntimeError('Unexpected EOF')
        frames.extend(decode_frame(b) for b in parser.feed(block))
assert [f.message_id for f in frames]==[1020,1120,1130]
saved=LabRoleStore(L/'data/lab-roles.sqlite3').get(1001)
assert frames[1].payload==saved[360:] and frames[2].payload==saved[:360]
result={'source':'synthetic TCP smoke, NOT real Client.exe relogin','start':started,'end':time.time(),'local_peer':peer,'messages':[{'id':f.message_id,'size':len(f.payload)} for f in frames],'persisted_name':saved[4:25].split(b'\0')[0].decode('gbk'),'passed':True}
(O/'E-016-live-v4-smoke.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps(result))
