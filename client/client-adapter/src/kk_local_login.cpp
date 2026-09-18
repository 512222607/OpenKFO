// Local password-authenticated handoff for the verified gfld.dat build.
// Calls its existing session setter and Connect routine on the game UI thread.
// No fake login acknowledgement or forced game state. Server still checks PID.
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <cstdio>
#include <cstring>

struct LoginRequest { DWORD magic; HWND window; char session[65]; };
static HINSTANCE instance;
static HHOOK hook;
static HANDLE finished;
static char session[65];
static volatile LONG busy;
static DWORD outcome;
static const UINT message = WM_APP + 0x3b0;

static bool read_memory(const void* address, void* value, SIZE_T length) {
    SIZE_T read = 0;
    return ReadProcessMemory(GetCurrentProcess(), address, value, length, &read) && read == length;
}
static bool bytes_match(DWORD address, const unsigned char* expected, SIZE_T length) {
    unsigned char actual[32];
    return length <= sizeof(actual) && read_memory((void*)address, actual, length) && !memcmp(actual, expected, length);
}
static bool compatible() {
    const unsigned char get[] = {0x55,0x8b,0xec,0xa1,0x28,0x8a,0x7c,0x01,0x5d,0xc3};
    const unsigned char set[] = {0x55,0x8b,0xec,0x51,0x89,0x4d,0xfc,0x83,0x7d,0x08,0x00,0x74,0x16};
    const unsigned char connect[] = {0x55,0x8b,0xec,0x83,0xec,0x08,0x89,0x4d,0xfc,0xe8,0x22,0xa4,0xb4,0xff};
    return GetModuleHandleW(nullptr) == (HMODULE)0x400000 && bytes_match(0x4032c0,get,sizeof(get)) &&
        bytes_match(0x913970,set,sizeof(set)) && bytes_match(0x913e10,connect,sizeof(connect));
}
static DWORD handoff() {
    if (!compatible()) return 11;
    DWORD role = 0, manager = 0, login = 0;
    if (!read_memory((void*)0x17c86f0,&role,4) || role < 0x10000 ||
        !read_memory((void*)0x17c8a28,&manager,4) || manager < 0x10000 ||
        !read_memory((void*)(manager+8),&login,4) || login < 0x10000) return 12;
    // Publish only the observed, already-initialized role table.
    wchar_t path[32768];
    if (!GetModuleFileNameW(nullptr,path,32768)) return 13;
    wchar_t* slash = wcsrchr(path,L'\\');
    if (!slash) return 13;
    wcscpy(slash+1,L"kk-roleprop-ready.txt");
    HANDLE file = CreateFileW(path,GENERIC_WRITE,FILE_SHARE_READ,nullptr,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,nullptr);
    if (file == INVALID_HANDLE_VALUE) return 13;
    char text[32]; int length = sprintf(text,"0x%08lX\r\n",role); DWORD written = 0;
    bool ok = WriteFile(file,text,length,&written,nullptr) && written == (DWORD)length;
    CloseHandle(file);
    if (!ok) return 13;
    using SetSession = void (__thiscall*)(void*,const char*);
    using Connect = bool (__thiscall*)(void*,const char*,DWORD);
    ((SetSession)0x913970)((void*)manager,session);
    return ((Connect)0x913e10)((void*)manager,"127.0.0.1",18000) ? 0 : 14;
}
static LRESULT CALLBACK receive(int code, WPARAM wparam, LPARAM lparam) {
    if (code >= 0) {
        CWPSTRUCT* msg = (CWPSTRUCT*)lparam;
        if (msg->message == message && msg->wParam == 0x4b4b4c31) {
            outcome = handoff();
            SecureZeroMemory(session,sizeof(session));
            SetEvent(finished);
        }
    }
    return CallNextHookEx(hook,code,wparam,lparam);
}
extern "C" __declspec(dllexport) DWORD WINAPI BeginLocalLogin(void* parameter) {
    LoginRequest request;
    if (!read_memory(parameter,&request,sizeof(request)) || request.magic != 0x4b4b4c31) return 1;
    if (InterlockedCompareExchange(&busy,1,0)) return 2;
    DWORD result = 3, owner = 0;
    DWORD thread = GetWindowThreadProcessId(request.window,&owner);
    if (owner == GetCurrentProcessId() && request.session[64] == 0 && compatible()) {
        bool valid = true;
        for (int i=0;i<64;++i) if (!((request.session[i]>='0'&&request.session[i]<='9') ||
                                      (request.session[i]>='a'&&request.session[i]<='f'))) valid=false;
        if (valid) {
            memcpy(session,request.session,sizeof(session));
            finished = CreateEventW(nullptr,TRUE,FALSE,nullptr);
            outcome = 4;
            hook = finished ? SetWindowsHookExW(WH_CALLWNDPROC,receive,instance,thread) : nullptr;
            DWORD_PTR ignored=0;
            if (hook && SendMessageTimeoutW(request.window,message,0x4b4b4c31,0,SMTO_ABORTIFHUNG|SMTO_BLOCK,10000,&ignored) &&
                WaitForSingleObject(finished,15000)==WAIT_OBJECT_0) result=outcome;
            else result=5;
            if (hook) UnhookWindowsHookEx(hook);
            if (finished) CloseHandle(finished);
        }
    }
    SecureZeroMemory(&request,sizeof(request));
    SecureZeroMemory(session,sizeof(session));
    InterlockedExchange(&busy,0);
    return result;
}
BOOL WINAPI DllMain(HINSTANCE module,DWORD reason,LPVOID) {
    if (reason==DLL_PROCESS_ATTACH) {instance=module;DisableThreadLibraryCalls(module);}
    return TRUE;
}
