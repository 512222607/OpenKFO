import sys,json,ctypes as C
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
import game_ui as g
R=Path(__file__).resolve().parent;c=json.loads((R/'live-context.json').read_text(encoding='utf-8-sig'));h=c['hwnd']
if g.pid(h)!=c['pid']:raise SystemExit('Stale HWND')
children=g.enum(h);edits=[x for x in children if g.cls(x)=='Edit' and g.u.IsWindowVisible(g.W.HWND(x))]
buttons=[x for x in children if g.cls(x)=='Button' and g.u.GetDlgCtrlID(g.W.HWND(x))==1001]
if len(edits)!=2 or len(buttons)!=1:raise SystemExit('Unexpected login form')
g.u.SendMessageW.argtypes=[g.W.HWND,g.W.UINT,g.W.WPARAM,g.W.LPARAM]
for edit,value in zip(edits,['labuser01','LocalTest26']):
 b=C.create_unicode_buffer(value);g.u.SendMessageW(g.W.HWND(edit),0xc,0,C.addressof(b))
if c.get('login_button') != buttons[0]:raise SystemExit('Observed login button is stale')
print('Synthetic test form ready; context unchanged')
