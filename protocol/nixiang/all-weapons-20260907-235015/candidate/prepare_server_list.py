import json,struct
from pathlib import Path
R=Path(__file__).resolve().parent
def frame(payload):return struct.pack('<HHHBB',0xaaee,(len(payload)^0xffdd)&0x88aa,len(payload),0,0)+payload
name='本地测试服'.encode('gbk')
entry=struct.pack('>IIHHBB',1,0x0100007f,10035,0,1,len(name))+name
servers=frame(struct.pack('<H',1012)+struct.pack('>H',1)+entry)
success=(R/'evidence'/'sdo-success-candidate.bin').read_bytes()
(R/'evidence'/'sdo-server-list-candidate.bin').write_bytes(servers)
(R/'lab-control.json').write_text(json.dumps({'case':'login-and-server-list','body':'登录成功|100100','sdo':{'encrypted':success.hex(),'1011':servers.hex()}}),encoding='utf-8')
print('Prepared SDK login and server-list responses')
