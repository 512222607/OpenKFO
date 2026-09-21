import sys,json,time,ctypes as C
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
import game_ui as g
c=json.loads((Path(__file__).parent/'live-context.json').read_text(encoding='utf-8-sig'));h=c['hwnd']
if g.pid(h)!=c['pid'] or g.cls(h)!='GAMECLIENT':raise SystemExit('Stale game')
u=g.u;u.GetForegroundWindow.restype=g.W.HWND
u.keybd_event(0x12,0,0,0);u.keybd_event(0x12,0,2,0);old=u.GetForegroundWindow();current=C.windll.kernel32.GetCurrentThreadId();fg=u.GetWindowThreadProcessId(old,None);target=u.GetWindowThreadProcessId(g.W.HWND(h),None)
u.AttachThreadInput(current,fg,True);u.AttachThreadInput(current,target,True)
try:
 u.ShowWindow(g.W.HWND(h),9);u.BringWindowToTop(g.W.HWND(h));u.SetActiveWindow(g.W.HWND(h));u.SetForegroundWindow(g.W.HWND(h));u.SetFocus(g.W.HWND(h))
finally:
 u.AttachThreadInput(current,target,False);u.AttachThreadInput(current,fg,False)
time.sleep(.2)
if u.GetForegroundWindow()!=h:raise SystemExit('Could not focus game; no click sent')
x,y=map(int,sys.argv[1:3]);point=g.W.POINT(x,y);u.ClientToScreen(g.W.HWND(h),C.byref(point));u.SetCursorPos(point.x,point.y)
time.sleep(.15)
u.mouse_event(2,0,0,0,0);time.sleep(.15);u.mouse_event(4,0,0,0,0)
print('Foreground game click',x,y)
