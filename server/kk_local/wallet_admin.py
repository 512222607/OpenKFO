"""Offline wallet administration with atomic, replay-safe grants and backups."""
from contextlib import closing
from datetime import datetime
import json
from pathlib import Path
import sqlite3
import uuid

from .store import Store


def handle(request, database):
    store = Store(str(database))
    db = store.db
    try:
        if request['operation'] == 'wallet_accounts':
            return [dict(uid=uid, account=name, nickname=nick, tickets=store.ticket_balance(uid),
                         gold=store.gold_balance(uid))
                    for uid, name, nick in db.execute('SELECT uid,account,nickname FROM accounts ORDER BY uid')]
        uid, amount, mode, operation = (request.get(k) for k in ('uid', 'amount', 'mode', 'id'))
        if (type(uid) is not int or type(amount) is not int or not 0 <= amount <= 2147483647
                or mode not in ('set', 'gift') or not isinstance(operation, str) or not 1 <= len(operation) <= 100):
            raise ValueError('点券参数无效')
        if mode == 'gift' and amount == 0:
            raise ValueError('赠送点券须大于零')
        signature = json.dumps([uid, amount, mode])
        folder = Path(database).parent / 'wallet-backups'
        folder.mkdir(exist_ok=True)
        backup = folder / (datetime.now().strftime('%Y%m%d-%H%M%S-') + uuid.uuid4().hex[:8] + '.sqlite3')
        with closing(sqlite3.connect(backup)) as target:
            db.backup(target)
        db.execute('BEGIN IMMEDIATE')
        previous = db.execute('SELECT request,result FROM admin_wallet_operations WHERE operation=?', (operation,)).fetchone()
        if previous:
            if previous[0] != signature:
                raise ValueError('操作编号已用于其他请求')
            db.rollback()
            return json.loads(previous[1])
        if not db.execute('SELECT 1 FROM accounts WHERE uid=?', (uid,)).fetchone():
            raise ValueError('角色不存在')
        before = store.ticket_balance(uid)
        after = before + amount if mode == 'gift' else amount
        if after > 2147483647:
            raise ValueError('点券余额超出上限')
        db.execute('INSERT OR REPLACE INTO ticket_wallet VALUES(?,?)', (uid, after))
        result = dict(uid=uid, before=before, after=after, backup=str(backup), message=f'点券：{before} → {after}；重新登录游戏后显示')
        db.execute('INSERT INTO admin_wallet_operations VALUES(?,?,?)', (operation, signature, json.dumps(result, ensure_ascii=False)))
        db.commit()
        return result
    except BaseException:
        db.rollback()
        raise
    finally:
        store.close()
