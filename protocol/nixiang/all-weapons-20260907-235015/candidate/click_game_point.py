import sys,json,time
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
import game_ui as g
c=json.loads((Path(__file__).parent/'live-context.json').read_text(encoding='utf-8-sig'));h=c['hwnd']
if g.pid(h)!=c['pid'] or g.cls(h)!='GAMECLIENT':raise SystemExit('Stale game window')
x,y=map(int,sys.argv[1:3]);v=x+y*65536
g.u.PostMessageW(g.W.HWND(h),0x200,0,v);g.u.PostMessageW(g.W.HWND(h),0x201,1,v);time.sleep(.15);g.u.PostMessageW(g.W.HWND(h),0x202,0,v)
print('Clicked isolated game',x,y)
