"""Read the live installed server's login inventory without changing equipment."""
from pathlib import Path
import hashlib
import json
import socket
import sqlite3
import struct
import sys
from contextlib import closing

ROOT = Path(__file__).resolve().parent
PROJECT = Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
LAB = PROJECT / 'research/2026-09-06/work/login-to-world'
sys.path.insert(0,str(LAB))
from game_protocol import GameFrameStream, decode_frame, encode_frame

dbpath = LAB / 'data/lab-roles.sqlite3'
before_hash = hashlib.sha256(dbpath.read_bytes()).hexdigest()
with closing(sqlite3.connect(dbpath.as_uri()+'?mode=ro',uri=True)) as db:
    saved = bytes(db.execute('SELECT payload FROM lab_roles WHERE uid=1001').fetchone()[0])
    owned = b''.join(bytes(row[0]) for row in db.execute(
        'SELECT payload68 FROM lab_inventory WHERE uid=1001 ORDER BY instance_id'))
frames = []
stream = GameFrameStream()
reads = 0
with socket.create_connection(('127.0.0.1',10035),timeout=5) as conn:
    wire = encode_frame(1010, struct.pack('<I',1001)+bytes(92))
    for lo,hi in [(0,1),(1,5),(5,9),(9,len(wire))]:
        conn.sendall(wire[lo:hi])
    while len(frames)<3:
        block = conn.recv(97)
        if not block:
            raise RuntimeError('Connection closed before complete login')
        reads += 1
        frames.extend(decode_frame(raw) for raw in stream.feed(block))
assert [f.message_id for f in frames] == [1020,1120,1130]
assert frames[1].payload == owned and len(owned) == 19040
assert frames[2].payload == saved[:360]
records = [owned[i:i+68] for i in range(0,len(owned),68)]
weapons = [r for r in records if r[4] == 25]
ids = {struct.unpack_from('<I',r,5)[0] for r in weapons}
assert ids == set(json.loads((LAB/'weapon_ids.json').read_text()))
assert len(weapons)==274 and len(records)==280
assert all(struct.unpack_from('<H',r,23)[0] == 1 for r in weapons)
assert len({struct.unpack_from('<I',r)[0] for r in records})==280
after_hash = hashlib.sha256(dbpath.read_bytes()).hexdigest()
assert before_hash == after_hash
result = {'target':'127.0.0.1:10035','uid':1001,'kind':'synthetic TCP verification',
          'frames':[{'id':f.message_id,'length':len(f.payload)} for f in frames],
          'items':280,'weapons':274,'distinct_weapon_ids':len(ids),'read_chunks_max97bytes':reads,
          'all_weapon_counts_at_offset23_are_one':True,
          'role_main_record_matches':True,'inventory_matches_database':True,
          'database_unchanged_by_smoke':True,'database_sha256':after_hash,
          'equipped_weapon_instances':[struct.unpack_from('<I',r)[0] for r in weapons
                                       if struct.unpack_from('<H',r,17)[0] == 8]}
(ROOT/'evidence/E-installed-inventory-socket.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps(result))
