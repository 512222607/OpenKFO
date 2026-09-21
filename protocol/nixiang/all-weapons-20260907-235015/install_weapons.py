"""Install the verified local inventory extension after v4 has stopped.

Invoked by install_weapons.ps1, which owns graceful stop/start. No process
termination or client modification is performed by this script.
"""
import hashlib
import json
from pathlib import Path
import shutil
import sqlite3
import sys
from contextlib import closing
from datetime import datetime

PROJECT = Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
SOURCE = Path(__file__).resolve().parent
LAB = PROJECT / 'research/2026-09-06/work/login-to-world'
DB = LAB / 'data/lab-roles.sqlite3'
ROLE_HASH = 'ea7c295882b1371b8fe891c856015d5a0b4dc7ba473d1efaaa32e94fcc290cbf'
DB_HASH = '583fb68309f137f5eb672d9c4f2f94b25f4fd35826cae29030cad18da9f28342'
FILES = ['role_protocol.py', 'inventory_protocol.py', 'test_inventory_protocol.py',
         'test_inventory_store.py', 'weapon_ids.json']


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    if digest(LAB / 'role_protocol.py') != ROLE_HASH:
        raise RuntimeError('Active role source changed since baseline; refusing overwrite')
    if digest(DB) != DB_HASH:
        raise RuntimeError('Role database changed since baseline; refusing stale grant')
    for name in FILES:
        if not (SOURCE / 'candidate' / name).is_file():
            raise RuntimeError(f'Missing tested candidate: {name}')
    stamp = datetime.now().strftime('%Y%m%d-%H%M%S')
    case = PROJECT / 'research' / datetime.now().strftime('%Y-%m-%d') / ('all-weapons-' + stamp)
    if case.exists():
        raise RuntimeError('Archive already exists')
    case.mkdir(parents=True)
    # All task files are local source/evidence; no client media or runtime dump.
    for child in SOURCE.iterdir():
        if child.is_dir():
            shutil.copytree(child, case / child.name, ignore=shutil.ignore_patterns('__pycache__'))
        else:
            shutil.copy2(child, case / child.name)
    backup = case / 'backup'
    backup.mkdir()
    original_files = {}
    for name in FILES:
        target = LAB / name
        if target.exists():
            original_files[name] = digest(target)
            shutil.copy2(target, backup / name)
    shutil.copy2(PROJECT / 'CURRENT_STATUS.md', backup / 'CURRENT_STATUS.md')
    with closing(sqlite3.connect(DB.as_uri() + '?mode=ro', uri=True)) as src:
        role_rows_before = src.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall()
        with closing(sqlite3.connect(backup / 'lab-roles.sqlite3')) as dst:
            src.backup(dst)
    sys.path.insert(0, str(SOURCE / 'candidate'))
    from inventory_protocol import InventoryStore
    with closing(sqlite3.connect(DB.as_uri() + '?mode=ro', uri=True)) as src:
        role = src.execute('SELECT name,payload FROM lab_roles WHERE uid=1001').fetchone()
    if role is None:
        raise RuntimeError('The existing UID1001 character is absent')
    ids = json.loads((SOURCE / 'candidate/weapon_ids.json').read_text(encoding='utf-8'))
    if len(ids) != 274 or len(set(ids)) != 274 or 253002 not in ids:
        raise RuntimeError('Weapon catalog does not match verified 274 records')
    installed = []
    try:
        store = InventoryStore(DB)
        result = store.grant_weapons(1001, bytes(role[1]), [{'local_id': i, 'kind': 25} for i in ids])
        if result != {'added_weapons': 273, 'total_weapons': 274, 'total_items': 280}:
            raise RuntimeError(f'Unexpected grant counts: {result}')
        items = store.get_items(1001, bytes(role[1]))
        if len(items) != 19040:
            raise RuntimeError('Unexpected complete inventory length')
        with closing(sqlite3.connect(DB.as_uri() + '?mode=ro', uri=True)) as src:
            if src.execute('PRAGMA integrity_check').fetchone()[0] != 'ok':
                raise RuntimeError('SQLite integrity check failed')
            if src.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall() != role_rows_before:
                raise RuntimeError('Original character changed')
        for name in FILES:
            shutil.copy2(SOURCE / 'candidate' / name, LAB / name)
            installed.append(name)
        manifest = {'case_directory':str(case), 'uid':1001, 'name':role[0], **result,
                    'role_rows_unchanged':True, 'backup_database_sha256':digest(backup / 'lab-roles.sqlite3'),
                    'database_before_sha256':DB_HASH, 'database_after_sha256':digest(DB),
                    'original_files':original_files,
                    'installed':{name:digest(LAB/name) for name in FILES}}
        (case / 'installed-manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
        (SOURCE / 'installed-location.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
        print(json.dumps(manifest,ensure_ascii=False),flush=True)
    except Exception:
        # v4 is stopped. Restore the exact backed-up role database on failure.
        with closing(sqlite3.connect(backup / 'lab-roles.sqlite3')) as src:
            with closing(sqlite3.connect(DB)) as dst:
                src.backup(dst)
        for name in installed:
            if name in original_files:
                shutil.copy2(backup / name, LAB / name)
            # New additive files are harmless and retained for failure evidence.
        raise


if __name__ == '__main__':
    main()
