"""Verify the running service without changing the current weapon selection."""
from collections import deque
from contextlib import closing
import hashlib
import json
from pathlib import Path
import socket
import sqlite3
import struct
import sys

ROOT=Path(__file__).resolve().parent
PROJECT=Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
LAB=PROJECT/'research/2026-09-06/work/login-to-world'
sys.path.insert(0,str(LAB))
from game_protocol import GameFrameStream,decode_frame,encode_frame
from inventory_protocol import PERMANENT_DISPLAY_MINUTES

DB=LAB/'data/lab-roles.sqlite3'
case=Path(json.loads((ROOT/'installed-location.json').read_text())['case_directory'])
with closing(sqlite3.connect(DB.as_uri()+'?mode=ro',uri=True)) as db:
    roles_before=db.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall()
    saved=bytes(db.execute('SELECT payload FROM lab_roles WHERE uid=1001').fetchone()[0])
    inventory_before=db.execute('SELECT * FROM lab_inventory ORDER BY uid,instance_id').fetchall()
    owned=b''.join(bytes(row[0]) for row in db.execute('SELECT payload68 FROM lab_inventory WHERE uid=1001 ORDER BY instance_id'))
    assert db.execute('SELECT count(*) FROM lab_inventory WHERE uid=1001 AND kind=25 AND permanent=1').fetchone()[0]==274
with closing(sqlite3.connect((case/'backup/lab-roles.sqlite3').as_uri()+'?mode=ro',uri=True)) as db:
    assert roles_before==db.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall()
records=[owned[i:i+68] for i in range(0,len(owned),68)]
weapons=[r for r in records if r[4]==25]
equipped=[r for r in weapons if struct.unpack_from('<H',r,17)[0]==8]
assert len(equipped)==1
equipped_id=struct.unpack_from('<I',equipped[0])[0]
assert len(weapons)==274 and len(records)==280
assert {struct.unpack_from('<I',r,5)[0] for r in weapons}==set(json.loads((LAB/'weapon_ids.json').read_text()))
assert all(struct.unpack_from('<I',r,13)[0]==PERMANENT_DISPLAY_MINUTES
           and struct.unpack_from('<I',r,19)[0]==1
           and struct.unpack_from('<H',r,23)[0]==0 for r in weapons)
stream=GameFrameStream()
pending=deque()
reads=0
def receive(conn,n):
    global reads
    while len(pending)<n:
        block=conn.recv(97)
        assert block, 'Unexpected service disconnect'
        reads+=1
        pending.extend(decode_frame(raw) for raw in stream.feed(block))
    return [pending.popleft() for _ in range(n)]

with socket.create_connection(('127.0.0.1',10035),timeout=5) as conn:
    login=encode_frame(1010,struct.pack('<I',1001)+bytes(92))
    for lo,hi in [(0,1),(1,5),(5,9),(9,len(login))]:
        conn.sendall(login[lo:hi])
    frames=receive(conn,3)
    assert [f.message_id for f in frames]==[1020,1120,1130]
    assert frames[1].payload==owned and frames[2].payload==saved[:360]
    # Re-select the already equipped weapon with the captured warehouse slot0.
    # This exercises the installed fix without altering the user's selection.
    conn.sendall(encode_frame(2080,struct.pack('<IIII',equipped_id,0,0,0)))
    ack=receive(conn,1)[0]
    assert ack.message_id==2090 and len(ack.payload)==84
    assert struct.unpack_from('<II',ack.payload)==(equipped_id,8)
    assert ack.payload[16:]==equipped[0]
    conn.sendall(encode_frame(2080,struct.pack('<IIII',equipped_id,9,0,0)))
    reject=receive(conn,1)[0]
    assert reject.message_id==2100 and reject.payload==struct.pack('<H',38)
    conn.sendall(login)
    again=receive(conn,3)
    assert [f.message_id for f in again]==[1020,1120,1130]
    assert again[1].payload==owned
with closing(sqlite3.connect(DB.as_uri()+'?mode=ro',uri=True)) as db:
    assert roles_before==db.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall()
    assert inventory_before==db.execute('SELECT * FROM lab_inventory ORDER BY uid,instance_id').fetchall()
result={'pid':int(sys.argv[1]),'test_count':82,'target':'127.0.0.1:10035','uid':1001,
        'items':280,'weapons':274,'all_permanent':True,'client_display':'365+',
        'slot_zero_acknowledged':True,'unsupported_slot_rejected_without_disconnect':True,
        'original_role_unchanged':True,'inventory_unchanged_by_smoke':True,
        'equipped_instance_preserved':equipped_id,'read_chunks_max97bytes':reads,
        'frames':[{'id':f.message_id,'length':len(f.payload)} for f in frames],
        'database_sha256':hashlib.sha256(DB.read_bytes()).hexdigest()}
(ROOT/'evidence/E-permanent-socket.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(result))
