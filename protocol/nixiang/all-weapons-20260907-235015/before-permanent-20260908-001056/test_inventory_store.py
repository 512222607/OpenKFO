"""Inventory persistence tests use disposable SQLite files and no network."""

from concurrent.futures import ThreadPoolExecutor
from contextlib import closing
from pathlib import Path
import sqlite3
import struct
import tempfile
import unittest

from inventory_protocol import InventoryStore


def baseline(uid=1001, weapon=253002):
    role = bytearray(836)
    struct.pack_into('<I', role, 0, uid)
    role[4:8] = b't07\0'
    role[122], role[124] = 2, 13
    for i, (kind, local_id) in enumerate(zip((15, 13, 12, 17, 16, 14, 25),
                                            (152002, 132002, 122001, 172002, 162003, 142002, weapon))):
        struct.pack_into('<IBII', role, 360 + 68 * i, i + 1, kind, local_id, 1)
        struct.pack_into('<H', role, 360 + 68 * i + 17, i + 2)
    return bytes(role)


CATALOG = [{'local_id': 253002, 'kind': 25},
           {'local_id': 100000, 'kind': 25},
           {'local_id': 253003, 'kind': 25}]


def records(payload):
    return [payload[i:i + 68] for i in range(0, len(payload), 68)]


class InventoryStoreTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.path = Path(self.temp.name) / 'roles.sqlite3'
        self.baseline = baseline()
        with closing(sqlite3.connect(self.path)) as db, db:
            db.execute('''CREATE TABLE lab_roles(uid INTEGER PRIMARY KEY,name TEXT,
                         request BLOB,payload BLOB,created_at TEXT)''')
            db.execute('INSERT INTO lab_roles VALUES(?,?,?,?,?)',
                       (1001, 't07', b'opaque original creation request', self.baseline, 'unchanged timestamp'))
        self.original_rows = self.role_rows()
        self.store = InventoryStore(self.path)

    def tearDown(self):
        self.assertEqual(self.role_rows(), self.original_rows, 'Inventory modified original characters')

    def role_rows(self):
        with closing(sqlite3.connect(self.path)) as db:
            return db.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall()

    def inventory_rows(self):
        with closing(sqlite3.connect(self.path)) as db:
            return db.execute('SELECT * FROM lab_inventory ORDER BY uid,instance_id').fetchall()

    def test_ungranted_role_keeps_exact_original_equipment(self):
        self.assertEqual(self.store.get_items(1001, self.baseline), self.baseline[360:])
        self.assertEqual(self.inventory_rows(), [])

    def test_grant_preserves_equipped_baseline_and_adds_unequipped_unique_weapons(self):
        result = self.store.grant_weapons(1001, self.baseline, CATALOG)
        self.assertEqual(result, {'added_weapons': 2, 'total_weapons': 3, 'total_items': 9})
        items = records(self.store.get_items(1001, self.baseline))
        self.assertEqual(b''.join(items[:6]), self.baseline[360:360 + 6 * 68])
        original_weapon = bytearray(items[6])
        self.assertEqual(struct.unpack_from('<H', original_weapon, 23)[0], 1)
        struct.pack_into('<H', original_weapon, 23, 0)
        self.assertEqual(bytes(original_weapon), self.baseline[360 + 6 * 68:])
        self.assertEqual([struct.unpack_from('<IBII', item) for item in items[7:]],
                         [(8, 25, 100000, 1), (9, 25, 253003, 1)])
        self.assertEqual([struct.unpack_from('<H', item, 17)[0] for item in items[7:]], [0, 0])
        self.assertEqual([struct.unpack_from('<H', item, 23)[0] for item in items if item[4] == 25], [1, 1, 1])

    def test_repeated_grant_repairs_legacy_zero_warehouse_count_preserving_slots(self):
        self.store.grant_weapons(1001, self.baseline, CATALOG)
        self.store.equip_weapon(1001, 8)
        with closing(sqlite3.connect(self.path)) as db, db:
            for instance_id, payload in db.execute('SELECT instance_id,payload68 FROM lab_inventory WHERE kind=25').fetchall():
                broken = bytearray(payload)
                struct.pack_into('<H', broken, 23, 0)
                db.execute('UPDATE lab_inventory SET payload68=? WHERE uid=1001 AND instance_id=?', (bytes(broken), instance_id))
        self.assertEqual(self.store.grant_weapons(1001, self.baseline, CATALOG),
                         {'added_weapons': 0, 'total_weapons': 3, 'total_items': 9})
        weapons = [item for item in records(self.store.get_items(1001, self.baseline)) if item[4] == 25]
        self.assertEqual([struct.unpack_from('<H', item, 23)[0] for item in weapons], [1, 1, 1])
        self.assertEqual([struct.unpack_from('<I', item)[0] for item in weapons
                          if struct.unpack_from('<H', item, 17)[0] == 8], [8])
        self.assertEqual(self.store.grant_weapons(1001, self.baseline, CATALOG)['added_weapons'], 0)

    def test_grant_preserves_existing_positive_count_and_duration_inventory(self):
        self.store.grant_weapons(1001, self.baseline, CATALOG)
        with closing(sqlite3.connect(self.path)) as db, db:
            for instance_id, count, duration in ((8, 5, 0), (9, 0, 86400)):
                payload = bytearray(db.execute('SELECT payload68 FROM lab_inventory WHERE uid=1001 AND instance_id=?',
                                               (instance_id,)).fetchone()[0])
                struct.pack_into('<H', payload, 23, count)
                struct.pack_into('<I', payload, 13, duration)
                db.execute('UPDATE lab_inventory SET payload68=? WHERE uid=1001 AND instance_id=?', (bytes(payload), instance_id))
        before = self.inventory_rows()
        self.store.grant_weapons(1001, self.baseline, CATALOG)
        self.assertEqual(self.inventory_rows(), before)

    def test_repeated_and_concurrent_grants_are_idempotent(self):
        with ThreadPoolExecutor(max_workers=4) as pool:
            results = list(pool.map(lambda _: self.store.grant_weapons(1001, self.baseline, CATALOG), range(8)))
        self.assertEqual(sum(result['added_weapons'] for result in results), 2)
        before = self.inventory_rows()
        self.assertEqual(self.store.grant_weapons(1001, self.baseline, list(reversed(CATALOG)))['added_weapons'], 0)
        self.assertEqual(self.inventory_rows(), before)

    def test_reopening_store_preserves_grants_and_equipment_selection(self):
        self.store.grant_weapons(1001, self.baseline, CATALOG)
        self.store.equip_weapon(1001, 8)
        expected = self.store.get_items(1001, self.baseline)
        reopened = InventoryStore(self.path, create_schema=False)
        self.assertEqual(reopened.get_items(1001, self.baseline), expected)
        reopened.grant_weapons(1001, self.baseline, CATALOG)
        self.assertEqual(reopened.get_items(1001, self.baseline), expected)

    def test_invalid_catalog_is_atomic_before_and_after_first_grant(self):
        invalid = [[], {}, [*CATALOG, {'local_id': 0, 'kind': 25}],
                   [*CATALOG, {'local_id': 100007, 'kind': 26}],
                   [*CATALOG, {'local_id': 100007, 'kind': True}],
                   [*CATALOG, {'local_id': True, 'kind': 25}],
                   [*CATALOG, {'local_id': 2 ** 32, 'kind': 25}],
                   [*CATALOG, {'local_id': 253002, 'kind': 25}]]
        for already_granted in (False, True):
            if already_granted:
                self.store.grant_weapons(1001, self.baseline, CATALOG)
            before = self.inventory_rows()
            for catalog in invalid:
                with self.subTest(granted=already_granted, catalog=catalog):
                    with self.assertRaises(ValueError):
                        self.store.grant_weapons(1001, self.baseline, catalog)
                    self.assertEqual(self.inventory_rows(), before)

    def test_conflicting_local_id_rolls_back_baseline_inserts(self):
        with self.assertRaises(ValueError):
            self.store.grant_weapons(1001, self.baseline, [{'local_id': 152002, 'kind': 25}])
        self.assertEqual(self.inventory_rows(), [])

    def test_malformed_or_wrong_character_baseline_is_rejected(self):
        modified = bytearray(self.baseline)
        modified[4] = ord('x')
        invalid = [(1001, self.baseline[:-1]), (1002, self.baseline),
                   (1001, bytes(modified)), (True, self.baseline)]
        for uid, role in invalid:
            with self.subTest(uid=uid, length=len(role)):
                with self.assertRaises(ValueError):
                    self.store.grant_weapons(uid, role, CATALOG)
                self.assertEqual(self.inventory_rows(), [])

    def test_equip_replaces_only_weapon_slot_and_duplicate_is_noop(self):
        self.store.grant_weapons(1001, self.baseline, CATALOG)
        before = self.store.get_items(1001, self.baseline)
        changed = self.store.equip_weapon(1001, 8)
        self.assertEqual([struct.unpack_from('<I', item)[0] for item in changed], [7, 8])
        self.assertEqual([struct.unpack_from('<H', item, 17)[0] for item in changed], [0, 8])
        after = self.store.get_items(1001, self.baseline)
        self.assertEqual(after[:6 * 68], before[:6 * 68])
        self.assertEqual(sum(struct.unpack_from('<H', item, 17)[0] == 8 for item in records(after)), 1)
        self.assertEqual(self.store.equip_weapon(1001, 8), [])
        self.assertEqual(self.store.get_items(1001, self.baseline), after)

    def test_equip_rejects_other_uid_clothes_and_unknown_instance_atomically(self):
        self.store.grant_weapons(1001, self.baseline, CATALOG)
        before = self.inventory_rows()
        for uid, instance_id in ((1002, 8), (1001, 1), (1001, 999), (1001, 0)):
            with self.subTest(uid=uid, instance_id=instance_id):
                with self.assertRaises(ValueError):
                    self.store.equip_weapon(uid, instance_id)
                self.assertEqual(self.inventory_rows(), before)

    def test_failed_equipment_update_rolls_back_previous_weapon_change(self):
        self.store.grant_weapons(1001, self.baseline, CATALOG)
        before = self.inventory_rows()
        with closing(sqlite3.connect(self.path)) as db, db:
            db.execute('''CREATE TRIGGER fail_selected_weapon BEFORE UPDATE ON lab_inventory
                          WHEN NEW.instance_id=8
                          BEGIN SELECT RAISE(ABORT, 'simulated failed write'); END''')
        with self.assertRaises(sqlite3.IntegrityError):
            self.store.equip_weapon(1001, 8)
        self.assertEqual(self.inventory_rows(), before)

    def test_unequip_is_persistent_idempotent_and_can_be_equipped_again(self):
        self.store.grant_weapons(1001, self.baseline, CATALOG)
        changed = self.store.unequip_weapon(1001, 7)
        self.assertEqual(len(changed), 1)
        self.assertEqual(struct.unpack_from('<I', changed[0])[0], 7)
        self.assertEqual(struct.unpack_from('<H', changed[0], 17)[0], 0)
        self.assertEqual(self.store.unequip_weapon(1001, 7), [])
        saved = self.store.get_items(1001, self.baseline)
        reopened = InventoryStore(self.path, create_schema=False)
        self.assertEqual(reopened.get_items(1001, self.baseline), saved)
        self.assertTrue(all(struct.unpack_from('<H', item, 17)[0] == 0
                            for item in records(saved) if item[4] == 25))
        self.assertEqual(len(reopened.equip_weapon(1001, 8)), 1)
        self.assertEqual(b''.join(records(saved)[:6]), self.baseline[360:360 + 6 * 68])

    def test_unequip_rejects_wrong_owner_clothes_and_unknown_instance_atomically(self):
        self.store.grant_weapons(1001, self.baseline, CATALOG)
        before = self.inventory_rows()
        for uid, instance_id in ((1002, 7), (1001, 1), (1001, 999), (1001, 0)):
            with self.subTest(uid=uid, instance_id=instance_id):
                with self.assertRaises(ValueError):
                    self.store.unequip_weapon(uid, instance_id)
                self.assertEqual(self.inventory_rows(), before)

    def test_schema_creation_can_be_explicitly_skipped(self):
        other_path = Path(self.temp.name) / 'unmigrated.sqlite3'
        with closing(sqlite3.connect(other_path)) as db, db:
            db.execute('CREATE TABLE lab_roles(uid INTEGER PRIMARY KEY,payload BLOB)')
            db.execute('INSERT INTO lab_roles VALUES(?,?)', (1001, self.baseline))
        store = InventoryStore(other_path, create_schema=False)
        with closing(sqlite3.connect(other_path)) as db:
            self.assertIsNone(db.execute("SELECT name FROM sqlite_master WHERE name='lab_inventory'").fetchone())
        with self.assertRaises(sqlite3.OperationalError):
            store.get_items(1001, self.baseline)
        migrated = InventoryStore(other_path)
        self.assertEqual(migrated.get_items(1001, self.baseline), self.baseline[360:])

    def test_missing_database_and_nonboolean_schema_flag_do_not_create_files(self):
        missing = Path(self.temp.name) / 'missing.sqlite3'
        with self.assertRaises(sqlite3.OperationalError):
            InventoryStore(missing)
        self.assertFalse(missing.exists())
        with self.assertRaises(ValueError):
            InventoryStore(self.path, create_schema=1)

    def test_corrupt_persisted_record_is_rejected(self):
        self.store.grant_weapons(1001, self.baseline, CATALOG)
        with closing(sqlite3.connect(self.path)) as db, db:
            db.execute('UPDATE lab_inventory SET local_id=100009 WHERE uid=1001 AND instance_id=8')
        with self.assertRaises(ValueError):
            self.store.get_items(1001, self.baseline)


if __name__ == '__main__':
    unittest.main()
