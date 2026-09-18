from pathlib import Path
import tempfile
import unittest
import struct

from server.kk_local.shop_admin import handle
from server.kk_local.store import Store
from server.kk_local import packets
from server.kk_local.wallet_admin import handle as wallet


class ShopAdminTests(unittest.TestCase):
    def test_listing_ticket_purchase_replay_and_delisting(self):
        with tempfile.TemporaryDirectory() as tmp:
            database = Path(tmp) / 'accounts.sqlite3'
            store = Store(str(database)); store.seed_local(); store.close()
            items = [dict(key='25:253905', id=253905, kind=25, name='骤足', stackable=False, icon='')]
            request = dict(operation='shop_save', key='25:253905', currency='ticket', price=60, days=365, quantity=1, enabled=True)
            result = handle(request, database, items)
            self.assertTrue(Path(result['backup']).is_file())
            wallet(dict(operation='wallet_update', uid=1001, mode='gift', amount=100, id='gift'), database)
            store = Store(str(database))
            try:
                record = store.shop_records(10, 25)[0]
                # Native kind 0 takes the failed/default requirement branch;
                # kind 1 with minimum rank 0 admits all character ranks.
                self.assertEqual(record.requirement, (1, 0))
                purchase = bytearray(169)
                struct.pack_into('<IQ', purchase, 0, 109, 1001)
                struct.pack_into('<Q', purchase, 54, 1001)
                struct.pack_into('<I', purchase, 145, record.u32(9))
                struct.pack_into('<I', purchase, 157, 60)
                result = store.purchase_gold_once(1001, 'buy-1', bytes(purchase))
                self.assertEqual(result[0], 40)
                self.assertEqual(struct.unpack_from('<I', result[1], 13)[0], 8760)
                self.assertEqual(struct.unpack_from('<H', result[1], 23)[0], 0)
                self.assertEqual(packets.gold_purchase_result(*result)[0].id, 1230)
                self.assertEqual(store.gold_balance(1001), 0)
                self.assertEqual(store.purchase_gold_once(1001, 'buy-1', bytes(purchase)), result)
                with self.assertRaises(ValueError):
                    store.purchase_gold_once(1001, 'buy-2', bytes(purchase))
                self.assertEqual(store.ticket_balance(1001), 40)
                handle(dict(request, enabled=False), database, items)
                self.assertFalse(store.shop_records(10, 25))
                with self.assertRaises(ValueError):
                    store.purchase_gold_once(1001, 'buy-3', bytes(purchase))
                self.assertEqual(store.ticket_balance(1001), 40)
                self.assertEqual(handle(dict(operation='shop_catalog'), database, items)['offers']['25:253905']['price'], 60)
            finally:
                store.close()


if __name__ == '__main__':
    unittest.main()
