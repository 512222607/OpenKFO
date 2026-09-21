"""Back up and install permanent inventory plus the verified slot-zero fix.

The PowerShell wrapper stops only the observed local lab service first.
"""
from contextlib import closing
from datetime import datetime
import hashlib
import json
from pathlib import Path
import shutil
import sqlite3
import struct
import sys

ROOT = Path(__file__).resolve().parent
PROJECT = Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
LAB = PROJECT / 'research/2026-09-06/work/login-to-world'
DB = LAB / 'data/lab-roles.sqlite3'
CASE = Path(json.loads((ROOT/'installed-location.json').read_text())['case_directory'])
FILES = ['role_protocol.py','inventory_protocol.py','test_inventory_protocol.py','test_inventory_store.py','weapon_ids.json']
EXPECTED_ROLE = '88b5508c18e9c9a6d9d1229f1b0164e4a2cbeeeb1006c71b6404c1d9f99f800a'

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    assert digest(LAB/'role_protocol.py') == EXPECTED_ROLE, 'Active role source changed'
    assert all((ROOT/'candidate'/name).is_file() for name in FILES)
    backup = CASE / ('before-permanent-' + datetime.now().strftime('%Y%m%d-%H%M%S'))
    backup.mkdir()
    for name in FILES:
        shutil.copy2(LAB/name,backup/name)
    shutil.copy2(LAB/'lab-control.json',backup/'lab-control.json')
    with closing(sqlite3.connect(DB.as_uri()+'?mode=ro',uri=True)) as db:
        roles_before = db.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall()
        inventory_before = db.execute('SELECT instance_id,kind,local_id,payload68 FROM lab_inventory WHERE uid=1001 ORDER BY instance_id').fetchall()
        with closing(sqlite3.connect(backup/'lab-roles.sqlite3')) as dst:
            db.backup(dst)
    assert len(inventory_before) == 280
    sys.path.insert(0,str(ROOT/'candidate'))
    from inventory_protocol import InventoryStore, PERMANENT_DISPLAY_MINUTES
    installed = []
    try:
        store = InventoryStore(DB)
        assert store.set_weapons_permanent(1001) == 274
        with closing(sqlite3.connect(DB.as_uri()+'?mode=ro',uri=True)) as db:
            assert db.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
            assert roles_before == db.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall()
            inventory_after = db.execute('SELECT instance_id,kind,local_id,payload68,permanent FROM lab_inventory WHERE uid=1001 ORDER BY instance_id').fetchall()
        for before, after in zip(inventory_before,inventory_after,strict=True):
            assert before[:3] == after[:3]
            old, new = bytes(before[3]), bytes(after[3])
            assert old[17:19] == new[17:19], 'Current equipment must be preserved'
            if before[1] == 25:
                assert after[4] == 1
                assert struct.unpack_from('<I',new,13)[0] == PERMANENT_DISPLAY_MINUTES
                assert struct.unpack_from('<I',new,19)[0] == 1
                assert struct.unpack_from('<H',new,23)[0] == 0
                assert old[:13] == new[:13] and old[25:] == new[25:]
            else:
                assert old == new and after[4] == 0
        for name in FILES:
            shutil.copy2(ROOT/'candidate'/name,LAB/name)
            installed.append(name)
        result = {'backup_directory':str(backup),'permanent_weapons':274,
                  'original_role_unchanged':True,'equipment_slots_preserved':True,
                  'client_display':'365+','permanent_ownership_without_expiry':True,
                  'display_minutes':PERMANENT_DISPLAY_MINUTES,
                  'installed':{name:digest(LAB/name) for name in FILES},
                  'database_sha256':digest(DB)}
        for path in [ROOT/'permanent-install.json',CASE/'permanent-install.json']:
            path.write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
        print(json.dumps(result,ensure_ascii=False),flush=True)
    except Exception:
        with closing(sqlite3.connect(backup/'lab-roles.sqlite3')) as src:
            with closing(sqlite3.connect(DB)) as dst:
                src.backup(dst)
        for name in installed:
            shutil.copy2(backup/name,LAB/name)
        raise

if __name__ == '__main__':
    main()
