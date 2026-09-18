import base64
import struct
import unittest
from unittest.mock import patch

from server.kk_local import online_admin as admin


class OnlineAdminTests(unittest.TestCase):
    def setUp(self):
        self.items = [dict(key='25:253013', kind=25, id=253013, name='武器', stackable=False, icon='', fields=[]),
                      dict(key='64:640001', kind=64, id=640001, name='药水', stackable=True, icon='', fields=[])]

    def test_online_inventory_never_reads_sqlite(self):
        with patch.object(admin, 'remote', return_value=[{'uid': 1003}]) as remote:
            self.assertEqual(admin.dispatch({'operation': 'accounts'}), [{'uid': 1003}])
            remote.assert_called_once_with({'operation': 'accounts'})

    def test_grant_preserves_duration_quantity_contract(self):
        with patch.object(admin, 'catalog', return_value=self.items), patch.object(admin, 'remote', return_value={}) as remote:
            admin.dispatch(dict(operation='grant', uid=1003, id='retry-same', keys=['25:253013', '64:640001'], quantity=10, days=365))
            request = remote.call_args.args[0]
            equipment, consumable = [base64.b64decode(value) for value in request['records']]
            self.assertEqual(struct.unpack_from('<I', equipment, 13)[0], 8760)
            self.assertEqual(struct.unpack_from('<H', equipment, 23)[0], 0)
            self.assertEqual(struct.unpack_from('<H', consumable, 23)[0], 10)
            self.assertEqual(request['id'], 'retry-same')

    def test_bulk_all_ignores_search_and_preserves_existing_settings(self):
        with patch.object(admin, 'catalog', return_value=self.items), patch.object(admin, 'remote', return_value={}) as remote:
            admin.dispatch(dict(operation='shop_batch', id='bulk-1', keys=[], all=True, enabled=True))
            request = remote.call_args.args[0]
            self.assertTrue(request['preserve'])
            self.assertEqual(len(request['offers']), 2)
            record = base64.b64decode(request['offers'][0]['record'])
            self.assertEqual(struct.unpack_from('<I', record, 38)[0], 100)
            self.assertEqual(record[83], 1)
            self.assertTrue(request['all'])

    def test_selected_items_only_and_connection_failure_propagates(self):
        with patch.object(admin, 'catalog', return_value=self.items), patch.object(admin, 'remote', side_effect=ValueError('offline')) as remote:
            with self.assertRaisesRegex(ValueError, 'offline'):
                admin.dispatch(dict(operation='shop_batch', id='bulk-2', keys=['64:640001'], enabled=False))
            self.assertEqual(len(remote.call_args.args[0]['offers']), 1)
            self.assertFalse(remote.call_args.args[0]['all'])

    def test_unknown_or_duplicate_selection_rejected(self):
        with patch.object(admin, 'catalog', return_value=self.items), patch.object(admin, 'remote') as remote:
            for keys in [[], ['25:253013', '25:253013'], ['99:999']]:
                with self.assertRaises(ValueError):
                    admin.dispatch(dict(operation='shop_batch', keys=keys, enabled=True))
            remote.assert_not_called()


if __name__ == '__main__':
    unittest.main()
