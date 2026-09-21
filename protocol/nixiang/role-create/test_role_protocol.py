import concurrent.futures
import json
from pathlib import Path
import struct
import tempfile
import unittest
import sys
sys.path.insert(0,str(Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server\research\2026-09-06\work\login-to-world')))
from role_protocol import LabRoleStore, RoleSession, parse_create_role, option_map, build_role_payload, build_world_handoff_payload

PROJECT=Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
LAB=PROJECT/'research/2026-09-06/work/login-to-world'
CASE=PROJECT/'research/2026-09-07/role-create'

class RoleTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.control=json.loads((CASE/'lab-control.before-1151.json').read_text(encoding='utf-8-sig'))
        cls.options=option_map(bytes.fromhex(cls.control['game']['1010'][1]['payload_hex']))
        cls.request=bytes.fromhex(json.loads((CASE/'E-013-nonzero-request.json').read_text(encoding='utf-8'))['payload_hex'])

    def setUp(self):
        self.temp=tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.path=Path(self.temp.name)/'roles.sqlite3'
        self.store=LabRoleStore(self.path)

    def test_real_capture_and_wire_equivalence(self):
        r=parse_create_role(self.request)
        self.assertEqual((r.name,r.gender,r.variant),('t07',2,13))
        self.assertEqual(r.choices,(152002,132002,122001,172002,162003,142002,253002))
        self.assertEqual(build_role_payload(1001,self.request,self.options),(CASE/'candidate-1151.bin').read_bytes())

    def test_persistence_and_concurrent_retry(self):
        with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
            results=list(pool.map(lambda _:self.store.create(1001,self.request,self.options),range(8)))
        self.assertTrue(all(r==results[0] for r in results))
        self.assertEqual(LabRoleStore(self.path).get(1001),results[0])
        self.assertIsNone(self.store.get(2002))
        with self.assertRaises(ValueError): self.store.create(2002,self.request,self.options)

    def test_reject_malformed_and_unoffered(self):
        for raw in (self.request[:-1],self.request+b'0',b'x'*68):
            with self.assertRaises(ValueError): parse_create_role(raw)
        raw=bytearray(self.request);struct.pack_into('<I',raw,23,0xffffffff)
        with self.assertRaises(ValueError): self.store.create(1001,bytes(raw),self.options)
        self.assertIsNone(self.store.get(1001))

    def test_preserve_opaque_fields_and_existing_role(self):
        self.store.create(1001,self.request,self.options)
        retry=bytearray(self.request);retry[60:]=b'12345678'
        self.assertEqual(self.store.create(1001,bytes(retry),self.options),self.store.get(1001))
        retry[0]=ord('x')
        with self.assertRaises(ValueError):self.store.create(1001,bytes(retry),self.options)
        self.assertEqual(parse_create_role(self.request).raw,self.request)

    def test_session_create_ack_and_reconnect(self):
        session=RoleSession(self.store,1001,self.options)
        with self.assertRaises(ValueError):session.handle(1150,self.request,self.control)
        login=struct.pack('<I',1001)+bytes(92)
        self.assertIsNone(session.handle(1010,login,self.control))
        self.assertEqual([r['message_id'] for r in session.handle(1150,self.request,self.control)],[1151])
        self.assertEqual([r['message_id'] for r in session.handle(3320,bytes.fromhex('ed070404'),self.control)],[3330,1130])
        other=RoleSession(LabRoleStore(self.path),1001,self.options)
        self.assertEqual([r['message_id'] for r in other.handle(1010,login,self.control)],[1020,1120,1130])
        with self.assertRaises(ValueError):other.handle(3320,bytes(4),self.control)

    def test_optional_1201_channel_advance_after_existing_role_selection(self):
        self.store.create(1001,self.request,self.options)
        login=struct.pack('<I',1001)+bytes(92)
        session=RoleSession(self.store,1001,self.options)
        session.handle(1010,login,self.control)
        self.assertEqual(
            [r['message_id'] for r in session.handle(3320,struct.pack('<I',1001),self.control)],
            [3330],
        )
        probe_control=json.loads(json.dumps(self.control))
        probe_control.setdefault('role_persistence',{})['advance_after_role_select_1201']=True
        replies=session.handle(3320,struct.pack('<I',1001),probe_control)
        self.assertEqual([r['message_id'] for r in replies],[3330,1201])
        self.assertEqual(bytes.fromhex(replies[1]['payload_hex']),bytes(4))

    def test_2010_returns_bounded_2030_world_handoff(self):
        login=struct.pack('<I',1001)+bytes(92)
        session=RoleSession(self.store,1001,self.options)
        replies=session.handle(2010,login,self.control)
        self.assertEqual([r['message_id'] for r in replies],[2030])
        payload=bytes.fromhex(replies[0]['payload_hex'])
        self.assertEqual(len(payload),52)
        self.assertEqual(struct.unpack_from('<I',payload,0)[0],1001)
        self.assertEqual(payload[4:24].split(b'\0',1)[0],b'127.0.0.1')
        self.assertEqual(struct.unpack_from('<H',payload,24)[0],5136)
        self.assertEqual(struct.unpack_from('<I',payload,26)[0],1)
        for bad in (login[:-1],struct.pack('<I',1002)+bytes(92)):
            with self.assertRaises(ValueError):session.handle(2010,bad,self.control)
        for args in ((0,), (1001,'x'*20), (1001,'127.0.0.1',0), (1001,'127.0.0.1',5136,0)):
            with self.assertRaises(ValueError):build_world_handoff_payload(*args)

    def test_distinct_server_choice_and_local_id(self):
        custom=dict(self.options)
        raw=bytearray(self.request);struct.pack_into('<I',raw,23,42)
        custom[(2,0,42)]=152002
        payload=build_role_payload(1001,bytes(raw),custom)
        self.assertEqual(struct.unpack_from('<I',payload,365)[0],152002)

    def test_real_tcp_fragmentation_create_and_reconnect(self):
        import socket,threading
        import lab_server_v4 as server
        from game_protocol import encode_frame,decode_frame,GameFrameStream
        saved_event,saved_control,saved_ports=server.event,server.load_control,server.GAME_PORTS
        events=[]
        server.event=events.append
        server.load_control=lambda:self.control
        tcp=server.Server(('127.0.0.1',0),server.Handler)
        tcp.role_store=self.store;tcp.role_uid=1001;tcp.role_options=self.options
        port=tcp.server_address[1]
        server.GAME_PORTS={port}
        worker=threading.Thread(target=tcp.serve_forever,daemon=True);worker.start()
        def receive(sock,n):
            stream=GameFrameStream();frames=[]
            while len(frames)<n:
                block=sock.recv(8192)
                if not block:raise AssertionError('Unexpected EOF')
                frames.extend(decode_frame(b) for b in stream.feed(block))
            return frames
        login=encode_frame(1010,struct.pack('<I',1001)+bytes(92))
        try:
            with socket.create_connection(('127.0.0.1',port),timeout=3) as sock:
                for i in range(0,len(login),3):sock.sendall(login[i:i+3])
                self.assertEqual([f.message_id for f in receive(sock,2)],[1020,1125])
                sock.sendall(encode_frame(1150,self.request,9))
                created=receive(sock,1)[0]
                self.assertEqual((created.message_id,len(created.payload)),(1151,836))
                sock.sendall(encode_frame(3320,bytes.fromhex('ed070404')))
                self.assertEqual([f.message_id for f in receive(sock,2)],[3330,1130])
            with socket.create_connection(('127.0.0.1',port),timeout=3) as sock:
                sock.sendall(login)
                frames=receive(sock,3)
                self.assertEqual([f.message_id for f in frames],[1020,1120,1130])
                self.assertEqual(frames[1].payload,created.payload[360:])
                self.assertEqual(frames[2].payload,created.payload[:360])
            self.assertFalse(any(e['kind']=='game-frame-error' for e in events))
        finally:
            tcp.shutdown();tcp.server_close();worker.join()
            server.event,server.load_control,server.GAME_PORTS=saved_event,saved_control,saved_ports

if __name__=='__main__':unittest.main()
