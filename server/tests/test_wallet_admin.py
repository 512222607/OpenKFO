from pathlib import Path
import tempfile
import unittest

from server.kk_local.store import Store
from server.kk_local.wallet_admin import handle


class WalletAdminTests(unittest.TestCase):
    def test_grant_set_replay_overflow_and_account_isolation(self):
        with tempfile.TemporaryDirectory() as tmp:
            database = Path(tmp) / 'accounts.sqlite3'
            store = Store(str(database))
            store.seed_local()
            store.provision_local(1002, 'second')
            store.close()
            req = dict(operation='wallet_update', uid=1001, mode='gift', amount=100, id='gift-1')
            result = handle(req, database)
            self.assertEqual(result['after'], 100)
            self.assertTrue(Path(result['backup']).is_file())
            self.assertEqual(handle(req, database), result)
            with self.assertRaises(ValueError):
                handle(dict(req, amount=200), database)
            self.assertEqual(handle(dict(req, id='set-1', mode='set', amount=50), database)['after'], 50)
            with self.assertRaises(ValueError):
                handle(dict(req, id='overflow', amount=2147483647), database)
            with self.assertRaises(ValueError):
                handle(dict(req, id='missing', uid=9999), database)
            rows = handle(dict(operation='wallet_accounts'), database)
            self.assertEqual([r['tickets'] for r in rows], [50, 0])
            self.assertEqual([r['gold'] for r in rows], [0, 0])
            from server.kk_local.engine import Engine, Connection, Phase
            from server.kk_local.wire import Message, ProtocolError
            from server.tests.test_local_service import hello
            import struct
            store = Store(str(database))
            try:
                engine = Engine(store)
                engine.grant_offline_adapter_session()
                messages = engine.handle(Connection(1), hello(1010))
                ticket = next(m for m in messages if m.id == 1230)
                self.assertNotIn(1250, [m.id for m in messages])  # native txtCoupon
                self.assertEqual(struct.unpack('<I', ticket.payload)[0], 50)
                self.assertLess(messages.index(ticket), next(i for i, m in enumerate(messages) if m.id == 7080))
                lobby = Connection(2, phase=Phase.LOBBY, uid=1001)
                engine.game = lobby
                self.assertEqual(engine.handle(lobby, Message(1232, b'')), [Message(1230, struct.pack('<I', 50))])
                with store.db:
                    store.db.execute('UPDATE ticket_wallet SET balance=0 WHERE uid=1001')
                self.assertEqual(engine.handle(lobby, Message(1232, b'')), [Message(1230, bytes(4))])
                with self.assertRaises(ProtocolError):
                    engine.handle(lobby, Message(1232, b'bad'))
            finally:
                store.close()


if __name__ == '__main__':
    unittest.main()
