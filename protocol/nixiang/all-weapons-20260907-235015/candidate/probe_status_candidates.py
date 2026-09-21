"""Bounded response grammar experiment on one synthetic local account."""
import json,time
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parent))
import game_ui as g
R=Path(__file__).resolve().parent
c=json.loads((R/'live-context.json').read_text(encoding='utf-8-sig'));p=c['pid'];button=c['login_button']
def dismiss():
 for h in g.windows(p):
  if g.cls(h)=='#32770' and g.text(h) in ['错误','提示']:
   bs=[b for b in g.enum(h) if g.cls(b)=='Button' and g.text(b) in ['确定','确定(&O)','OK']]
   if len(bs)!=1:raise RuntimeError('Unexpected dialog')
   g.u.PostMessageW(g.W.HWND(h),0x111,g.u.GetDlgCtrlID(g.W.HWND(bs[0])),bs[0])
 time.sleep(.25)
out=R/'evidence'/('status-candidates-'+time.strftime('%H%M%S')+'.jsonl')
for value in ['SUCCESS','success','OK','ok','TRUE','true','200','0000','100','0','1','2','3','4','5','9','10','-1','成功','登录成功']:
 dismiss()
 if g.pid(button)!=p or not g.u.IsWindowVisible(g.W.HWND(button)):break
 (R/'lab-control.json').write_text(json.dumps({'case':'status-candidate-'+value,'body':value+'|1001'}),encoding='utf-8')
 g.u.PostMessageW(g.W.HWND(button),0x201,1,44+18*65536);g.u.PostMessageW(g.W.HWND(button),0x202,0,44+18*65536)
 result=None
 for _ in range(40):
  time.sleep(.1)
  ds=[h for h in g.windows(p) if g.cls(h)=='#32770' and g.text(h) in ['错误','提示']]
  if ds:
   result=[g.text(b) for b in g.enum(ds[0]) if g.cls(b)=='Static'];break
 row={'status':value,'dialog':result}
 with out.open('a',encoding='utf-8') as f:f.write(json.dumps(row,ensure_ascii=False)+'\n')
 print(json.dumps(row,ensure_ascii=False),flush=True)
 if result is None:break
print(out,flush=True)
