"""Temporary loopback response oracle; never account authentication."""
import socketserver,json,struct,time,threading
from pathlib import Path
R=Path(__file__).resolve().parent
lock=threading.Lock()
def event(x):
 with lock:
  with (R/'evidence'/'lab-wire.jsonl').open('a',encoding='utf-8') as f:f.write(json.dumps({'time':time.time(),**x})+'\n')
class Handler(socketserver.BaseRequestHandler):
 def handle(self):
  self.request.settimeout(30);buf=b''
  event({'kind':'connect','port':self.server.server_address[1]})
  try:
   while True:
    block=self.request.recv(65536)
    if not block:break
    buf+=block
    if self.server.server_address[1]!=8094:
     event({'kind':'other-port-request','port':self.server.server_address[1],'hex':block.hex()})
     control=json.loads((R/'lab-control.json').read_text(encoding='utf-8-sig'))
     response=control.get('ports',{}).get(str(self.server.server_address[1]))
     if response and len(buf)>=8 and len(buf)>=8+buf[7]+struct.unpack_from('<H',buf,4)[0]:
      self.request.sendall(bytes.fromhex(response));event({'kind':'other-port-response','port':self.server.server_address[1],'hex':response});buf=b''
     continue
    while len(buf)>=12:
     magic,n,typ=struct.unpack_from('<III',buf)
     if magic!=0xa5d2b3d6 or not 12<=n<=1048576:raise ValueError('Unknown framing')
     if len(buf)<n:break
     req,buf=buf[:n],buf[n:];control=json.loads((R/'lab-control.json').read_text())
     event({'kind':'request','case':control['case'],'type':typ,'hex':req.hex()})
     body=control['body'].encode('gbk')+b'\0';reply=struct.pack('<II',0xff012cab,len(body)+8)+body
     self.request.sendall(reply);event({'kind':'response','case':control['case'],'hex':reply.hex()})
  except Exception as e:event({'kind':'end','error':str(e)})
class Server(socketserver.ThreadingTCPServer):
 allow_reuse_address=True
 daemon_threads=True
servers=[]
for port in [8094,8000,10035,5136]:
 s=Server(('127.0.0.1',port),Handler);servers.append(s);threading.Thread(target=s.serve_forever,daemon=True).start()
print('Local protocol lab ready',flush=True)
try:
 while not (R/'lab-stop').exists():time.sleep(.25)
finally:
 for s in servers:s.shutdown();s.server_close()
