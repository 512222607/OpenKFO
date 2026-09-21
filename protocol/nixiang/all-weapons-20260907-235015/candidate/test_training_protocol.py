"""Free-training room regressions against captured requests and the real TCP handler.

Each server binds an OS-selected loopback port and uses a disposable role database.
The public replies and persisted character rows are the state-transition oracle.
"""

from collections import deque
from contextlib import closing, contextmanager
import json
from pathlib import Path
import socket
import sqlite3
import struct
import tempfile
import threading
import unittest
from unittest.mock import patch

from game_protocol import GameFrameStream, decode_frame, encode_frame
import lab_server_v4 as lab
from role_protocol import LabRoleStore, RoleSession, option_map


ROOT = Path(__file__).resolve().parent
CAPTURE = json.loads((ROOT / 'training-create-captured.json').read_text(encoding='utf-8-sig'))
TRAINING_REQUEST = bytes.fromhex(CAPTURE['payload_hex'])
STATUS = struct.pack('<QI', 1001, 0)


class WireClient:
    def __init__(self, sock):
        self.sock = sock
        self.stream = GameFrameStream()
        self.pending = deque()

    def send(self, message_id, payload=b'', fragmented=False):
        wire = encode_frame(message_id, payload)
        if fragmented:
            # Split both the outer header and the encrypted inner body.
            for start, end in ((0, 1), (1, 5), (5, 9), (9, len(wire))):
                self.sock.sendall(wire[start:end])
        else:
            self.sock.sendall(wire)

    def send_together(self, requests):
        self.sock.sendall(b''.join(encode_frame(opcode, body) for opcode, body in requests))

    def receive(self, count=1):
        while len(self.pending) < count:
            data = self.sock.recv(65536)
            if not data:
                raise AssertionError('Server closed before the expected protocol replies')
            self.pending.extend(decode_frame(raw) for raw in self.stream.feed(data))
        return [self.pending.popleft() for _ in range(count)]

    def read_until_closed(self):
        replies = list(self.pending)
        self.pending.clear()
        while True:
            data = self.sock.recv(65536)
            if not data:
                return replies
            replies.extend(decode_frame(raw) for raw in self.stream.feed(data))


class TrainingProtocolTests(unittest.TestCase):
    def setUp(self):
        self.control = json.loads((ROOT / 'lab-control.json').read_text(encoding='utf-8-sig'))
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.store = LabRoleStore(Path(self.temp.name) / 'roles.sqlite3')
        self.options = option_map(bytes.fromhex(self.control['game']['1010'][1]['payload_hex']))
        role_request = bytearray(68)
        role_request[:8] = b'training'
        role_request[21:23] = bytes((1, 0))
        for slot in range(7):
            choice = next(choice for gender, item_slot, choice in self.options
                          if gender == 1 and item_slot == slot)
            struct.pack_into('<I', role_request, 23 + 4 * slot, choice)
        self.role = self.store.create(1001, role_request, self.options)
        self.before_rows = self.role_rows()
        self.events = []

    def tearDown(self):
        self.assertEqual(self.role_rows(), self.before_rows, 'Room operations changed persisted characters')

    def role_rows(self):
        with closing(sqlite3.connect(self.store.path)) as db:
            return db.execute('SELECT uid, name, request, payload, created_at FROM lab_roles ORDER BY uid').fetchall()

    @contextmanager
    def running_server(self):
        with patch.object(lab, 'event', self.events.append), patch.object(lab, 'load_control', lambda: self.control):
            server = lab.Server(('127.0.0.1', 0), lab.Handler)
            server.role_store = self.store
            server.role_uid = 1001
            server.role_options = self.options
            port = server.server_address[1]
            lab.GAME_PORTS.add(port)
            worker = threading.Thread(target=server.serve_forever, kwargs={'poll_interval': 0.01}, daemon=True)
            worker.start()
            try:
                yield port
            finally:
                server.shutdown()
                server.server_close()
                worker.join(3)
                lab.GAME_PORTS.discard(port)

    @contextmanager
    def client(self, port):
        with socket.create_connection(('127.0.0.1', port), timeout=3) as sock:
            yield WireClient(sock)

    def create_and_enter(self, client, fragmented=False, request=TRAINING_REQUEST):
        client.send(3010, request, fragmented=fragmented)
        created, = client.receive()
        self.assertEqual((created.message_id, created.key_index, len(created.payload)), (3020, 0, 83))
        self.assertEqual(created.payload[2:], request)
        handle, = struct.unpack('<H', created.payload[:2])
        self.assertNotEqual(handle, 0)
        client.send(3070, struct.pack('<H', handle) + bytes(12), fragmented=fragmented)
        entered, = client.receive()
        self.assertEqual((entered.message_id, entered.key_index, len(entered.payload)), (3100, 0, 245))
        self.assertEqual(struct.unpack_from('<HQ', entered.payload), (handle, 1001))
        self.assertEqual(entered.payload[107:128], self.role[4:25])
        return handle

    def assert_polling_suppressed_in_room(self, client):
        # The status echo is an ordered barrier: any unsolicited lobby reply
        # from the preceding polls would appear before it on this TCP stream.
        client.send_together(((2250, bytes(8)), (2260, bytes(3)), (3550, STATUS)))
        barrier, = client.receive()
        self.assertEqual((barrier.message_id, barrier.payload), (3550, STATUS))

    def test_capture_is_a_real_decodable_training_create_frame(self):
        captured = decode_frame(bytes.fromhex(CAPTURE['hex']))
        self.assertEqual((captured.message_id, captured.key_index, len(captured.payload)), (3010, 0, 81))
        self.assertEqual(captured.payload, TRAINING_REQUEST)

    def test_fragmented_create_enter_leave_lobby_and_reenter(self):
        with self.running_server() as port, self.client(port) as client:
            self.create_and_enter(client, fragmented=True)
            self.assert_polling_suppressed_in_room(client)
            client.send(3110, fragmented=True)
            left, = client.receive()
            self.assertEqual((left.message_id, left.key_index, left.payload), (3115, 0, b''))
            client.send_together(((2250, bytes(8)), (2260, bytes(3))))
            lobby = client.receive(2)
            self.assertEqual([(reply.message_id, len(reply.payload)) for reply in lobby], [(2270, 8), (2280, 8)])
            self.assertEqual(lobby[0].payload, bytes(8), 'Lobby must not contain a stale room')
            self.create_and_enter(client, fragmented=True)
            self.assert_polling_suppressed_in_room(client)
        self.assertFalse(any(item.get('kind') == 'game-frame-error' for item in self.events))

    def test_coalesced_leave_polls_create_and_enter_preserve_wire_order(self):
        with self.running_server() as port, self.client(port) as client:
            handle = self.create_and_enter(client)
            client.send_together(((3110, b''), (2250, bytes(8)), (2260, bytes(3)),
                                  (3010, TRAINING_REQUEST), (3070, struct.pack('<H', handle) + bytes(12))))
            replies = client.receive(5)
            self.assertEqual([reply.message_id for reply in replies], [3115, 2270, 2280, 3020, 3100])
            self.assertEqual(replies[0].payload, b'')
            self.assertEqual(replies[3].payload[2:], TRAINING_REQUEST)
            self.assertEqual(struct.unpack_from('<HQ', replies[4].payload), (handle, 1001))
            self.assert_polling_suppressed_in_room(client)

    def test_leave_discards_created_room_before_another_enter_is_allowed(self):
        with self.running_server() as port, self.client(port) as client:
            handle = self.create_and_enter(client)
            client.send_together(((3110, b''), (3070, struct.pack('<H', handle) + bytes(12))))
            replies = client.read_until_closed()
            self.assertEqual([(reply.message_id, reply.payload) for reply in replies], [(3115, b'')])
        self.assertTrue(any(item.get('kind') == 'game-frame-error' for item in self.events))

    def test_invalid_leave_cannot_report_success_or_process_queued_lobby_poll(self):
        with self.running_server() as port:
            for bad_payload in (b'\0', bytes(8)):
                with self.subTest(payload_length=len(bad_payload)), self.client(port) as client:
                    self.create_and_enter(client)
                    client.send_together(((3110, bad_payload), (2250, bytes(8))))
                    self.assertEqual(client.read_until_closed(), [])
            with self.client(port) as fresh:
                fresh.send(2250, bytes(8))
                lobby, = fresh.receive()
                self.assertEqual((lobby.message_id, lobby.payload), (2270, bytes(8)))
                self.create_and_enter(fresh)

    def test_invalid_leave_preserves_room_until_a_valid_leave(self):
        session = RoleSession(self.store, 1001, self.options)
        session.handle(3010, TRAINING_REQUEST, self.control)
        session.handle(3070, struct.pack('<H', 1) + bytes(12), self.control)
        with self.assertRaises(ValueError):
            session.handle(3110, b'\0', self.control)
        self.assertEqual(session.handle(2250, bytes(8), self.control), [])
        self.assertEqual(session.handle(2260, bytes(3), self.control), [])
        self.assertEqual(session.handle(3110, b'', self.control),
                         [{'message_id': 3115, 'key_index': 0, 'payload_hex': ''}])
        self.assertEqual(session.handle(2250, bytes(8), self.control)[0]['message_id'], 2270)
        with self.assertRaises(ValueError):
            session.handle(3070, struct.pack('<H', 1) + bytes(12), self.control)

    def test_malformed_training_create_and_enter_never_emit_success(self):
        missing_name_terminator = b'x' * 21 + TRAINING_REQUEST[21:]
        missing_password_terminator = TRAINING_REQUEST[:21] + b'x' * 11 + TRAINING_REQUEST[32:]
        with self.running_server() as port:
            for bad in (TRAINING_REQUEST[:-1], TRAINING_REQUEST + b'\0',
                        missing_name_terminator, missing_password_terminator):
                with self.subTest(operation='create', payload=bad.hex()), self.client(port) as client:
                    client.send(3010, bad, fragmented=True)
                    self.assertEqual(client.read_until_closed(), [])
            for bad in (bytes(13), bytes(15), struct.pack('<H', 2) + bytes(12)):
                with self.subTest(operation='enter', payload=bad.hex()), self.client(port) as client:
                    client.send(3010, TRAINING_REQUEST)
                    self.assertEqual(client.receive()[0].message_id, 3020)
                    client.send(3070, bad, fragmented=True)
                    self.assertEqual(client.read_until_closed(), [])

    def test_old_fixed_leave_rule_cannot_override_live_session_transition(self):
        self.control['game']['3110'] = {'message_id': 3115, 'payload_hex': 'ffffffff'}
        with self.running_server() as port, self.client(port) as client:
            self.create_and_enter(client)
            client.send_together(((3110, b''), (2250, bytes(8)), (3550, STATUS)))
            left, lobby, barrier = client.receive(3)
            self.assertEqual((left.message_id, left.payload), (3115, b''))
            self.assertEqual((lobby.message_id, lobby.payload), (2270, bytes(8)))
            self.assertEqual((barrier.message_id, barrier.payload), (3550, STATUS))

    def assert_start_reply(self, reply, room_handle):
        self.assertEqual((reply.message_id, reply.key_index, len(reply.payload)), (4080, 0, 53))
        self.assertEqual(struct.unpack_from('<I', reply.payload)[0], room_handle)
        self.assertEqual(struct.unpack_from('<H', reply.payload, 11)[0], 0, 'Local player occupies host seat zero')
        self.assertEqual(reply.payload[4:], bytes(49), 'The local start contract leaves timing and match identity zero')

    def test_fragmented_start_leave_lobby_and_start_a_new_training_room(self):
        self.assertEqual(TRAINING_REQUEST[37], 4)
        with self.running_server() as port, self.client(port) as client:
            handle = self.create_and_enter(client, fragmented=True)
            client.send(4030, fragmented=True)
            client.send(3550, STATUS)
            started, barrier = client.receive(2)
            self.assert_start_reply(started, handle)
            self.assertEqual((barrier.message_id, barrier.payload), (3550, STATUS))
            client.send_together(((3110, b''), (2250, bytes(8)), (2260, bytes(3))))
            replies = client.receive(3)
            self.assertEqual([(reply.message_id, len(reply.payload)) for reply in replies],
                             [(3115, 0), (2270, 8), (2280, 8)])
            new_handle = self.create_and_enter(client)
            client.send_together(((4030, b''), (3550, STATUS)))
            restarted, barrier = client.receive(2)
            self.assert_start_reply(restarted, new_handle)
            self.assertEqual((barrier.message_id, barrier.payload), (3550, STATUS))
        self.assertFalse(any(item.get('kind') == 'game-frame-error' for item in self.events))
        sent_ids = [item['message_id'] for item in self.events
                    if item.get('kind') == 'game-frame' and item.get('direction') == 'response']
        self.assertNotIn(4050, sent_ids, 'Start must not invent a separate ready handshake')
        self.assertNotIn(4100, sent_ids, 'Start must not emit a match-settlement message')

    def test_duplicate_start_is_ignored_but_a_new_create_can_start_once(self):
        with self.running_server() as port, self.client(port) as client:
            for attempt in range(2):
                with self.subTest(room_creation=attempt):
                    handle = self.create_and_enter(client)
                    client.send_together(((4030, b''), (4030, b''), (3550, STATUS)))
                    started, barrier = client.receive(2)
                    self.assert_start_reply(started, handle)
                    self.assertEqual((barrier.message_id, barrier.payload), (3550, STATUS))

    def test_start_without_enter_or_after_leave_is_ignored_even_with_old_config(self):
        self.control['game']['4030'] = {'message_id': 4080, 'payload_hex': 'ffffffff'}
        with self.running_server() as port, self.client(port) as client:
            for state in ('fresh connection', 'created only', 'left room'):
                with self.subTest(state=state):
                    if state == 'created only':
                        client.send(3010, TRAINING_REQUEST)
                        self.assertEqual(client.receive()[0].message_id, 3020)
                    elif state == 'left room':
                        self.create_and_enter(client)
                        client.send(3110)
                        self.assertEqual(client.receive()[0].message_id, 3115)
                    client.send_together(((4030, b''), (3550, STATUS)))
                    barrier, = client.receive()
                    self.assertEqual((barrier.message_id, barrier.payload), (3550, STATUS))

    def test_non_training_room_does_not_emit_a_start_or_consume_future_training_start(self):
        self.control['game']['4030'] = {'message_id': 4080, 'payload_hex': 'ffffffff'}
        with self.running_server() as port, self.client(port) as client:
            for mode in (0, 6):
                request = bytearray(TRAINING_REQUEST)
                request[37] = mode
                with self.subTest(room_mode=mode):
                    self.create_and_enter(client, request=bytes(request))
                    client.send_together(((4030, b''), (3550, STATUS)))
                    barrier, = client.receive()
                    self.assertEqual((barrier.message_id, barrier.payload), (3550, STATUS))
                    self.assert_polling_suppressed_in_room(client)
            handle = self.create_and_enter(client)
            client.send_together(((4030, b''), (3550, STATUS)))
            started, barrier = client.receive(2)
            self.assert_start_reply(started, handle)
            self.assertEqual((barrier.message_id, barrier.payload), (3550, STATUS))

    def test_malformed_start_never_emits_success_or_processes_following_valid_start(self):
        with self.running_server() as port:
            for entered in (False, True):
                with self.subTest(entered=entered), self.client(port) as client:
                    if entered:
                        self.create_and_enter(client)
                    client.send_together(((4030, b'\0'), (4030, b''), (3550, STATUS)))
                    self.assertEqual(client.read_until_closed(), [])

    def test_malformed_start_does_not_consume_a_valid_start(self):
        session = RoleSession(self.store, 1001, self.options)
        session.handle(3010, TRAINING_REQUEST, self.control)
        session.handle(3070, struct.pack('<H', 1) + bytes(12), self.control)
        with self.assertRaises(ValueError):
            session.handle(4030, b'\0', self.control)
        started = session.handle(4030, b'', self.control)
        self.assertEqual([reply['message_id'] for reply in started], [4080])
        self.assertEqual(len(bytes.fromhex(started[0]['payload_hex'])), 53)
        self.assertEqual(session.handle(4030, b'', self.control), [])

    def test_training_load_completion_leave_and_reenter_on_the_same_connection(self):
        with self.running_server() as port, self.client(port) as client:
            for attempt in range(2):
                with self.subTest(training_round=attempt):
                    handle = self.create_and_enter(client, fragmented=True)
                    client.send(4030, fragmented=True)
                    self.assert_start_reply(client.receive()[0], handle)
                    client.send(4160, fragmented=True)
                    loaded, = client.receive()
                    self.assertEqual((loaded.message_id, loaded.key_index, loaded.payload), (4180, 0, b''))
                    client.send_together(((3110, b''), (2250, bytes(8)), (2260, bytes(3))))
                    replies = client.receive(3)
                    self.assertEqual([(reply.message_id, len(reply.payload)) for reply in replies],
                                     [(3115, 0), (2270, 8), (2280, 8)])
        self.assertFalse(any(item.get('kind') == 'game-frame-error' for item in self.events))

    def test_duplicate_load_completion_is_ignored_and_a_new_create_can_load_again(self):
        with self.running_server() as port, self.client(port) as client:
            for attempt in range(2):
                with self.subTest(room_creation=attempt):
                    handle = self.create_and_enter(client)
                    client.send_together(((4030, b''), (4160, b''), (4160, b''), (3550, STATUS)))
                    started, loaded, barrier = client.receive(3)
                    self.assert_start_reply(started, handle)
                    self.assertEqual((loaded.message_id, loaded.payload), (4180, b''))
                    self.assertEqual((barrier.message_id, barrier.payload), (3550, STATUS))

    def test_load_completion_before_start_or_after_leave_does_not_fall_back_to_old_config(self):
        self.control['game']['4160'] = {'message_id': 4180, 'payload_hex': 'ffffffff'}
        with self.running_server() as port, self.client(port) as client:
            for state in ('fresh connection', 'entered only', 'left loaded room'):
                with self.subTest(state=state):
                    if state == 'entered only':
                        self.create_and_enter(client)
                    elif state == 'left loaded room':
                        client.send_together(((4030, b''), (4160, b''), (3110, b'')))
                        self.assertEqual([reply.message_id for reply in client.receive(3)], [4080, 4180, 3115])
                    client.send_together(((4160, b''), (3550, STATUS)))
                    barrier, = client.receive()
                    self.assertEqual((barrier.message_id, barrier.payload), (3550, STATUS))

    def test_malformed_load_completion_never_emits_success_or_processes_queued_completion(self):
        with self.running_server() as port:
            for started in (False, True):
                with self.subTest(started=started), self.client(port) as client:
                    if started:
                        handle = self.create_and_enter(client)
                        client.send(4030)
                        self.assert_start_reply(client.receive()[0], handle)
                    client.send_together(((4160, b'\0'), (4160, b''), (3550, STATUS)))
                    self.assertEqual(client.read_until_closed(), [])

    def test_malformed_load_completion_does_not_consume_a_valid_completion(self):
        session = RoleSession(self.store, 1001, self.options)
        session.handle(3010, TRAINING_REQUEST, self.control)
        session.handle(3070, struct.pack('<H', 1) + bytes(12), self.control)
        session.handle(4030, b'', self.control)
        with self.assertRaises(ValueError):
            session.handle(4160, b'\0', self.control)
        self.assertEqual(session.handle(4160, b'', self.control),
                         [{'message_id': 4180, 'key_index': 0, 'payload_hex': ''}])
        self.assertEqual(session.handle(4160, b'', self.control), [])

    def start_and_load(self, client, handle):
        client.send_together(((4030, b''), (4160, b'')))
        started, loaded = client.receive(2)
        self.assert_start_reply(started, handle)
        self.assertEqual((loaded.message_id, loaded.payload), (4180, b''))
        return started.payload[45:53]

    def assert_scene_active_reply(self, reply, handle, match_identity):
        self.assertEqual((reply.message_id, reply.key_index, len(reply.payload)), (8070, 0, 12))
        self.assertEqual(struct.unpack_from('<I', reply.payload)[0], handle)
        self.assertEqual(reply.payload[4:], match_identity)
        self.assertNotEqual(reply.payload[4:], struct.pack('<Q', 1001),
                            'Scene activation carries the 4080 match identity, not the player UID')

    def test_complete_training_activation_leave_and_reenter_preserve_the_character(self):
        with self.running_server() as port, self.client(port) as client:
            for attempt in range(2):
                with self.subTest(training_round=attempt):
                    handle = self.create_and_enter(client, fragmented=True)
                    identity = self.start_and_load(client, handle)
                    client.send(8040, struct.pack('<HQI', handle, 1001, attempt), fragmented=True)
                    self.assert_scene_active_reply(client.receive()[0], handle, identity)
                    self.assert_polling_suppressed_in_room(client)
                    client.send_together(((3110, b''), (2250, bytes(8)), (2260, bytes(3))))
                    self.assertEqual([(reply.message_id, len(reply.payload)) for reply in client.receive(3)],
                                     [(3115, 0), (2270, 8), (2280, 8)])
        self.assertFalse(any(item.get('kind') == 'game-frame-error' for item in self.events))

    def test_duplicate_scene_activation_is_ignored_and_new_create_resets_activation(self):
        with self.running_server() as port, self.client(port) as client:
            for attempt in range(2):
                with self.subTest(room_creation=attempt):
                    handle = self.create_and_enter(client)
                    identity = self.start_and_load(client, handle)
                    client.send_together(((8040, struct.pack('<HQI', handle, 1001, 0xffffffff)),
                                          (8040, struct.pack('<HQI', handle, 1001, 0)),
                                          (3550, STATUS)))
                    activated, barrier = client.receive(2)
                    self.assert_scene_active_reply(activated, handle, identity)
                    self.assertEqual((barrier.message_id, barrier.payload), (3550, STATUS))

    def test_scene_activation_before_loading_or_after_leave_cannot_use_old_config(self):
        self.control['game']['8040'] = {'message_id': 8070, 'payload_hex': 'ffffffff'}
        with self.running_server() as port, self.client(port) as client:
            request = struct.pack('<HQI', 1, 1001, 123)
            for state in ('fresh connection', 'entered only', 'started only'):
                with self.subTest(state=state):
                    if state == 'entered only':
                        self.create_and_enter(client)
                    elif state == 'started only':
                        client.send(4030)
                        self.assert_start_reply(client.receive()[0], 1)
                    client.send_together(((8040, request), (3550, STATUS)))
                    barrier, = client.receive()
                    self.assertEqual((barrier.message_id, barrier.payload), (3550, STATUS))
            client.send_together(((4160, b''), (8040, request), (3110, b''), (8040, request), (3550, STATUS)))
            loaded, activated, left, barrier = client.receive(4)
            self.assertEqual((loaded.message_id, loaded.payload), (4180, b''))
            self.assert_scene_active_reply(activated, 1, bytes(8))
            self.assertEqual((left.message_id, left.payload), (3115, b''))
            self.assertEqual((barrier.message_id, barrier.payload), (3550, STATUS))

    def test_invalid_scene_activation_identity_or_size_never_reports_success(self):
        valid = struct.pack('<HQI', 1, 1001, 456)
        bad_requests = (valid[:-1], valid + b'\0', struct.pack('<HQI', 2, 1001, 456),
                        struct.pack('<HQI', 1, 1002, 456))
        with self.running_server() as port:
            for bad in bad_requests:
                with self.subTest(payload=bad.hex()), self.client(port) as client:
                    handle = self.create_and_enter(client)
                    self.start_and_load(client, handle)
                    client.send_together(((8040, bad), (8040, valid), (3550, STATUS)))
                    self.assertEqual(client.read_until_closed(), [])

    def test_invalid_scene_identity_does_not_consume_valid_activation(self):
        session = RoleSession(self.store, 1001, self.options)
        session.handle(3010, TRAINING_REQUEST, self.control)
        session.handle(3070, struct.pack('<H', 1) + bytes(12), self.control)
        started = session.handle(4030, b'', self.control)
        identity = bytes.fromhex(started[0]['payload_hex'])[45:53]
        session.handle(4160, b'', self.control)
        for invalid in (struct.pack('<HQI', 2, 1001, 0), struct.pack('<HQI', 1, 1002, 0)):
            with self.assertRaises(ValueError):
                session.handle(8040, invalid, self.control)
        activated = session.handle(8040, struct.pack('<HQI', 1, 1001, 0), self.control)
        self.assertEqual(activated, [{'message_id': 8070, 'key_index': 0,
                                     'payload_hex': (struct.pack('<I', 1) + identity).hex()}])
        self.assertEqual(session.handle(8040, struct.pack('<HQI', 1, 1001, 1), self.control), [])


if __name__ == '__main__':
    unittest.main()
