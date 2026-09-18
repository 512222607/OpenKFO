"""Local login UI; credentials and tickets stay out of arguments and files."""
import ctypes
from ctypes import wintypes
import hashlib
import json
from pathlib import Path
import socket
import struct
import subprocess
import threading
import time
import tkinter as tk
from tkinter import ttk

from .native_identity import WindowsNativeVerifier
from .sdo_identity import ProcessEntry

ROOT = Path(__file__).resolve().parents[2]
CLIENT = ROOT / 'runtime-local/client'
IMAGE = CLIENT / 'gfld.dat'
IMAGE_HASH = '98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b'


def api(operation, **arguments):
    data = json.dumps(dict(schema='kk-local-auth-v1', operation=operation, arguments=arguments)).encode('utf8')
    with socket.create_connection(('127.0.0.1', 17999), timeout=8) as connection:
        connection.sendall(struct.pack('!I', len(data)) + data)
        with connection.makefile('rb') as stream:
            header = stream.read(4)
            if len(header) != 4:
                raise ValueError('账号服务未返回完整响应')
            size = struct.unpack('!I', header)[0]
            if not 2 <= size <= 8192:
                raise ValueError('账号服务返回长度异常')
            body = stream.read(size)
            if len(body) != size:
                raise ValueError('账号服务响应中断')
            reply = json.loads(body)
    if not reply.get('ok'):
        raise ValueError(reply.get('error', '认证失败'))
    return reply['result']


def game_process():
    if hashlib.sha256(IMAGE.read_bytes()).hexdigest() != IMAGE_HASH:
        raise ValueError('客户端版本不匹配，已停止适配')
    verifier = WindowsNativeVerifier(IMAGE)
    kernel = verifier.kernel
    kernel.CreateToolhelp32Snapshot.argtypes = [wintypes.DWORD, wintypes.DWORD]
    kernel.CreateToolhelp32Snapshot.restype = wintypes.HANDLE
    for name in ('Process32FirstW', 'Process32NextW'):
        function = getattr(kernel, name)
        function.argtypes = [wintypes.HANDLE, ctypes.POINTER(ProcessEntry)]
        function.restype = wintypes.BOOL
    snapshot = kernel.CreateToolhelp32Snapshot(2, 0)
    if snapshot in (None, ctypes.c_void_p(-1).value):
        raise ValueError('无法检查游戏进程')
    found = []
    try:
        row = ProcessEntry()
        row.size = ctypes.sizeof(row)
        ok = kernel.Process32FirstW(snapshot, ctypes.byref(row))
        while ok:
            if row.exe.lower() == 'gfld.dat':
                try:
                    found.append(verifier.process(int(row.pid)))
                except ValueError:
                    pass
            ok = kernel.Process32NextW(snapshot, ctypes.byref(row))
    finally:
        kernel.CloseHandle(snapshot)
    if len(found) > 1:
        raise ValueError('存在多个本地游戏进程，请只保留一个')
    if found:
        return verifier, found[0], None
    process = subprocess.Popen([str(IMAGE)], cwd=CLIENT)
    return verifier, verifier.process(process.pid), process


def wait_for_tables(verifier, identity, timeout=90):
    kernel = verifier.kernel
    kernel.ReadProcessMemory.argtypes = [wintypes.HANDLE, ctypes.c_void_p, ctypes.c_void_p,
                                        ctypes.c_size_t, ctypes.POINTER(ctypes.c_size_t)]
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        if verifier.process(identity.pid) != identity:
            raise ValueError('游戏进程已更换，请重新登录')
        handle = kernel.OpenProcess(0x1010, False, identity.pid)
        if not handle:
            raise ValueError('无法读取本地游戏初始化状态')
        try:
            values = []
            for address in (0x17c86f0, 0x17c8a28):
                value = wintypes.DWORD()
                read = ctypes.c_size_t()
                ok = kernel.ReadProcessMemory(handle, address, ctypes.byref(value), 4, ctypes.byref(read))
                values.append(value.value if ok and read.value == 4 else 0)
            if all(value >= 0x10000 for value in values):
                return
        finally:
            kernel.CloseHandle(handle)
        time.sleep(.25)
    raise ValueError('游戏初始化超时，尚未进入登录准备状态')


def login(account, password, register=False, progress=lambda message: None):
    helper = ROOT / 'build/adapter/local-handoff.exe'
    adapter = ROOT / 'build/adapter/native-login.dll'
    if not helper.is_file() or not adapter.is_file():
        raise ValueError('缺少本地适配模块，请先构建')
    if register:
        progress('正在创建本地账号…')
        api('register', account=account, password=password)
    progress('正在验证本地账号密码…')
    authenticated = api('login', account=account, password=password)
    session = authenticated['session']
    try:
        progress('正在启动游戏并等待角色配置初始化…')
        verifier, identity, process = game_process()
        wait_for_tables(verifier, identity)
        selected = api('select_region', session=session, region_id=1)
        api('bind_client', ticket=selected['ticket'], uid=selected['uid'], region_id=1, pid=identity.pid)
        progress('认证通过，正在连接本地区服…')
        result = subprocess.run([str(helper), str(identity.pid), str(IMAGE), str(adapter)],
                                input=session.encode('ascii'), capture_output=True, timeout=45,
                                creationflags=subprocess.CREATE_NO_WINDOW)
        if result.returncode:
            raise ValueError('游戏连接适配失败，诊断码 ' + str(result.returncode))
        deadline = time.monotonic() + 45
        status = None
        while time.monotonic() < deadline:
            status = api('status', session=session, pid=identity.pid)
            if status['lobby_ready']:
                return dict(pid=identity.pid, stage=status['stage'], lobby_ready=True)
            time.sleep(.5)
        raise ValueError('尚未完成大厅交接，当前阶段：' + str(status['stage'] if status else 'unknown'))
    except BaseException:
        try:
            api('logout', session=session)
        except (OSError, ValueError):
            pass
        raise


def main():
    window = tk.Tk()
    window.title('功夫小子 · 本地登录')
    window.geometry('440x290')
    window.resizable(False, False)
    frame = ttk.Frame(window, padding=22)
    frame.pack(fill='both', expand=True)
    ttk.Label(frame, text='功夫小子 · 本地区服', font=('Microsoft YaHei UI', 17)).pack(anchor='w')
    ttk.Label(frame, text='账号为 3–20 位字母数字，密码至少 8 位。').pack(anchor='w', pady=(8, 12))
    account = ttk.Entry(frame)
    account.pack(fill='x', pady=4)
    password = ttk.Entry(frame, show='●')
    password.pack(fill='x', pady=4)
    status = tk.StringVar(value='使用本地账号登录；首次使用请创建账号。')
    buttons = ttk.Frame(frame)
    buttons.pack(fill='x', pady=12)
    def progress(message):
        window.after(0, status.set, message)
    def start(register):
        user, secret = account.get().strip(), password.get()
        password.delete(0, 'end')
        for button in (signin, signup):
            button.configure(state='disabled')
        def work():
            try:
                result = login(user, secret, register, progress)
                progress('已完成本地认证和大厅交接，请切换到游戏窗口。')
            except Exception as error:
                translations = {'invalid_credentials': '账号或密码不正确', 'account_unavailable': '账号已存在，请直接登录',
                                'invalid_account_format': '账号须为 3–20 位字母数字',
                                'password_length_8_to_128_required': '密码须为 8–128 个字符'}
                progress(translations.get(str(error), str(error)))
            finally:
                window.after(0, lambda: [button.configure(state='normal') for button in (signin, signup)])
        threading.Thread(target=work, daemon=True).start()
    signin = ttk.Button(buttons, text='登录本地区服', command=lambda: start(False))
    signin.pack(side='left', expand=True, fill='x', padx=(0, 8))
    signup = ttk.Button(buttons, text='创建账号并登录', command=lambda: start(True))
    signup.pack(side='left', expand=True, fill='x')
    ttk.Label(frame, textvariable=status, wraplength=390).pack(anchor='w')
    account.focus_set()
    window.mainloop()


if __name__ == '__main__':
    main()
