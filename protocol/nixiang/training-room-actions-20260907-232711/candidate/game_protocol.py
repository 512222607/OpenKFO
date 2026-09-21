"""Codec for the legacy Client.exe game protocol used on ports 10035/5136."""

from __future__ import annotations

from dataclasses import dataclass
import struct


MAGIC = b"\xee\xaa"
HEADER_SIZE = 8
INNER_HEADER_SIZE = 10
MAX_ENCODED_SIZE = 2 * 1024 * 1024

# Client.exe initializes eleven strings at 0x63CB90.  The block transform only
# consumes the first eight bytes of each string.
KEYS = (
    b"00Na~1fd",
    b"00xxgg!@",
    b"<>>>SDSD",
    b"012123AS",
    b"<>>>sd!s",
    b"dasdasds",
    b"00xxLL:>",
    b"<>>>$#@@",
    b"01CscaSD",
    b"<>>>*s^6",
    b"KLDK0mji",
)


class GameProtocolError(ValueError):
    """Raised when a complete game frame is structurally invalid."""


@dataclass(frozen=True)
class GameFrame:
    message_id: int
    key_index: int
    payload: bytes
    raw: bytes


def _round_up_8(size: int) -> int:
    return (size + 7) & ~7


def _rol64(value: int, bits: int) -> int:
    bits &= 63
    return ((value << bits) | (value >> (64 - bits))) & 0xFFFFFFFFFFFFFFFF


def _ror64(value: int, bits: int) -> int:
    bits &= 63
    return ((value >> bits) | (value << (64 - bits))) & 0xFFFFFFFFFFFFFFFF


def _encrypt_blocks(data: bytes, key: bytes) -> bytes:
    padded = data.ljust(_round_up_8(len(data)), b"\0")
    key64 = int.from_bytes(key, "little")
    result = bytearray()
    for offset in range(0, len(padded), 8):
        plain64 = int.from_bytes(padded[offset : offset + 8], "little")
        result += (_rol64(plain64, 3) ^ key64).to_bytes(8, "little")
    return bytes(result)


def _decrypt_blocks(data: bytes, key: bytes) -> bytes:
    if len(data) % 8:
        raise GameProtocolError("encrypted block length is not a multiple of 8")
    key64 = int.from_bytes(key, "little")
    result = bytearray()
    for offset in range(0, len(data), 8):
        cipher64 = int.from_bytes(data[offset : offset + 8], "little")
        result += _ror64(cipher64 ^ key64, 3).to_bytes(8, "little")
    return bytes(result)


def header_guard(encoded_size: int) -> int:
    return (encoded_size ^ 0xBBCC) & 0x88AA


def encode_frame(message_id: int, payload: bytes = b"", key_index: int = 0) -> bytes:
    if not 0 <= key_index < len(KEYS):
        raise GameProtocolError(f"invalid key index: {key_index}")
    if not 0 <= message_id <= 0xFFFFFFFF:
        raise GameProtocolError(f"invalid message id: {message_id}")
    if len(payload) > MAX_ENCODED_SIZE:
        raise GameProtocolError("payload is too large")

    transformed_payload = _encrypt_blocks(payload, KEYS[key_index])
    inner = struct.pack("<IHI", message_id, key_index, len(payload)) + transformed_payload
    encoded = _encrypt_blocks(inner, KEYS[0])
    if len(encoded) > MAX_ENCODED_SIZE:
        raise GameProtocolError("encoded frame is too large")
    return MAGIC + struct.pack("<HI", header_guard(len(encoded)), len(encoded)) + encoded


def decode_frame(raw: bytes) -> GameFrame:
    if len(raw) < HEADER_SIZE:
        raise GameProtocolError("frame is shorter than the outer header")
    if raw[:2] != MAGIC:
        raise GameProtocolError("invalid game-frame magic")

    guard, encoded_size = struct.unpack_from("<HI", raw, 2)
    if guard != header_guard(encoded_size):
        raise GameProtocolError("invalid game-frame guard")
    if encoded_size < 16 or encoded_size > MAX_ENCODED_SIZE or encoded_size % 8:
        raise GameProtocolError(f"invalid encoded size: {encoded_size}")
    if len(raw) != HEADER_SIZE + encoded_size:
        raise GameProtocolError("frame length does not match its header")

    inner = _decrypt_blocks(raw[HEADER_SIZE:], KEYS[0])
    message_id, key_index, payload_size = struct.unpack_from("<IHI", inner)
    if key_index >= len(KEYS):
        raise GameProtocolError(f"invalid inner key index: {key_index}")
    transformed_size = _round_up_8(payload_size)
    if INNER_HEADER_SIZE + transformed_size > len(inner):
        raise GameProtocolError("declared payload does not fit in the frame")

    transformed_payload = inner[INNER_HEADER_SIZE : INNER_HEADER_SIZE + transformed_size]
    payload = _decrypt_blocks(transformed_payload, KEYS[key_index])[:payload_size]
    return GameFrame(message_id, key_index, payload, raw)


class GameFrameStream:
    """Reassembles game frames across arbitrary TCP recv boundaries."""

    def __init__(self, max_encoded_size: int = MAX_ENCODED_SIZE):
        self.buffer = bytearray()
        self.max_encoded_size = max_encoded_size
        self.discarded_bytes = 0

    def feed(self, data: bytes) -> list[bytes]:
        self.buffer.extend(data)
        frames: list[bytes] = []
        while True:
            marker = self.buffer.find(MAGIC)
            if marker < 0:
                keep = 1 if self.buffer.endswith(MAGIC[:1]) else 0
                self.discarded_bytes += len(self.buffer) - keep
                if keep:
                    self.buffer[:] = self.buffer[-1:]
                else:
                    self.buffer.clear()
                break
            if marker:
                del self.buffer[:marker]
                self.discarded_bytes += marker
            if len(self.buffer) < HEADER_SIZE:
                break

            guard, encoded_size = struct.unpack_from("<HI", self.buffer, 2)
            valid = (
                16 <= encoded_size <= self.max_encoded_size
                and encoded_size % 8 == 0
                and guard == header_guard(encoded_size)
            )
            if not valid:
                del self.buffer[0]
                self.discarded_bytes += 1
                continue

            total_size = HEADER_SIZE + encoded_size
            if len(self.buffer) < total_size:
                break
            frames.append(bytes(self.buffer[:total_size]))
            del self.buffer[:total_size]
        return frames
