from pathlib import Path
import hashlib
import json
import socket
import struct
import sys

CASE = Path(__file__).resolve().parent
PROJECT = Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
LAB = PROJECT / 'research/2026-09-06/work/login-to-world'
sys.path.insert(0, str(LAB))
from game_protocol import GameFrameStream, decode_frame, encode_frame

database = LAB / 'data/lab-roles.sqlite3'
before = hashlib.sha256(database.read_bytes()).hexdigest()
request = bytes.fromhex(json.loads((CASE / 'candidate/training-create-captured.json').read_text())['payload_hex'])
results = []
with socket.create_connection(('127.0.0.1', 10035), timeout=3) as sock:
    stream = GameFrameStream()
    for opcode, payload, expect_id, expect_length in (
        (3010, request, 3020, 83),
        (3070, struct.pack('<H', 1) + bytes(12), 3100, 245),
        (4030, b'', 4080, 53),
        (4160, b'', 4180, 0),
        (8040, struct.pack('<HQI', 1, 1001, 0), 8070, 12),
        (3110, b'', 3115, 0),
        (2250, bytes(8), 2270, 8),
        (2260, bytes(3), 2280, 8),
    ):
        sock.sendall(encode_frame(opcode, payload))
        frames = []
        while not frames:
            raw = sock.recv(65536)
            if not raw:
                raise AssertionError('Unexpected disconnect')
            frames.extend(stream.feed(raw))
        assert len(frames) == 1, (opcode, len(frames))
        response = decode_frame(frames[0])
        assert (response.message_id, len(response.payload)) == (expect_id, expect_length)
        results.append({'request': opcode, 'response': response.message_id, 'payload_len': len(response.payload), 'payload_hex': response.payload.hex()})
after = hashlib.sha256(database.read_bytes()).hexdigest()
assert before == after, 'Persisted role database changed'
record = {'test': 'new installed live server, independent loopback socket; no client UI/session mutation', 'responses': results, 'database_unchanged': True, 'database_sha256': after}
(CASE / 'evidence/E-installed-socket-smoke.json').write_text(json.dumps(record, indent=2), encoding='utf-8')
print(json.dumps({'responses': [[r['request'], r['response'], r['payload_len']] for r in results], 'database_unchanged': True}))
