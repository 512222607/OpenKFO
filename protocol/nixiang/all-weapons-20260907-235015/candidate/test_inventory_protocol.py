"""Full weapon snapshots and equipment changes through the actual lab handler.

Only disposable role databases and OS-selected loopback ports are used. Tests
replace event logging and configuration loading before starting the handler.
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
from inventory_protocol import InventoryStore
import lab_server_v4 as lab
from role_protocol import LabRoleStore, RoleSession, option_map


ROOT = Path(__file__).resolve().parent
WEAPON_IDS = json.loads((ROOT / 'weapon_ids.json').read_text(encoding='utf-8-sig'))
CATALOG = [{'local_id': local_id, 'kind': 25} for local_id in WEAPON_IDS]


def item_records(payload):
    if len(payload) % 68:
        raise AssertionError('Incomplete inventory record')
    return [payload[offset:offset + 68] for offset in range(0, len(payload), 68)]


class FragmentedClient:
    def __init__(self, sock):
        self.sock = sock
        self.stream = GameFrameStream()
        self.pending = deque()
        self.read_count = 0

    def send(self, opcode, payload):
        wire = encode_frame(opcode, payload)
        # Divide the outer header and encrypted body across independent writes.
        for start, end in ((0, 1), (1, 3), (3, 7), (7, 13), (13, len(wire))):
            self.sock.sendall(wire[start:end])

    def receive(self, count):
        while len(self.pending) < count:
            block = self.sock.recv(97)
            if not block:
                raise AssertionError('Handler disconnected before its complete replies')
            self.read_count += 1
            self.pending.extend(decode_frame(raw) for raw in self.stream.feed(block))
        return [self.pending.popleft() for _ in range(count)]


class InventoryProtocolTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.control = json.loads((ROOT / 'lab-control.json').read_text(encoding='utf-8-sig'))
        options_rule = next(rule for rule in self.control['game']['1010'] if rule['message_id'] == 1125)
        self.options = option_map(bytes.fromhex(options_rule['payload_hex']))
        self.path = Path(self.temp.name) / 'roles.sqlite3'
        self.store = LabRoleStore(self.path)
        request = bytearray(68)
        request[:4] = b't07\0'
        request[21:23] = bytes((2, 13))
        for slot, local_id in enumerate((152002, 132002, 122001, 172002, 162003, 142002, 253002)):
            choice = next(choice for (gender, offered_slot, choice), value in self.options.items()
                          if gender == 2 and offered_slot == slot and value == local_id)
            struct.pack_into('<I', request, 23 + slot * 4, choice)
        self.baseline = self.store.create(1001, bytes(request), self.options)
        self.before_roles = self.role_rows()
        self.inventory = InventoryStore(self.path)
        self.grant_result = self.inventory.grant_weapons(1001, self.baseline, CATALOG)
        self.login = struct.pack('<I', 1001) + bytes(92)
        self.events = []

    def tearDown(self):
        self.assertEqual(self.role_rows(), self.before_roles, 'Inventory protocol changed original role rows')
        self.assertEqual(self.store.get(1001), self.baseline)

    def role_rows(self):
        with closing(sqlite3.connect(self.path)) as db:
            return db.execute('SELECT uid,name,request,payload,created_at FROM lab_roles ORDER BY uid').fetchall()

    def assert_snapshot(self, payload, equipped_instance=7):
        self.assertEqual(len(payload), 280 * 68)
        self.assertEqual(len(WEAPON_IDS), 274)
        items = item_records(payload)
        instances = [struct.unpack_from('<I', item)[0] for item in items]
        self.assertEqual(len(instances), len(set(instances)))
        weapons = [item for item in items if item[4] == 25]
        self.assertEqual(len(weapons), 274)
        self.assertEqual({struct.unpack_from('<I', item, 5)[0] for item in weapons}, set(WEAPON_IDS))
        self.assertTrue(all(struct.unpack_from('<I', item, 9)[0] == 1 for item in weapons))
        self.assertTrue(all(struct.unpack_from('<H', item, 23)[0] != 0
                            or struct.unpack_from('<I', item, 13)[0] != 0 for item in weapons),
                        'A weapon would be filtered out of the real warehouse UI')
        equipped = [struct.unpack_from('<I', item)[0] for item in weapons
                    if struct.unpack_from('<H', item, 17)[0] == 8]
        self.assertEqual(equipped, [] if equipped_instance is None else [equipped_instance])
        self.assertEqual(b''.join(items[:6]), self.baseline[360:360 + 6 * 68])

    def assert_login_frames(self, frames, equipped_instance=7):
        self.assertEqual([frame.message_id for frame in frames], [1020, 1120, 1130])
        self.assert_snapshot(frames[1].payload, equipped_instance)
        self.assertEqual(frames[2].payload, self.baseline[:360])
        return frames[1].payload

    @contextmanager
    def running_server(self):
        with patch.object(lab, 'event', self.events.append), patch.object(lab, 'load_control', lambda: self.control):
            server = lab.Server(('127.0.0.1', 0), lab.Handler)
            server.role_store, server.role_uid, server.role_options = self.store, 1001, self.options
            port = server.server_address[1]
            lab.GAME_PORTS.add(port)
            worker = threading.Thread(target=server.serve_forever, kwargs={'poll_interval': .01}, daemon=True)
            worker.start()
            try:
                yield port
            finally:
                server.shutdown()
                server.server_close()
                worker.join(timeout=2)
                lab.GAME_PORTS.discard(port)

    @contextmanager
    def client(self, port):
        with socket.create_connection(('127.0.0.1', port), timeout=5) as sock:
            sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
            yield FragmentedClient(sock)

    def test_complete_snapshot_and_repeated_session_login_preserve_role(self):
        self.assertEqual(self.grant_result, {'added_weapons': 273, 'total_weapons': 274, 'total_items': 280})
        session = RoleSession(self.store, 1001, self.options)
        snapshots = []
        for _ in range(2):
            replies = session.handle(1010, self.login, self.control)
            self.assertEqual([reply['message_id'] for reply in replies], [1020, 1120, 1130])
            snapshots.append(bytes.fromhex(replies[1]['payload_hex']))
            self.assert_snapshot(snapshots[-1])
            self.assertEqual(bytes.fromhex(replies[2]['payload_hex']), self.baseline[:360])
        self.assertEqual(snapshots[0], snapshots[1])
        self.assertEqual(LabRoleStore(self.path).get_items(1001), snapshots[0])

    def test_tcp_fragmented_large_snapshot_repeated_login_and_reconnect(self):
        snapshots = []
        with self.running_server() as port:
            with self.client(port) as client:
                for _ in range(2):
                    client.send(1010, self.login)
                    snapshots.append(self.assert_login_frames(client.receive(3)))
                self.assertGreater(client.read_count, 380)
            with self.client(port) as reconnected:
                reconnected.send(1010, self.login)
                snapshots.append(self.assert_login_frames(reconnected.receive(3)))
                self.assertGreater(reconnected.read_count, 190)
        self.assertTrue(all(snapshot == snapshots[0] for snapshot in snapshots))
        self.assertFalse(any(event.get('kind') == 'game-frame-error' for event in self.events))

    def test_tcp_equipment_switch_duplicate_and_reconnect_keep_only_new_weapon_equipped(self):
        equip_request = struct.pack('<IIII', 8, 8, 0, 0)
        with self.running_server() as port:
            with self.client(port) as client:
                client.send(1010, self.login)
                self.assert_login_frames(client.receive(3))
                client.send(2080, equip_request)
                old_reply, new_reply = client.receive(2)
                self.assertEqual((old_reply.message_id, len(old_reply.payload)), (2310, 72))
                self.assertEqual(struct.unpack_from('<II', old_reply.payload), (7, 7))
                self.assertEqual(struct.unpack_from('<H', old_reply.payload, 4 + 17)[0], 0)
                self.assertEqual((new_reply.message_id, len(new_reply.payload)), (2090, 84))
                self.assertEqual(new_reply.payload[:16], equip_request)
                self.assertEqual(struct.unpack_from('<I', new_reply.payload, 16)[0], 8)
                self.assertEqual(struct.unpack_from('<H', new_reply.payload, 16 + 17)[0], 8)
                client.send(2080, equip_request)
                duplicate = client.receive(1)[0]
                self.assertEqual((duplicate.message_id, duplicate.payload), (2090, new_reply.payload))
            with self.client(port) as reconnected:
                reconnected.send(1010, self.login)
                self.assert_login_frames(reconnected.receive(3), equipped_instance=8)
        self.assert_snapshot(LabRoleStore(self.path).get_items(1001), equipped_instance=8)
        self.assertFalse(any(event.get('kind') == 'game-frame-error' for event in self.events))

    def test_real_zero_destination_request_selects_default_weapon_slot(self):
        from inventory_protocol import PERMANENT_DISPLAY_MINUTES

        self.assertEqual(self.inventory.set_weapons_permanent(1001), 274)

        def assert_permanent_item(item):
            self.assertEqual(struct.unpack_from('<I', item, 13)[0], PERMANENT_DISPLAY_MINUTES)
            self.assertEqual(struct.unpack_from('<I', item, 19)[0], 1)
            self.assertEqual(struct.unpack_from('<H', item, 23)[0], 0)

        # Real-client wire: instance 165, destination left zero, eight opaque
        # trailing bytes. This is a valid second UI path, not a disconnect.
        request = bytes.fromhex('a5000000000000000000000000000000')
        with self.running_server() as port:
            with self.client(port) as client:
                client.send(1010, self.login)
                self.assert_login_frames(client.receive(3))
                client.send(2080, request)
                old, new = client.receive(2)
                self.assertEqual((old.message_id,new.message_id),(2310,2090))
                self.assertEqual(struct.unpack_from('<I',new.payload,16)[0],165)
                self.assertEqual(struct.unpack_from('<H',new.payload,16+17)[0],8)
                assert_permanent_item(new.payload[16:])
                client.send(2080, struct.pack('<IIII', 165, 9, 0, 0))
                rejected = client.receive(1)[0]
                self.assertEqual((rejected.message_id, rejected.payload), (2100, struct.pack('<H', 38)))
                client.send(1010,self.login)
                snapshot = self.assert_login_frames(client.receive(3),equipped_instance=165)
                for item in item_records(snapshot):
                    if item[4] == 25:
                        assert_permanent_item(item)
        self.assertFalse(any(event.get('kind') == 'game-frame-error' for event in self.events))

    def test_invalid_equipment_owner_slot_length_and_unlogged_session_preserve_inventory(self):
        before = self.store.get_items(1001)
        unlogged = RoleSession(self.store, 1001, self.options)
        with self.assertRaises(ValueError):
            unlogged.handle(2080, struct.pack('<IIII', 8, 8, 0, 0), self.control)
        session = RoleSession(self.store, 1001, self.options)
        session.handle(1010, self.login, self.control)
        unsupported = session.handle(2080, struct.pack('<IIII', 8, 9, 0, 0), self.control)
        self.assertEqual([(r['message_id'],r['payload_hex']) for r in unsupported],[(2100,'2600')])
        self.assertEqual(self.store.get_items(1001),before)
        for payload in (bytes(15), bytes(17),
                        struct.pack('<IIII', 1, 8, 0, 0), struct.pack('<IIII', 99999, 8, 0, 0)):
            with self.subTest(payload=payload.hex()):
                with self.assertRaises(ValueError):
                    session.handle(2080, payload, self.control)
                self.assertEqual(self.store.get_items(1001), before)
        other = RoleSession(self.store, 1002, self.options)
        other.handle(2010, struct.pack('<I', 1002) + bytes(92), self.control)
        with self.assertRaises(ValueError):
            other.handle(2080, struct.pack('<IIII', 8, 8, 0, 0), self.control)
        self.assertEqual(self.store.get_items(1001), before)

    def test_tcp_unequip_duplicate_reconnect_and_equip_from_empty_slot(self):
        with self.running_server() as port:
            with self.client(port) as client:
                client.send(1010, self.login)
                self.assert_login_frames(client.receive(3))
                client.send(2300, struct.pack('<I', 7))
                removed = client.receive(1)[0]
                self.assertEqual((removed.message_id, len(removed.payload)), (2310, 72))
                self.assertEqual(struct.unpack_from('<II', removed.payload), (7, 7))
                self.assertEqual(struct.unpack_from('<H', removed.payload, 4 + 17)[0], 0)
                client.send(2300, struct.pack('<I', 7))
                duplicate = client.receive(1)[0]
                self.assertEqual((duplicate.message_id, duplicate.payload), (2310, removed.payload))
            with self.client(port) as reconnected:
                reconnected.send(1010, self.login)
                self.assert_login_frames(reconnected.receive(3), equipped_instance=None)
                reconnected.send(2080, struct.pack('<IIII', 8, 8, 0, 0))
                installed = reconnected.receive(1)[0]
                self.assertEqual((installed.message_id, len(installed.payload)), (2090, 84))
                self.assertEqual(struct.unpack_from('<H', installed.payload, 16 + 17)[0], 8)
        self.assert_snapshot(self.store.get_items(1001), equipped_instance=8)
        self.assertFalse(any(event.get('kind') == 'game-frame-error' for event in self.events))

    def test_invalid_unequip_owner_length_and_unlogged_session_preserve_inventory(self):
        before = self.store.get_items(1001)
        unlogged = RoleSession(self.store, 1001, self.options)
        with self.assertRaises(ValueError):
            unlogged.handle(2300, struct.pack('<I', 7), self.control)
        session = RoleSession(self.store, 1001, self.options)
        session.handle(2010, self.login, self.control)
        for payload in (bytes(3), bytes(5), struct.pack('<I', 1), struct.pack('<I', 99999)):
            with self.subTest(payload=payload.hex()):
                with self.assertRaises(ValueError):
                    session.handle(2300, payload, self.control)
                self.assertEqual(self.store.get_items(1001), before)
        other = RoleSession(self.store, 1002, self.options)
        other.handle(2010, struct.pack('<I', 1002) + bytes(92), self.control)
        with self.assertRaises(ValueError):
            other.handle(2300, struct.pack('<I', 7), self.control)
        self.assertEqual(self.store.get_items(1001), before)


if __name__ == '__main__':
    unittest.main()
