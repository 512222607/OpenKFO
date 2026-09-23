#pragma once
#include <windows.h>
#include <cstdlib>

namespace launcher_lifecycle {
inline constexpr wchar_t InstanceName[] = L"Local\\OpenKFO.FlutterLauncher.Instance";
inline constexpr wchar_t WindowProperty[] = L"OpenKFO.FlutterLauncher.MainWindow";
inline constexpr DWORD ShutdownGraceMs = 5000;
inline UINT ActivateMessage() {
  static const UINT message = RegisterWindowMessageW(L"OpenKFO.FlutterLauncher.Activate");
  return message;
}

struct WindowSearch { const wchar_t* property; HWND window = nullptr; };
inline BOOL CALLBACK FindWindow(HWND window, LPARAM context) {
  auto& search = *reinterpret_cast<WindowSearch*>(context);
  if (GetPropW(window, search.property)) {
    search.window = window;
    return FALSE;
  }
  return TRUE;
}

// Acquired before pending-update handling or starting Flutter/plugins.
class Instance {
 public:
  explicit Instance(const wchar_t* name = InstanceName, const wchar_t* property = WindowProperty)
      : name_(name), property_(property) {}
  ~Instance() { if (mutex_) CloseHandle(mutex_); }
  bool Acquire() {
    mutex_ = CreateMutexW(nullptr, TRUE, name_);
    if (!mutex_) {
      MessageBoxW(nullptr, L"无法创建启动器单实例锁。", L"启动器提示", MB_OK | MB_ICONERROR);
      return false;
    }
    if (GetLastError() != ERROR_ALREADY_EXISTS) return true;
    // An existing window may still be starting, or its owner may have crashed.
    for (int attempt = 0; attempt < 50; ++attempt) {
      DWORD result = WaitForSingleObject(mutex_, 0);
      if (result == WAIT_OBJECT_0 || result == WAIT_ABANDONED) return true;
      WindowSearch search{property_};
      EnumWindows(FindWindow, reinterpret_cast<LPARAM>(&search));
      if (search.window) {
        DWORD process = 0; GetWindowThreadProcessId(search.window, &process);
        AllowSetForegroundWindow(process);
        DWORD_PTR ignored;
        if (SendMessageTimeoutW(search.window, ActivateMessage(), 0, 0,
            SMTO_ABORTIFHUNG | SMTO_BLOCK, 1000, &ignored)) return false;
      }
      Sleep(100);
    }
    MessageBoxW(nullptr, L"启动器正在启动或退出，请稍后再试。", L"启动器提示", MB_OK | MB_ICONINFORMATION);
    return false;
  }
 private:
  HANDLE mutex_ = nullptr;
  const wchar_t* name_;
  const wchar_t* property_;
};

inline DWORD WINAPI ShutdownDeadline(void*) {
  Sleep(ShutdownGraceMs);
  OutputDebugStringW(L"OpenKFO: launcher shutdown exceeded grace period; terminating this process only.\n");
  TerminateProcess(GetCurrentProcess(), EXIT_SUCCESS);
  return 0;
}

// Only arm after WM_DESTROY: the window is irreversibly closing. Engine/plugin
// cleanup gets a grace period; a stuck destructor cannot retain update files.
inline void BeginShutdown() {
  HANDLE thread = CreateThread(nullptr, 0, ShutdownDeadline, nullptr, 0, nullptr);
  if (thread) CloseHandle(thread);
}
}  // namespace launcher_lifecycle
