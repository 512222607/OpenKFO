using System.Text;
using System.Text.Json.Nodes;
using System.Runtime.InteropServices;

namespace KungFuLauncher;

internal static class SelfTests
{
    internal static void Run(InstanceManager real)
    {
        string testRoot = Path.Combine(Path.GetTempPath(), "kungfu-launcher-test-" + Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(testRoot);
        try
        {
            var resources = System.Reflection.Assembly.GetExecutingAssembly().GetManifestResourceNames();
            string fresh = Path.Combine(testRoot, "fresh-install");
            Bootstrap.Prepare(fresh);
            Require(File.Exists(Path.Combine(fresh, "bridge.json")) && File.Exists(Path.Combine(fresh, "launcher-certificates", "online", "login.key")), "standalone launcher prepares configuration and certificates");
            File.WriteAllText(Path.Combine(fresh, "bridge.json"), "custom configuration");
            File.Delete(Path.Combine(fresh, "launcher-certificates", "online", "origin.crt"));
            Bootstrap.Prepare(fresh);
            Require(File.ReadAllText(Path.Combine(fresh, "bridge.json")) == "custom configuration" && File.Exists(Path.Combine(fresh, "launcher-certificates", "online", "origin.crt")), "restore missing resources without replacing existing settings");
            Require(resources.Contains("LoginSkin.dll") && resources.Contains("LoginSkinHost.exe") && resources.Contains("OpenKFO.Updater.exe"), "independent updater and presentation-only login skin embedded");
            TestCredentials(testRoot);
            string connectionTest = Path.Combine(testRoot, "connection-test");
            Directory.CreateDirectory(Path.Combine(connectionTest, "Data"));
            string connectionXML = Path.Combine(connectionTest, "Data", "config.xml");
            File.WriteAllText(connectionXML, "original configuration");
            string oldConfigHash = InstanceManager.FileHash(connectionXML);
            File.WriteAllText(Path.Combine(connectionTest,"Settings.xml"), "<Settings><LoginServer Index=\"2\"/><Sound Volume=\"77\"/></Settings>");
            InstanceManager.PrepareConnectionFiles(connectionTest, 2);
            Require(File.ReadAllText(Path.Combine(connectionTest,"Settings.xml")) == "<Settings><LoginServer Index=\"0\"/><Sound Volume=\"77\"/></Settings>", "stale server index repaired without changing other settings");
            Require(File.ReadAllText(connectionXML).Contains("127.0.0.1") && File.ReadAllText(connectionXML).Contains("18100"), "embedded SDK configuration uses local per-window endpoint");
            Require(File.ReadAllText(Path.Combine(connectionTest,"server.ini")).Contains("18184"), "native authentication endpoint prepared");
            Require(File.Exists(Path.Combine(connectionTest,"launcher-components","connection-backups",oldConfigHash,"Data","config.xml")), "previous connection configuration backed up");
            InstanceManager.PrepareConnectionFiles(connectionTest, 2);

            string bridgeInstall = Path.Combine(testRoot, "bridge-test.exe");
            InstanceManager.InstallBridge(bridgeInstall, [1, 2, 3]);
            InstanceManager.InstallBridge(bridgeInstall, [1, 2, 3]);
            InstanceManager.InstallBridge(bridgeInstall, [4, 5, 6]);
            Require(File.ReadAllBytes(bridgeInstall).SequenceEqual(new byte[] { 4, 5, 6 }), "bridge component replaced atomically");

            string native = Path.Combine(testRoot, "native-component-test");
            Directory.CreateDirectory(native);
            File.WriteAllText(Path.Combine(native, "SDError.dll"), "original login component");
            string previous = InstanceManager.FileHash(Path.Combine(native, "SDError.dll"));
            InstanceManager.PrepareNativeLogin(native);
            Require(File.Exists(Path.Combine(native, "launcher-components", "native-login-backups", previous, "SDError.dll")), "original login component backed up");
            string installed = InstanceManager.FileHash(Path.Combine(native, "SDError.dll"));
            InstanceManager.PrepareNativeLogin(native);
            Require(InstanceManager.FileHash(Path.Combine(native, "SDError.dll")) == installed && File.Exists(Path.Combine(native, "libssl-1_1.dll")), "native login components installed idempotently");
            string source = Path.Combine(testRoot, "client"); Directory.CreateDirectory(Path.Combine(source, "Data"));
            Directory.CreateDirectory(Path.Combine(source, "OpenKFO", "backups"));
            File.WriteAllText(Path.Combine(source, "OpenKFO", "backups", "private.json"), "must not copy");
            File.WriteAllText(Path.Combine(source, "private-token.txt"), "must not copy");
            foreach (string name in new[] { "gfld.dat", "server.ini", "Data/config.xml", "Data/config.spf2" }) File.Copy(Path.Combine(real.SourceDirectory, name == "gfld.dat" ? InstanceManager.ImageName(real.SourceDirectory) : name), Path.Combine(source, name));
            var config = new JsonObject
            {
                ["url"] = "wss://example.invalid/kk/tunnel", ["client_directory"] = "client",
                ["instances_directory"] = "instances",
                ["client_sha256"] = InstanceManager.FileHash(Path.Combine(source, "gfld.dat")),
                ["config_hash"] = InstanceManager.FileHash(Path.Combine(source, "Data", "config.spf2")),
                ["server_certificate"] = "origin.crt", ["login_certificate"] = "cert.pem", ["login_key"] = "key.pem"
            };
            File.WriteAllText(Path.Combine(testRoot, "bridge.json"), config.ToJsonString());
            config["client_directory"] = ".";
            File.WriteAllText(Path.Combine(testRoot, "bridge.json"), config.ToJsonString());
            Require(new InstanceManager(testRoot).SourceDirectory == source, "auto-detect adjacent client directory without copying game assets");
            config["client_directory"] = "client";
            File.WriteAllText(Path.Combine(testRoot, "bridge.json"), config.ToJsonString());
            var manager = new InstanceManager(testRoot);
            bool missingCertificate = false;
            try { manager.ValidateInstallation(); } catch (IOException error) { missingCertificate = error.Message.Contains("证书"); }
            Require(missingCertificate, "missing certificates explained");
            foreach (string name in new[] { "origin.crt", "cert.pem", "key.pem" }) File.WriteAllText(Path.Combine(testRoot, name), "test placeholder");
            manager.ValidateInstallation();
            File.Move(Path.Combine(source, "gfld.dat"), Path.Combine(source, "gfld.test"));
            bool missingGame = false;
            try { manager.ValidateInstallation(); } catch (IOException error) { missingGame = error.Message.Contains("gfld.dat") && error.Message.Contains("完整解压"); }
            Require(missingGame, "missing game explained");
            File.Move(Path.Combine(source, "gfld.test"), Path.Combine(source, "gfld.dat"));
            string empty = Path.Combine(testRoot, "empty"); Directory.CreateDirectory(empty);
            bool missingConfig = false;
            try { _ = new InstanceManager(empty); } catch (IOException error) { missingConfig = error.Message.Contains("bridge.json") && error.Message.Contains("快捷方式"); }
            Require(missingConfig, "standalone EXE explained");
            File.WriteAllText(Path.Combine(empty, "bridge.json"), "{}");
            bool invalidConfig = false;
            try { _ = new InstanceManager(empty); } catch (IOException error) { invalidConfig = error.Message.Contains("格式不正确"); }
            Require(invalidConfig, "invalid config explained");
            Require(manager.EnvironmentName == "线上服务器" && !manager.EnvironmentDescription.Contains("example.invalid"), "online label hides endpoint");
            config["url"] = "tls://127.0.0.1:19091";
            File.WriteAllText(Path.Combine(testRoot, "bridge.json"), config.ToJsonString());
            var local = new InstanceManager(testRoot);
            Require(local.EnvironmentName == "本地测试服" && !local.EnvironmentDescription.Contains("127.0.0.1"), "local label hides endpoint");
            config["url"] = "wss://example.invalid/kk/tunnel";
            File.WriteAllText(Path.Combine(testRoot, "bridge.json"), config.ToJsonString());
            var progress = new Progress<string>();
            string originalHash = InstanceManager.FileHash(Path.Combine(source, "gfld.dat"));
            Require(manager.InstanceDirectory(2) == Path.Combine(testRoot, "launcher-components", "window-2"), "English component directory");
            string prepared = manager.Prepare(2, progress);
            Require(manager.ClientDirectory(2) == Path.Combine(testRoot, "instances", "client-2"), "configured instance directory");
            Require(!Directory.Exists(Path.Combine(manager.ClientDirectory(2), "OpenKFO")) && !File.Exists(Path.Combine(manager.ClientDirectory(2), "private-token.txt")), "exclude project and private files from client clone");
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
            Require(manager.HealthUri.AbsoluteUri == "https://example.invalid/health", "health URL");
            config["url"] = "tls://example.invalid:19091";
            File.WriteAllText(Path.Combine(testRoot, "bridge.json"), config.ToJsonString());
            var direct = new InstanceManager(testRoot);
            Require(direct.Endpoint.Scheme == "tls" && direct.Endpoint.Host == "example.invalid" && direct.HealthUri.Port == 19091, "direct TLS endpoint");
            Require(direct.UpdateManifest("launcher").AbsoluteUri == "https://example.invalid/updates/launcher.json", "direct TLS uses HTTPS update port");
            config["update_base_url"] = "https://updates.example.invalid/releases/";
            File.WriteAllText(Path.Combine(testRoot, "bridge.json"), config.ToJsonString());
            var separated = new InstanceManager(testRoot);
            Require(separated.UpdateManifest("launcher").AbsoluteUri == "https://updates.example.invalid/releases/launcher.json" && separated.Endpoint == direct.Endpoint, "update host does not change game endpoint");
            config.Remove("update_base_url"); File.WriteAllText(Path.Combine(testRoot, "bridge.json"), config.ToJsonString());
            Require(!Directory.Exists(Path.Combine(testRoot, "launcher-components", "updater")), "URL check does not start updater");
            string bridgePath = Path.Combine(testRoot, "launcher-components", "shared", "OnlineBridge.exe");
            InstanceManager.ValidateSharedBridgeDirectory(bridgePath, bridgePath.ToUpperInvariant());
            bool otherDirectoryRejected = false;
            try { InstanceManager.ValidateSharedBridgeDirectory(bridgePath, Path.Combine(testRoot, "other", "OnlineBridge.exe")); }
            catch (IOException error) { otherDirectoryRejected = error.Message.Contains("另一个游戏目录") && error.Message.Contains("启动选中窗口"); }
            Require(otherDirectoryRejected, "cross-directory bridge conflict is explained before queuing a launch");
            Require(Enumerable.Range(1, 8).SelectMany(number => new[] { InstanceManager.LoginPort(number), InstanceManager.SDKPort(number), InstanceManager.GamePort(number) }).Distinct().Count() == 24, "eight isolated port sets");
            string image = Path.Combine(manager.ClientDirectory(2), "gfld.dat"); secondBytes[100] ^= 1; File.WriteAllBytes(image, secondBytes);
            bool rejected = false;
            try { manager.Prepare(2, progress); } catch (IOException) { rejected = true; }
            Require(rejected, "modified image rejected");
            config["single_client"] = true;
            File.WriteAllText(Path.Combine(testRoot, "bridge.json"), config.ToJsonString());
            var single = new InstanceManager(testRoot);
            Require(single.WindowCount == 1, "single client mode");
            bool copyBlocked = false;
            try { single.Prepare(2, progress); } catch (ArgumentOutOfRangeException) { copyBlocked = true; }
            Require(copyBlocked, "single client cannot create copies");
            config["shared_client"] = true;
            File.WriteAllText(Path.Combine(testRoot, "bridge.json"), config.ToJsonString());
            var shared = new InstanceManager(testRoot);
            string sharedPrepared = shared.Prepare(3, progress);
            Require(File.ReadAllText(Path.Combine(source, "zz.crt")) == File.ReadAllText(Path.Combine(testRoot, "cert.pem")), "native login certificate prepared");
            File.WriteAllText(Path.Combine(source, "zz.crt"), "stale certificate");
            shared.Prepare(3, progress);
            Require(File.ReadAllText(Path.Combine(source, "zz.crt")) == File.ReadAllText(Path.Combine(testRoot, "cert.pem")), "stale native certificate repaired");
            var sharedConfig = JsonNode.Parse(File.ReadAllText(sharedPrepared))!;
            Require(shared.WindowCount == 8 && shared.ClientDirectory(3) == source, "shared client multi-window");
            Require(!Directory.Exists(Path.Combine(testRoot, "instances", "client-3")) && InstanceManager.FileHash(Path.Combine(source, "gfld.dat")) == originalHash, "no duplicate client or disk mutex patch");
            Require(sharedConfig["login_port"]!.GetValue<int>() == 18084 && sharedConfig["control_directory"]!.GetValue<string>().EndsWith("shared"), "shared listener routing");
            Require(sharedConfig["client_executable"]!.GetValue<string>() == "gfld.dat", "gfld selected");
            File.Move(Path.Combine(source, "gfld.dat"), Path.Combine(source, "gfxz.dat"));
            bool gfxzRejected = false;
            try { shared.ValidateInstallation(); }
            catch (IOException error) { gfxzRejected = error.Message.Contains("gfld.dat"); }
            Require(gfxzRejected, "gfxz-only installation rejected with missing gfld message");
            shared.PrepareClientImage();
            Require(InstanceManager.FileHash(Path.Combine(source, "gfld.dat")) == originalHash, "embedded gfld extracted");
            shared.PrepareClientImage();
            File.WriteAllText(Path.Combine(source, "gfld.dat"), "different client");
            bool overwriteRejected = false;
            try { shared.PrepareClientImage(); } catch (IOException) { overwriteRejected = true; }
            Require(overwriteRejected && File.ReadAllText(Path.Combine(source, "gfld.dat")) == "different client", "unknown existing image preserved");
            Require(InstanceManager.FileHash(Path.Combine(source, "gfxz.dat")) == originalHash, "unsupported image unchanged");
            File.WriteAllText(Path.Combine(AppContext.BaseDirectory, "self-test-result.json"), new JsonObject { ["status"] = "passed", ["checks"] = 14, ["credential_checks"] = "encrypted persistence, window isolation, restore, clear, native edits, password masking, no auto-submit", ["real_game_login_tested"] = false, ["time"] = DateTimeOffset.Now.ToString("O") }.ToJsonString());
        }
        finally { Directory.Delete(testRoot, true); }
    }
    private static void TestCredentials(string root)
    {
        string first = Path.Combine(root, "window-1"), second = Path.Combine(root, "window-2");
        var one = new WindowCredentials("fixture-one", "secret-one" );
        var two = new WindowCredentials("fixture-two", "secret-two" );
        one.Save(first); two.Save(second);
        byte[] firstSave = File.ReadAllBytes(Path.Combine(first, "credentials.bin"));
        one.Save(first);
        Require(!firstSave.SequenceEqual(File.ReadAllBytes(Path.Combine(first, "credentials.bin"))), "AES randomized nonce");
        one.Save(first, "1234567890abcdef");

        Require(WindowCredentials.Load(first) == one && WindowCredentials.Load(second) == two, "isolated credential restore");
        byte[] stored = File.ReadAllBytes(Path.Combine(first, "credentials.bin"));
        Require(!Encoding.UTF8.GetString(stored).Contains(one.Password) && !Encoding.Unicode.GetString(stored).Contains(one.Password), "password encrypted on disk");
        var legacy = Path.Combine(root, "legacy"); Directory.CreateDirectory(legacy);
        File.WriteAllBytes(Path.Combine(legacy, "credentials.bin"), System.Security.Cryptography.ProtectedData.Protect(System.Text.Json.JsonSerializer.SerializeToUtf8Bytes(one), null, System.Security.Cryptography.DataProtectionScope.CurrentUser));
        string migrated = Path.Combine(root, "migrated");
        Require(WindowCredentials.LoadMigrating(migrated, legacy, WindowCredentials.DefaultKey) == one && !File.Exists(Path.Combine(legacy, "credentials.bin")), "legacy migration removes old file only after verification");
        var envelope = JsonNode.Parse(File.ReadAllText(Path.Combine(migrated, "credentials.bin")))!;
        byte[] cipher = Convert.FromBase64String(envelope["Ciphertext"]!.GetValue<string>()); cipher[0] ^= 1;
        envelope["Ciphertext"] = Convert.ToBase64String(cipher); File.WriteAllText(Path.Combine(migrated, "credentials.bin"), envelope.ToJsonString());
        bool rejected = false; try { WindowCredentials.Load(migrated); } catch (System.Security.Cryptography.CryptographicException) { rejected = true; }
        Require(rejected, "AES authentication rejects tampering");
        new WindowCredentials("", "").Save(first);
        Require(!File.Exists(Path.Combine(first, "credentials.bin")) && WindowCredentials.Load(first) == new WindowCredentials("", "") && WindowCredentials.Load(second) == two, "clear only selected window");
        using var target = new Form();
        using var other = new Form();
        IntPtr MakeEdit(Form parent, int id, bool masked) => CreateWindowExW(0, "EDIT", "untouched", 0x40000000 | (masked ? 0x20 : 0), 0, 0, 150, 30, parent.Handle, new IntPtr(id), IntPtr.Zero, IntPtr.Zero);
        var account = MakeEdit(target, 1001, false);
        var password = MakeEdit(target, 1002, true);
        var otherAccount = MakeEdit(other, 1001, false);
        var otherPassword = MakeEdit(other, 1002, true);
        using var button = new Button(); target.Controls.Add(button);
        bool clicked = false; button.Click += (_, _) => clicked = true;
        Require(account != IntPtr.Zero && password != IntPtr.Zero && otherAccount != IntPtr.Zero && otherPassword != IntPtr.Zero, "native fixture controls");
        Require(one.FillDialog(target.Handle), "native credential fill");
        string Read(IntPtr handle) { var value = new StringBuilder(100); GetWindowTextW(handle, value, value.Capacity); return value.ToString(); }
        Require(Read(account) == one.Account && Read(password) == one.Password, "matching native field contents");
        Require(Read(otherAccount) == "untouched" && Read(otherPassword) == "untouched", "other window unchanged");
        Require((GetWindowLongW(password, -16) & 0x20) != 0 && !clicked, "password masked and no automatic login");
        Require(!one.FillDialog(button.Handle), "unrelated control rejected");
    }
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] private static extern IntPtr CreateWindowExW(int exStyle, string className, string text, int style, int x, int y, int width, int height, IntPtr parent, IntPtr menu, IntPtr instance, IntPtr parameter);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] private static extern int GetWindowTextW(IntPtr window, StringBuilder text, int length);
    [DllImport("user32.dll")] private static extern int GetWindowLongW(IntPtr window, int index);
    private static void Require(bool value, string message) { if (!value) throw new InvalidOperationException("Self-test failed: " + message); }
}
