from __future__ import annotations

import socket
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))

from game_protocol import GameFrameStream, decode_frame, encode_frame  # noqa: E402


def main() -> None:
    stream = GameFrameStream()
    frames = []
    with socket.create_connection(("127.0.0.1", 10035), timeout=5) as sock:
        sock.settimeout(1)
        sock.sendall(encode_frame(3010, bytes(81), 0))
        while True:
            try:
                frames.extend(stream.feed(sock.recv(65536)))
            except socket.timeout:
                break

    print(f"frames={len(frames)}")
    for raw in frames:
        frame = decode_frame(raw)
        print(f"message_id={frame.message_id} key_index={frame.key_index} payload_len={len(frame.payload)}")
        if len(frame.payload) >= 0x65:
            print(f"off_54={frame.payload[0x54:0x58].hex()} off_61={frame.payload[0x61:0x65].hex()}")


if __name__ == "__main__":
    main()
