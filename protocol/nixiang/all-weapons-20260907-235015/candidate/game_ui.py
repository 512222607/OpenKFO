"""Local isolated-client controls; checks PID ownership before every input."""
import ctypes as C,json,argparse,time
from pathlib import Path
from ctypes import wintypes as W
u=C.windll.user32
u.GetWindowTextW.argtypes=[W.HWND,W.LPWSTR,C.c_int]
u.GetClassNameW.argtypes=[W.HWND,W.LPWSTR,C.c_int]
u.GetWindowThreadProcessId.argtypes=[W.HWND,C.POINTER(W.DWORD)]
u.PostMessageW.argtypes=[W.HWND,W.UINT,W.WPARAM,W.LPARAM]
u.GetDlgCtrlID.argtypes=[W.HWND]
CB=C.WINFUNCTYPE(W.BOOL,W.HWND,W.LPARAM)
def text(h):
 b=C.create_unicode_buffer(512);u.GetWindowTextW(h,b,512);return b.value
def cls(h):
 b=C.create_unicode_buffer(256);u.GetClassNameW(h,b,256);return b.value
def pid(h):
 p=W.DWORD();u.GetWindowThreadProcessId(h,C.byref(p));return p.value
def enum(parent=None):
 rows=[]
 cb=CB(lambda h,_:rows.append(int(h)) or True)
 if parent:u.EnumChildWindows(W.HWND(parent),cb,0)
 else:u.EnumWindows(cb,0)
 return rows
def windows(p):return [h for h in enum() if pid(h)==p and u.IsWindowVisible(W.HWND(h))]
if __name__=='__main__':
 root=next(x for x in Path(__file__).resolve().parents if (x/'go.mod').exists())
 active=json.loads((root/'research/2026-09-06/work/login-protocol/active-observer.json').read_text())
 ap=argparse.ArgumentParser();ap.add_argument('action',choices=['inspect','dismiss','login','context']);ap.add_argument('--pid',type=int,default=active['game_pid']);a=ap.parse_args()
 wins=windows(a.pid)
 if a.action=='inspect':
  print(json.dumps([{'h':h,'class':cls(h),'title':text(h),'children':[{'h':c,'id':u.GetDlgCtrlID(W.HWND(c)),'class':cls(c),'text':text(c) if cls(c)!='Edit' else '(redacted)'} for c in enum(h)]} for h in wins],ensure_ascii=False))
 elif a.action=='dismiss':
  dialogs=[h for h in wins if cls(h)=='#32770' and text(h) in ['错误','提示']]
  for h in dialogs:
   buttons=[c for c in enum(h) if cls(c)=='Button' and text(c) in ['确定','确定(&O)','OK']]
   if len(buttons)!=1:raise SystemExit('Ambiguous dialog')
   b=buttons[0];u.PostMessageW(W.HWND(h),0x111,u.GetDlgCtrlID(W.HWND(b)),b)
  time.sleep(.3);print(json.dumps({'dismissed':len(dialogs)}))
 elif a.action=='context':
  main=next(h for h in wins if cls(h)=='GAMECLIENT');p=W.DWORD();tid=u.GetWindowThreadProcessId(W.HWND(main),C.byref(p))
  print(json.dumps({'pid':a.pid,'hwnd':main,'tid':tid}))
 else:
  ctx=json.loads((Path(__file__).parent/'live-context.json').read_text(encoding='utf-8-sig'));b=ctx['login_button']
  if pid(b)!=a.pid or cls(b)!='Button':raise SystemExit('Observed login button is stale; inspect again')
  u.PostMessageW(W.HWND(b),0x201,1,44+18*65536);u.PostMessageW(W.HWND(b),0x202,0,44+18*65536)
  print('Login click posted')
