import struct,json
from pathlib import Path
R=Path(__file__).resolve().parent
def string(s):
 b=s.encode('ascii');return struct.pack('>H',len(b))+b
payload=struct.pack('<H',1002)+b'\1'+string('labuser01')+string('1001')+bytes.fromhex('0102030405060708')+bytes.fromhex('1112131415161718')+bytes(range(32))
frame=struct.pack('<HHHBB',0xaaee,(len(payload)^0xffdd)&0x88aa,len(payload),0,0)+payload
(R/'evidence'/'sdo-success-candidate.bin').write_bytes(frame)
(R/'lab-control.json').write_text(json.dumps({'case':'native-success-sdo-candidate','body':'登录成功|1001','ports':{'8000':frame.hex()}}),encoding='utf-8')
print('Prepared diagnostic SDL response',len(frame))
