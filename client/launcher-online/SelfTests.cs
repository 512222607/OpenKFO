using System.Text;
using System.Text.Json.Nodes;

namespace KungFuLauncher;

internal static class SelfTests
{
    internal static void Run(InstanceManager real)
    {
        string testRoot = Path.Combine(Path.GetTempPath(), "kungfu-launcher-test-" + Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(testRoot);
        try
        {
            string source = Path.Combine(testRoot, "client"); Directory.CreateDirectory(Path.Combine(source, "Data"));
            foreach (string name in new[] { "gfld.dat", "server.ini", "Data/config.xml", "Data/config.spf2" }) File.Copy(Path.Combine(real.SourceDirectory, name), Path.Combine(source, name));
            var config = new JsonObject
            {
                ["url"] = "wss://ebmqxj.sbs/kk/tunnel", ["client_directory"] = "client",
                ["client_sha256"] = InstanceManager.FileHash(Path.Combine(source, "gfld.dat")),
                ["config_hash"] = InstanceManager.FileHash(Path.Combine(source, "Data", "config.spf2")),
                ["server_certificate"] = "origin.crt", ["login_certificate"] = "cert.pem", ["login_key"] = "key.pem"
            };
            File.WriteAllText(Path.Combine(testRoot, "bridge.json"), config.ToJsonString());
            var manager = new InstanceManager(testRoot);
            var progress = new Progress<string>();
            string originalHash = InstanceManager.FileHash(Path.Combine(source, "gfld.dat"));
            string prepared = manager.Prepare(2, progress);
            var second = JsonNode.Parse(File.ReadAllText(prepared))!;
            Require(second["login_port"]!.GetValue<int>() == 18184, "second login port");
            Require(second["sdk_port"]!.GetValue<int>() == 18100, "second SDK port");
            Require(second["game_port"]!.GetValue<int>() == 18101, "second game port");
            byte[] secondBytes = File.ReadAllBytes(Path.Combine(manager.ClientDirectory(2), "gfld.dat"));
            Require(Encoding.ASCII.GetString(secondBytes, 0x7ce610, 9) == "KungfuKi2", "independent mutex");
            Require(InstanceManager.Hash(secondBytes) == second["client_sha256"]!.GetValue<string>(), "patched hash");
            Require(InstanceManager.FileHash(Path.Combine(source, "gfld.dat")) == originalHash, "source unchanged");
            Require(File.ReadAllText(Path.Combine(manager.ClientDirectory(2), "server.ini")).Contains("18184"), "native login port");
            Require(Encoding.Latin1.GetString(File.ReadAllBytes(Path.Combine(manager.ClientDirectory(2), "Data/config.xml"))).Contains("18100"), "native SDK port");
            manager.Prepare(2, progress);
            Require(manager.HealthUri.AbsoluteUri == "https://ebmqxj.sbs/health", "health URL");
            config["url"] = "tls://114.55.133.88:19091";
            File.WriteAllText(Path.Combine(testRoot, "bridge.json"), config.ToJsonString());
            var direct = new InstanceManager(testRoot);
            Require(direct.Endpoint.Scheme == "tls" && direct.HealthUri.Port == 19091, "direct TLS endpoint");
            Require(Enumerable.Range(1, 8).SelectMany(number => new[] { InstanceManager.LoginPort(number), InstanceManager.SDKPort(number), InstanceManager.GamePort(number) }).Distinct().Count() == 24, "eight isolated port sets");
            string image = Path.Combine(manager.ClientDirectory(2), "gfld.dat"); secondBytes[100] ^= 1; File.WriteAllBytes(image, secondBytes);
            bool rejected = false;
            try { manager.Prepare(2, progress); } catch (IOException) { rejected = true; }
            Require(rejected, "modified image rejected");
            File.WriteAllText(Path.Combine(AppContext.BaseDirectory, "self-test-result.json"), new JsonObject { ["status"] = "passed", ["checks"] = 13, ["real_game_login_tested"] = false, ["time"] = DateTimeOffset.Now.ToString("O") }.ToJsonString());
        }
        finally { Directory.Delete(testRoot, true); }
    }
    private static void Require(bool value, string message) { if (!value) throw new InvalidOperationException("Self-test failed: " + message); }
}
