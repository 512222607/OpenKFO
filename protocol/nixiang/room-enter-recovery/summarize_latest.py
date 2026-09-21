from pathlib import Path
from datetime import datetime
import json
import sys

path = Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\work\login-to-world\evidence\lab-wire-v4.jsonl')
cutoff = float(sys.argv[1]) if len(sys.argv) > 1 else 1788793000
with path.open('rb') as f:
    f.seek(0, 2)
    length = f.tell()
    f.seek(max(0, length - 4 * 1024 * 1024))
    if f.tell():
        f.readline()
    rows = []
    for line in f:
        try:
            row = json.loads(line)
        except ValueError:
            continue
        if row.get('time', 0) < cutoff:
            continue
        if row.get('kind') == 'game-frame' and row.get('message_id'):
            rows.append({'time': datetime.fromtimestamp(row['time']).isoformat(timespec='seconds'),
                         'epoch': row['time'], 'direction': row['direction'], 'id': row['message_id'],
                         'len': row['payload_len'], 'hex': row['payload_hex'][:190]})
        elif row.get('kind') in ('connect', 'end', 'game-frame-error'):
            rows.append(row)
print(json.dumps(rows[-65:], ensure_ascii=False, indent=2))
