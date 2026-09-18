import unittest
from types import SimpleNamespace
from unittest.mock import patch

from server.kk_local.legacy_login import authenticate, receive_json


class Stream:
    def __init__(self, chunks):
        self.chunks = iter(chunks)

    def recv(self, size):
        return next(self.chunks, b'')


class LegacyLoginTests(unittest.TestCase):
    def test_guest_ignores_dialog_password_but_keeps_native_binding(self):
        with patch('server.kk_local.legacy_login.api', side_effect=[{'session': 'a'*64}, {'ticket': 'b'*64, 'uid': 1002}, {}]) as api:
            token = authenticate(dict(type='login', username='anything', password='wrong'), SimpleNamespace(pid=42), 'internal-test-secret')
            self.assertEqual(token, 'a'*64)
            self.assertEqual(api.call_args_list[0].kwargs, dict(account='localguest', password='internal-test-secret'))
            self.assertEqual(api.call_args_list[2].kwargs['pid'], 42)

    def test_split_json_and_reject_trailing_or_oversize(self):
        self.assertEqual(receive_json(Stream([b'{"type":', b'"login"}'])), {'type': 'login'})
        for chunks in ([b'{}{}'], [b'[]'], [b'{'], [b'x' * 1024] * 8):
            with self.assertRaises(ValueError):
                receive_json(Stream(chunks))

    def test_password_failure_never_binds_or_issues_token(self):
        with patch('server.kk_local.legacy_login.api', side_effect=ValueError('invalid_credentials')) as api:
            with self.assertRaises(ValueError):
                authenticate(dict(type='login', username='fixture', password='synthetic-invalid'), SimpleNamespace(pid=42))
            self.assertEqual([call.args[0] for call in api.call_args_list], ['login_legacy_sha256'])

    def test_bind_uses_kernel_identity_and_revokes_on_failure(self):
        with patch('server.kk_local.legacy_login.api', side_effect=[{'session': 'a' * 64}, {'ticket': 'b' * 64, 'uid': 1001}, ValueError('rejected'), {}]) as api:
            with self.assertRaises(ValueError):
                authenticate(dict(type='login', username='fixture', password='synthetic-password', client_id=999), SimpleNamespace(pid=42))
            self.assertEqual(api.call_args_list[2].kwargs['pid'], 42)
            self.assertEqual(api.call_args_list[3].args[0], 'logout')


if __name__ == '__main__':
    unittest.main()
