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
            using var package = new MemoryStream();
            using (var zip = new ZipArchive(package, ZipArchiveMode.Create, true))
                foreach (var name in new[] { "Data/config.spf2", "UI/test.xml", "runtime.dll" }) { using var entry = zip.CreateEntry(name).Open(); entry.Write(next); }
            bytes = package.ToArray();
            var client = m with { Kind = "client", SHA256 = UpdateEngine.Hash(bytes), Size = bytes.Length, Package = UpdateEngine.Hash(bytes) + ".zip" };
            UpdateEngine.Validate(client, "client"); files = UpdateEngine.Unpack(client, bytes);
            try { UpdateEngine.Apply(client, files, root, bridge, n => { if (n == 2) throw new IOException("injected"); }); throw new Exception("client rollback not invoked"); } catch (IOException e) when (e.Message == "injected") { }
            if (File.Exists(Path.Combine(root, "UI/test.xml"))) throw new Exception("new client file not rolled back");
            UpdateEngine.Apply(client, files, root, bridge);
            if (!UpdateEngine.Current(client, root)) throw new Exception("client install failed");
            File.WriteAllText(Path.Combine(root, "UI/test.xml"), "tampered");
            if (UpdateEngine.Current(client, root)) throw new Exception("client tampering missed");
            foreach (var name in new[] { "bridge.json", "launcher-certificates/login.key", "gfld.dat", "Data/../bridge.json", "Data/config.spf2:ads", "Data/test. /x" })
                if (UpdateEngine.AllowedClientFile(name)) throw new Exception("unsafe client file accepted: " + name);
            bytes = Zip("launcher.exe");
            var launcherRelease = new Manifest("launcher", "test", "登录器更新", UpdateEngine.Hash(bytes), bytes.Length, UpdateEngine.Hash(bytes) + ".zip", null, UpdateEngine.Hash(next));
            UpdateEngine.Validate(launcherRelease, "launcher"); files = UpdateEngine.Unpack(launcherRelease, bytes);
            string localPackage = Path.Combine(root, launcherRelease.Package); File.WriteAllBytes(localPackage, bytes);
            var localBytes = UpdateEngine.ReadLocal(localPackage, launcherRelease.Size);
            UpdateEngine.Unpack(launcherRelease, localBytes);
            try { UpdateEngine.ReadLocal(localPackage, bytes.Length - 1); throw new Exception("oversized local package accepted"); } catch (InvalidDataException) { }
            localBytes[0] ^= 1;
            try { UpdateEngine.Unpack(launcherRelease, localBytes); throw new Exception("tampered local package accepted"); } catch (InvalidDataException) { }
            string launcherPath = Path.Combine(root, "功夫小子线上登录器.exe"); File.WriteAllBytes(launcherPath, old);
            try { UpdateEngine.Apply(launcherRelease, files, root, null, n => { if(n == 1) throw new IOException("injected"); }, launcherPath); throw new Exception("launcher rollback not invoked"); } catch(IOException e) when(e.Message == "injected") { }
            if (!File.ReadAllBytes(launcherPath).SequenceEqual(old)) throw new Exception("launcher rollback failed");
            UpdateEngine.Apply(launcherRelease, files, root, null, launcher: launcherPath);
            if (!UpdateEngine.Current(launcherRelease, root, launcherPath) || !File.Exists(bridge)) throw new Exception("renamed launcher update failed");
            var separated = launcherRelease with { GameEndpoint = "tls://game.example.invalid:19091", UpdateBaseURL = "https://example.invalid/updates/" };
            UpdateEngine.Validate(separated, "launcher");
            File.WriteAllText(bridge, "{\"url\":\"tls://example.invalid:19091\",\"client_directory\":\".\"}");
            string before = File.ReadAllText(bridge);
            try { UpdateEngine.Apply(separated, files, root, bridge, n => { if (n == 2) throw new IOException("injected"); }, launcherPath); throw new Exception("config rollback not invoked"); } catch (IOException e) when (e.Message == "injected") { }
            if (File.ReadAllText(bridge) != before) throw new Exception("config rollback failed");
            UpdateEngine.Apply(separated, files, root, bridge, launcher: launcherPath);
            var migrated = JsonNode.Parse(File.ReadAllText(bridge))!;
            if (migrated["url"]!.GetValue<string>() != separated.GameEndpoint || migrated["credentials_scope"]!.GetValue<string>() != "tls://example.invalid:19091/" || migrated["client_directory"]!.GetValue<string>() != ".") throw new Exception("separate endpoints migration failed");
            File.WriteAllText(Path.Combine(AppContext.BaseDirectory, "updater-test-result.json"), "{\"ok\":true,\"checks\":[\"checksum\",\"install\",\"rollback\",\"preserve-settings\",\"zip-paths\"]}");
        }
        finally { Directory.Delete(root, true); }
    }
}
