"""Explicit local shop offers configured by the desktop administrator."""
from contextlib import closing
from datetime import datetime
import json
from pathlib import Path
import sqlite3
import struct
import uuid

from .store import Store, EQUIPMENT_SLOTS


def handle(request, database, items):
    store = Store(str(database))
    db = store.db
    try:
        db.execute('CREATE TABLE IF NOT EXISTS admin_shop_settings(item_key TEXT PRIMARY KEY, settings TEXT NOT NULL)')
        db.commit()
        available = {i['key']: i for i in items if i['kind'] in EQUIPMENT_SLOTS or i['kind'] in (71, 74)}
        if request['operation'] == 'shop_catalog':
            return dict(items=[{k: i[k] for k in ('key', 'id', 'kind', 'name', 'stackable', 'icon')} for i in available.values()],
                        offers={key: json.loads(value) for key, value in db.execute('SELECT item_key,settings FROM admin_shop_settings')})
        key = request.get('key')
        item = available.get(key)
        if item is None:
            raise ValueError('商品不属于已支持的本地道具')
        currency, price, days, quantity, enabled = (request.get(k) for k in ('currency', 'price', 'days', 'quantity', 'enabled'))
        if (currency not in ('gold', 'ticket') or type(price) is not int or not 1 <= price <= 2147483647
                or type(days) is not int or not 1 <= days <= 3650
                or type(quantity) is not int or not 1 <= quantity <= 999 or type(enabled) is not bool):
            raise ValueError('价格、期限或数量无效')
        config = dict(currency=currency, price=price, days=days, quantity=quantity, enabled=enabled)
        folder = Path(database).parent / 'shop-backups'
        folder.mkdir(exist_ok=True)
        backup = folder / (datetime.now().strftime('%Y%m%d-%H%M%S-') + uuid.uuid4().hex[:8] + '.sqlite3')
        with closing(sqlite3.connect(backup)) as target:
            db.backup(target)
        # Reserve the high key range for these explicitly-created local offers.
        catalog_key = 0x70000000 + item['id']
        record = bytearray(108)
        struct.pack_into('<IBII', record, 0, catalog_key, item['kind'], item['id'], catalog_key)
        # item.txt column 6 supplies the native character applicability bitmask.
        if len(item.get('fields', [])) > 6:
            mask = int(item['fields'][6])
            if not 0 <= mask <= 0xffffffff:
                raise ValueError('商品适用角色范围无效')
            struct.pack_into('<I', record, 14, mask)
        struct.pack_into('<II', record, 30 if currency == 'gold' else 38, price, price)
        record[48] = 1
        # 847F40/83D420 reject requirement kind 0. Kind 1 reads the minimum
        # title rank from +13; rank 0 admits every character (9CC640).
        record[83] = 1
        grant = bytearray(68)
        struct.pack_into('<BI', grant, 4, item['kind'], item['id'])
        if item['stackable']:
            struct.pack_into('<H', grant, 23, quantity)
            struct.pack_into('<I', record, 26, quantity)
        else:
            struct.pack_into('<I', grant, 13, days * 24)
            struct.pack_into('<I', record, 22, days * 24)
        # 8893B8/85D880: ordinary weapon selector is category 10, variant 25.
        db.execute('BEGIN IMMEDIATE')
        conflict = db.execute('SELECT catalog_key FROM shop_catalog WHERE category=10 AND variant=? AND item_id=?', (item['kind'], item['id'])).fetchone()
        if conflict and conflict[0] != catalog_key:
            raise ValueError('已有外部导入商品，未覆盖')
        db.execute('DELETE FROM shop_catalog WHERE catalog_key=?', (catalog_key,))
        db.execute('DELETE FROM gold_offers WHERE catalog_key=?', (catalog_key,))
        if enabled:
            db.execute('INSERT INTO shop_catalog VALUES(?,?,?,?,?,?)', (10, item['kind'], item['id'], item['id'], catalog_key, bytes(record)))
            db.execute('INSERT INTO gold_offers VALUES(?,?,?)', (catalog_key, bytes(record), bytes(grant)))
        db.execute('INSERT OR REPLACE INTO admin_shop_settings VALUES(?,?)', (key, json.dumps(config)))
        db.commit()
        return dict(backup=str(backup), message='商城配置已保存；重新登录游戏刷新商品缓存')
    except BaseException:
        db.rollback()
        raise
    finally:
        store.close()
