"""Prepare one explicit loopback role response from an observed 1150 request."""
import json
import struct
import hashlib
from pathlib import Path

PROJECT = Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
LAB = PROJECT / 'research/2026-09-06/work/login-to-world'
OUT = PROJECT / 'research/2026-09-07/role-create'

def main():
    OUT.mkdir(parents=True, exist_ok=True)
    rows = [json.loads(s) for s in (LAB/'evidence/lab-wire-v3.jsonl').read_text().splitlines()]
    requests = [r for r in rows if r.get('direction') == 'request' and r.get('message_id') == 1150]
    sample = requests[-1]
    request = bytes.fromhex(sample['payload_hex'])
    assert len(request) == 68 and request[:4] == b't07\0'
    choices = struct.unpack_from('<7I', request, 23)
    assert all(choices)
    catalog = json.loads((LAB/'evidence/E-011-item-config-enumeration.json').read_text(encoding='utf-8-sig'))['payload']['records']
    by_id = {r['id']: r for r in catalog}
    types = (15, 13, 12, 17, 16, 14, 25)
    slots = (2, 3, 4, 5, 6, 7, 8)
    role = bytearray(360)
    struct.pack_into('<I', role, 0, 1001)
    role[4:25] = request[:21]
    role[122] = request[21]  # same bone key as create preview (9D1340 / 9D0F70)
    role[124] = request[22]  # secondary stats key, from create request; candidate mapping
    items = bytearray()
    decoded = []
    for i, (item_id, item_type, slot) in enumerate(zip(choices, types, slots)):
        assert by_id[item_id]['recordId'] == item_type
        item = bytearray(68)
        struct.pack_into('<IBII', item, 0, i+1, item_type, item_id, 1)
        struct.pack_into('<H', item, 17, slot)
        items.extend(item)
        decoded.append({'slot':i,'item_id':item_id,'type':item_type,'equipped_slot':slot})
    payload = bytes(role + items)
    assert len(payload) == 836
    import sys
    sys.path.insert(0, str(LAB))
    from game_protocol import encode_frame, decode_frame
    assert decode_frame(encode_frame(1151,payload)).payload == payload
    (OUT/'E-013-nonzero-request.json').write_text(json.dumps(sample,indent=2),encoding='utf-8')
    (OUT/'E-013-decoded.json').write_text(json.dumps({'name':'t07','gender':request[21],'variant':request[22],'items':decoded,'opaque_tail_hex':request[51:].hex()},indent=2),encoding='utf-8')
    (OUT/'candidate-1151.bin').write_bytes(payload)
    control_path = LAB/'lab-control.json'
    backup = OUT/'lab-control.before-1151.json'
    if backup.exists():
        raise RuntimeError('Probe already prepared; refusing to overwrite baseline')
    backup.write_bytes(control_path.read_bytes())
    control = json.loads(control_path.read_text(encoding='utf-8-sig'))
    control['game']['1150'] = {'message_id':1151,'key_index':0,'delay_ms':100,'payload_hex':payload.hex()}
    control_path.write_text(json.dumps(control,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'prepared':str(OUT),'items':decoded,'payload_size':len(payload),'sha256':hashlib.sha256(payload).hexdigest()}))

if __name__ == '__main__':
    main()
