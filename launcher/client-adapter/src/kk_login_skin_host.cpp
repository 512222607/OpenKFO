// A narrow, same-user presentation hook for the selected game instance only.
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <cwchar>
#include <cstdlib>

static HWND loginWindow;
static BOOL CALLBACK findLogin(HWND window, LPARAM) {
    wchar_t name[64]; GetClassNameW(window, name, 64);
    if (!wcscmp(name, L"LoginChildWndClass")) { loginWindow = window; return FALSE; }
    return TRUE;
}
static BOOL CALLBACK findGame(HWND window, LPARAM processId) {
    DWORD owner; GetWindowThreadProcessId(window, &owner);
    wchar_t name[64]; GetClassNameW(window, name, 64);
    if (owner == (DWORD)processId && !wcscmp(name, L"GAMECLIENT")) {
        EnumChildWindows(window, findLogin, 0);
        return loginWindow ? FALSE : TRUE;
    }
    return TRUE;
}
int wmain(int count, wchar_t** args) {
    if (count != 4) return 1;
    DWORD processId = wcstoul(args[1], nullptr, 10);
    HANDLE process = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION | SYNCHRONIZE, FALSE, processId);
    if (!process) return 2;
    wchar_t image[32768]; DWORD size = 32768;
    if (!QueryFullProcessImageNameW(process, 0, image, &size) || _wcsicmp(image, args[2])) { CloseHandle(process); return 3; }
    // One skin host per native process, irrespective of launcher window count.
    wchar_t lockName[80]; swprintf_s(lockName, L"Local\\KungFuLoginSkin%lu", processId);
    HANDLE lock = CreateMutexW(nullptr, FALSE, lockName);
    if (!lock || GetLastError() == ERROR_ALREADY_EXISTS) { if (lock) CloseHandle(lock); CloseHandle(process); return 0; }
    HMODULE module = LoadLibraryW(args[3]);
    auto hookFunction = module ? (HOOKPROC)GetProcAddress(module, "_LoginSkinHook@12") : nullptr;
    if (!hookFunction) { CloseHandle(lock); CloseHandle(process); return 4; }
    HHOOK hook = nullptr;
    HWND attached = nullptr;
    while (WaitForSingleObject(process, 0) == WAIT_TIMEOUT) {
        loginWindow = nullptr;
        EnumWindows(findGame, processId);
        if (loginWindow != attached || (attached && !IsWindow(attached))) {
            if (hook) UnhookWindowsHookEx(hook);
            hook = nullptr;
            attached = nullptr;
        }
        if (loginWindow && !hook) {
            hook = SetWindowsHookExW(WH_CALLWNDPROC, hookFunction, module, GetWindowThreadProcessId(loginWindow, nullptr));
            if (hook) attached = loginWindow;
        }
        if (hook && attached) {
            DWORD_PTR ignored;
            SendMessageTimeoutW(attached, WM_APP + 0x3b7, 0x4b4b534b, 0, SMTO_ABORTIFHUNG | SMTO_BLOCK, 1000, &ignored);
        }
        if (WaitForSingleObject(process, 200) != WAIT_TIMEOUT) break;
    }
    if (hook) UnhookWindowsHookEx(hook);
    FreeLibrary(module); CloseHandle(lock); CloseHandle(process);
    return 0;
}
