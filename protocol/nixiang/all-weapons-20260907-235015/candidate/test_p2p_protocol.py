from pathlib import Path
import socket
import struct
import sys
import threading
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parent))

from p2p_protocol import (  # noqa: E402
    LOGIN_ACK_BODY,
    U32_BODY,
    MSG_KEEPALIVE_ACK,
    MSG_KEEPALIVE_REQ,
    MSG_LOGIN_ACK,
    MSG_LOGIN_REQ,
    decode_login_request,
    build_keepalive_ack,
    build_login_ack,
    encode_datagram,
    parse_datagram,
)


def login_request_datagram(session_id: int = 0x11223344) -> bytes:
    name = b"labuser01"
    body = (
        struct.pack("!H", len(name))
        + name
        + struct.pack("!IHI", 0x7F000001, 40000, 0xAABBCCDD)
        + bytes(range(129))
    )
    return encode_datagram(MSG_LOGIN_REQ, body, session_id=session_id)


class P2PProtocolTests(unittest.TestCase):
    def test_header_is_little_endian_with_route_byte_count(self):
        raw = encode_datagram(
            1003,
            b"body",
            session_id=0x11223344,
            src_p2p_id=1001,
            dst_or_aux=2002,
            flag=1,
            route_ids=(7, 8),
        )
        self.assertEqual(
            struct.unpack_from("<HHIIIIHBB", raw, 0),
            (1, 1003, 0x11223344, 0, 1001, 2002, 0, 1, 8),
        )
        frame = parse_datagram(raw)
        self.assertEqual(frame.header.route_ids, (7, 8))
        self.assertEqual(frame.body, b"body")

    def test_decodes_variable_length_login_request_body(self):
        frame = parse_datagram(login_request_datagram())
        request = decode_login_request(frame)
        self.assertEqual(request.login_name, b"labuser01")
        self.assertEqual(request.advertised_ip, 0x7F000001)
        self.assertEqual(request.advertised_port, 40000)
        self.assertEqual(request.session_hint, 0xAABBCCDD)
        self.assertEqual(request.opaque_p2p_info, bytes(range(129)))
        self.assertEqual(request.trailing, b"")

    def test_login_ack_matches_recovered_wire_layout(self):
        raw = build_login_ack(
            session_id=0x11223344,
            assigned_p2p_id=1001,
            observed_ip="127.0.0.1",
            observed_port=5136,
        )
        self.assertEqual(
            struct.unpack_from("<HHIIIIHBB", raw, 0),
            (1, MSG_LOGIN_ACK, 0x11223344, 0, 0, 1001, 0, 0, 0),
        )
        self.assertEqual(LOGIN_ACK_BODY.unpack_from(raw, 24), (0, 0, 0x11223344, 0x7F000001, 5136))

    def test_keepalive_ack_targets_logged_in_client_id(self):
        raw = build_keepalive_ack(session_id=0, dst_p2p_id=1001)
        self.assertEqual(
            struct.unpack_from("<HHIIIIHBB", raw, 0),
            (1, MSG_KEEPALIVE_ACK, 0, 0, 0, 1001, 0, 0, 0),
        )
        self.assertEqual(U32_BODY.unpack_from(raw, 24), (0,))

    def test_udp_server_replies_to_login_and_keepalive(self):
        import lab_server_v4 as server

        saved_event = server.event
        events = []
        server.event = events.append
        udp = server.P2PUDPServer(("127.0.0.1", 0), server.P2PUDPHandler)
        udp.role_uid = 1001
        worker = threading.Thread(target=udp.serve_forever, daemon=True)
        worker.start()
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as client:
                client.settimeout(3)
                client.sendto(login_request_datagram(), udp.server_address)
                local_port = client.getsockname()[1]
                reply, source = client.recvfrom(4096)

            self.assertEqual(source, udp.server_address)
            frame = parse_datagram(reply)
            self.assertEqual(frame.header.message_id, MSG_LOGIN_ACK)
            self.assertEqual(frame.header.session_id, 0x11223344)
            self.assertEqual(frame.header.src_p2p_id, 0)
            self.assertEqual(frame.header.dst_or_aux, 1001)
            self.assertEqual(LOGIN_ACK_BODY.unpack(frame.body), (0, 0, 0x11223344, 0x7F000001, local_port))

            with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as client:
                client.settimeout(3)
                request = encode_datagram(
                    MSG_KEEPALIVE_REQ,
                    U32_BODY.pack(0),
                    session_id=0x11223344,
                    src_p2p_id=1001,
                )
                client.sendto(request, udp.server_address)
                reply, source = client.recvfrom(4096)

            self.assertEqual(source, udp.server_address)
            frame = parse_datagram(reply)
            self.assertEqual(frame.header.message_id, MSG_KEEPALIVE_ACK)
            self.assertEqual(frame.header.session_id, 0x11223344)
            self.assertEqual(frame.header.src_p2p_id, 0)
            self.assertEqual(frame.header.dst_or_aux, 1001)
            self.assertEqual(U32_BODY.unpack(frame.body), (0,))
            self.assertFalse(any(item["kind"] == "p2p-udp-error" for item in events))
        finally:
            udp.shutdown()
            udp.server_close()
            worker.join()
            server.event = saved_event


if __name__ == "__main__":
    unittest.main()
