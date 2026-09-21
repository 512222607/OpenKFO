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

TYPES = (15, 13, 12, 17, 16, 14, 25)
EQUIP_SLOTS = (2, 3, 4, 5, 6, 7, 8)
ROOM_CREATE_REQUEST_SIZE = 81
ROOM_CREATE_ACK_SIZE = 4
ROOM_LIST_REQUEST_SIZE = 8
ROOM_LIST_ENTRY_SIZE = 13
ROOM_LIST_CAPACITY = 100
ROOM_LIST_WIRE_SIZE = 4 + ROOM_LIST_CAPACITY * ROOM_LIST_ENTRY_SIZE
ROOM_PAGE_REQUEST_SIZE = 3
ROOM_PAGE_HEADER_SIZE = 8
ROOM_CONTEXT_REQUEST_SIZE = 0
ROOM_CONTEXT_SLOT_COUNT = 4
ROOM_CONTEXT_SLOT_SIZE = 8
ROOM_CONTEXT_WIRE_SIZE = 40
ROOM_ENTER_REQUEST_SIZE = 8
ROOM_MODE_STATUS_REQUEST_SIZE = 0
ROOM_MODE_STATUS_FIELD_COUNT = 7
ROOM_MODE_STATUS_WIRE_SIZE = 28
ROOM_MODE_STATUS_VALUE = 1
ROOM_ENTER_ACK_SIZE = 1
ROOM_ENTER_ACK_OK = 0
ROOM_POST_ENTER_2540_REQUEST_SIZE = 1
ROOM_POST_ENTER_2560_REQUEST_SIZE = 9
ROOM_POST_ENTER_PLAYER_SIZE = 62
ROOM_POST_ENTER_NAME_OFFSET = 37
ROOM_POST_ENTER_TAIL_OFFSET = 58
ROOM_POST_ENTER_DEFAULT_NAME = 't07'
ROOM_STATE_SIZE = 196
ROOM_MODE_OFFSET = 0x54
ROOM_LIST_FLAG_OFFSET = 0x5C
ROOM_ID_OFFSET = 0x61
ROOM_STATUS_COLOR = 0xFF00FF00
ROOM_LIST_ENTRY_FLAG = 1
ROOM_CONTEXT_SLOT_VALUE = 1
DEFAULT_ROOM_BATTLE_MODE_KEY = 121000
DEFAULT_ROOM_ID = DEFAULT_ROOM_BATTLE_MODE_KEY * 100
ROOM_CREATE_STATE_PUSH_DELAY_MS = 150
ROOM_CREATE_CONTEXT_PUSH_DELAY_MS = 220
ROOM_CREATE_ENTER_ACK_PUSH_DELAY_MS = 300

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

def build_room_create_ack_payload(room_id=DEFAULT_ROOM_ID):
    """Build the 4-byte 3020 room-id ack consumed by Client.exe."""
    if not 0 < room_id <= 0xffffffff:
        raise ValueError('Invalid room ID')
    return struct.pack('<I', room_id)

def build_room_state_payload(room_id=DEFAULT_ROOM_ID, mode=ROOM_STATUS_COLOR, room_flag=ROOM_LIST_ENTRY_FLAG):
    """Build the 196-byte room-state payload consumed by Client.exe."""
    if not 0 < room_id <= 0xffffffff:
        raise ValueError('Invalid room ID')
    if not 0 <= mode <= 0xffffffff:
        raise ValueError('Invalid room mode')
    if not 0 <= room_flag <= 0xff:
        raise ValueError('Invalid room flag')
    payload = bytearray(ROOM_STATE_SIZE)
    struct.pack_into('<I', payload, ROOM_MODE_OFFSET, mode)
    payload[ROOM_LIST_FLAG_OFFSET] = room_flag
    struct.pack_into('<I', payload, ROOM_ID_OFFSET, room_id)
    return bytes(payload)

def build_room_list_payload(room_id=DEFAULT_ROOM_ID, first_value=0, second_value=0, room_flag=ROOM_LIST_ENTRY_FLAG):
    """Build the 0x518-byte 2500 room-list payload parsed by Client.exe."""
    if not 0 < room_id <= 0xffffffff:
        raise ValueError('Invalid room ID')
    if not 0 <= first_value <= 0xffffffff or not 0 <= second_value <= 0xffffffff:
        raise ValueError('Invalid room-list value')
    if not 0 <= room_flag <= 0xff:
        raise ValueError('Invalid room flag')
    payload = bytearray(ROOM_LIST_WIRE_SIZE)
    struct.pack_into('<I', payload, 0, 1)
    struct.pack_into('<IIIB', payload, 4, room_id, first_value, second_value, room_flag)
    return bytes(payload)

def build_room_page_payload(total_rooms=0, total_pages=1):
    """Build the minimal 2580 page response for 2260/3 room polling.

    IDA: sub_814280 accepts 8 + n*0x103 bytes.  The first two DWORDs feed
    controller counters; an empty one-page response unlocks state 10/11
    without inventing a rich 0x103-byte room record.
    """
    if not 0 <= total_rooms <= 0xffffffff or not 1 <= total_pages <= 0xffffffff:
        raise ValueError('Invalid room page counters')
    return struct.pack('<II', total_rooms, total_pages)

def build_room_context_payload(room_id=DEFAULT_ROOM_ID, slot_value=ROOM_CONTEXT_SLOT_VALUE):
    """Build the 40-byte 20564 room-context payload consumed by sub_A1C630."""
    if not 0 < room_id <= 0xffffffff:
        raise ValueError('Invalid room ID')
    if not 0 < slot_value <= 0xffffffff:
        raise ValueError('Invalid room-context slot value')
    payload = bytearray(ROOM_CONTEXT_WIRE_SIZE)
    struct.pack_into('<II', payload, 0, room_id, slot_value)
    return bytes(payload)

def build_room_mode_status_payload(status=ROOM_MODE_STATUS_VALUE, extra_fields=None):
    """Build the 28-byte 20566 candidate consumed by sub_A1C240."""
    if not 0 <= status <= 0xffffffff:
        raise ValueError('Invalid room mode status')
    fields = [status]
    if extra_fields is None:
        fields.extend([0] * (ROOM_MODE_STATUS_FIELD_COUNT - 1))
    else:
        extras = list(extra_fields)
        if len(extras) != ROOM_MODE_STATUS_FIELD_COUNT - 1:
            raise ValueError('Room mode status requires exactly six extra fields')
        for value in extras:
            if not 0 <= value <= 0xffffffff:
                raise ValueError('Invalid room mode status extra field')
        fields.extend(extras)
    return struct.pack('<' + 'I' * ROOM_MODE_STATUS_FIELD_COUNT, *fields)

def build_room_enter_ack_payload(status=ROOM_ENTER_ACK_OK):
    """Build the 1-byte 20560 success candidate consumed by sub_A1BC40."""
    if not 0 <= status <= 0xff:
        raise ValueError('Invalid room enter status')
    return bytes([status])

def build_room_post_enter_player_payload(uid=1001, room_id=DEFAULT_ROOM_ID, name=ROOM_POST_ENTER_DEFAULT_NAME):
    """Build a 62-byte 2550/2570 post-enter payload consumed by sub_81F570."""
    if not 0 < uid <= 0xffffffffffffffff:
        raise ValueError('Invalid player UID')
    if not 0 <= room_id <= 0xffffffff:
        raise ValueError('Invalid room ID')
    encoded_name = name.encode('gbk', errors='strict')
    if not encoded_name or len(encoded_name) > ROOM_POST_ENTER_TAIL_OFFSET - ROOM_POST_ENTER_NAME_OFFSET - 1:
        raise ValueError('Room player name must fit the NUL-terminated field')
    payload = bytearray(ROOM_POST_ENTER_PLAYER_SIZE)
    struct.pack_into('<Q', payload, 0, uid)
    struct.pack_into('<I', payload, 29, room_id)
    payload[ROOM_POST_ENTER_NAME_OFFSET:ROOM_POST_ENTER_NAME_OFFSET + len(encoded_name)] = encoded_name
    return bytes(payload)

class RoleSession:
    def __init__(self, store, uid, options):
        self.store, self.uid, self.options = store, uid, options
        self.logged_in = False
        self.pending_create = False

    def handle(self, message_id, payload, control):
        if message_id == 2010:
            if len(payload) != 96 or struct.unpack_from('<I', payload)[0] != self.uid:
                raise ValueError('Invalid alternate-login request')
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
            return [login, response(1120,saved[360:],250), response(1130,saved[:360])]
        if message_id == 3010:
            if len(payload) != ROOM_CREATE_REQUEST_SIZE:
                raise ValueError('3010 must contain exactly 81 bytes')
            replies = [response(3020, build_room_create_ack_payload())]
            if control.get('room_stage', {}).get('push_room_state_3030_after_create', True):
                replies.append(response(3030, build_room_state_payload(), ROOM_CREATE_STATE_PUSH_DELAY_MS))
            if control.get('room_stage', {}).get('push_room_context_20564_after_create', False):
                replies.append(response(20564, build_room_context_payload(), ROOM_CREATE_CONTEXT_PUSH_DELAY_MS))
            if control.get('room_stage', {}).get('push_room_enter_ack_20560_after_create', False):
                replies.append(response(20560, build_room_enter_ack_payload(), ROOM_CREATE_ENTER_ACK_PUSH_DELAY_MS))
            return replies
        if message_id == 2250:
            if len(payload) != ROOM_LIST_REQUEST_SIZE:
                raise ValueError('2250 must contain exactly eight bytes')
            return [response(2500, build_room_list_payload())]
        if message_id == 2260:
            if len(payload) != ROOM_PAGE_REQUEST_SIZE:
                raise ValueError('2260 must contain exactly three bytes')
            if control.get('room_stage', {}).get('enable_room_page_2580', False):
                return [response(2580, build_room_page_payload())]
            return None
        if message_id == 20544:
            if len(payload) != ROOM_CONTEXT_REQUEST_SIZE:
                raise ValueError('20544 must not contain a payload')
            return [response(20564, build_room_context_payload())]
        if message_id == 20540:
            if len(payload) != ROOM_ENTER_REQUEST_SIZE:
                raise ValueError('20540 must contain exactly eight bytes')
            return [response(20560, build_room_enter_ack_payload())]
        if message_id == 2540:
            if len(payload) != ROOM_POST_ENTER_2540_REQUEST_SIZE:
                raise ValueError('2540 must contain exactly one byte')
            if control.get('room_stage', {}).get('enable_post_enter_25xx', True):
                return [response(2550, build_room_post_enter_player_payload(self.uid))]
            return None
        if message_id == 2560:
            if len(payload) != ROOM_POST_ENTER_2560_REQUEST_SIZE:
                raise ValueError('2560 must contain exactly nine bytes')
            if control.get('room_stage', {}).get('enable_post_enter_25xx', True):
                return [response(2570, build_room_post_enter_player_payload(self.uid))]
            return None
        if message_id == 20546:
            if len(payload) != ROOM_MODE_STATUS_REQUEST_SIZE:
                raise ValueError('20546 must not contain a payload')
            if control.get('room_stage', {}).get('enable_room_mode_20566', False):
                return [response(20566, build_room_mode_status_payload())]
            return []
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
