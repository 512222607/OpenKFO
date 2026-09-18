import sqlite3
from contextlib import closing
import struct
import tempfile
import unittest
from pathlib import Path
from server.kk_local.store import Store
from server.kk_local.item_admin import grant


class ItemAdminTests(unittest.TestCase):
    def test_equipment_days_and_consumable_counts_use_separate_fields(self):
        with tempfile.TemporaryDirectory() as folder:
            path=Path(folder)/'accounts.sqlite3'
            store=Store(path)
            store.provision_local(1003,'testuser')
            original=store.snapshot(1003)[3]
            for r, in store.db.execute('SELECT record FROM inventory'):
                self.assertEqual(struct.unpack_from('<I',r,13)[0],8760)
                self.assertEqual(struct.unpack_from('<H',r,23)[0],0)
            store.close()
            items={'25:253043':dict(kind=25,id=253043,name='weapon',stackable=False),
                   '64:640001':dict(kind=64,id=640001,name='potion',stackable=True)}
            result=grant(path,items,1003,list(items),10,'mixed',365)
            with closing(sqlite3.connect(path)) as db:
                rows=[r for r, in db.execute('SELECT record FROM inventory ORDER BY instance')]
            self.assertEqual(b''.join(rows[:7]),original)
            weapon,potion=rows[-2:]
            self.assertEqual(struct.unpack_from('<I',weapon,13)[0],8760)
            self.assertEqual(struct.unpack_from('<i',weapon,19)[0],0)
            self.assertEqual(struct.unpack_from('<H',weapon,23)[0],0)
            self.assertEqual(struct.unpack_from('<I',potion,13)[0],0)
            self.assertEqual(struct.unpack_from('<H',potion,23)[0],10)
            self.assertEqual(grant(path,items,1003,list(items),10,'mixed',365),result)
            with self.assertRaises(ValueError): grant(path,items,1003,list(items),10,'mixed',30)
            for invalid in (0,3651,True):
                with self.assertRaises(ValueError): grant(path,items,1003,list(items),10,'bad',invalid)
            self.assertEqual(grant(path,items,1003,['25:253043'],99,'repeat',30)['skipped'],1)

    def test_account_isolation_idempotency_and_atomic_overflow(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'accounts.sqlite3'
            store = Store(path)
            store.provision_local(1001, 'first')
            store.provision_local(1002, 'guest')
            original = store.snapshot(1001)[3]
            worn = store.snapshot(1002)[3]
            store.close()
            items = {
                '12:121005': dict(kind=12, id=121005, name='existing', stackable=False),
                '64:640001': dict(kind=64, id=640001, name='potion', stackable=True),
                '30:300001': dict(kind=30, id=300001, name='talisman', stackable=False),
            }
            result = grant(path, items, 1002, list(items), 5, 'one')
            self.assertEqual((result['added'], result['skipped']), (2, 1))
            self.assertTrue(Path(result['backup']).is_file())
            self.assertEqual(grant(path, items, 1002, list(items), 5, 'one'), result)
            with closing(sqlite3.connect(path)) as db:
                rows = [r[0] for r in db.execute('SELECT record FROM inventory WHERE uid=1002 ORDER BY instance')]
            self.assertEqual(b''.join(rows[:7]), worn)
            self.assertEqual(struct.unpack_from('<H', rows[-1], 23)[0], 0)
            self.assertEqual(struct.unpack_from('<H', rows[-2], 23)[0], 5)
            with self.assertRaises(ValueError):
                grant(path, items, 1002, ['64:640001'], 999, 'overflow')
            with self.assertRaises(ValueError):
                grant(path, items, 1002, ['64:999999'], 1, 'unknown')
            store = Store(path)
            self.assertEqual(store.snapshot(1001)[3], original)
            self.assertEqual(store.snapshot(1002)[3], b''.join(rows))
            store.close()


if __name__ == '__main__': unittest.main()
