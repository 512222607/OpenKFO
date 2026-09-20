using System.IO.Compression;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.Json.Serialization;

namespace OpenKFO.Updater;
internal sealed record Manifest(
 [property: JsonPropertyName("kind")] string Kind,
 [property: JsonPropertyName("version")] string Version,
 [property: JsonPropertyName("notes")] string Notes,
 [property: JsonPropertyName("sha256")] string SHA256,
 [property: JsonPropertyName("size")] long Size,
 [property: JsonPropertyName("package")] string Package,
 [property: JsonPropertyName("config_hash")] string? ConfigHash,
 [property: JsonPropertyName("executable_hash")] string? ExecutableHash = null);

internal static class UpdateEngine
{
    internal static string Hash(byte[] data) => Convert.ToHexString(SHA256.HashData(data)).ToLowerInvariant();
    internal static bool ValidHash(string? text) => text is { Length: 64 } && text.All(c => c is >= '0' and <= '9' or >= 'a' and <= 'f');
    internal static void Validate(Manifest m, string kind)
    {
        if (m.Kind != kind || (kind != "gm" && kind != "weapons" && kind != "client" && kind != "launcher") || !ValidHash(m.SHA256) || m.Package != m.SHA256 + ".zip" || m.Size < 1 || m.Size > 256 * 1024 * 1024 || string.IsNullOrWhiteSpace(m.Version) || m.Version.Length > 100 || string.IsNullOrWhiteSpace(m.Notes) || m.Notes.Length > 16384 || (kind == "client" || kind == "weapons") && !ValidHash(m.ConfigHash) || kind == "launcher" && !ValidHash(m.ExecutableHash)) throw new InvalidDataException("更新清单无效。");
    }
    internal static bool Current(Manifest m, string target, string? launcher = null)
    {
        if (m.Kind == "launcher") return launcher != null && File.Exists(launcher) && Hash(File.ReadAllBytes(launcher)) == m.ExecutableHash;
        if (m.Kind == "client")
        {
            string receipt = Path.Combine(target, "client-installed.json"), hashes = Path.Combine(target, "client-files.json");
            if (!File.Exists(receipt) || !File.Exists(hashes) || JsonSerializer.Deserialize<Manifest>(File.ReadAllText(receipt))?.SHA256 != m.SHA256) return false;
            var files = JsonSerializer.Deserialize<Dictionary<string, string>>(File.ReadAllText(hashes));
            return files is { Count: > 0 } && files.All(p => AllowedClientFile(p.Key) && File.Exists(Path.Combine(target, p.Key)) && Hash(File.ReadAllBytes(Path.Combine(target, p.Key))) == p.Value);
        }
        var path = Path.Combine(target, m.Kind == "weapons" ? "Data/config.spf2" : "gm-installed.json");
        if (!File.Exists(path)) return false;
        if (m.Kind == "weapons")
        {
            var installed = Path.Combine(target, "weapons-installed.json");
            return Hash(File.ReadAllBytes(path)) == m.ConfigHash && File.Exists(installed)
                && JsonSerializer.Deserialize<Manifest>(File.ReadAllText(installed))?.Version == m.Version;
        }
        return JsonSerializer.Deserialize<Manifest>(File.ReadAllText(path))?.SHA256 == m.SHA256;
    }
    internal static Uri SecureUri(string text) { var uri = new Uri(text); if (uri.Scheme != "https" || uri.UserInfo != "") throw new InvalidDataException("更新地址必须使用 HTTPS。"); return uri; }
    internal static async Task<byte[]> Download(HttpClient http, Uri uri, long maximum, Action<string> progress)
    {
        using var response = await http.GetAsync(uri, HttpCompletionOption.ResponseHeadersRead); response.EnsureSuccessStatusCode();
        if (response.Content.Headers.ContentLength > maximum) throw new InvalidDataException("更新文件过大。");
        using var input = await response.Content.ReadAsStreamAsync(); using var output = new MemoryStream(); byte[] buffer = new byte[65536]; int count;
        using var timeout = new CancellationTokenSource(TimeSpan.FromMinutes(10));
        while ((count = await input.ReadAsync(buffer, timeout.Token)) > 0) { if (output.Length + count > maximum) throw new InvalidDataException("更新文件超过清单长度。"); output.Write(buffer, 0, count); progress($"已下载 {output.Length / 1024:N0} KB"); }
        return output.ToArray();
    }
    internal static Dictionary<string, byte[]> Unpack(Manifest m, byte[] bytes)
    {
        if (bytes.LongLength != m.Size || Hash(bytes) != m.SHA256) throw new InvalidDataException("下载文件校验失败，未修改现有文件。");
        using var zip = new ZipArchive(new MemoryStream(bytes)); var files = new Dictionary<string, byte[]>(StringComparer.OrdinalIgnoreCase); long size = 0;
        foreach (var e in zip.Entries)
        {
            var name = e.FullName; if (name.EndsWith('/')) continue;
            if (name.Contains('\\') || name.Contains(':') || name.StartsWith('/') || name.Contains("..") || files.ContainsKey(name) || ((e.ExternalAttributes >> 16) & 0xF000) == 0xA000) throw new InvalidDataException("更新包路径无效。");
            bool allowed = m.Kind == "launcher" ? name == "launcher.exe" : m.Kind == "client" ? AllowedClientFile(name) : m.Kind == "weapons" ? name == "Data/config.spf2" : name == "OpenKFO.Updater.exe" || name == "GM管理器.exe" || name == "kungfu-desktop-admin.exe" || name.EndsWith(".dll", StringComparison.OrdinalIgnoreCase) && !name.Contains('/') || name.StartsWith("data/", StringComparison.Ordinal);
            if (!allowed || e.Length < 0 || (size += e.Length) > 512L * 1024 * 1024) throw new InvalidDataException("更新包包含不允许替换的文件。");
            using var input = e.Open(); using var output = new MemoryStream(); byte[] buffer = new byte[65536]; int n; while ((n = input.Read(buffer)) > 0) { if (output.Length + n > e.Length) throw new InvalidDataException("解压长度异常。"); output.Write(buffer, 0, n); }
            files.Add(name, output.ToArray());
        }
        if (m.Kind == "weapons" && (files.Count != 1 || !files.TryGetValue("Data/config.spf2", out var config) || Hash(config) != m.ConfigHash)) throw new InvalidDataException("武器配置校验失败。");
        if (m.Kind == "client" && (!files.TryGetValue("Data/config.spf2", out var clientConfig) || Hash(clientConfig) != m.ConfigHash)) throw new InvalidDataException("客户端配置校验失败。");
        if (m.Kind == "launcher" && (files.Count != 1 || !files.TryGetValue("launcher.exe", out var executable) || Hash(executable) != m.ExecutableHash)) throw new InvalidDataException("登录器校验失败。");
        if (m.Kind == "gm" && new[] { "GM管理器.exe", "kungfu-desktop-admin.exe", "flutter_windows.dll", "data/icudtl.dat" }.Any(n => !files.ContainsKey(n))) throw new InvalidDataException("GM 运行文件不完整。");
        return files;
    }
    internal static bool AllowedClientFile(string name) => !name.Contains("..") && !name.Contains('\\') && !name.Contains(':') && !name.Split('/').Any(p => p.Length == 0 || p.EndsWith('.') || p.EndsWith(' '))
        && (new[] { "Data/", "effect/", "GPK/", "HostWidgets/", "SDO/", "spdata/", "UI/", "Weapon/" }.Any(p => name.StartsWith(p, StringComparison.Ordinal))
            || !name.Contains('/') && name.EndsWith(".dll", StringComparison.OrdinalIgnoreCase));
    // Each changed file is backed up before replacement. A durable journal also
    // allows recovery after power loss, before attempting a later update.
    internal static void Apply(Manifest m, Dictionary<string, byte[]> files, string target, string? bridge, Action<int>? afterWrite = null, string? launcher = null)
    {
        target = Path.GetFullPath(target); string state = StateDirectory(target, m.Kind);
        Recover(target, m.Kind); Directory.CreateDirectory(state);
        var writes = files.ToDictionary(p => Path.GetFullPath(p.Key, target), p => p.Value, StringComparer.OrdinalIgnoreCase);
        if (m.Kind == "launcher")
        {
            if (launcher == null || !string.Equals(Path.GetDirectoryName(Path.GetFullPath(launcher)), target, StringComparison.OrdinalIgnoreCase) || !launcher.EndsWith(".exe", StringComparison.OrdinalIgnoreCase)) throw new InvalidDataException("登录器目标路径不正确。");
            writes.Clear(); writes[Path.GetFullPath(launcher)] = files["launcher.exe"];
        }
        if (m.Kind == "client" || m.Kind == "weapons")
        {
            if (bridge == null) throw new InvalidDataException("缺少登录器配置路径。");
            var config = JsonNode.Parse(File.ReadAllText(bridge))!.AsObject(); config["config_hash"] = m.ConfigHash;
            writes[Path.GetFullPath(bridge)] = Encoding.UTF8.GetBytes(config.ToJsonString(new JsonSerializerOptions { WriteIndented = true }));
            writes[Path.Combine(target, "client-update-notes.txt")] = Encoding.UTF8.GetBytes(m.Version + "\r\n\r\n" + m.Notes);
        }
        if (m.Kind == "client") writes[Path.Combine(target, "client-files.json")] = JsonSerializer.SerializeToUtf8Bytes(files.ToDictionary(p => p.Key, p => Hash(p.Value)));
        writes[Path.Combine(target, m.Kind + "-installed.json")] = JsonSerializer.SerializeToUtf8Bytes(m);
        var journal = new List<Backup>(); int index = 0;
        foreach (var p in writes) { AssertNoLinks(p.Key); var backup = Path.Combine(state, index++.ToString()); bool exists = File.Exists(p.Key); if (exists) File.Copy(p.Key, backup, true); journal.Add(new(p.Key, backup, exists)); }
        File.WriteAllText(Path.Combine(state, "journal.json"), JsonSerializer.Serialize(journal));
        try { index = 0; foreach (var p in writes) { Directory.CreateDirectory(Path.GetDirectoryName(p.Key)!); Atomic(p.Key, p.Value); afterWrite?.Invoke(++index); } File.Delete(Path.Combine(state, "journal.json")); }
        catch { Recover(target, m.Kind); throw; }
    }
    private sealed record Backup(string Path, string Copy, bool Existed);
    internal static void AssertNoLinks(string path) { for (string? p = path; p != null; p = Path.GetDirectoryName(p)) if ((File.Exists(p) || Directory.Exists(p)) && (File.GetAttributes(p) & FileAttributes.ReparsePoint) != 0) throw new IOException("更新目标不能经过目录链接。"); }
    internal static void Atomic(string path, byte[] bytes) { var temp = path + ".update-next"; File.WriteAllBytes(temp, bytes); File.Move(temp, path, true); }
    internal static string StateDirectory(string target, string kind) => Path.Combine(target, kind == "launcher" ? ".openkfo-launcher-update" : ".openkfo-update");
    internal static void Recover(string target, string kind = "client")
    {
        var state = StateDirectory(target, kind); var journal = Path.Combine(state, "journal.json"); if (!File.Exists(journal)) return;
        foreach (var item in JsonSerializer.Deserialize<List<Backup>>(File.ReadAllText(journal))!) { AssertNoLinks(item.Path); if (item.Existed) Atomic(item.Path, File.ReadAllBytes(item.Copy)); else File.Delete(item.Path); }
        File.Delete(journal);
    }
}
