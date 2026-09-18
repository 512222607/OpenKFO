"""Local desktop inventory administration over stdin/stdout, no network port."""
import json
from contextlib import closing
from pathlib import Path
import sqlite3
import struct
import sys
import uuid
from datetime import datetime
from .maps import ClientConfig
from .spf2 import decode_config
from .store import EQUIPMENT_SLOTS

ROOT = Path(__file__).resolve().parents[2]
CLIENT = ROOT / 'runtime-local/client'
DATABASE = ROOT / 'runtime-local/accounts.sqlite3'
KINDS = {
    12: ('服装外观', '上衣'), 13: ('服装外观', '脸型'), 14: ('服装外观', '鞋子'),
    15: ('服装外观', '头发 / 帽子'), 16: ('服装外观', '裤子'), 17: ('服装外观', '手套'),
    18: ('服装外观', '套装'), 20: ('服装外观', '头部饰品'), 21: ('服装外观', '背部饰品'),
    25: ('武器装备', '武器'), 26: ('武器装备', '投掷 / 副武器'), 30: ('武器装备', '护符'),
    31: ('个性装饰', '称号'), 50: ('材料道具', '许愿瓶'), 60: ('材料道具', '宝石 / 材料'),
    61: ('材料道具', '转生石'), 64: ('消耗用品', '战斗药水 / 手雷'), 68: ('消耗用品', '替身娃娃'),
    71: ('功能卡券', '喇叭卡'), 72: ('功能卡券', '双倍经验卡'), 73: ('功能卡券', 'VIP / 名侠卡'),
    74: ('功能卡券', '武器切换卡'), 75: ('功能卡券', '百宝券'), 76: ('功能卡券', '节日百宝券'),
    77: ('个性装饰', '幻影卡'), 78: ('功能卡券', '置顶卡'), 79: ('个性装饰', '个性图标'),
    80: ('功能卡券', '经验 / 改名卡'), 81: ('礼包活动', '福袋'), 82: ('礼包活动', '红包'),
    83: ('个性装饰', '特效饰品'), 84: ('社交婚礼', '婚礼道具'),
    85: ('礼包活动', '爆竹'), 86: ('礼包活动', '粽子'), 87: ('礼包活动', '镰刀宝箱'),
    88: ('礼包活动', '破天宝箱'), 89: ('礼包活动', '龙牙宝箱'), 90: ('礼包活动', '月饼'),
    91: ('礼包活动', '赤子宝箱'), 92: ('礼包活动', '烤火鸡'), 93: ('礼包活动', '圣诞袜'),
    94: ('礼包活动', '五色圣诞袜'), 95: ('礼包活动', '礼包 / 活动道具'),
    96: ('礼包活动', '新手 / 劳动礼包'), 99: ('功能卡券', '折扣卡'),
}
STACKABLE = {64, 71, 74}
TIMED_EQUIPMENT = set(EQUIPMENT_SLOTS) - STACKABLE
SUPPORTED = {12, 13, 14, 15, 16, 17, 18, 20, 21, 25, 64, 71, 74}


def catalog(client=CLIENT):
    archive = ClientConfig(client / 'Data/config.spf2')
    index = archive.entries['item.txt']
    offset, size = struct.unpack_from('<II', archive.data, archive.table + index * 8)
    content = decode_config(archive.data[offset+4:offset+size+4]).decode('gb18030')
    result = []
    seen = set()
    for line in content.splitlines():
        if not line.strip():
            continue
        fields = line.split('\t')
        if len(fields) < 17:
            raise ValueError('物品配置字段不完整')
        kind, item_id = int(fields[0]), int(fields[1])
        key = f'{kind}:{item_id}'
        if key in seen:
            raise ValueError('物品配置存在重复编号：' + key)
        seen.add(key)
        group, category = KINDS.get(kind, ('其他道具', f'类型 {kind}'))
        icon = (client / 'Data/UI' / fields[9].replace('\\', '/')).resolve()
        if not icon.is_relative_to((client / 'Data/UI').resolve()):
            raise ValueError('图标路径超出客户端目录')
        name = fields[3]
        result.append(dict(key=key, id=item_id, kind=kind, name=name, group=group, category=category,
                           description='' if fields[16] == '#' else fields[16],
                           icon=str(icon) if icon.is_file() else '',
                           gender='男' if '（男）' in name or '(男)' in name else '女' if '（女）' in name or '(女)' in name else '通用',
                           stackable=kind in STACKABLE, timed=kind in TIMED_EQUIPMENT, supported=kind in SUPPORTED, fields=fields))
    return result


def grant(database, items, uid, keys, quantity, operation, days=365):
    if type(days) is not int or not 1 <= days <= 3650:
        raise ValueError('装备期限须为 1–3650 天')
    if type(uid) is not int or type(quantity) is not int or not 1 <= quantity <= 999:
        raise ValueError('角色或数量无效，数量须为 1–999')
    if not isinstance(keys, list) or not keys or len(keys) > 4000 or any(not isinstance(k, str) for k in keys):
        raise ValueError('请选择 1–4000 件道具')
    if len(set(keys)) != len(keys) or any(k not in items for k in keys):
        raise ValueError('存在重复或不属于本客户端的道具')
    if not isinstance(operation, str) or not 1 <= len(operation) <= 100:
        raise ValueError('操作编号无效')
    db = sqlite3.connect(database, timeout=10)
    db.execute('PRAGMA foreign_keys=ON')
    try:
        db.execute('CREATE TABLE IF NOT EXISTS admin_item_grants(operation TEXT PRIMARY KEY, uid INTEGER NOT NULL, request TEXT NOT NULL, result TEXT NOT NULL)')
        db.commit()
        request = json.dumps([uid, keys, quantity, days], ensure_ascii=False)
        previous = db.execute('SELECT request,result FROM admin_item_grants WHERE operation=?', (operation,)).fetchone()
        if previous:
            if previous[0] != request:
                raise ValueError('操作编号已用于其他请求')
            return json.loads(previous[1])
        if not db.execute('SELECT 1 FROM accounts WHERE uid=?', (uid,)).fetchone():
            raise ValueError('角色不存在')
        folder = Path(database).parent / 'item-backups'
        folder.mkdir(exist_ok=True)
        backup = folder / (datetime.now().strftime('%Y%m%d-%H%M%S-') + uuid.uuid4().hex[:8] + '.sqlite3')
        with closing(sqlite3.connect(backup)) as target:
            db.backup(target)
        db.execute('BEGIN IMMEDIATE')
        # Recheck after acquiring the write lock to make retries idempotent.
        previous = db.execute('SELECT request,result FROM admin_item_grants WHERE operation=?', (operation,)).fetchone()
        if previous:
            if previous[0] != request:
                raise ValueError('操作编号已用于其他请求')
            db.rollback()
            return json.loads(previous[1])
        records = db.execute('SELECT instance,record FROM inventory WHERE uid=? ORDER BY instance', (uid,)).fetchall()
        existing = {}
        for instance, raw in records:
            existing.setdefault(f'{raw[4]}:{struct.unpack_from("<I",raw,5)[0]}', (instance, raw))
        next_id = max([0x100000] + [i for i, _ in records]) + 1
        new_count = sum(k not in existing for k in keys)
        if len(records) + new_count > 8000 or next_id + new_count > 0xffffffff:
            raise ValueError('背包容量上限为 8000 条记录')
        added = updated = skipped = 0
        for key in keys:
            item = items[key]
            old = existing.get(key)
            if old and not item['stackable']:
                skipped += 1
                continue
            if old:
                instance, raw = old
                record = bytearray(raw)
                count = struct.unpack_from('<H', record, 23)[0] + quantity
                if count > 999:
                    raise ValueError(item['name'] + ' 添加后超过 999，整批操作未写入')
                updated += 1
            else:
                instance = next_id
                next_id += 1
                record = bytearray(68)
                struct.pack_into('<IBI', record, 0, instance, item['kind'], item['id'])
                count = quantity
                added += 1
            # +23 is NOT universally a count (e.g. talismans use a scale).
            # Unimplemented kinds get only the common identity, never guessed
            # effect parameters. UI clearly distinguishes storage from usability.
            if item['stackable']:
                struct.pack_into('<H', record, 23, count)
            elif item['kind'] in TIMED_EQUIPMENT:
                # Native A1EC20: state +19 == 0 uses +13 hours; +23 must be zero.
                struct.pack_into('<I', record, 13, days * 24)
            db.execute('INSERT OR REPLACE INTO inventory VALUES(?,?,?)', (uid, instance, bytes(record)))
        result = dict(added=added, updated=updated, skipped=skipped, backup=str(backup), uid=uid)
        db.execute('INSERT INTO admin_item_grants VALUES(?,?,?,?)', (operation, uid, request, json.dumps(result)))
        db.commit()
        return result
    finally:
        db.close()


def dispatch(request):
    operation = request.get('operation')
    if operation in ('wallet_accounts', 'wallet_update'):
        if not DATABASE.is_file():
            raise ValueError('本地账号数据库不存在')
        from .wallet_admin import handle
        return handle(request, DATABASE)
    items = catalog()
    if operation in ('shop_catalog', 'shop_save'):
        if not DATABASE.is_file():
            raise ValueError('本地账号数据库不存在')
        from .shop_admin import handle
        return handle(request, DATABASE, items)
    if operation in ('weapon_catalog', 'weapon_save', 'weapon_apply', 'weapon_restore'):
        from .weapon_admin import handle
        return handle(request, CLIENT, items)
    if operation == 'catalog':
        return dict(items=items, root=str(ROOT), database=str(DATABASE), categories=len({i['kind'] for i in items}))
    if not DATABASE.is_file():
        raise ValueError('本地账号数据库不存在，请先启动本地服务器')
    if operation == 'grant':
        return grant(DATABASE, {i['key']: i for i in items}, request.get('uid'), request.get('keys'), request.get('quantity'), request.get('id'), request.get('days', 365))
    with closing(sqlite3.connect(DATABASE)) as db:
        if operation == 'accounts':
            return [dict(uid=r[0], account=r[1], nickname=r[2], count=r[3]) for r in db.execute('SELECT a.uid,a.account,a.nickname,COUNT(i.instance) FROM accounts a LEFT JOIN inventory i ON i.uid=a.uid GROUP BY a.uid ORDER BY a.account != "localguest",a.uid')]
        if operation == 'inventory':
            uid = request.get('uid')
            if type(uid) is not int:
                raise ValueError('角色编号无效')
            return [dict(instance=i, key=f'{r[4]}:{struct.unpack_from("<I",r,5)[0]}', slot=struct.unpack_from('<H',r,17)[0], quantity=struct.unpack_from('<H',r,23)[0], duration_hours=struct.unpack_from('<I',r,13)[0], duration_state=struct.unpack_from('<i',r,19)[0]) for i, r in db.execute('SELECT instance,record FROM inventory WHERE uid=? ORDER BY instance', (uid,))]
    raise ValueError('不支持的管理操作')


def main():
    sys.stdin.reconfigure(encoding='utf-8')
    sys.stdout.reconfigure(encoding='utf-8')
    try:
        request = json.loads(sys.stdin.buffer.read(1024 * 1024))
        if not isinstance(request, dict):
            raise ValueError('请求格式错误')
        result = dict(ok=True, result=dispatch(request))
    except Exception as error:
        result = dict(ok=False, error=str(error))
    print(json.dumps(result, ensure_ascii=False))


if __name__ == '__main__':
    main()
