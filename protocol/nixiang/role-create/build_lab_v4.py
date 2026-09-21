"""Generate the next lab server while retaining original v3 evidence/code."""
from pathlib import Path
HERE=Path(__file__).resolve().parent
PROJECT=Path(r'C:\Users\24032\Desktop\code\kungfu-mock-server')
source=(PROJECT/'research/2026-09-06/work/login-to-world/lab_server_v3.py').read_text(encoding='utf-8-sig')
source=source.replace('synthetic account/session only.', 'synthetic account/session with persisted lab roles.')
source=source.replace('EVENT_LOCK = threading.Lock()', 'from role_protocol import LabRoleStore, RoleSession, option_map\n\nEVENT_LOCK = threading.Lock()')
source=source.replace('lab-wire-v3.jsonl','lab-wire-v4.jsonl')
source=source.replace('        game_stream = GameFrameStream()', '        game_stream = GameFrameStream()\n        self.role_session = RoleSession(self.server.role_store, self.server.role_uid, self.server.role_options)')
old='                rule = load_control().get("game", {}).get(str(frame.message_id))'
new='''                control = load_control()
                rule = self.role_session.handle(frame.message_id, frame.payload, control)
                if rule is None:
                    rule = control.get("game", {}).get(str(frame.message_id))'''
assert old in source
source=source.replace(old,new)
old='                event({"kind": "game-frame-error", "port": port, "error": str(exc), "hex": raw.hex()})'
source=source.replace(old,old+'\n                raise  # close invalid lab session; never claim creation succeeded')
pos=source.index('\nservers = []')
source=source[:pos]+'''
def main():
    control = load_control()
    settings = control.get('role_persistence', {})
    if settings.get('synthetic_uid') != 1001:
        raise ValueError('This server requires explicit synthetic_uid=1001')
    store = LabRoleStore(ROOT / 'data' / 'lab-roles.sqlite3')
    options_rule = next(r for r in control['game']['1010'] if r.get('message_id') == 1125 and r.get('enabled', True))
    options = option_map(bytes.fromhex(options_rule['payload_hex']))
    servers = []
    try:
        for port in (8094, 8000, 10035, 5136):
            server = Server(('127.0.0.1', port), Handler)
            server.role_store = store
            server.role_uid = 1001
            server.role_options = options
            servers.append(server)
            threading.Thread(target=server.serve_forever, daemon=True).start()
        print('Loopback protocol lab v4 ready; synthetic UID 1001; persistent roles', flush=True)
        while not (ROOT / 'lab-stop-v4').exists():
            time.sleep(.25)
    finally:
        for server in servers:
            server.shutdown()
            server.server_close()

if __name__ == '__main__':
    main()
'''
(HERE/'lab_server_v4.py').write_text(source,encoding='utf-8')
print('Generated lab_server_v4.py')
