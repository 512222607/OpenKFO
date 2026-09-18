"""Loopback TLS/JSON adapter for the custom gfld login dialog.

Experimental wire compatibility. Password checks and native binding remain in
the existing account service. Never log request bodies, passwords or tokens.
"""
import ctypes
import argparse
import asyncio
import secrets
from ctypes import wintypes
from datetime import datetime, timedelta, timezone
import hashlib
import ipaddress
import json
from pathlib import Path
import socketserver
import ssl

from .client_login import CLIENT, IMAGE, IMAGE_HASH, ROOT, api, wait_for_tables
from .native_identity import WindowsNativeVerifier

PORT = 18084


def receive_json(connection):
    data = bytearray()
    decoder = json.JSONDecoder()
    while len(data) < 8192:
        part = connection.recv(min(1024, 8192 - len(data)))
        if not part:
            raise ValueError('incomplete_request')
        data.extend(part)
        try:
            text = data.decode('utf-8')
            value, end = decoder.raw_decode(text.lstrip())
        except (UnicodeDecodeError, json.JSONDecodeError):
            continue
        if text.lstrip()[end:].strip() or not isinstance(value, dict):
            raise ValueError('invalid_request')
        return value
    raise ValueError('request_too_large')


def authenticate(request, identity, guest_password=None):
    if request.get('type') != 'login':
        raise ValueError('unsupported_request')
    if not isinstance(request.get('username'), str) or not isinstance(request.get('password'), str):
        raise ValueError('invalid_request')
    if guest_password is not None:
        granted = api('login', account='localguest', password=guest_password)
    else:
        granted = api('login_legacy_sha256', account=request['username'], password=request['password'])
    session = granted['session']
    try:
        region = api('select_region', session=session, region_id=1)
        api('bind_client', ticket=region['ticket'], uid=region['uid'], region_id=1, pid=identity.pid)
    except BaseException:
        api('logout', session=session)
        raise
    return session


def publish_observed_table(verifier, identity):
    wait_for_tables(verifier, identity, timeout=10)
    if verifier.process(identity.pid) != identity:
        raise ValueError('native_process_changed')
    kernel = verifier.kernel
    handle = kernel.OpenProcess(0x1010, False, identity.pid)
    if not handle:
        raise ValueError('native_process_unavailable')
    try:
        pointer = wintypes.DWORD()
        length = ctypes.c_size_t()
        if not kernel.ReadProcessMemory(handle, 0x17c86f0, ctypes.byref(pointer), 4, ctypes.byref(length)) or length.value != 4 or pointer.value < 0x10000:
            raise ValueError('role_table_unavailable')
        (CLIENT / 'kk-roleprop-ready.txt').write_text(f'0x{pointer.value:08X}\n', encoding='ascii')
    finally:
        kernel.CloseHandle(handle)


class Handler(socketserver.BaseRequestHandler):
    def handle(self):
        session = None
        try:
            # Attribute the socket before accepting credentials; the claimed
            # client_id field is not trusted as a Windows process identity.
            verifier = WindowsNativeVerifier(IMAGE)
            identity = verifier.tcp_peer(self.client_address, self.request.getsockname())
            self.request.settimeout(12)
            with self.server.tls.wrap_socket(self.request, server_side=True) as connection:
                try:
                    request = receive_json(connection)
                    session = authenticate(request, identity, self.server.guest_password)
                    request.clear()
                    publish_observed_table(verifier, identity)
                    # This dialog stores at most 32 characters. Authorization
                    # is the full API session bound to the kernel-owned PID;
                    # the game service does not authenticate this legacy field.
                    response = dict(code=200, token=session[:32], msg='OK')
                    connection.sendall(json.dumps(response).encode('utf-8'))
                    print(f'legacy_login authenticated pid={identity.pid}', flush=True)
                    session = None  # Preserve the authenticated game lease.
                except (ValueError, OSError) as error:
                    connection.sendall(json.dumps(dict(code=403, msg='Local login failed')).encode('utf-8'))
                    allowed = {'invalid_credentials', 'password_length_8_to_128_required', 'rate_limited',
                               'invalid_account_format', 'native_process_already_bound', 'invalid_request', 'unsupported_request'}
                    reason = str(error) if str(error) in allowed else type(error).__name__
                    print('legacy_login rejected: ' + reason, flush=True)
        except ssl.SSLError as error:
            print('legacy_tls rejected: ' + str(error.reason), flush=True)
        except (ValueError, OSError) as error:
            print('legacy_connection rejected: ' + type(error).__name__, flush=True)
        finally:
            if session:
                try:
                    api('logout', session=session)
                except (ValueError, OSError):
                    pass


def tls_context():
    from cryptography import x509
    from cryptography.hazmat.primitives import hashes, serialization
    from cryptography.hazmat.primitives.asymmetric import rsa
    from cryptography.x509.oid import NameOID
    folder = ROOT / 'runtime-local/legacy-tls'
    folder.mkdir(parents=True, exist_ok=True)
    key_path, cert_path = folder / 'key.pem', folder / 'cert.pem'
    if not key_path.exists() or not cert_path.exists():
        key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
        name = x509.Name([x509.NameAttribute(NameOID.COMMON_NAME, 'KungFuKid loopback')])
        now = datetime.now(timezone.utc)
        cert = (x509.CertificateBuilder().subject_name(name).issuer_name(name)
                .public_key(key.public_key()).serial_number(x509.random_serial_number())
                .not_valid_before(now - timedelta(minutes=5)).not_valid_after(now + timedelta(days=30))
                .add_extension(x509.SubjectAlternativeName([x509.IPAddress(ipaddress.ip_address('127.0.0.1'))]), critical=False)
                .sign(key, hashes.SHA256()))
        key_path.write_bytes(key.private_bytes(serialization.Encoding.PEM, serialization.PrivateFormat.PKCS8, serialization.NoEncryption()))
        cert_path.write_bytes(cert.public_bytes(serialization.Encoding.PEM))
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    context.minimum_version = ssl.TLSVersion.TLSv1_2
    context.load_cert_chain(cert_path, key_path)
    return context


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--guest', action='store_true', help='Ignore dialog credentials; use the dedicated local guest character')
    args = parser.parse_args()
    if hashlib.sha256(IMAGE.read_bytes()).hexdigest() != IMAGE_HASH:
        raise ValueError('client_version_mismatch')
    class Server(socketserver.ThreadingTCPServer):
        daemon_threads = True
    with Server(('127.0.0.1', PORT), Handler) as server:
        server.tls = tls_context()
        server.guest_password = None
        if args.guest:
            from .store import Store
            from .auth import AuthManager
            # Explicit local guest mode. The random internal credential stays in
            # memory; user accounts and the normal password API are unchanged.
            secret = secrets.token_urlsafe(32)
            store = Store(ROOT / 'runtime-local/accounts.sqlite3')
            manager = AuthManager(store, [dict(id=1, name='Local', host='127.0.0.1', game_port=18001)])
            try:
                exists = store.db.execute('SELECT 1 FROM accounts WHERE account=?', ('localguest',)).fetchone()
                if exists:
                    asyncio.run(manager.set_local_password('localguest', secret))
                else:
                    asyncio.run(manager.register('localguest', secret, 'LocalGuest'))
            finally:
                manager.close()
                store.close()
            server.guest_password = secret
            print('Guest mode enabled: dialog passwords ignored; dedicated localguest character', flush=True)
        print(f'Legacy login TLS ready at 127.0.0.1:{PORT}', flush=True)
        server.serve_forever()


if __name__ == '__main__':
    main()
