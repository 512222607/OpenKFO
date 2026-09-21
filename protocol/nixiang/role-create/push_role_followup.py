"""Bounded hot-config push on the existing lab connection; restore in finally."""
import json, time, os, sys
from pathlib import Path
P=Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
L=P/'research/2026-09-06/work/login-to-world'
O=P/'research/2026-09-07/role-create'
C=L/'lab-control.json'
def write(data):
    temp=C.with_suffix('.role-probe.tmp')
    temp.write_bytes(data)
    os.replace(temp,C)
def main():
    original=C.read_bytes()
    control=json.loads(original.decode('utf-8-sig'))
    assert '0' not in control['game']
    msg=int(sys.argv[1]) if len(sys.argv)>1 else 3330
    assert msg in (3330,1130)
    body='e9030000' if msg==3330 else (O/'candidate-1151.bin').read_bytes()[:360].hex()
    baseline=(json.dumps(control,indent=2)+'\n').encode()
    control['game']['0']={'message_id':msg,'payload_hex':body,'delay_ms':100}
    logfile=L/'evidence/lab-wire-v3.jsonl'
    start=logfile.stat().st_size
    start_time=time.time()
    try:
        write((json.dumps(control,indent=2)+'\n').encode())
        with logfile.open('r',encoding='utf-8') as f:
            f.seek(start)
            while time.time()-start_time<8:
                line=f.readline()
                if not line:
                    time.sleep(.005)
                    continue
                try: event=json.loads(line)
                except ValueError: continue
                if event.get('direction')=='response' and event.get('message_id')==msg:
                    write(baseline)
                    (O/f'E-015-followup-{msg}.json').write_text(json.dumps(event,indent=2),encoding='utf-8')
                    print(f'{msg} observed; heartbeat rule removed')
                    break
            else: print('No 3330 observed within bounded window')
    finally:
        write(baseline)
if __name__=='__main__':main()
