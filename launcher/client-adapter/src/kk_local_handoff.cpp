#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <tlhelp32.h>
#include <cstdio>
#include <cwchar>
#include <cstdlib>
#include <cstring>
#include <io.h>
#include <fcntl.h>

struct LoginRequest { DWORD magic; HWND window; char session[65]; };
static HWND game_window;
static BOOL CALLBACK find_window(HWND window, LPARAM pid) {
    DWORD owner=0;GetWindowThreadProcessId(window,&owner);
    wchar_t class_name[64]={};
    GetClassNameW(window,class_name,64);
    if (owner==(DWORD)pid && !wcscmp(class_name,L"GAMECLIENT") && IsWindowVisible(window) && !GetWindow(window,GW_OWNER)) {
        game_window=window;return FALSE;
    }
    return TRUE;
}
static DWORD remote_module(DWORD pid,const wchar_t* name) {
    HANDLE snapshot=CreateToolhelp32Snapshot(TH32CS_SNAPMODULE,pid);
    if (snapshot==INVALID_HANDLE_VALUE) return 0;
    MODULEENTRY32W entry={};entry.dwSize=sizeof(entry);DWORD base=0;
    if (Module32FirstW(snapshot,&entry)) do {
        if (!_wcsicmp(entry.szModule,name)) {base=(DWORD)entry.modBaseAddr;break;}
    } while(Module32NextW(snapshot,&entry));
    CloseHandle(snapshot);return base;
}
static bool remote_call(HANDLE process,DWORD function,const void* data,SIZE_T size,DWORD& result) {
    void* memory=VirtualAllocEx(process,nullptr,size,MEM_COMMIT|MEM_RESERVE,PAGE_READWRITE);
    SIZE_T written=0;
    if (!memory || !WriteProcessMemory(process,memory,data,size,&written) || written!=size) {
        if(memory)VirtualFreeEx(process,memory,0,MEM_RELEASE);return false;
    }
    HANDLE thread=CreateRemoteThread(process,nullptr,0,(LPTHREAD_START_ROUTINE)function,memory,0,nullptr);
    bool complete=thread && WaitForSingleObject(thread,20000)==WAIT_OBJECT_0;
    bool ok=complete && GetExitCodeThread(thread,&result);
    if(thread)CloseHandle(thread);
    // Do not free an argument that a timed-out remote thread may still use.
    if(complete || !thread)VirtualFreeEx(process,memory,0,MEM_RELEASE);
    return ok;
}
int wmain(int argc,wchar_t** argv) {
    if(argc!=4) {fwprintf(stderr,L"Usage: local-handoff PID exact-game-path adapter-path\n");return 1;}
    DWORD pid=wcstoul(argv[1],nullptr,10);
    HANDLE process=OpenProcess(PROCESS_CREATE_THREAD|PROCESS_QUERY_INFORMATION|PROCESS_VM_OPERATION|PROCESS_VM_WRITE|PROCESS_VM_READ,FALSE,pid);
    if(!process)return 2;
    wchar_t image[32768];DWORD count=32768;
    if(!QueryFullProcessImageNameW(process,0,image,&count) || _wcsicmp(image,argv[2])) {CloseHandle(process);return 3;}
    LoginRequest request={};request.magic=0x4b4b4c31;
    _setmode(_fileno(stdin),_O_BINARY);
    if(fread(request.session,1,64,stdin)!=64 || fgetc(stdin)!=EOF) {CloseHandle(process);return 4;}
    for(int i=0;i<64;++i) if(!((request.session[i]>='0'&&request.session[i]<='9') ||
        (request.session[i]>='a'&&request.session[i]<='f'))) {CloseHandle(process);return 4;}
    EnumWindows(find_window,pid);request.window=game_window;
    if(!game_window) {CloseHandle(process);return 5;}
    FARPROC load=GetProcAddress(GetModuleHandleW(L"kernel32.dll"),"LoadLibraryW");
    MEMORY_BASIC_INFORMATION info={};VirtualQuery((void*)load,&info,sizeof(info));
    wchar_t module_path[32768];GetModuleFileNameW((HMODULE)info.AllocationBase,module_path,32768);
    wchar_t* module_name=wcsrchr(module_path,L'\\');
    DWORD remote_base=module_name?remote_module(pid,module_name+1):0;
    if(!remote_base) {CloseHandle(process);return 6;}
    DWORD loaded=0;
    if(!remote_call(process,remote_base+(DWORD)load-(DWORD)info.AllocationBase,argv[3],(wcslen(argv[3])+1)*2,loaded) || !loaded) {
        CloseHandle(process);return 7;
    }
    HMODULE local=LoadLibraryExW(argv[3],nullptr,DONT_RESOLVE_DLL_REFERENCES);
    FARPROC begin=local?GetProcAddress(local,"BeginLocalLogin"):nullptr;
    if(!begin) {if(local)FreeLibrary(local);CloseHandle(process);return 8;}
    DWORD address=loaded+(DWORD)begin-(DWORD)local;FreeLibrary(local);
    DWORD result=99;bool ok=remote_call(process,address,&request,sizeof(request),result);
    SecureZeroMemory(&request,sizeof(request));CloseHandle(process);
    if(!ok)return 9;
    printf("Native handoff result: %lu\n",result);
    return result?20+(int)result:0;
}
