"""Local room reconstruction from the relocated client handler table.

The dump is loaded at zero in IDA: table pointer VA must be reduced by
0x10000. Direct relative calls already resolve to dump offsets. Relevant
handlers: 3020=0x8153A0 (83 bytes), 3100=0x814490 (245 bytes).
This module provides one synthetic user's room, not a multiplayer service.
"""
from dataclasses import dataclass
import struct

CREATE_SIZE = 81
CREATE_ACK_SIZE = 83
ENTER_REQUEST_SIZE = 14
ENTER_ACK_SIZE = 245
PLAYER_SIZE = 149


def response(message_id, payload):
    return {'message_id': message_id, 'key_index': 0, 'payload_hex': payload.hex()}


def validate_create_request(payload):
    if len(payload) != CREATE_SIZE:
        raise ValueError('3010 requires exactly 81 bytes')
    for start, size in ((0, 21), (21, 11)):
        if b'\0' not in payload[start:start + size]:
            raise ValueError('Room strings must be NUL terminated')


def build_create_ack(request, room_handle=1):
    validate_create_request(request)
    if not 1 <= room_handle <= 0xffff:
        raise ValueError('Room handle must be a nonzero WORD')
    # sub_8153A0 copies the original 81-byte request from offset 2.
    return struct.pack('<H', room_handle) + request


def build_enter_ack(request, uid, role, room_handle=1, map_id=None, map_variant=None):
    validate_create_request(request)
    if not 1 <= uid <= 0xffffffffffffffff or not 1 <= room_handle <= 0xffff:
        raise ValueError('Invalid local player or room handle')
    if role is None or len(role) != 836:
        raise ValueError('A persisted character is required to enter a room')
    payload = bytearray(ENTER_ACK_SIZE)
    struct.pack_into('<HQ', payload, 0, room_handle, uid)
    payload[10] = 0  # creator's player slot; 8 would select spectator handling
    payload[11] = 0
    payload[12:20] = request[38:46]
    if map_id is not None:
        struct.pack_into('<I', payload, 12, map_id)
    if map_variant is not None:
        struct.pack_into('<I', payload, 16, map_variant)
    payload[24:45] = request[0:21]
    payload[45:56] = request[21:32]
    payload[56:61] = request[32:37]
    payload[61] = bool(request[21])
    payload[62] = request[37]
    payload[65] = request[46]
    payload[66] = 0
    payload[67:69] = request[47:49]
    payload[73] = request[49]
    payload[78:82] = request[59:63]
    # Self appearance is supplied by the already logged-in client, not by
    # these 149 bytes. Fill identity fields; unsupported metadata stays 0.
    struct.pack_into('<Q', payload, 96, uid)
    # Peer-layout identity: +8 slot, +9 team, +10 position, +11 name[21].
    payload[107:128] = role[4:25]
    return bytes(payload)


@dataclass
class RoomSession:
    uid: int
    store: object
    request: bytes | None = None
    room_handle: int = 1
    entered: bool = False

    def handle(self, message_id, payload, control):
        if message_id == 3010:
            reply = build_create_ack(payload, self.room_handle)
            self.request = bytes(payload)
            self.entered = False
            return [response(3020, reply)]
        if message_id == 3070:
            if len(payload) != ENTER_REQUEST_SIZE:
                raise ValueError('3070 requires exactly 14 bytes')
            if self.request is None or struct.unpack_from('<H', payload)[0] != self.room_handle:
                raise ValueError('3070 references no room created by this session')
            settings = control.get('room_recovery', {})
            reply = build_enter_ack(self.request, self.uid, self.store.get(self.uid),
                                    self.room_handle, settings.get('map_id'), settings.get('map_variant'))
            self.entered = True
            return [response(3100, reply)]
        if message_id == 3550:
            if len(payload) != 12 or struct.unpack_from('<Q', payload)[0] != self.uid:
                raise ValueError('3550 must describe the local player')
            # The receiver reads QWORD player UID + DWORD status. Preserve
            # the client's actual status instead of inventing a new field.
            return [response(3550, payload)]
        if message_id == 2250:
            if len(payload) != 8:
                raise ValueError('2250 requires exactly eight bytes')
            return [] if self.entered else [response(2270, bytes(8))]
        if message_id == 2260:
            if len(payload) != 3:
                raise ValueError('2260 requires exactly three bytes')
            return [] if self.entered else [response(2280, struct.pack('<II', 0, 1))]
        # These were previously mistaken for room initialization. Suppress
        # old fixed config fallback replies; they belong to other features.
        if message_id in (20540, 20544, 20546, 2540, 2560):
            return []
        return None
