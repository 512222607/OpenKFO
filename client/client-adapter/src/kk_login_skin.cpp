// Presentation only: preserve the original login controls, IDs and window
// procedure. Never read, store, send or replace account/password contents.
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <commctrl.h>
#include <cwchar>

static const UINT SkinMessage = WM_APP + 0x3b7;
static const UINT_PTR SkinId = 0x4b4b534b;
static HBRUSH panelBrush, fieldBrush;
static HFONT headingFont, titleFont, textFont, smallFont, emblemFont;
static const COLORREF Panel = RGB(23, 32, 47), Field = RGB(36, 48, 66);
static const COLORREF Ink = RGB(239, 234, 219), Muted = RGB(157, 169, 185);
static const COLORREF Gold = RGB(229, 186, 103);

static HFONT font(int height, int weight) {
    return CreateFontW(-height, 0, 0, 0, weight, FALSE, FALSE, FALSE,
        DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
        CLEARTYPE_QUALITY, DEFAULT_PITCH, L"Microsoft YaHei UI");
}
static void resources() {
    if (panelBrush) return;
    panelBrush = CreateSolidBrush(Panel); fieldBrush = CreateSolidBrush(Field);
    headingFont = font(32, FW_BOLD); titleFont = font(25, FW_BOLD);
    textFont = font(17, FW_NORMAL); smallFont = font(13, FW_NORMAL);
    emblemFont = font(80, FW_BOLD);
}
static void text(HDC dc, const wchar_t* value, RECT rect, HFONT type, COLORREF color, UINT flags = DT_LEFT | DT_VCENTER | DT_SINGLELINE) {
    auto previous = SelectObject(dc, type); SetBkMode(dc, TRANSPARENT);
    SetTextColor(dc, color); DrawTextW(dc, value, -1, &rect, flags); SelectObject(dc, previous);
}
static void fill(HDC dc, RECT rect, COLORREF color) {
    HBRUSH brush = CreateSolidBrush(color); FillRect(dc, &rect, brush); DeleteObject(brush);
}
static void paint(HWND window, HDC dc) {
    RECT client; GetClientRect(window, &client); FillRect(dc, &client, panelBrush);
    fill(dc, {0, 0, 208, 420}, RGB(15, 23, 36));
    fill(dc, {28, 31, 65, 34}, Gold);
    text(dc, L"功夫小子", {27, 49, 204, 97}, headingFont, Ink);
    text(dc, L"一招一式，再战江湖", {28, 103, 200, 132}, smallFont, Muted);
    HPEN pen = CreatePen(PS_SOLID, 1, RGB(104, 89, 66));
    auto oldPen = SelectObject(dc, pen); auto oldBrush = SelectObject(dc, GetStockObject(NULL_BRUSH));
    Ellipse(dc, 36, 179, 174, 317); Ellipse(dc, 43, 186, 167, 310);
    SelectObject(dc, oldBrush); SelectObject(dc, oldPen); DeleteObject(pen);
    text(dc, L"武", {36, 179, 174, 312}, emblemFont, Gold, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
    text(dc, L"登录，即刻开战", {28, 357, 200, 388}, smallFont, Muted);
    text(dc, L"账号登录", {246, 37, 575, 77}, titleFont, Ink);
    text(dc, L"欢迎回来", {247, 78, 575, 101}, smallFont, Muted);
    text(dc, L"账号", {247, 108, 575, 130}, smallFont, Muted);
    text(dc, L"密码", {247, 188, 575, 210}, smallFont, Muted);
    fill(dc, {244, 134, 578, 176}, Field); fill(dc, {244, 214, 578, 256}, Field);
    text(dc, L"请使用自己的账号登录", {246, 376, 578, 398}, smallFont, Muted, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}
static LRESULT CALLBACK editProcedure(HWND window, UINT message, WPARAM wparam, LPARAM lparam, UINT_PTR, DWORD_PTR) {
    if (message == WM_KEYDOWN && (wparam == VK_RETURN || wparam == VK_TAB)) {
        HWND parent = GetParent(window);
        if (wparam == VK_RETURN) {
            HWND login = GetDlgItem(parent, 1003);
            if (IsWindowEnabled(login)) PostMessageW(parent, WM_COMMAND, MAKEWPARAM(1003, BN_CLICKED), (LPARAM)login);
        } else {
            HWND next = GetNextDlgTabItem(parent, window, GetKeyState(VK_SHIFT) < 0);
            if (next) SetFocus(next);
        }
        return 0;
    }
    if (message == WM_CHAR && (wparam == VK_RETURN || wparam == VK_TAB)) return 0;
    if (message == WM_NCDESTROY) RemoveWindowSubclass(window, editProcedure, SkinId);
    return DefSubclassProc(window, message, wparam, lparam);
}
static LRESULT CALLBACK updateProcedure(HWND window, UINT message, WPARAM wparam, LPARAM lparam) {
    if (message == WM_SIZE) { MoveWindow(GetDlgItem(window, 1), 14, 14, LOWORD(lparam) - 28, HIWORD(lparam) - 28, TRUE); return 0; }
    return DefWindowProcW(window, message, wparam, lparam);
}
static void showUpdates(HWND owner, const wchar_t* text) {
    auto instance = GetModuleHandleW(nullptr);
    WNDCLASSW type = {}; type.hInstance = instance; type.lpfnWndProc = updateProcedure;
    type.lpszClassName = L"OpenKFOWeaponUpdates"; type.hCursor = LoadCursorW(nullptr, MAKEINTRESOURCEW(32512));
    type.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1); RegisterClassW(&type);
    HWND window = CreateWindowExW(WS_EX_TOOLWINDOW, type.lpszClassName, L"武器更新内容",
        WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 680, 480, owner, nullptr, instance, nullptr);
    HWND content = CreateWindowExW(WS_EX_CLIENTEDGE, L"EDIT", text,
        WS_CHILD | WS_VISIBLE | WS_VSCROLL | ES_MULTILINE | ES_READONLY | ES_AUTOVSCROLL,
        14, 14, 630, 400, window, (HMENU)1, instance, nullptr);
    SendMessageW(content, WM_SETFONT, (WPARAM)textFont, TRUE);
    RECT rect; GetClientRect(window, &rect); MoveWindow(content, 14, 14, rect.right - 28, rect.bottom - 28, TRUE);
    ShowWindow(window, SW_SHOW); SetForegroundWindow(window);
}
static LRESULT CALLBACK loginProcedure(HWND window, UINT message, WPARAM wparam, LPARAM lparam, UINT_PTR, DWORD_PTR) {
    if (message == WM_COMMAND && LOWORD(wparam) == 0x4b55) {
        wchar_t path[32768]; GetModuleFileNameW(nullptr, path, 32768);
        wchar_t* end = wcsrchr(path, L'\\'); if (end) wcscpy_s(end + 1, 32768 - (end + 1 - path), L"weapon-update-notes.txt");
        HANDLE file = CreateFileW(path, GENERIC_READ, FILE_SHARE_READ, nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
        wchar_t text[32769] = L"当前客户端没有武器更新说明。";
        if (file != INVALID_HANDLE_VALUE) {
            char bytes[32768]; DWORD length = 0;
            if (ReadFile(file, bytes, sizeof(bytes), &length, nullptr) && length) {
                int count = MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, bytes, (int)length, text, 32768);
                if (count > 0) text[count] = 0;
            }
            CloseHandle(file);
        }
        showUpdates(window, text); return 0;
    }
    if (message == WM_ERASEBKGND) return 1;
    if (message == WM_PAINT) {
        PAINTSTRUCT state; HDC dc = BeginPaint(window, &state); paint(window, dc); EndPaint(window, &state); return 0;
    }
    if (message == WM_PRINTCLIENT) { paint(window, (HDC)wparam); return 0; }
    if (message == WM_CTLCOLOREDIT) {
        SetBkColor((HDC)wparam, Field); SetTextColor((HDC)wparam, Ink); return (LRESULT)fieldBrush;
    }
    if (message == WM_DRAWITEM && (wparam == 1003 || wparam == 1004)) {
        auto item = (DRAWITEMSTRUCT*)lparam;
        bool primary = wparam == 1003, down = (item->itemState & ODS_SELECTED) != 0;
        fill(item->hDC, item->rcItem, primary ? (down ? RGB(198, 151, 73) : Gold) : Panel);
        text(item->hDC, primary ? L"登 录 游 戏" : L"返回", item->rcItem, textFont,
            (item->itemState & ODS_DISABLED) ? Muted : (primary ? RGB(28, 30, 35) : Muted), DT_CENTER | DT_VCENTER | DT_SINGLELINE);
        if (item->itemState & ODS_FOCUS) { RECT focus = item->rcItem; InflateRect(&focus, -4, -4); DrawFocusRect(item->hDC, &focus); }
        return TRUE;
    }
    if (message == WM_SHOWWINDOW && wparam) {
        RECT parent; GetClientRect(GetParent(window), &parent);
        SetWindowPos(window, HWND_TOP, (parent.right - 620) / 2, (parent.bottom - 420) / 2, 620, 420, SWP_NOACTIVATE);
    }
    if (message == WM_NCDESTROY) RemoveWindowSubclass(window, loginProcedure, SkinId);
    return DefSubclassProc(window, message, wparam, lparam);
}

extern "C" __declspec(dllexport) BOOL __stdcall SkinLoginWindow(HWND window) {
    DWORD_PTR installed = 0;
    if (GetWindowSubclass(window, loginProcedure, SkinId, &installed)) return TRUE;
    HWND account = GetDlgItem(window, 1001), password = GetDlgItem(window, 1002);
    HWND login = GetDlgItem(window, 1003), cancel = GetDlgItem(window, 1004);
    if (!account || !password || !login || !cancel) return FALSE;
    // Only the verified native password edit is styled; retain ES_PASSWORD.
    if (!(GetWindowLongW(password, GWL_STYLE) & ES_PASSWORD)) return FALSE;
    resources();
    if (!SetWindowSubclass(window, loginProcedure, SkinId, 0)) return FALSE;
    // Pin the callback module for the native window's lifetime, including
    // after the launcher helper has been closed.
    HMODULE pinned;
    GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_PIN,
        (LPCWSTR)&SkinLoginWindow, &pinned);
    for (HWND child = GetWindow(window, GW_CHILD); child; child = GetWindow(child, GW_HWNDNEXT)) {
        wchar_t className[32]; GetClassNameW(child, className, 32);
        if (!_wcsicmp(className, L"Static")) ShowWindow(child, SW_HIDE);
    }
    SetWindowLongW(window, GWL_STYLE, (GetWindowLongW(window, GWL_STYLE) & ~(WS_CAPTION | WS_BORDER | WS_THICKFRAME)) | WS_CLIPCHILDREN);
    SetWindowLongW(window, GWL_EXSTYLE, GetWindowLongW(window, GWL_EXSTYLE) & ~(WS_EX_CLIENTEDGE | WS_EX_DLGMODALFRAME));
    RECT parent; GetClientRect(GetParent(window), &parent);
    SetWindowPos(window, nullptr, (parent.right - 620) / 2, (parent.bottom - 420) / 2, 620, 420, SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
    HWND edits[] = { account, password };
    for (int index = 0; index < 2; ++index) {
        HWND edit = edits[index];
        SetWindowLongW(edit, GWL_STYLE, (GetWindowLongW(edit, GWL_STYLE) & ~WS_BORDER) | WS_TABSTOP);
        SetWindowLongW(edit, GWL_EXSTYLE, GetWindowLongW(edit, GWL_EXSTYLE) & ~WS_EX_CLIENTEDGE);
        SetWindowPos(edit, nullptr, 255, 143 + index * 80, 310, 26, SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
        SendMessageW(edit, WM_SETFONT, (WPARAM)textFont, TRUE);
        SetWindowSubclass(edit, editProcedure, SkinId, 0);
    }
    HWND buttons[] = { login, cancel };
    for (int index = 0; index < 2; ++index) {
        SetWindowLongW(buttons[index], GWL_STYLE, (GetWindowLongW(buttons[index], GWL_STYLE) & ~BS_TYPEMASK) | BS_OWNERDRAW | WS_TABSTOP);
        SetWindowPos(buttons[index], nullptr, 244, 281 + index * 52, 334, index ? 30 : 44, SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
    }
    SetWindowTextW(login, L"登录游戏"); SetWindowTextW(cancel, L"返回");
    HWND updates = CreateWindowExW(0, L"BUTTON", L"武器更新内容", WS_CHILD | WS_VISIBLE | WS_TABSTOP,
        245, 379, 334, 28, window, (HMENU)0x4b55, GetModuleHandleW(nullptr), nullptr);
    SendMessageW(updates, WM_SETFONT, (WPARAM)textFont, TRUE);
    RedrawWindow(window, nullptr, nullptr, RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_FRAME);
    return TRUE;
}
static BOOL CALLBACK findLogin(HWND window, LPARAM) {
    wchar_t className[64]; GetClassNameW(window, className, 64);
    if (!wcscmp(className, L"LoginChildWndClass")) SkinLoginWindow(window);
    return TRUE;
}
extern "C" __declspec(dllexport) LRESULT CALLBACK LoginSkinHook(int code, WPARAM wparam, LPARAM lparam) {
    if (code >= 0) {
        auto message = (CWPSTRUCT*)lparam;
        if (message->message == SkinMessage && message->wParam == SkinId) findLogin(message->hwnd, 0);
    }
    return CallNextHookEx(nullptr, code, wparam, lparam);
}
BOOL WINAPI DllMain(HINSTANCE, DWORD, LPVOID) { return TRUE; }
