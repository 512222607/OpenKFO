import argparse,json,time,threading
from pathlib import Path
import frida
p=argparse.ArgumentParser();p.add_argument('script');p.add_argument('--seconds',type=int,default=300);a=p.parse_args()
R=Path(__file__).resolve().parent
P=next(x for x in R.parents if (x/'go.mod').exists())
active=json.loads((P/'research/2026-09-06/work/login-protocol/active-observer.json').read_text())
done=threading.Event();s=frida.get_local_device().attach(active['game_pid'])
out=R/'evidence'/f'{Path(a.script).stem}-{time.strftime("%H%M%S")}.jsonl'
with out.open('x',encoding='utf-8') as f:
 def receive(message,data):
  x=message.get('payload',message);f.write(json.dumps(x,ensure_ascii=False,default=str)+'\n');f.flush()
  print(json.dumps({k:v for k,v in x.items() if k in ['kind','pid','threads','error','base','at','result','n']},ensure_ascii=False),flush=True)
  if x.get('kind')=='done' or message.get('type')=='error':done.set()
 s.on('detached',lambda *args:done.set())
 source=(R/a.script).read_text(encoding='utf-8-sig')
 if (R/'live-context.json').exists():
  ctx=json.loads((R/'live-context.json').read_text(encoding='utf-8-sig'))
  if ctx['pid']!=active['game_pid']:raise RuntimeError('Refresh live-context.json for the current game')
  source=source.replace('tid=35584','tid='+str(ctx['tid'])).replace('!==525720','!=='+str(ctx['login_button']))
 q=s.create_script(source);q.on('message',receive)
 try:
  q.load();done.wait(a.seconds)
 finally:
  try:q.exports_sync.cleanup()
  except Exception:pass
  try:s.detach()
  except Exception:pass
print(str(out),flush=True)
