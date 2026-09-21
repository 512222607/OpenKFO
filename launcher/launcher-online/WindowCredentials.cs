using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace KungFuLauncher;

internal sealed record WindowCredentials(string Account, string Password)
{
    // Distribution default, not an authentication secret. DPAPI binds saved keys to this Windows user.
    internal const string DefaultKey = "LS1KuGmfVgqfuRT2";
    private sealed record Envelope(int Version, byte[] WrappedKey, byte[] Nonce, byte[] Tag, byte[] Ciphertext);
    internal static bool ValidKey(string? key) => key is { Length: 16 } && key.All(c => c >= 33 && c <= 126);

    internal static WindowCredentials Load(string directory)
    {
        string path = Path.Combine(directory, "credentials.bin");
        if (!File.Exists(path)) return new("", "");
        byte[] stored = File.ReadAllBytes(path);
        byte[] plain;
        if (stored.Length > 0 && stored[0] == (byte)'{')
        {
            var envelope = JsonSerializer.Deserialize<Envelope>(stored) ?? throw new IOException("账号记录格式无效。");
            if (envelope.Version != 1) throw new IOException("账号记录版本不支持。");
            byte[] key = ProtectedData.Unprotect(envelope.WrappedKey, null, DataProtectionScope.CurrentUser);
            plain = new byte[envelope.Ciphertext.Length];
            try { using var aes = new AesGcm(key, 16); aes.Decrypt(envelope.Nonce, envelope.Ciphertext, envelope.Tag, plain); }
            catch { CryptographicOperations.ZeroMemory(plain); throw; }
            finally { CryptographicOperations.ZeroMemory(key); }
        }
        else plain = ProtectedData.Unprotect(stored, null, DataProtectionScope.CurrentUser); // Previous launcher format.
        try { return JsonSerializer.Deserialize<WindowCredentials>(plain) ?? throw new IOException("保存的账号数据无效。"); }
        finally { CryptographicOperations.ZeroMemory(plain); }
    }

    internal void Save(string directory, string? configuredKey = null)
    {
        Directory.CreateDirectory(directory);
        string path = Path.Combine(directory, "credentials.bin");
        if (Account.Length == 0 && Password.Length == 0) { File.Delete(path); return; }
        string selected = string.IsNullOrEmpty(configuredKey) ? DefaultKey : configuredKey;
        if (!ValidKey(selected)) throw new IOException("账号保存密钥必须为16位可打印ASCII字符。");
        byte[] plain = JsonSerializer.SerializeToUtf8Bytes(this), key = Encoding.ASCII.GetBytes(selected);
        try
        {
            byte[] nonce = RandomNumberGenerator.GetBytes(12), tag = new byte[16], encrypted = new byte[plain.Length];
            using (var aes = new AesGcm(key, 16)) aes.Encrypt(nonce, plain, encrypted, tag);
            var envelope = new Envelope(1, ProtectedData.Protect(key, null, DataProtectionScope.CurrentUser), nonce, tag, encrypted);
            string temporary = path + ".tmp";
            File.WriteAllBytes(temporary, JsonSerializer.SerializeToUtf8Bytes(envelope));
            File.Move(temporary, path, true);
        }
        finally { CryptographicOperations.ZeroMemory(plain); CryptographicOperations.ZeroMemory(key); }
    }

    internal static WindowCredentials LoadMigrating(string destination, string legacy, string key)
    {
        if (File.Exists(Path.Combine(destination, "credentials.bin"))) return Load(destination);
        var saved = Load(legacy);
        if (!File.Exists(Path.Combine(legacy, "credentials.bin"))) return saved;
        saved.Save(destination, key);
        if (Load(destination) != saved) throw new IOException("旧账号记录迁移校验失败。");
        File.Delete(Path.Combine(legacy, "credentials.bin"));
        return saved;
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
