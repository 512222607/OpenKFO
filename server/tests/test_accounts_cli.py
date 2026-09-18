import asyncio
import contextlib
import io
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch
from server.kk_local.accounts import main
from server.kk_local.auth import AuthManager
from server.kk_local.store import Store


class AccountCliTests(unittest.TestCase):
    def test_register_and_password_change_use_hidden_input(self):
        with tempfile.TemporaryDirectory() as directory:
            database = str(Path(directory) / 'accounts.sqlite3')
            for operation, password in [('register', 'Synthetic-first-password42'),
                                        ('set-password', 'Synthetic-second-password42')]:
                with patch('sys.argv', ['accounts', '--database', database, operation, 'LocalTester']), \
                     patch('getpass.getpass', side_effect=[password, password]), \
                     contextlib.redirect_stdout(io.StringIO()) as output:
                    main()
                self.assertNotIn(password, output.getvalue())
                store = Store(database)
                auth = AuthManager(store, [dict(id=1, name='Local', host='127.0.0.1', game_port=18001)])
                try:
                    self.assertEqual(asyncio.run(auth.login('LocalTester', password))['uid'], 1001)
                finally:
                    auth.close()
                    store.close()


if __name__ == '__main__':
    unittest.main()
