using System.IO.Compression;
using System.Text;
using System.Text.Json.Nodes;
namespace OpenKFO.Updater;
internal static class UpdateTests
{
    internal static void Run()
    {
        string root = Path.Combine(Path.GetTempPath(), "openkfo-updater-test-" + Guid.NewGuid()); Directory.CreateDirectory(Path.Combine(root, "Data")); try
        {
            var old = Encoding.UTF8.GetBytes("old"); var next = Encoding.UTF8.GetBytes("new"); var bridge = Path.Combine(root, "bridge.json"); File.WriteAllBytes(Path.Combine(root, "Data/config.spf2"), old); File.WriteAllText(bridge, "{\"config_hash\":\"old\",\"url\":\"keep\"}");
            byte[] Zip(string name) { using var buffer = new MemoryStream(); using (var z = new ZipArchive(buffer, ZipArchiveMode.Create, true)) { using var f = z.CreateEntry(name).Open(); f.Write(next); } return buffer.ToArray(); }
            var bytes = Zip("Data/config.spf2"); var m = new Manifest("weapons", "test", "冰冻持续时间调整", UpdateEngine.Hash(bytes), bytes.Length, UpdateEngine.Hash(bytes) + ".zip", UpdateEngine.Hash(next)); UpdateEngine.Validate(m, "weapons"); var files = UpdateEngine.Unpack(m, bytes);
            try { UpdateEngine.Apply(m, files, root, bridge, n => { if (n == 2) throw new IOException("injected"); }); throw new Exception("rollback not invoked"); } catch (IOException e) when (e.Message == "injected") { }
            if (!File.ReadAllBytes(Path.Combine(root, "Data/config.spf2")).SequenceEqual(old) || JsonNode.Parse(File.ReadAllText(bridge))!["config_hash"]!.GetValue<string>() != "old") throw new Exception("rollback failed");
            UpdateEngine.Apply(m, files, root, bridge); if (!UpdateEngine.Current(m, root) || JsonNode.Parse(File.ReadAllText(bridge))!["url"]!.GetValue<string>() != "keep") throw new Exception("install failed");
            foreach (var name in new[] { "../escape", "Data/config.spf2:ads", "Data\\config.spf2", "bridge.json" }) { bytes = Zip(name); var bad = m with { SHA256 = UpdateEngine.Hash(bytes), Size = bytes.Length, Package = UpdateEngine.Hash(bytes) + ".zip" }; try { UpdateEngine.Unpack(bad, bytes); throw new Exception("accepted unsafe zip"); } catch (InvalidDataException) { } }
            File.WriteAllText(Path.Combine(AppContext.BaseDirectory, "updater-test-result.json"), "{\"ok\":true,\"checks\":[\"checksum\",\"install\",\"rollback\",\"preserve-settings\",\"zip-paths\"]}");
        }
        finally { Directory.Delete(root, true); }
    }
}
