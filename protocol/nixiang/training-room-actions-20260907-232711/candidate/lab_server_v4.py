"""Explicit loopback protocol experiments; synthetic account/session with persisted lab roles."""

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

from p2p_protocol import (  # noqa: E402
    MSG_KEEPALIVE_REQ,
    MSG_LOGIN_REQ,
    P2PProtocolError,
    build_keepalive_ack,
    build_login_ack,
    decode_login_request,
    parse_datagram,
)

from role_protocol import LabRoleStore, RoleSession, option_map

EVENT_LOCK = threading.Lock()
GAME_PORTS = {10035, 5136}
P2P_UDP_PORTS = {5136}


def event(record: dict) -> None:
    with EVENT_LOCK:
        with (ROOT / "evidence" / "lab-wire-v4.jsonl").open("a", encoding="utf-8") as handle:
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
        self.role_session = RoleSession(self.server.role_store, self.server.role_uid, self.server.role_options)
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

                control = load_control()
                rule = self.role_session.handle(frame.message_id, frame.payload, control)
                if rule is None:
                    rule = control.get("game", {}).get(str(frame.message_id))
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
                raise  # close invalid lab session; never claim creation succeeded


class Server(socketserver.ThreadingTCPServer):
    allow_reuse_address = True
    daemon_threads = True


class P2PUDPHandler(socketserver.BaseRequestHandler):
    def handle(self) -> None:
        data, udp_socket = self.request
        port = self.server.server_address[1]
        client_ip, client_port = self.client_address
        event({"kind": "p2p-udp-request", "port": port, "client": f"{client_ip}:{client_port}", "hex": data.hex()})

        try:
            frame = parse_datagram(data)
            record = {
                "kind": "p2p-udp-frame",
                "direction": "request",
                "port": port,
                "client": f"{client_ip}:{client_port}",
                "message_id": frame.header.message_id,
                "session_id": frame.header.session_id,
                "src_p2p_id": frame.header.src_p2p_id,
                "dst_or_aux": frame.header.dst_or_aux,
                "route_count": len(frame.header.route_ids),
                "body_len": len(frame.body),
            }
            if frame.header.message_id == MSG_LOGIN_REQ:
                login = decode_login_request(frame)
                record.update(
                    {
                        "login_name": login.login_name.decode("gbk", "replace"),
                        "advertised_ip": login.advertised_ip,
                        "advertised_port": login.advertised_port,
                        "session_hint": login.session_hint,
                        "opaque_len": len(login.opaque_p2p_info),
                        "trailing_len": len(login.trailing),
                    }
                )
            event(record)

            if frame.header.message_id == MSG_LOGIN_REQ:
                reply = build_login_ack(
                    session_id=frame.header.session_id,
                    assigned_p2p_id=self.server.role_uid,
                    observed_ip=client_ip,
                    observed_port=client_port,
                )
            elif frame.header.message_id == MSG_KEEPALIVE_REQ:
                reply = build_keepalive_ack(
                    session_id=frame.header.session_id,
                    dst_p2p_id=frame.header.src_p2p_id or self.server.role_uid,
                )
            else:
                return

            udp_socket.sendto(reply, self.client_address)
            reply_frame = parse_datagram(reply)
            event(
                {
                    "kind": "p2p-udp-frame",
                    "direction": "response",
                    "port": port,
                    "client": f"{client_ip}:{client_port}",
                    "message_id": reply_frame.header.message_id,
                    "session_id": reply_frame.header.session_id,
                    "src_p2p_id": reply_frame.header.src_p2p_id,
                    "dst_or_aux": reply_frame.header.dst_or_aux,
                    "body_len": len(reply_frame.body),
                    "hex": reply.hex(),
                }
            )
        except (P2PProtocolError, UnicodeError, OSError) as exc:
            event({"kind": "p2p-udp-error", "port": port, "client": f"{client_ip}:{client_port}", "error": str(exc), "hex": data.hex()})


class P2PUDPServer(socketserver.ThreadingUDPServer):
    allow_reuse_address = True
    daemon_threads = True


def main():
    control = load_control()
    settings = control.get('role_persistence', {})
    if settings.get('synthetic_uid') != 1001:
        raise ValueError('This server requires explicit synthetic_uid=1001')
    store = LabRoleStore(ROOT / 'data' / 'lab-roles.sqlite3')
    options_rule = next(r for r in control['game']['1010'] if r.get('message_id') == 1125 and r.get('enabled', True))
    options = option_map(bytes.fromhex(options_rule['payload_hex']))
    servers = []
    try:
        for port in (8094, 8000, 10035, 5136):
            server = Server(('127.0.0.1', port), Handler)
            server.role_store = store
            server.role_uid = 1001
            server.role_options = options
            servers.append(server)
            threading.Thread(target=server.serve_forever, daemon=True).start()
        for port in P2P_UDP_PORTS:
            server = P2PUDPServer(('127.0.0.1', port), P2PUDPHandler)
            server.role_uid = 1001
            servers.append(server)
            threading.Thread(target=server.serve_forever, daemon=True).start()
        print('Loopback protocol lab v4 ready; synthetic UID 1001; persistent roles; UDP P2P 5136', flush=True)
        while not (ROOT / 'lab-stop-v4').exists():
            time.sleep(.25)
    finally:
        for server in servers:
            server.shutdown()
            server.server_close()

if __name__ == '__main__':
    main()
