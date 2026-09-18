"""Desktop administration over authenticated SSH, never local SQLite."""
import base64
import json
from pathlib import Path
import struct
import subprocess
import sys
import uuid

from .item_admin import ROOT, CLIENT, STACKABLE, TIMED_EQUIPMENT, catalog
from .store import EQUIPMENT_SLOTS

CONFIG = ROOT / 'runtime-local/online-admin.json'


def remote(request):
    config = json.loads(CONFIG.read_text(encoding='utf-8-sig'))
    host, user, key = (config[name] for name in ('host', 'user', 'key'))
    if not Path(key).is_file():
        raise ValueError('找不到线上管理 SSH 密钥；未操作本地数据库')
    command = ['ssh', '-T', '-i', key, '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes',
               '-o', 'ConnectTimeout=10', '-o', 'ServerAliveInterval=10', '-o', 'ServerAliveCountMax=2',
               '-p', str(int(config.get('port', 22))), f'{user}@{host}',
               '''sudo -n bash -c 'export "$(cat /etc/kungfu-go/game.env)"; exec /opt/kungfu-go/kungfu-admin' ''']
    try:
        process = subprocess.run(command, input=json.dumps(request).encode(), capture_output=True, timeout=75,
                                 creationflags=getattr(subprocess, 'CREATE_NO_WINDOW', 0))
    except subprocess.TimeoutExpired as error:
        raise ValueError('线上请求超时。写入结果可能尚未收到，请保持原操作重试，勿重复创建发放请求。') from error
    if process.returncode:
        detail = process.stderr.decode('utf-8', 'replace').strip()[-1500:]
        raise ValueError('线上管理连接失败；未回退本地数据库。\n' + detail)
    try:
        result = json.loads(process.stdout)
    except (ValueError, UnicodeError) as error:
        raise ValueError('线上管理返回无效响应，请检查管理程序是否已部署') from error
    if result.get('ok') is not True:
        raise ValueError(result.get('error', '线上操作失败'))
    return result['result']


def template(item, quantity, days):
    record = bytearray(68)
    struct.pack_into('<BI', record, 4, item['kind'], item['id'])
    if item['kind'] in STACKABLE:
        struct.pack_into('<H', record, 23, quantity)
    elif item['kind'] in TIMED_EQUIPMENT:
        struct.pack_into('<I', record, 13, days * 24)
    return record


def offer(item, settings):
    currency, price, days, quantity, enabled = (settings.get(key) for key in ('currency', 'price', 'days', 'quantity', 'enabled'))
    if (currency not in ('gold', 'ticket') or type(price) is not int or not 1 <= price <= 2147483647
            or type(days) is not int or not 1 <= days <= 3650 or type(quantity) is not int
            or not 1 <= quantity <= 999 or type(enabled) is not bool):
        raise ValueError('价格、期限、数量或上架状态无效')
    key = 0x70000000 + item['id']
    record = bytearray(108)
    struct.pack_into('<IBII', record, 0, key, item['kind'], item['id'], key)
    mask = int(item['fields'][6]) if len(item.get('fields', [])) > 6 else 0
    struct.pack_into('<I', record, 14, mask)
    struct.pack_into('<II', record, 30 if currency == 'gold' else 38, price, price)
    record[48] = record[83] = 1
    struct.pack_into('<I', record, 26 if item['stackable'] else 22, quantity if item['stackable'] else days * 24)
    return dict(key=key, category=10, variant=item['kind'], enabled=enabled,
                record=base64.b64encode(record).decode(), grant=base64.b64encode(template(item, quantity, days)).decode())


def dispatch(request):
    operation = request.get('operation')
    if operation in ('accounts', 'inventory', 'wallet_accounts', 'wallet_update'):
        return remote(request)
    if operation in ('weapon_catalog', 'weapon_save', 'weapon_apply', 'weapon_restore'):
        from .weapon_admin import handle
        return handle(request, CLIENT, catalog())
    items = catalog()
    if operation == 'catalog':
        return dict(items=items, root=str(ROOT), database='线上 MySQL', environment='线上服务器', categories=len({i['kind'] for i in items}))
    by_key = {item['key']: item for item in items}
    if operation == 'grant':
        quantity, days = request.get('quantity'), request.get('days', 365)
        if type(quantity) is not int or not 1 <= quantity <= 999 or type(days) is not int or not 1 <= days <= 3650:
            raise ValueError('数量或期限无效')
        keys = request.get('keys')
        if not isinstance(keys, list) or not 1 <= len(keys) <= 4000 or len(set(keys)) != len(keys) or any(key not in by_key for key in keys):
            raise ValueError('请选择当前客户端目录中的有效道具')
        return remote(dict(operation=operation, uid=request.get('uid'), id=request.get('id'),
                           records=[base64.b64encode(template(by_key[key], quantity, days)).decode() for key in keys]))
    available = {key: item for key, item in by_key.items() if item['kind'] in EQUIPMENT_SLOTS or item['kind'] in (71, 74)}
    if operation == 'shop_catalog':
        offers = {}
        for row in remote({'operation': operation}):
            record, grant = base64.b64decode(row['record']), base64.b64decode(row['grant'])
            if len(record) != 108 or len(grant) != 68:
                raise ValueError('线上商品记录长度异常')
            key = f'{grant[4]}:{struct.unpack_from("<I", grant, 5)[0]}'
            tickets = struct.unpack_from('<I', record, 38)[0]
            offers[key] = dict(currency='ticket' if tickets else 'gold',
                               price=tickets or struct.unpack_from('<I', record, 30)[0],
                               days=struct.unpack_from('<I', grant, 13)[0] // 24 or 365,
                               quantity=struct.unpack_from('<H', grant, 23)[0] or 1, enabled=row['enabled'])
        return dict(items=[{field: item[field] for field in ('key', 'id', 'kind', 'name', 'stackable', 'icon')} for item in available.values()], offers=offers, environment='线上 MySQL')
    if operation in ('shop_save', 'shop_batch'):
        enabled = request.get('enabled')
        if type(enabled) is not bool:
            raise ValueError('上架状态无效')
        all_items = operation == 'shop_batch' and request.get('all') is True
        keys = list(available) if all_items else ([request.get('key')] if operation == 'shop_save' else request.get('keys'))
        if not isinstance(keys, list) or not keys or len(set(keys)) != len(keys) or any(key not in available for key in keys):
            raise ValueError('请选择可售商品')
        defaults = dict(currency='ticket', price=100, days=365, quantity=1, enabled=enabled)
        settings = request if operation == 'shop_save' else defaults
        return remote(dict(operation=operation, id=request.get('id') or str(uuid.uuid4()),
                           offers=[offer(available[key], settings) for key in keys],
                           enabled=enabled, all=all_items, preserve=operation == 'shop_batch'))
    raise ValueError('不支持的线上管理操作')


def main():
    sys.stdin.reconfigure(encoding='utf-8')
    sys.stdout.reconfigure(encoding='utf-8')
    try:
        request = json.loads(sys.stdin.buffer.read(4 * 1024 * 1024))
        result = dict(ok=True, result=dispatch(request))
    except Exception as error:
        result = dict(ok=False, error=str(error))
    print(json.dumps(result, ensure_ascii=False))


if __name__ == '__main__':
    main()
