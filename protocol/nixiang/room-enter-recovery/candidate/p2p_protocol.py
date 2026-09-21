"""Minimal SDP2P UDP wire helpers recovered from SDP2P.dll.

The packet header is copied as raw little-endian fields by SDP2P.dll, while
message bodies use htons/htonl for scalar fields.
"""

from __future__ import annotations

from dataclasses import dataclass
import ipaddress
import struct
from typing import Iterable


MSG_LOGIN_REQ = 1001
MSG_LOGIN_ACK = 1002
MSG_KEEPALIVE_REQ = 1013
MSG_KEEPALIVE_ACK = 1014

P2P_HEADER_SIZE = 24
P2P_HEADER = struct.Struct("<HHIIIIHBB")
LOGIN_ACK_BODY = struct.Struct("!IIIIH")
U32_BODY = struct.Struct("!I")
MAX_ROUTE_IDS = 32


class P2PProtocolError(ValueError):
    """Raised when a UDP datagram does not match the recovered P2P format."""


@dataclass(frozen=True)
class P2PHeader:
    version: int
    message_id: int
    session_id: int
    reserved: int
    src_p2p_id: int
    dst_or_aux: int
    reserved2: int
    flag: int
    route_ids: tuple[int, ...] = ()

    @property
    def route_bytes(self) -> int:
        return len(self.route_ids) * 4


@dataclass(frozen=True)
class P2PDatagram:
    header: P2PHeader
    body: bytes


@dataclass(frozen=True)
class P2PLoginRequest:
    login_name: bytes
    advertised_ip: int
    advertised_port: int
    session_hint: int
    opaque_p2p_info: bytes
    trailing: bytes = b""


def _u16(value: int, name: str) -> int:
    if not 0 <= int(value) <= 0xFFFF:
        raise P2PProtocolError(f"{name} out of uint16 range: {value!r}")
    return int(value)


def _u8(value: int, name: str) -> int:
    if not 0 <= int(value) <= 0xFF:
        raise P2PProtocolError(f"{name} out of uint8 range: {value!r}")
    return int(value)


def _u32(value: int, name: str) -> int:
    if not 0 <= int(value) <= 0xFFFFFFFF:
        raise P2PProtocolError(f"{name} out of uint32 range: {value!r}")
    return int(value)


def parse_datagram(raw: bytes) -> P2PDatagram:
    if len(raw) < P2P_HEADER_SIZE:
        raise P2PProtocolError(f"P2P datagram too short: {len(raw)}")

    (
        version,
        message_id,
        session_id,
        reserved,
        src_p2p_id,
        dst_or_aux,
        reserved2,
        flag,
        route_bytes,
    ) = P2P_HEADER.unpack_from(raw, 0)

    if route_bytes % 4:
        raise P2PProtocolError(f"route byte count is not aligned: {route_bytes}")
    if route_bytes > MAX_ROUTE_IDS * 4:
        raise P2PProtocolError(f"too many route bytes: {route_bytes}")
    body_offset = P2P_HEADER_SIZE + route_bytes
    if len(raw) < body_offset:
        raise P2PProtocolError(f"P2P datagram truncated in route list: {len(raw)} < {body_offset}")

    route_ids = tuple(
        struct.unpack_from("<I", raw, P2P_HEADER_SIZE + i)[0]
        for i in range(0, route_bytes, 4)
    )
    header = P2PHeader(
        version=version,
        message_id=message_id,
        session_id=session_id,
        reserved=reserved,
        src_p2p_id=src_p2p_id,
        dst_or_aux=dst_or_aux,
        reserved2=reserved2,
        flag=flag,
        route_ids=route_ids,
    )
    return P2PDatagram(header=header, body=raw[body_offset:])


def encode_datagram(
    message_id: int,
    body: bytes = b"",
    *,
    version: int = 1,
    session_id: int = 0,
    reserved: int = 0,
    src_p2p_id: int = 0,
    dst_or_aux: int = 0,
    reserved2: int = 0,
    flag: int = 0,
    route_ids: Iterable[int] = (),
) -> bytes:
    routes = tuple(_u32(route_id, "route_id") for route_id in route_ids)
    if len(routes) > MAX_ROUTE_IDS:
        raise P2PProtocolError(f"too many route ids: {len(routes)}")

    header = P2P_HEADER.pack(
        _u16(version, "version"),
        _u16(message_id, "message_id"),
        _u32(session_id, "session_id"),
        _u32(reserved, "reserved"),
        _u32(src_p2p_id, "src_p2p_id"),
        _u32(dst_or_aux, "dst_or_aux"),
        _u16(reserved2, "reserved2"),
        _u8(flag, "flag"),
        _u8(len(routes) * 4, "route_bytes"),
    )
    route_blob = b"".join(struct.pack("<I", route_id) for route_id in routes)
    return header + route_blob + body


def decode_login_request(datagram: P2PDatagram) -> P2PLoginRequest:
    if datagram.header.message_id != MSG_LOGIN_REQ:
        raise P2PProtocolError(f"expected login request {MSG_LOGIN_REQ}, got {datagram.header.message_id}")

    body = datagram.body
    if len(body) < 2:
        raise P2PProtocolError("login request missing name length")
    name_len = struct.unpack_from("!H", body, 0)[0]
    pos = 2
    end = pos + name_len
    if len(body) < end + 4 + 2 + 4 + 129:
        raise P2PProtocolError("login request body is truncated")

    login_name = body[pos:end]
    pos = end
    advertised_ip = struct.unpack_from("!I", body, pos)[0]
    pos += 4
    advertised_port = struct.unpack_from("!H", body, pos)[0]
    pos += 2
    session_hint = struct.unpack_from("!I", body, pos)[0]
    pos += 4
    opaque_p2p_info = body[pos : pos + 129]
    pos += 129
    return P2PLoginRequest(
        login_name=login_name,
        advertised_ip=advertised_ip,
        advertised_port=advertised_port,
        session_hint=session_hint,
        opaque_p2p_info=opaque_p2p_info,
        trailing=body[pos:],
    )


def build_login_ack(
    *,
    session_id: int,
    assigned_p2p_id: int,
    observed_ip: str,
    observed_port: int,
    error_code: int = 0,
    unknown: int = 0,
) -> bytes:
    body = LOGIN_ACK_BODY.pack(
        _u32(error_code, "error_code"),
        _u32(unknown, "unknown"),
        _u32(session_id, "session_id"),
        int(ipaddress.IPv4Address(observed_ip)),
        _u16(observed_port, "observed_port"),
    )
    return encode_datagram(
        MSG_LOGIN_ACK,
        body,
        session_id=session_id,
        src_p2p_id=0,
        dst_or_aux=assigned_p2p_id,
    )


def build_keepalive_ack(*, session_id: int, dst_p2p_id: int, error_code: int = 0) -> bytes:
    return encode_datagram(
        MSG_KEEPALIVE_ACK,
        U32_BODY.pack(_u32(error_code, "error_code")),
        session_id=session_id,
        src_p2p_id=0,
        dst_or_aux=dst_p2p_id,
    )
