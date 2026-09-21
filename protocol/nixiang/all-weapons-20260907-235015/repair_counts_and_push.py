"""Repair validated weapon count fields and deliver one live inventory snapshot.

The temporary heartbeat response only samples the client receive path. The
original heartbeat rule is restored in finally; formal login uses RoleSession.
"""
from collections import deque
from contextlib import closing
from datetime import datetime
import hashlib
import json
import os
from pathlib import Path
import shutil
import sqlite3
import sys
import time

ROOT = Path(__file__).resolve().parent
PROJECT = Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
LAB = PROJECT/'research/2026-09-06/work/login-to-world'
DB = LAB/'data/lab-roles.sqlite3'
CONTROL = LAB/'lab-control.json'
CASE = Path(json.loads((ROOT/'installed-location.json').read_text(encoding='utf-8'))['case_directory'])
sys.path.insert(0,str(ROOT/'candidate'))
from inventory_protocol import InventoryStore


def atomic_control(value):
    staging = CONTROL.with_name('lab-control.weapon-count-stage.json')
    staging.write_text(json.dumps(value,ensure_ascii=False,indent=2),encoding='utf-8')
    os.replace(staging,CONTROL)


def main():
    stamp = datetime.now().strftime('%Y%m%d-%H%M%S')
    backup = CASE/('before-count-fix-'+stamp)
    backup.mkdir()
    shutil.copy2(CONTROL,backup/'lab-control.json')
    shutil.copy2(LAB/'inventory_protocol.py',backup/'inventory_protocol.py')
    with closing(sqlite3.connect(DB.as_uri()+'?mode=ro',uri=True)) as src:
        rows_before=src.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall()
        baseline=bytes(src.execute('SELECT payload FROM lab_roles WHERE uid=1001').fetchone()[0])
        with closing(sqlite3.connect(backup/'lab-roles.sqlite3')) as dst:
            src.backup(dst)
    ids=json.loads((LAB/'weapon_ids.json').read_text())
    store=InventoryStore(DB)
    result=store.grant_weapons(1001,baseline,[{'local_id':i,'kind':25} for i in ids])
    items=store.get_items(1001,baseline)
    assert result == {'added_weapons':0,'total_weapons':274,'total_items':280}
    assert all(int.from_bytes(items[i+23:i+25],'little')>=1
               for i in range(0,len(items),68) if items[i+4]==25)
    with closing(sqlite3.connect(DB.as_uri()+'?mode=ro',uri=True)) as src:
        assert src.execute('SELECT * FROM lab_roles ORDER BY uid').fetchall()==rows_before
    # Current v4 already reads the table for all login and equipment paths.
    # Updated grant code is installed for subsequent grants/restarts as well.
    for name in ['inventory_protocol.py','test_inventory_store.py','test_inventory_protocol.py']:
        shutil.copy2(ROOT/'candidate'/name,LAB/name)
        shutil.copy2(ROOT/'candidate'/name,CASE/'candidate'/name)
    before=json.loads(CONTROL.read_text(encoding='utf-8-sig'))
    had_rule='0' in before.get('game',{})
    old_rule=before.get('game',{}).get('0')
    rule={'message_id':1120,'key_index':0,'payload_hex':items.hex(),'delay_ms':0}
    before.setdefault('game',{})['0']=rule
    wire=LAB/'evidence/lab-wire-v4.jsonl'
    position=wire.stat().st_size
    hit=None
    t0=time.time()
    try:
        atomic_control(before)
        pending=''
        with wire.open(encoding='utf-8') as log:
            log.seek(position)
            while time.time()-t0<8:
                pending+=log.read()
                lines=pending.split('\n')
                pending=lines.pop()
                for line in lines:
                    if not line:
                        continue
                    entry=json.loads(line)
                    if (entry.get('direction')=='response' and entry.get('message_id')==1120
                        and entry.get('payload_hex')==items.hex()):
                        hit={k:entry[k] for k in ['time','kind','direction','message_id','payload_len']}
                        break
                if hit:
                    break
                time.sleep(.05)
    finally:
        current=json.loads(CONTROL.read_text(encoding='utf-8-sig'))
        if current.get('game',{}).get('0') != rule:
            raise RuntimeError('Heartbeat rule changed concurrently; original rule not overwritten')
        if had_rule:
            current['game']['0']=old_rule
        else:
            current['game'].pop('0',None)
        atomic_control(current)
    report={'grant':result,'count_field_offset':23,'count':1,'role_rows_unchanged':True,
            'backup':str(backup),'temporary_heartbeat_rule_restored':True,
            'live_snapshot_sent':hit,'inventory_sha256':hashlib.sha256(items).hexdigest()}
    for target in [ROOT/'evidence/E-count-fix-live-push.json',CASE/'evidence/E-count-fix-live-push.json']:
        target.write_text(json.dumps(report,indent=2),encoding='utf-8')
    print(json.dumps(report),flush=True)
    if not hit:
        raise RuntimeError('No active client consumed the snapshot; relogin required')


if __name__=='__main__':
    main()
