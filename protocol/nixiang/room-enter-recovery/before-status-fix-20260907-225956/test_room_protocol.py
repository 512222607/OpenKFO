import json
from pathlib import Path
import socket
import sqlite3
import struct
import tempfile
import threading
import unittest

from game_protocol import GameFrameStream, decode_frame, encode_frame
from role_protocol import LabRoleStore, RoleSession, option_map
from room_protocol import RoomSession, build_create_ack, build_enter_ack

ROOT = Path(__file__).resolve().parent
REQUEST = bytes.fromhex(json.loads((ROOT / 'room-create-captured.json').read_text())['payload_hex'])


class RoomProtocolTests(unittest.TestCase):
    def setUp(self):
        self.control = json.loads((ROOT / 'lab-control.json').read_text(encoding='utf-8-sig'))
        self.temp = tempfile.TemporaryDirectory()
        self.store = LabRoleStore(Path(self.temp.name) / 'roles.sqlite3')
        self.options = option_map(bytes.fromhex(self.control['game']['1010'][1]['payload_hex']))
        # Create a local test role from genuinely offered appearance choices.
        request = bytearray(68)
        request[:5] = b'room1'
        request[21:23] = bytes([1, 0])
        for slot in range(7):
            choice = next(choice for gender, item_slot, choice in self.options if gender == 1 and item_slot == slot)
            struct.pack_into('<I', request, 23 + 4 * slot, choice)
        self.role = self.store.create(1001, request, self.options)
        self.session = RoleSession(self.store, 1001, self.options)

    def tearDown(self):
        self.temp.cleanup()

    def test_real_create_request_is_echoed_after_word_handle(self):
        reply = self.session.handle(3010, REQUEST, self.control)
        self.assertEqual([r['message_id'] for r in reply], [3020])
        payload = bytes.fromhex(reply[0]['payload_hex'])
        self.assertEqual(len(payload), 83)
        self.assertEqual(payload[:2], b'\x01\x00')
        self.assertEqual(payload[2:], REQUEST)
        self.assertNotEqual(len(payload), 4)

    def test_handler_driven_enter_sequence_and_character_survives(self):
        self.session.handle(3010, REQUEST, self.control)
        status = struct.pack('<QI', 1001, 0)
        self.assertEqual(self.session.handle(3550, status, self.control)[0]['payload_hex'], status.hex())
        replies = self.session.handle(3070, struct.pack('<H', 1) + bytes(12), self.control)
        self.assertEqual([r['message_id'] for r in replies], [3100])
        payload = bytes.fromhex(replies[0]['payload_hex'])
        self.assertEqual(len(payload), 245)
        self.assertEqual(struct.unpack_from('<HQ', payload), (1, 1001))
        self.assertEqual(payload[10:12], b'\0\0')
        self.assertEqual(payload[24:45], REQUEST[:21])
        self.assertEqual(payload[45:56], REQUEST[21:32])
        self.assertEqual(payload[56:61], REQUEST[32:37])
        self.assertEqual(payload[62], 6)
        self.assertEqual(payload[65], 1)
        self.assertEqual(struct.unpack_from('<H', payload, 67)[0], 180)
        self.assertEqual(payload[107:128], self.role[4:25])
        self.assertEqual(payload[96 + 78:96 + 120], bytes(42))
        self.assertEqual(self.store.get(1001), self.role)
        self.assertEqual(self.session.handle(2250, bytes(8), self.control), [])
        self.assertEqual(self.session.handle(2260, bytes(3), self.control), [])

    def test_room_map_override_only_changes_selected_fields(self):
        a = build_enter_ack(REQUEST, 1001, self.role)
        b = build_enter_ack(REQUEST, 1001, self.role, map_id=123, map_variant=456)
        self.assertEqual(b[12:20], struct.pack('<II', 123, 456))
        self.assertEqual(a[:12] + a[20:], b[:12] + b[20:])

    def test_incorrect_lengths_and_unknown_handle_are_rejected(self):
        for bad in (REQUEST[:-1], REQUEST + b'\0', b'x' * 81):
            with self.assertRaises(ValueError):
                self.session.handle(3010, bad, self.control)
        with self.assertRaises(ValueError):
            self.session.handle(3070, b'\1\0' + bytes(12), self.control)
        self.session.handle(3010, REQUEST, self.control)
        for bad in (bytes(13), bytes(15), b'\2\0' + bytes(12)):
            with self.assertRaises(ValueError):
                self.session.handle(3070, bad, self.control)
        with self.assertRaises(ValueError):
            self.session.handle(3550, struct.pack('<QI', 9999, 0), self.control)
        with self.assertRaises(ValueError):
            build_create_ack(REQUEST, 65536)
        with self.assertRaises(ValueError):
            build_enter_ack(REQUEST, 1001, None)

    def test_wrong_feature_responses_cannot_be_reenabled_by_old_config(self):
        old_control = {'room_stage': {
            'push_room_state_3030_after_create': True,
            'push_room_context_20564_after_create': True,
            'push_room_enter_ack_20560_after_create': True,
            'enable_post_enter_25xx': True,
            'enable_room_mode_20566': True,
        }}
        self.assertEqual([r['message_id'] for r in self.session.handle(3010, REQUEST, old_control)], [3020])
        for opcode in (20540, 20544, 20546, 2540, 2560):
            self.assertEqual(self.session.handle(opcode, b'', old_control), [])

    def test_lobby_replies_use_correct_opcode_and_do_not_include_fake_room(self):
        first = self.session.handle(2250, bytes(8), self.control)[0]
        second = self.session.handle(2260, bytes(3), self.control)[0]
        self.assertEqual((first['message_id'], len(bytes.fromhex(first['payload_hex']))), (2270, 8))
        self.assertEqual((second['message_id'], len(bytes.fromhex(second['payload_hex']))), (2280, 8))
        self.assertNotIn('room_stage', self.control)
        self.assertNotIn('3010', self.control['game'])

    def test_tcp_fragmentation_and_actual_server_dispatch(self):
        import lab_server_v4 as lab
        before = self.store.get(1001)
        captured = []
        old_event, old_control = lab.event, lab.load_control
        lab.event = captured.append
        lab.load_control = lambda: self.control
        server = lab.Server(('127.0.0.1', 0), lab.Handler)
        port = server.server_address[1]
        server.role_store, server.role_uid, server.role_options = self.store, 1001, self.options
        lab.GAME_PORTS.add(port)
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        try:
            with socket.create_connection(('127.0.0.1', port), timeout=3) as sock:
                stream = GameFrameStream()
                def exchange(opcode, body):
                    wire = encode_frame(opcode, body)
                    sock.sendall(wire[:5])
                    sock.sendall(wire[5:])
                    while True:
                        frames = stream.feed(sock.recv(65536))
                        if frames:
                            return decode_frame(frames[0])
                created = exchange(3010, REQUEST)
                self.assertEqual((created.message_id, len(created.payload)), (3020, 83))
                handle = struct.unpack_from('<H', created.payload)[0]
                status = exchange(3550, struct.pack('<QI', 1001, 0))
                self.assertEqual(status.message_id, 3550)
                entered = exchange(3070, struct.pack('<H', handle) + bytes(12))
                self.assertEqual((entered.message_id, len(entered.payload)), (3100, 245))
            self.assertFalse(any(r.get('kind') == 'game-frame-error' for r in captured))
            self.assertEqual([r['message_id'] for r in captured
                              if r.get('kind') == 'game-frame' and r.get('direction') == 'response'],
                             [3020, 3550, 3100])
            self.assertEqual(self.store.get(1001), before)
        finally:
            server.shutdown()
            server.server_close()
            thread.join(3)
            lab.GAME_PORTS.discard(port)
            lab.event, lab.load_control = old_event, old_control


if __name__ == '__main__':
    unittest.main()
