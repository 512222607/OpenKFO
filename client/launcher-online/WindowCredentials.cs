using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace KungFuLauncher;

internal sealed record WindowCredentials(string Account, string Password)
{
    internal static WindowCredentials Load(string directory)
    {
        string path = Path.Combine(directory, "credentials.bin");
        if (!File.Exists(path)) return new("", "");
        byte[] plain = ProtectedData.Unprotect(File.ReadAllBytes(path), null, DataProtectionScope.CurrentUser);
        try { return JsonSerializer.Deserialize<WindowCredentials>(plain) ?? throw new IOException("保存的账号数据无效。"); }
        finally { CryptographicOperations.ZeroMemory(plain); }
    }

    internal void Save(string directory)
    {
        Directory.CreateDirectory(directory);
        string path = Path.Combine(directory, "credentials.bin");
        if (Account.Length == 0 && Password.Length == 0) { File.Delete(path); return; }
        byte[] plain = JsonSerializer.SerializeToUtf8Bytes(this);
        try
        {
            byte[] encrypted = ProtectedData.Protect(plain, null, DataProtectionScope.CurrentUser);
            string temporary = path + ".tmp";
            File.WriteAllBytes(temporary, encrypted);
            File.Move(temporary, path, true);
        }
        finally { CryptographicOperations.ZeroMemory(plain); }
    }

    internal async Task<bool> FillAsync(Process game)
    {
        if (Account.Length == 0 && Password.Length == 0) return false;
        return await Task.Run(async () =>
        {
            for (int attempt = 0; attempt < 60 && !game.HasExited; attempt++)
            {
                IntPtr login = IntPtr.Zero;
                EnumWindows((window, _) =>
                {
                    GetWindowThreadProcessId(window, out uint owner);
                    if (owner != game.Id || ClassName(window) != "GAMECLIENT") return true;
                    EnumChildWindows(window, (child, _) =>
                    {
                        if (ClassName(child) == "LoginChildWndClass") { login = child; return false; }
                        return true;
                    }, IntPtr.Zero);
                    return login == IntPtr.Zero;
                }, IntPtr.Zero);
                if (login != IntPtr.Zero && FillDialog(login)) return true;
                await Task.Delay(500);
            }
            return false;
        });
    }

    internal bool FillDialog(IntPtr login)
    {
        IntPtr account = GetDlgItem(login, 1001), password = GetDlgItem(login, 1002);
        if (ClassName(account) != "Edit" || ClassName(password) != "Edit" || (GetWindowLongW(password, -16) & 0x20) == 0) return false;
        return SetText(account, Account) && SetText(password, Password);
    }

    private static bool SetText(IntPtr window, string value) =>
        SendMessageTimeoutW(window, 0x000C, IntPtr.Zero, value, 0x0003, 1500, out var result) != IntPtr.Zero && result != IntPtr.Zero;
    private static string ClassName(IntPtr window) { var name = new StringBuilder(64); GetClassNameW(window, name, name.Capacity); return name.ToString(); }
    private delegate bool WindowCallback(IntPtr window, IntPtr parameter);
    [DllImport("user32.dll")] private static extern bool EnumWindows(WindowCallback callback, IntPtr parameter);
    [DllImport("user32.dll")] private static extern bool EnumChildWindows(IntPtr parent, WindowCallback callback, IntPtr parameter);
    [DllImport("user32.dll")] private static extern uint GetWindowThreadProcessId(IntPtr window, out uint processId);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] private static extern int GetClassNameW(IntPtr window, StringBuilder name, int length);
    [DllImport("user32.dll")] private static extern IntPtr GetDlgItem(IntPtr parent, int id);
    [DllImport("user32.dll")] private static extern int GetWindowLongW(IntPtr window, int index);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] private static extern IntPtr SendMessageTimeoutW(IntPtr window, uint message, IntPtr wparam, string value, uint flags, uint timeout, out IntPtr result);
}
