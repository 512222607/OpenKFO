using System.IO.Compression;
using System.Reflection;

namespace KungFuLauncher;

internal static class Bootstrap
{
    private static readonly HashSet<string> Files = new(StringComparer.Ordinal)
    {
        "bridge.json", "launcher-certificates/online/origin.crt",
        "launcher-certificates/online/login.crt", "launcher-certificates/online/login.key"
    };

    internal static void Prepare(string root)
    {
        using var resource = Assembly.GetExecutingAssembly().GetManifestResourceStream("launcher-bootstrap.zip")
            ?? throw new IOException("启动器缺少内置连接配置，请重新下载完整发布包。");
        using var archive = new ZipArchive(resource, ZipArchiveMode.Read);
        if (archive.Entries.Count != Files.Count || archive.Entries.Select(e => e.FullName).Distinct().Count() != Files.Count
            || archive.Entries.Any(e => !Files.Contains(e.FullName) || e.Length > 65536))
            throw new IOException("启动器内置连接配置无效。");
        // Never redirect an existing local/custom installation to the online server.
        bool existingConfig = File.Exists(Path.Combine(root, "bridge.json")) || File.Exists(Path.Combine(root, "bridge.local.json"));
        foreach (var entry in archive.Entries)
        {
            string path = Path.Combine(root, entry.FullName.Replace('/', Path.DirectorySeparatorChar));
            if (File.Exists(path) || entry.FullName == "bridge.json" && existingConfig) continue;
            Directory.CreateDirectory(Path.GetDirectoryName(path)!);
            string temporary = path + "." + Guid.NewGuid().ToString("N") + ".tmp";
            try
            {
                using (var output = new FileStream(temporary, FileMode.CreateNew, FileAccess.Write, FileShare.None))
                using (var input = entry.Open()) input.CopyTo(output);
                try { File.Move(temporary, path); }
                catch (IOException) when (File.Exists(path)) { } // Concurrent extraction completed first.
            }
            finally
            {
                if (File.Exists(temporary)) File.Delete(temporary);
            }
        }
    }
}
