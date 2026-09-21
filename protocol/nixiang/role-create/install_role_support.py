"""Archive role work and install v4 without changing live processes."""
from pathlib import Path
import json, shutil, hashlib, sys, os
HERE=Path(__file__).resolve().parent
P=Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
L=P/'research/2026-09-06/work/login-to-world'
O=P/'research/2026-09-07/role-create'
for name in ('role_protocol.py','lab_server_v4.py'):
    target=L/name
    if target.exists():
        raise RuntimeError(f'Refusing to overwrite {target}')
    shutil.copy2(HERE/name,target)
for name in ('prepare_role_probe.py','push_role_followup.py','test_role_protocol.py','build_lab_v4.py','install_role_support.py'):
    shutil.copy2(HERE/name,O/name)
sys.path.insert(0,str(L))
from role_protocol import LabRoleStore,option_map
control=json.loads((O/'lab-control.before-1151.json').read_text(encoding='utf-8-sig'))
request=bytes.fromhex(json.loads((O/'E-013-nonzero-request.json').read_text(encoding='utf-8'))['payload_hex'])
options=option_map(bytes.fromhex(control['game']['1010'][1]['payload_hex']))
payload=LabRoleStore(L/'data/lab-roles.sqlite3').create(1001,request,options)
assert payload==(O/'candidate-1151.bin').read_bytes()
# Restore v3's safe default 1150 response; v4 handles character messages dynamically.
control['role_persistence']={'synthetic_uid':1001}
temp=L/'lab-control.install.tmp'
temp.write_text(json.dumps(control,indent=2)+'\n',encoding='utf-8')
os.replace(temp,L/'lab-control.json')
snapshot=(L/'evidence/lab-wire-v3.jsonl').read_bytes()
(O/'E-014-wire-snapshot.jsonl').write_bytes(snapshot)
manifest={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in O.iterdir() if p.is_file() and p.name!='SHA256.json'}
(O/'SHA256.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
print('Installed v4 and persisted t07; v3 live process not restarted')
