// Standalone Windows integration test; uses separate locks/windows from the app.
#include "launcher_lifecycle.h"
#include <string>
#include <cstdio>

static std::wstring property;
static HANDLE activated;
static bool hang;
static LRESULT CALLBACK Procedure(HWND window, UINT message, WPARAM w, LPARAM l) {
  if (message == launcher_lifecycle::ActivateMessage()) { SetEvent(activated); return 0; }
  if (message == WM_DESTROY) {
    RemovePropW(window, property.c_str());
    launcher_lifecycle::BeginShutdown();
    if (hang) Sleep(INFINITE); // Simulate engine destruction deadlock.
    PostQuitMessage(0);
    return 0;
  }
  return DefWindowProcW(window, message, w, l);
}
static PROCESS_INFORMATION Start(const std::wstring& base, const wchar_t* mode) {
  wchar_t image[32768]; GetModuleFileNameW(nullptr, image, 32768);
  std::wstring command = L"\"" + std::wstring(image) + L"\" " + base + L" " + mode;
  STARTUPINFOW startup{}; startup.cb = sizeof(startup);
  PROCESS_INFORMATION process{};
  if (!CreateProcessW(image, command.data(), nullptr, nullptr, FALSE, CREATE_NO_WINDOW,
      nullptr, nullptr, &startup, &process)) ExitProcess(20);
  CloseHandle(process.hThread);
  return process;
}
int wmain(int argc, wchar_t** argv) {
  if (argc == 3) {
    const std::wstring base = argv[1]; property = base + L"Window";
    launcher_lifecycle::Instance instance(base.c_str(), property.c_str());
    if (!instance.Acquire()) return 10;
    hang = !wcscmp(argv[2], L"hang");
    activated = OpenEventW(EVENT_MODIFY_STATE, FALSE, (base + L"Active").c_str());
    WNDCLASSW type{}; type.hInstance = GetModuleHandleW(nullptr);
    type.lpfnWndProc = Procedure; type.lpszClassName = L"OpenKFOLifecycleTest";
    RegisterClassW(&type);
    HWND window = CreateWindowW(type.lpszClassName, L"Lifecycle fixture", WS_OVERLAPPEDWINDOW,
        0, 0, 200, 100, nullptr, nullptr, type.hInstance, nullptr);
    if (!window) return 21;
    SetPropW(window, property.c_str(), reinterpret_cast<HANDLE>(1));
    HANDLE ready = OpenEventW(EVENT_MODIFY_STATE, FALSE, (base + L"Ready").c_str());
    SetEvent(ready); CloseHandle(ready);
    MSG message{};
    while (GetMessageW(&message, nullptr, 0, 0) > 0) DispatchMessageW(&message);
    CloseHandle(activated);
    return 0;
  }
  const std::wstring base = L"Local\\OpenKFO.LifecycleTest." + std::to_wstring(GetCurrentProcessId());
  const auto prop = base + L"Window";
  HANDLE ready = CreateEventW(nullptr, TRUE, FALSE, (base + L"Ready").c_str());
  HANDLE active = CreateEventW(nullptr, TRUE, FALSE, (base + L"Active").c_str());
  for (const auto mode : {L"normal", L"hang", L"normal"}) {
    ResetEvent(ready); ResetEvent(active);
    auto owner = Start(base, mode);
    if (WaitForSingleObject(ready, 5000) != WAIT_OBJECT_0) return 1;
    auto duplicate = Start(base, mode);
    if (WaitForSingleObject(duplicate.hProcess, 5000) != WAIT_OBJECT_0) return 2;
    DWORD code; GetExitCodeProcess(duplicate.hProcess, &code); CloseHandle(duplicate.hProcess);
    if (code != 10 || WaitForSingleObject(active, 1000) != WAIT_OBJECT_0) return 3;
    launcher_lifecycle::WindowSearch search{prop.c_str()};
    EnumWindows(launcher_lifecycle::FindWindow, reinterpret_cast<LPARAM>(&search));
    if (!search.window) return 4;
    PostMessageW(search.window, WM_CLOSE, 0, 0);
    if (WaitForSingleObject(owner.hProcess, 7000) != WAIT_OBJECT_0) return 5;
    GetExitCodeProcess(owner.hProcess, &code); CloseHandle(owner.hProcess);
    if (code != 0) return 6;
  }
  CloseHandle(ready); CloseHandle(active);
  puts("PASS: duplicate activates owner; normal close exits; stuck cleanup exits; next launch reacquires lock");
  return 0;
}
