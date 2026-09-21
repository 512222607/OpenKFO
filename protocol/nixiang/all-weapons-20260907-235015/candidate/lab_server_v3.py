"""Explicit loopback protocol experiments; synthetic account/session only."""

from __future__ import annotations

import json
from pathlib import Path
import socketserver
import struct
import sys
import threading
import time


ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))

from game_protocol import GameFrameStream, decode_frame, encode_frame  # noqa: E402


EVENT_LOCK = threading.Lock()
GAME_PORTS = {10035, 5136}


def event(record: dict) -> None:
    with EVENT_LOCK:
        with (ROOT / "evidence" / "lab-wire-v3.jsonl").open("a", encoding="utf-8") as handle:
            handle.write(json.dumps({"time": time.time(), **record}) + "\n")


def load_control() -> dict:
    return json.loads((ROOT / "lab-control.json").read_text(encoding="utf-8-sig"))


class Handler(socketserver.BaseRequestHandler):
    def handle(self) -> None:
        self.request.settimeout(120)
        port = self.server.server_address[1]
        buffer = b""
        authenticated = False
        game_stream = GameFrameStream()
        event({"kind": "connect", "port": port})

        try:
            while True:
                block = self.request.recv(65536)
                if not block:
                    break

                if port in GAME_PORTS:
                    self._handle_game_block(port, block, game_stream)
                    continue

                buffer += block
                while len(buffer) >= (12 if port == 8094 else 8):
                    control = load_control()
                    if port == 8094:
                        magic, frame_size, opcode = struct.unpack_from("<III", buffer)
                        if magic != 0xA5D2B3D6 or not 12 <= frame_size <= 4096:
                            raise ValueError("Invalid native frame")
                    else:
                        magic, check, payload_size, flags, extra_size = struct.unpack_from("<HHHBB", buffer)
                        if magic != 0xAAEE or check != ((payload_size ^ 0xFFDD) & 0x88AA):
                            raise ValueError("Invalid SDK frame")
                        frame_size = payload_size + 8 + extra_size
                        if frame_size > 12288:
                            raise ValueError("SDK frame too large")

                    if len(buffer) < frame_size:
                        break
                    frame, buffer = buffer[:frame_size], buffer[frame_size:]

                    if port == 8094:
                        body = control["body"].encode("gbk") + b"\0"
                        reply = struct.pack("<II", 0xFF012CAB, len(body) + 8) + body
                    else:
                        opcode = struct.unpack_from("<H", frame, 8 + extra_size)[0] if not flags & 3 else "encrypted"
                        reply_hex = control.get("sdo", {}).get(str(opcode), "")
                        if opcode == "encrypted":
                            if authenticated:
                                reply_hex = ""
                            authenticated = True
                        reply = bytes.fromhex(reply_hex)

                    event({"kind": "request", "port": port, "opcode": opcode, "hex": frame.hex()})
                    if reply:
                        self.request.sendall(reply)
                        event({"kind": "response", "port": port, "opcode": opcode, "hex": reply.hex()})
        except Exception as exc:
            event({"kind": "end", "port": port, "error": str(exc)})

    def _handle_game_block(self, port: int, block: bytes, stream: GameFrameStream) -> None:
        event({"kind": "game-request", "port": port, "hex": block.hex()})
        for raw in stream.feed(block):
            try:
                frame = decode_frame(raw)
                event(
                    {
                        "kind": "game-frame",
                        "direction": "request",
                        "port": port,
                        "message_id": frame.message_id,
                        "key_index": frame.key_index,
                        "payload_len": len(frame.payload),
                        "payload_hex": frame.payload.hex(),
                        "hex": raw.hex(),
                    }
                )

                rule = load_control().get("game", {}).get(str(frame.message_id))
                if not rule:
                    continue
                responses = rule if isinstance(rule, list) else [rule]
                for response in responses:
                    if not response.get("enabled", True):
                        continue
                    delay_ms = int(response.get("delay_ms", 0))
                    if delay_ms > 0:
                        time.sleep(delay_ms / 1000.0)
                    response_payload = bytes.fromhex(response.get("payload_hex", ""))
                    response_id = int(response["message_id"])
                    response_key = int(response.get("key_index", 0))
                    reply = encode_frame(response_id, response_payload, response_key)
                    self.request.sendall(reply)
                    event(
                        {
                            "kind": "game-frame",
                            "direction": "response",
                            "port": port,
                            "message_id": response_id,
                            "key_index": response_key,
                            "payload_len": len(response_payload),
                            "payload_hex": response_payload.hex(),
                            "hex": reply.hex(),
                        }
                    )
            except Exception as exc:
                event({"kind": "game-frame-error", "port": port, "error": str(exc), "hex": raw.hex()})


class Server(socketserver.ThreadingTCPServer):
    allow_reuse_address = True
    daemon_threads = True


servers = []
for listen_port in (8094, 8000, 10035, 5136):
    server = Server(("127.0.0.1", listen_port), Handler)
    servers.append(server)
    threading.Thread(target=server.serve_forever, daemon=True).start()

print("Loopback protocol lab v3 ready", flush=True)
try:
    while not (ROOT / "lab-stop").exists():
        time.sleep(0.25)
finally:
    for server in servers:
        server.shutdown()
        server.server_close()
