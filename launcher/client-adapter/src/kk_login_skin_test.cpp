#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <commctrl.h>
#include <cstdio>
#include <cwchar>

static int loginClicks;
static LRESULT CALLBACK windowProcedure(HWND window, UINT message, WPARAM wparam, LPARAM lparam) {
    if (message == WM_COMMAND && LOWORD(wparam) == 1003 && HIWORD(wparam) == BN_CLICKED) ++loginClicks;
    return DefWindowProcW(window, message, wparam, lparam);
}
static bool savePreview(HWND window, const wchar_t* path) {
    RECT rect; GetClientRect(window, &rect);
    HDC source = GetDC(window), target = CreateCompatibleDC(source);
    BITMAPINFO info = {}; info.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    info.bmiHeader.biWidth = rect.right; info.bmiHeader.biHeight = -rect.bottom;
    info.bmiHeader.biPlanes = 1; info.bmiHeader.biBitCount = 32;
    void* pixels; HBITMAP bitmap = CreateDIBSection(source, &info, DIB_RGB_COLORS, &pixels, nullptr, 0);
    if (!bitmap) return false;
    auto previous = SelectObject(target, bitmap);
    SendMessageW(window, WM_PRINT, (WPARAM)target, PRF_CLIENT | PRF_CHILDREN | PRF_ERASEBKGND);
    GdiFlush();
    BITMAPFILEHEADER header = {}; header.bfType = 0x4d42;
    header.bfOffBits = sizeof(header) + sizeof(BITMAPINFOHEADER);
    DWORD length = rect.right * rect.bottom * 4; header.bfSize = header.bfOffBits + length;
    FILE* file = nullptr; _wfopen_s(&file, path, L"wb");
    bool ok = file && fwrite(&header, sizeof(header), 1, file) == 1 && fwrite(&info.bmiHeader, sizeof(info.bmiHeader), 1, file) == 1 && fwrite(pixels, length, 1, file) == 1;
    if (file) fclose(file);
    SelectObject(target, previous); DeleteObject(bitmap); DeleteDC(target); ReleaseDC(window, source);
    return ok;
}
int wmain(int count, wchar_t** args) {
    if (count != 3 && count != 4) return 1;
    INITCOMMONCONTROLSEX common = {sizeof(common), ICC_STANDARD_CLASSES}; InitCommonControlsEx(&common);
    auto instance = GetModuleHandleW(nullptr);
    WNDCLASSW type = {}; type.hInstance = instance; type.lpfnWndProc = windowProcedure; type.lpszClassName = L"GAMECLIENT";
    RegisterClassW(&type);
    HWND parent = CreateWindowW(type.lpszClassName, L"Login skin test", WS_OVERLAPPEDWINDOW, 0, 0, 900, 650, nullptr, nullptr, instance, nullptr);
    type.lpszClassName = L"LoginChildWndClass"; RegisterClassW(&type);
    HWND dialog = CreateWindowW(type.lpszClassName, L"登录", WS_CHILD | WS_VISIBLE | WS_CAPTION, 0, 0, 280, 180, parent, nullptr, instance, nullptr);
    HWND account = CreateWindowW(L"EDIT", L"test-only", WS_CHILD | WS_VISIBLE | WS_TABSTOP, 0, 0, 100, 25, dialog, (HMENU)1001, instance, nullptr);
    HWND password = CreateWindowW(L"EDIT", L"fixture-only", WS_CHILD | WS_VISIBLE | WS_TABSTOP | ES_PASSWORD, 0, 30, 100, 25, dialog, (HMENU)1002, instance, nullptr);
    HWND login = CreateWindowW(L"BUTTON", L"登录", WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON, 0, 60, 100, 25, dialog, (HMENU)1003, instance, nullptr);
    CreateWindowW(L"BUTTON", L"取消", WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON, 0, 90, 100, 25, dialog, (HMENU)1004, instance, nullptr);
    HMODULE module = LoadLibraryW(args[1]);
    auto install = module ? (BOOL(__stdcall*)(HWND))GetProcAddress(module, "_SkinLoginWindow@4") : nullptr;
    if (!install) return 2;
    PROCESS_INFORMATION host = {};
    if (count == 4) {
        wchar_t image[32768], command[32768]; GetModuleFileNameW(nullptr, image, 32768);
        swprintf_s(command, L"\"%s\" %lu \"%s\" \"%s\"", args[3], GetCurrentProcessId(), image, args[1]);
        STARTUPINFOW startup = {}; startup.cb = sizeof(startup);
        if (!CreateProcessW(nullptr, command, nullptr, nullptr, FALSE, CREATE_NO_WINDOW, nullptr, nullptr, &startup, &host)) return 9;
        for (int attempt = 0; attempt < 100; ++attempt) {
            MSG event; while (PeekMessageW(&event, nullptr, 0, 0, PM_REMOVE)) { TranslateMessage(&event); DispatchMessageW(&event); }
            RECT bounds; GetClientRect(dialog, &bounds); if (bounds.right == 620) break;
            if (WaitForSingleObject(host.hProcess, 50) == WAIT_OBJECT_0) { DWORD code; GetExitCodeProcess(host.hProcess, &code); printf("Host exited: %lu\n", code); return 10; }
        }
        RECT applied; GetClientRect(dialog, &applied); if (applied.right != 620) return 11;
    } else if (!install(dialog)) return 2;
    if (!install(dialog)) return 2;
    RECT rect; GetClientRect(dialog, &rect);
    if (rect.right != 620 || rect.bottom != 420 || !(GetWindowLongW(password, GWL_STYLE) & ES_PASSWORD)) return 3;
    if (GetDlgItem(dialog, 1001) != account || GetDlgItem(dialog, 1002) != password || GetDlgItem(dialog, 1003) != login) return 4;
    wchar_t value[64]; GetWindowTextW(password, value, 64);
    if (wcscmp(value, L"fixture-only")) return 5;
    SecureZeroMemory(value, sizeof(value));
    SendMessageW(account, WM_KEYDOWN, VK_RETURN, 0);
    MSG message;
    while (PeekMessageW(&message, nullptr, 0, 0, PM_REMOVE)) { TranslateMessage(&message); DispatchMessageW(&message); }
    if (loginClicks != 1) return 6;
    if (GetDlgItem(dialog, 0x4b55)) return 8; // Updates belong to the launcher.
    // Preview contains no account examples or password values.
    SetWindowTextW(account, L""); SetWindowTextW(password, L"");
    if (!savePreview(dialog, args[2])) return 7;
    DestroyWindow(parent);
    if (host.hProcess) { CloseHandle(host.hThread); CloseHandle(host.hProcess); }
    puts("PASS: original controls retained, password masking and value preserved, Enter delivered once, idempotent styling, preview saved");
    return 0;
}
