from datetime import datetime
from pathlib import Path
import json
import socket
import sys

LAB = Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\work\login-to-world')
sys.path.insert(0, str(LAB))
from game_protocol import GameFrameStream, decode_frame, encode_frame

evidence = {'timestamp': datetime.now().isoformat(), 'port': 10035,
            'kind': 'isolated-smoke-session-not-real-client', 'responses': []}
with socket.create_connection(('127.0.0.1', 10035), timeout=3) as sock:
    stream = GameFrameStream()
    for op, payload, expected in [(3550, bytes.fromhex('ed0704040004040404040404'), 3550),
                                  (2250, bytes(8), 2270)]:
        sock.sendall(encode_frame(op, payload))
        frames = []
        while not frames:
            block = sock.recv(65536)
            if not block:
                raise RuntimeError('Server closed the connection')
            frames = stream.feed(block)
        assert len(frames) == 1
        frame = decode_frame(frames[0])
        assert frame.message_id == expected
        if op == 3550:
            assert frame.payload == payload
        evidence['responses'].append({'message_id': frame.message_id, 'length': len(frame.payload),
                                      'payload_hex': frame.payload.hex()})
evidence['result'] = 'PASS: opaque 3550 accepted and next request answered on same connection'
(Path(__file__).resolve().parent / 'E-live-status-smoke.json').write_text(json.dumps(evidence, indent=2), encoding='utf-8')
print(json.dumps(evidence))
