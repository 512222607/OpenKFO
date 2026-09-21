"""Persistent local-lab inventory using the validated 68-byte item records.

The original 836-byte lab_roles payload is never rewritten. 1120 is a complete
inventory snapshot, so get_items returns the baseline equipment plus all grants.
The caller must open an existing role database; this module creates only its own
table. No client, network, or process control is performed here.
"""

from contextlib import closing
from pathlib import Path
import sqlite3
import struct


ITEM_SIZE = 68
ROLE_SIZE = 836
UINT32_MAX = 0xffffffff
BASE_TYPES = (15, 13, 12, 17, 16, 14, 25)
BASE_SLOTS = (2, 3, 4, 5, 6, 7, 8)
WEAPON_KIND = 25
WEAPON_SLOT = 8


def _uint32(value, label):
    if type(value) is not int or not 0 < value <= UINT32_MAX:
        raise ValueError(f'{label} must be a positive uint32')
    return value


def _fields(payload):
    if not isinstance(payload, bytes) or len(payload) != ITEM_SIZE:
        raise ValueError('An inventory record must contain exactly 68 bytes')
    instance_id, kind, local_id, quantity = struct.unpack_from('<IBII', payload)
    slot = struct.unpack_from('<H', payload, 17)[0]
    _uint32(instance_id, 'Instance ID')
    _uint32(local_id, 'Local item ID')
    if kind not in BASE_TYPES or quantity != 1:
        raise ValueError('Unsupported inventory type or quantity')
    expected_slot = BASE_SLOTS[BASE_TYPES.index(kind)]
    if slot != expected_slot and not (kind == WEAPON_KIND and slot == 0):
        raise ValueError('Invalid inventory equipment slot')
    return instance_id, kind, local_id, slot


def _baseline_items(uid, baseline):
    _uint32(uid, 'UID')
    if not isinstance(baseline, bytes) or len(baseline) != ROLE_SIZE:
        raise ValueError('The original role baseline must contain 836 bytes')
    if struct.unpack_from('<I', baseline)[0] != uid:
        raise ValueError('Role baseline belongs to another UID')
    items = [baseline[offset:offset + ITEM_SIZE]
             for offset in range(360, ROLE_SIZE, ITEM_SIZE)]
    local_ids = set()
    for i, item in enumerate(items):
        instance_id, kind, local_id, slot = _fields(item)
        if (instance_id, kind, slot) != (i + 1, BASE_TYPES[i], BASE_SLOTS[i]):
            raise ValueError('Invalid original equipment record')
        if local_id in local_ids:
            raise ValueError('Duplicate local item in role baseline')
        local_ids.add(local_id)
    return items


def _catalog_ids(catalog):
    if not isinstance(catalog, (list, tuple)) or not catalog:
        raise ValueError('A nonempty weapon catalog is required')
    ids = set()
    for item in catalog:
        if not isinstance(item, dict) or type(item.get('kind')) is not int or item['kind'] != WEAPON_KIND:
            raise ValueError('Every catalog entry must have kind=25')
        local_id = _uint32(item.get('local_id'), 'Catalog local item ID')
        if local_id in ids:
            raise ValueError('Duplicate weapon in catalog')
        ids.add(local_id)
    return sorted(ids)


class InventoryStore:
    """Inventory extension of an existing lab_roles SQLite database.

    create_schema=False skips migration and requires the inventory table to
    already exist. All connections use mode=rw, preventing accidental creation
    of an empty database at a misspelled path.
    """

    def __init__(self, path, *, create_schema=True):
        if type(create_schema) is not bool:
            raise ValueError('create_schema must be a bool')
        self.path = Path(path).resolve()
        with closing(self._connect()) as db, db:
            if db.execute("SELECT 1 FROM sqlite_master WHERE type='table' AND name='lab_roles'").fetchone() is None:
                raise ValueError('An existing lab_roles database is required')
            if create_schema:
                db.execute('''CREATE TABLE IF NOT EXISTS lab_inventory (
                    uid INTEGER NOT NULL REFERENCES lab_roles(uid),
                    instance_id INTEGER NOT NULL CHECK(instance_id BETWEEN 1 AND 4294967295),
                    local_id INTEGER NOT NULL CHECK(local_id BETWEEN 1 AND 4294967295),
                    kind INTEGER NOT NULL CHECK(kind BETWEEN 1 AND 255),
                    payload68 BLOB NOT NULL CHECK(length(payload68)=68),
                    PRIMARY KEY(uid, instance_id),
                    UNIQUE(uid, local_id))''')

    def _connect(self):
        db = sqlite3.connect(self.path.as_uri() + '?mode=rw', uri=True, timeout=10)
        db.execute('PRAGMA foreign_keys=ON')
        return db

    @staticmethod
    def _assert_baseline(db, uid, baseline):
        row = db.execute('SELECT payload FROM lab_roles WHERE uid=?', (uid,)).fetchone()
        if row is None or bytes(row[0]) != baseline:
            raise ValueError('Role baseline does not match the persisted character')

    @staticmethod
    def _rows(db, uid):
        rows = db.execute('''SELECT instance_id,kind,local_id,payload68
                             FROM lab_inventory WHERE uid=? ORDER BY instance_id''', (uid,)).fetchall()
        equipped = 0
        result = []
        for instance_id, kind, local_id, payload in rows:
            payload = bytes(payload)
            actual_id, actual_kind, actual_local_id, slot = _fields(payload)
            if (instance_id, kind, local_id) != (actual_id, actual_kind, actual_local_id):
                raise ValueError('Inventory columns disagree with the item record')
            equipped += kind == WEAPON_KIND and slot == WEAPON_SLOT
            result.append((instance_id, kind, local_id, payload))
        if equipped > 1:
            raise ValueError('Inventory contains more than one equipped weapon')
        return result

    def get_items(self, uid, baseline836):
        """Return the complete 1120 item array; ungranted roles use the baseline."""
        _baseline_items(uid, baseline836)
        with closing(self._connect()) as db:
            self._assert_baseline(db, uid, baseline836)
            rows = self._rows(db, uid)
        return b''.join(row[3] for row in rows) if rows else baseline836[360:]

    def grant_weapons(self, uid, baseline836, catalog):
        """Idempotently grant a catalog, preserving equipment and the role row.

        Returns added_weapons, total_weapons, and total_items counts. Catalog
        validation finishes before any transaction changes are made.
        """
        initial = _baseline_items(uid, baseline836)
        local_ids = _catalog_ids(catalog)
        with closing(self._connect()) as db, db:
            db.execute('BEGIN IMMEDIATE')
            self._assert_baseline(db, uid, baseline836)
            rows = self._rows(db, uid)
            if not rows:
                for item in initial:
                    instance_id, kind, local_id, _ = _fields(item)
                    db.execute('INSERT INTO lab_inventory(uid,instance_id,local_id,kind,payload68) VALUES(?,?,?,?,?)',
                               (uid, instance_id, local_id, kind, item))
                rows = self._rows(db, uid)
            existing = {row[2]: row[1] for row in rows}
            for local_id in local_ids:
                if local_id in existing and existing[local_id] != WEAPON_KIND:
                    raise ValueError('Catalog weapon conflicts with an existing nonweapon')
            missing = [local_id for local_id in local_ids if local_id not in existing]
            next_id = max(7, max(row[0] for row in rows)) + 1
            if missing and next_id + len(missing) - 1 > UINT32_MAX:
                raise ValueError('Inventory instance ID space is exhausted')
            for offset, local_id in enumerate(missing):
                instance_id = next_id + offset
                item = bytearray(ITEM_SIZE)
                struct.pack_into('<IBII', item, 0, instance_id, WEAPON_KIND, local_id, 1)
                # +17 WORD=0 is the verified unequipped inventory position.
                db.execute('INSERT INTO lab_inventory(uid,instance_id,local_id,kind,payload68) VALUES(?,?,?,?,?)',
                           (uid, instance_id, local_id, WEAPON_KIND, bytes(item)))
            result = self._rows(db, uid)
            return {'added_weapons': len(missing),
                    'total_weapons': sum(row[1] == WEAPON_KIND for row in result),
                    'total_items': len(result)}

    def equip_weapon(self, uid, instance_id):
        """Atomically select an owned weapon; return changed 68-byte records.

        The unequipped old weapon precedes the new equipped weapon. Selecting
        the currently equipped instance again is an idempotent empty result.
        """
        _uint32(uid, 'UID')
        _uint32(instance_id, 'Instance ID')
        with closing(self._connect()) as db, db:
            db.execute('BEGIN IMMEDIATE')
            rows = self._rows(db, uid)
            selected = next((row for row in rows if row[0] == instance_id), None)
            if selected is None or selected[1] != WEAPON_KIND:
                raise ValueError('The selected instance is not an owned weapon')
            if struct.unpack_from('<H', selected[3], 17)[0] == WEAPON_SLOT:
                return []
            changed = []
            for old_id, kind, _local_id, payload in rows:
                if kind == WEAPON_KIND and struct.unpack_from('<H', payload, 17)[0] == WEAPON_SLOT:
                    item = bytearray(payload)
                    struct.pack_into('<H', item, 17, 0)
                    changed.append(bytes(item))
                    db.execute('UPDATE lab_inventory SET payload68=? WHERE uid=? AND instance_id=?',
                               (bytes(item), uid, old_id))
            item = bytearray(selected[3])
            struct.pack_into('<H', item, 17, WEAPON_SLOT)
            changed.append(bytes(item))
            db.execute('UPDATE lab_inventory SET payload68=? WHERE uid=? AND instance_id=?',
                       (bytes(item), uid, instance_id))
            return changed

    def unequip_weapon(self, uid, instance_id):
        """Persist an owned weapon in slot zero; repeated removal is a no-op."""
        _uint32(uid, 'UID')
        _uint32(instance_id, 'Instance ID')
        with closing(self._connect()) as db, db:
            db.execute('BEGIN IMMEDIATE')
            selected = next((row for row in self._rows(db, uid) if row[0] == instance_id), None)
            if selected is None or selected[1] != WEAPON_KIND:
                raise ValueError('The selected instance is not an owned weapon')
            if struct.unpack_from('<H', selected[3], 17)[0] == 0:
                return []
            item = bytearray(selected[3])
            struct.pack_into('<H', item, 17, 0)
            db.execute('UPDATE lab_inventory SET payload68=? WHERE uid=? AND instance_id=?',
                       (bytes(item), uid, instance_id))
            return [bytes(item)]
