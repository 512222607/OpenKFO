"""Validated local-lab character payloads; authentication is still synthetic.

1150 is 68 bytes. 1151 is a 360-byte role plus seven 68-byte items.
The unobserved role fields remain zero: this is a channel-selection baseline,
not a complete world/combat character schema.
"""
from dataclasses import dataclass
from contextlib import closing
from pathlib import Path
import sqlite3
import struct
from room_protocol import RoomSession
from inventory_protocol import InventoryStore

TYPES = (15, 13, 12, 17, 16, 14, 25)
EQUIP_SLOTS = (2, 3, 4, 5, 6, 7, 8)

@dataclass(frozen=True)
class CreateRole:
    name: str
    gender: int
    variant: int
    choices: tuple[int, ...]
    raw: bytes

def parse_create_role(payload: bytes) -> CreateRole:
    if len(payload) != 68:
        raise ValueError('1150 must contain exactly 68 bytes')
    field = payload[:21]
    end = field.find(b'\0')
    if not 1 <= end <= 20:
        raise ValueError('Nickname must be NUL terminated within 21 bytes')
    name = field[:end].decode('gbk', errors='strict')
    if name != name.strip() or any(ord(c) < 32 or ord(c) == 127 for c in name):
        raise ValueError('Invalid nickname')
    if payload[21] not in (1, 2) or payload[22] >= 20:
        raise ValueError('Unsupported gender or variant')
    return CreateRole(name, payload[21], payload[22], struct.unpack_from('<7I', payload, 23), payload)

def option_map(payload: bytes) -> dict:
    if not payload or len(payload) % 16:
        raise ValueError('1125 options must be complete 16-byte records')
    result = {}
    for gender, slot, choice, local_id in struct.iter_unpack('<4I', payload):
        key = (gender, slot, choice)
        if gender not in (1, 2) or slot >= 7 or not choice or not local_id:
            raise ValueError('Invalid 1125 option')
        if key in result and result[key] != local_id:
            raise ValueError('Ambiguous server choice ID')
        result[key] = local_id
    return result

def build_role_payload(role_id: int, request: bytes, options: dict) -> bytes:
    role = parse_create_role(request)
    if not 0 < role_id <= 0xffffffff:
        raise ValueError('Invalid role ID')
    state = bytearray(360)
    struct.pack_into('<I', state, 0, role_id)
    nickname = role.name.encode('gbk')
    state[4:4+len(nickname)] = nickname
    state[122] = role.gender
    state[124] = role.variant
    items = bytearray()
    for i, choice in enumerate(role.choices):
        local_id = options.get((role.gender, i, choice))
        if local_id is None:
            raise ValueError(f'Choice {choice} was not offered for slot {i}')
        item = bytearray(68)
        struct.pack_into('<IBII', item, 0, i+1, TYPES[i], local_id, 1)
        struct.pack_into('<H', item, 17, EQUIP_SLOTS[i])
        items.extend(item)
    return bytes(state + items)

def validate_role_payload(payload: bytes, uid: int) -> None:
    if len(payload) != 836 or struct.unpack_from('<I', payload)[0] != uid:
        raise ValueError('Invalid persisted role payload')
    if payload[122] not in (1, 2) or payload[124] >= 20:
        raise ValueError('Invalid persisted model fields')
    if not 1 <= payload[4:25].find(b'\0') <= 20:
        raise ValueError('Invalid persisted name')
    for i in range(7):
        offset = 360+68*i
        rid, kind, local_id, quantity = struct.unpack_from('<IBII', payload, offset)
        slot = struct.unpack_from('<H', payload, offset+17)[0]
        if (rid, kind, slot) != (i+1, TYPES[i], EQUIP_SLOTS[i]) or not local_id or quantity != 1:
            raise ValueError('Invalid persisted equipment')

class LabRoleStore:
    """One role per synthetic lab UID; does not authenticate the UID."""
    def __init__(self, path):
        self.path = Path(path)
        self.path.parent.mkdir(parents=True, exist_ok=True)
        with closing(sqlite3.connect(self.path)) as db, db:
            db.execute('''CREATE TABLE IF NOT EXISTS lab_roles (
                uid INTEGER PRIMARY KEY, name TEXT NOT NULL UNIQUE,
                request BLOB NOT NULL, payload BLOB NOT NULL,
                created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP)''')

    def get(self, uid):
        with closing(sqlite3.connect(self.path)) as db:
            row = db.execute('SELECT payload FROM lab_roles WHERE uid=?', (uid,)).fetchone()
        if row is None:
            return None
        payload = bytes(row[0])
        validate_role_payload(payload, uid)
        return payload

    def get_items(self, uid):
        saved = self.get(uid)
        if saved is None:
            raise ValueError('No persisted role for inventory')
        return InventoryStore(self.path).get_items(uid, saved)

    def create(self, uid, request, options):
        role = parse_create_role(request)
        payload = build_role_payload(uid, request, options)
        validate_role_payload(payload, uid)
        with closing(sqlite3.connect(self.path, timeout=10)) as db, db:
            db.execute('BEGIN IMMEDIATE')
            old = db.execute('SELECT request,payload FROM lab_roles WHERE uid=?', (uid,)).fetchone()
            if old:
                previous = parse_create_role(bytes(old[0]))
                # Ignore opaque referral/tail changes when retrying the same creation.
                if (previous.name, previous.gender, previous.variant, previous.choices) != (role.name, role.gender, role.variant, role.choices):
                    raise ValueError('This lab UID already has a different character')
                saved = bytes(old[1])
                validate_role_payload(saved, uid)
                return saved
            try:
                db.execute('INSERT INTO lab_roles(uid,name,request,payload) VALUES(?,?,?,?)', (uid, role.name, request, payload))
            except sqlite3.IntegrityError as exc:
                raise ValueError('Nickname already exists') from exc
        return payload

def response(message_id, payload, delay_ms=100):
    return {'message_id':message_id,'payload_hex':payload.hex(),'delay_ms':delay_ms,'key_index':0}

def build_world_handoff_payload(world_id, host='127.0.0.1', port=5136, route_id=1):
    """Build the 52-byte 2030 handoff record consumed by Client.exe.

    IDA shows a DWORD id, a 20-byte address field, a uint16 port and a DWORD
    route value at offsets 0, 4, 24 and 26.  The unobserved tail stays zero.
    """
    if not 0 < world_id <= 0xffffffff or not 0 < route_id <= 0xffffffff:
        raise ValueError('Invalid world or route ID')
    if not 0 < port <= 0xffff:
        raise ValueError('Invalid world port')
    try:
        encoded_host = host.encode('ascii')
    except UnicodeEncodeError as exc:
        raise ValueError('World host must be ASCII') from exc
    if not encoded_host or len(encoded_host) >= 20 or b'\0' in encoded_host:
        raise ValueError('World host must fit the NUL-terminated 20-byte field')
    payload = bytearray(52)
    struct.pack_into('<I', payload, 0, world_id)
    payload[4:4+len(encoded_host)] = encoded_host
    struct.pack_into('<H', payload, 24, port)
    struct.pack_into('<I', payload, 26, route_id)
    return bytes(payload)

class RoleSession:
    def __init__(self, store, uid, options):
        self.store, self.uid, self.options = store, uid, options
        self.logged_in = False
        self.pending_create = False
        self.room_session = RoomSession(uid, store)

    def handle(self, message_id, payload, control):
        room_reply = self.room_session.handle(message_id, payload, control)
        if room_reply is not None:
            return room_reply
        if message_id == 2300:
            if not self.logged_in:
                raise ValueError('Login is required before unequipping weapons')
            if len(payload) != 4:
                raise ValueError('2300 requires exactly four bytes')
            instance_id = struct.unpack('<I', payload)[0]
            inventory = InventoryStore(self.store.path)
            changed = inventory.unequip_weapon(self.uid, instance_id)
            if changed:
                selected = changed[0]
            else:
                items = self.store.get_items(self.uid)
                selected = next(items[i:i+68] for i in range(0,len(items),68)
                                if struct.unpack_from('<I',items,i)[0] == instance_id)
            return [response(2310, selected[:4] + selected, 0)]
        if message_id == 2080:
            if not self.logged_in:
                raise ValueError('Login is required before equipping weapons')
            if len(payload) != 16:
                raise ValueError('2080 requires exactly sixteen bytes')
            instance_id, slot = struct.unpack_from('<II', payload)
            if slot != 8:
                raise ValueError('Only the validated weapon equipment slot is supported')
            inventory = InventoryStore(self.store.path)
            changed = inventory.equip_weapon(self.uid, instance_id)
            replies = []
            for item in changed:
                if struct.unpack_from('<H', item, 17)[0] == 0:
                    # 2310 identifies the old instance then supplies its 68B
                    # unequipped state. Clear it before installing the new one.
                    replies.append(response(2310, item[:4] + item, 0))
            selected = next((item for item in changed
                             if struct.unpack_from('<I', item)[0] == instance_id), None)
            if selected is None:
                # A repeated request still receives the current successful state.
                items = self.store.get_items(self.uid)
                selected = next(items[i:i+68] for i in range(0,len(items),68)
                                if struct.unpack_from('<I',items,i)[0] == instance_id)
            prefix = struct.pack('<IIII', instance_id, slot, 0, 0)
            replies.append(response(2090, prefix + selected, 0))
            return replies
        if message_id == 2010:
            if len(payload) != 96 or struct.unpack_from('<I', payload)[0] != self.uid:
                raise ValueError('Invalid alternate-login request')
            self.logged_in = True
            return [response(2030, build_world_handoff_payload(self.uid))]
        if message_id == 1010:
            if len(payload) != 96 or struct.unpack_from('<I',payload)[0] != self.uid:
                raise ValueError('Only the configured synthetic lab UID is accepted')
            self.logged_in = True
            saved = self.store.get(self.uid)
            if saved is None:
                return None  # Existing 1020 + validated 1125 sequence.
            rules = control['game']['1010']
            login = next(r.copy() for r in rules if r.get('message_id') == 1020 and r.get('enabled',True))
            # 1120 replaces the client's entire collection. Send one complete
            # 68-byte-record array, including both equipment and owned weapons.
            return [login, response(1120,self.store.get_items(self.uid),250), response(1130,saved[:360])]
        if message_id not in (1150,3320):
            return None
        if not self.logged_in:
            raise ValueError('1010 is required before character requests')
        if message_id == 1150:
            saved = self.store.create(self.uid,payload,self.options)
            self.pending_create = True
            return [response(1151,saved)]
        if len(payload) != 4:
            raise ValueError('3320 requires four bytes')
        saved = self.store.get(self.uid)
        if saved is None:
            raise ValueError('No persisted role to select')
        if self.pending_create:
            self.pending_create = False
            # Validated sequence: 1151 -> 3320 -> 3330 -> 1130 reaches channels.
            return [response(3330,saved[:4]),response(1130,saved[:360])]
        if payload != saved[:4]:
            raise ValueError('Unknown role selection ID')
        replies = [response(3330,saved[:4])]
        settings = control.get('role_persistence', {})
        if settings.get('advance_after_role_select_1201', False):
            # IDA: inbound 1201 requires a DWORD. Zero enters the selected
            # channel/server path and causes the client to send 2010/96.
            replies.append(response(1201, bytes(4), 150))
        return replies
