using System.Diagnostics;
using System.Net;
using System.Net.Sockets;
using System.Net.Security;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text.Json;
using System.Text;
using System.Text.Json.Nodes;

namespace KungFuLauncher;

internal sealed class InstanceManager
{
    internal const int MaximumInstances = 8;
    private const string OriginalImageHash = "98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b";
    private const int MutexOffset = 0x7ce610;
    private readonly string root;
    private readonly JsonObject baseline;
    internal string SourceDirectory { get; }
    internal Uri HealthUri { get; }
    internal Uri Endpoint { get; }
    internal string RootDirectory => root;
    internal bool SharedClient => baseline["shared_client"]?.GetValue<bool>() == true;
    private string SharedDirectory => Path.Combine(root, "launcher-components", "shared");
    internal int WindowCount => SharedClient ? MaximumInstances : baseline["single_client"]?.GetValue<bool>() == true ? 1 : MaximumInstances;
    internal string EnvironmentName => Endpoint.IsLoopback ? "本地测试服" : "线上服务器";
    internal string EnvironmentDescription => $"{EnvironmentName} · {Endpoint.Authority} · {(WindowCount == 1 ? "单客户端" : "多窗口登录")}";

    internal InstanceManager(string rootDirectory)
    {
        root = Path.GetFullPath(rootDirectory);
        baseline = JsonNode.Parse(File.ReadAllText(Path.Combine(root, "bridge.json")))!.AsObject();
        SourceDirectory = Resolve(baseline["client_directory"]!.GetValue<string>());
        var endpoint = new Uri(baseline["url"]!.GetValue<string>());
        if (endpoint.Scheme != "wss" && endpoint.Scheme != "tls") throw new InvalidOperationException("服务器地址必须使用安全的 TLS 或 WSS 连接。");
        if (endpoint.Scheme == "tls" && endpoint.Port < 1) throw new InvalidOperationException("缺少游戏连接端口。");
        Endpoint = endpoint;
        HealthUri = endpoint.Scheme == "tls" ? endpoint : new UriBuilder(endpoint) { Scheme = "https", Path = "/health", Query = "", Port = endpoint.IsDefaultPort ? -1 : endpoint.Port }.Uri;
    }

    internal async Task CheckHealthAsync(HttpClient http)
    {
        if (Endpoint.Scheme == "wss")
        {
            using var response = await http.GetAsync(HealthUri);
            response.EnsureSuccessStatusCode();
            using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
            if (document.RootElement.GetProperty("service").GetString() != "kungfu-go" || document.RootElement.GetProperty("status").GetString() != "ok") throw new IOException("服务返回异常状态");
            return;
        }
        using var timeout = new CancellationTokenSource(TimeSpan.FromSeconds(8));
        using var certificate = X509Certificate2.CreateFromPem(File.ReadAllText(Resolve(baseline["server_certificate"]!.GetValue<string>())));
        using var socket = new TcpClient();
        await socket.ConnectAsync(Endpoint.Host, Endpoint.Port, timeout.Token);
        using var stream = new SslStream(socket.GetStream());
        await stream.AuthenticateAsClientAsync(new SslClientAuthenticationOptions
        {
            TargetHost = "kk-origin",
            CertificateChainPolicy = new X509ChainPolicy
            {
                TrustMode = X509ChainTrustMode.CustomRootTrust,
                CustomTrustStore = { certificate },
                RevocationMode = X509RevocationMode.NoCheck
            }
        }, timeout.Token);
        await stream.WriteAsync(Encoding.UTF8.GetBytes("{\"op\":\"health\"}\n"), timeout.Token);
        using var output = new MemoryStream();
        var buffer = new byte[1];
        while (output.Length < 8192)
        {
            if (await stream.ReadAsync(buffer, timeout.Token) != 1) throw new IOException("服务关闭连接");
            if (buffer[0] == (byte)'\n') break;
            output.WriteByte(buffer[0]);
        }
        if (output.Length >= 8192) throw new IOException("服务返回异常长度");
        using var status = JsonDocument.Parse(output.ToArray());
        if (status.RootElement.GetProperty("op").GetString() != "health" || status.RootElement.GetProperty("value").GetInt32() != 1) throw new IOException("服务暂不可用");
    }

    private string Resolve(string path) => Path.GetFullPath(path, root);
    internal static int LoginPort(int number) => 18084 + (number - 1) * 100;
    internal static int SDKPort(int number) => 18000 + (number - 1) * 100;
    internal static int GamePort(int number) => 18001 + (number - 1) * 100;
    internal string ClientDirectory(int number) => SharedClient || number == 1 ? SourceDirectory :
        baseline["instances_directory"] is JsonValue configured
            ? Path.Combine(Resolve(configured.GetValue<string>()), "client-" + number)
            : SourceDirectory + "-" + number;

    internal static IEnumerable<string> ClientFiles(string source)
    {
        // A client may share its root with source code and backups. Never clone those.
        var extensions = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            { ".dll", ".dat", ".ini", ".xml", ".sdp", ".nlb", ".exe", ".sys", ".crt", ".ico" };
        foreach (string file in Directory.EnumerateFiles(source))
            if (extensions.Contains(Path.GetExtension(file)) || Path.GetFileName(file) is "SPC32" or "TipsCount.txt") yield return file;
        foreach (string name in new[] { "Data", "effect", "GPK", "HostWidgets", "SDO", "spdata", "UI", "Weapon" })
        {
            string folder = Path.Combine(source, name);
            if (Directory.Exists(folder))
                foreach (string file in Directory.EnumerateFiles(folder, "*", new EnumerationOptions { RecurseSubdirectories = true, AttributesToSkip = FileAttributes.ReparsePoint, IgnoreInaccessible = false }))
                    yield return file;
        }
    }
    internal string InstanceDirectory(int number) => Path.Combine(root, "launcher-components", "window-" + number);
    internal string LogPath(int number) => Path.Combine(SharedClient ? SharedDirectory : InstanceDirectory(number), "online-client.log");

    internal Process? FindGame(int number)
    {
        string expected = Path.Combine(ClientDirectory(number), "gfld.dat");
        if (SharedClient)
        {
            Process? process = null;
            try
            {
                var state = JsonNode.Parse(File.ReadAllText(Path.Combine(SharedDirectory, $"window-{number}.json")))!;
                process = Process.GetProcessById(state["PID"]!.GetValue<int>());
                if ((ulong)process.StartTime.ToFileTimeUtc() == state["Created"]!.GetValue<ulong>() && string.Equals(process.MainModule?.FileName, expected, StringComparison.OrdinalIgnoreCase)) return process;
            }
            catch (Exception ex) when (ex is IOException or System.Text.Json.JsonException or ArgumentException or InvalidOperationException or System.ComponentModel.Win32Exception) { }
            process?.Dispose();
            return null;
        }
        foreach (var process in Process.GetProcesses())
        {
            bool retained = false;
            try
            {
                if (!process.ProcessName.StartsWith("gfld", StringComparison.OrdinalIgnoreCase)) continue;
                if (string.Equals(process.MainModule?.FileName, expected, StringComparison.OrdinalIgnoreCase))
                {
                    retained = true;
                    return process;
                }
            }
            catch (Exception exception) when (exception is System.ComponentModel.Win32Exception or InvalidOperationException) { }
            finally { if (!retained) process.Dispose(); }
        }
        return null;
    }

    internal bool IsRunning(int number) { using var process = FindGame(number); return process != null; }
    internal void Activate(int number)
    {
        using var process = FindGame(number);
        if (process == null) return;
        var window = process.MainWindowHandle;
        if (window != IntPtr.Zero) { ShowWindow(window, 9); SetForegroundWindow(window); }
    }

    internal async Task LaunchAsync(int number, IProgress<string> progress)
    {
        if (number < 1 || number > WindowCount) throw new ArgumentOutOfRangeException(nameof(number));
        using (var existing = FindGame(number))
        {
            if (existing != null) { await PrepareLoginAsync(number, existing, progress); Activate(number); return; }
        }
        // Serialize preparation across launcher windows; never stop an existing game.
        string stateDirectory = Path.Combine(root, "launcher-components");
        Directory.CreateDirectory(stateDirectory);
        using var preparationLock = new FileStream(Path.Combine(stateDirectory, SharedClient ? "shared.lock" : $"window-{number}.lock"), FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.None);
        string config = await Task.Run(() => Prepare(number, progress));
        using (var existing = FindGame(number))
        {
            if (existing != null) { await PrepareLoginAsync(number, existing, progress); Activate(number); return; }
        }
        if (!SharedClient) CheckAvailablePorts(number);
        string bridge = Path.Combine(SharedClient ? SharedDirectory : InstanceDirectory(number), "OnlineBridge.exe");
        var start = new ProcessStartInfo(bridge) { WorkingDirectory = Path.GetDirectoryName(bridge)!, UseShellExecute = false, CreateNoWindow = true };
        start.ArgumentList.Add("-config"); start.ArgumentList.Add(config);
        if (SharedClient) { start.ArgumentList.Add("-window"); start.ArgumentList.Add(number.ToString()); }
        using var helper = Process.Start(start) ?? throw new IOException("无法启动网络组件。");
        progress.Report($"窗口 {number} 正在启动游戏…");
        for (int attempt = 0; attempt < 60; attempt++)
        {
            await Task.Delay(500);
            using var game = FindGame(number);
            if (game != null) { await PrepareLoginAsync(number, game, progress); return; }
            if (helper.HasExited && (!SharedClient || helper.ExitCode != 0)) throw new IOException($"网络组件已退出，请查看窗口 {number} 的日志。");
        }
        throw new IOException($"窗口 {number} 启动超时，请查看日志；不要重复点击启动。");
    }

    private async Task PrepareLoginAsync(int number, Process game, IProgress<string> progress)
    {
        StartLoginSkin(number, game);
        var saved = WindowCredentials.Load(InstanceDirectory(number));
        if (saved.Account.Length == 0 && saved.Password.Length == 0)
        {
            progress.Report($"窗口 {number} 已启动，请在游戏里输入账号密码。");
            return;
        }
        progress.Report($"窗口 {number} 正在等待登录界面并填写账号密码…");
        bool filled = await saved.FillAsync(game);
        progress.Report(filled ? $"窗口 {number} 已填写保存的账号密码，请在游戏里点击登录。" : $"窗口 {number} 未找到可填写的登录界面；若已登录，无需重复操作。");
    }

    private void StartLoginSkin(int number, Process game)
    {
        byte[] ReadResource(string name)
        {
            using var resource = Assembly.GetExecutingAssembly().GetManifestResourceStream(name) ?? throw new IOException("缺少登录界面组件。");
            using var buffer = new MemoryStream(); resource.CopyTo(buffer); return buffer.ToArray();
        }
        byte[] skin = ReadResource("LoginSkin.dll"), host = ReadResource("LoginSkinHost.exe");
        // Versioned files let existing native windows keep their loaded DLL
        // while a new launcher ships an updated design.
        string directory = Path.Combine(root, "launcher-components", "login-skin", Hash(skin)[..12] + Hash(host)[..12]);
        Directory.CreateDirectory(directory);
        using var extractionLock = new FileStream(Path.Combine(directory, "extract.lock"), FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.None);
        string skinPath = Path.Combine(directory, "LoginSkin.dll"), hostPath = Path.Combine(directory, "LoginSkinHost.exe");
        if (!File.Exists(skinPath) || FileHash(skinPath) != Hash(skin)) File.WriteAllBytes(skinPath, skin);
        if (!File.Exists(hostPath) || FileHash(hostPath) != Hash(host)) File.WriteAllBytes(hostPath, host);
        var start = new ProcessStartInfo(hostPath) { WorkingDirectory = directory, UseShellExecute = false, CreateNoWindow = true };
        start.ArgumentList.Add(game.Id.ToString());
        start.ArgumentList.Add(Path.Combine(ClientDirectory(number), "gfld.dat"));
        start.ArgumentList.Add(skinPath);
        using var helper = Process.Start(start) ?? throw new IOException("无法启动登录界面组件。");
    }

    internal string Prepare(int number, IProgress<string> progress)
    {
        if (number < 1 || number > WindowCount) throw new ArgumentOutOfRangeException(nameof(number));
        string directory = ClientDirectory(number);
        if (!Directory.Exists(directory))
        {
            string staging = directory + ".preparing";
            Directory.CreateDirectory(staging);
            var files = ClientFiles(SourceDirectory).ToArray();
            for (int index = 0; index < files.Length; index++)
            {
                string relative = Path.GetRelativePath(SourceDirectory, files[index]);
                string destination = Path.Combine(staging, relative);
                Directory.CreateDirectory(Path.GetDirectoryName(destination)!);
                File.Copy(files[index], destination, true);
                if (index % 500 == 0) progress.Report($"首次准备窗口 {number}：复制资源 {index * 100 / files.Length}%（约 2.8 GB）");
            }
            Directory.Move(staging, directory);
        }
        string image = Path.Combine(directory, "gfld.dat");
        byte[] imageBytes = File.ReadAllBytes(image);
        if (imageBytes.Length < MutexOffset + 10) throw new IOException("游戏文件不完整。");
        // Restore the known mutex bytes for whole-file verification before changing this instance's name.
        string currentMutex = Encoding.ASCII.GetString(imageBytes, MutexOffset, 9);
        if (currentMutex != "KungfuKid" && currentMutex != "KungfuKi2" && currentMutex != $"Kungfu{number:000}") throw new IOException("不支持的游戏版本，未修改客户端。");
        Encoding.ASCII.GetBytes("KungfuKid\0").CopyTo(imageBytes, MutexOffset);
        if (!Hash(imageBytes).Equals(OriginalImageHash, StringComparison.OrdinalIgnoreCase)) throw new IOException("游戏文件校验不一致，未修改客户端。");
        if (number > 1 && !SharedClient)
        {
            Encoding.ASCII.GetBytes(number == 2 ? "KungfuKi2\0" : $"Kungfu{number:000}\0").CopyTo(imageBytes, MutexOffset);
            if (!File.ReadAllBytes(image).AsSpan().SequenceEqual(imageBytes)) File.WriteAllBytes(image, imageBytes);
            string sourcePackage = Path.Combine(SourceDirectory, "Data", "config.spf2");
            string targetPackage = Path.Combine(directory, "Data", "config.spf2");
            if (!FileHash(sourcePackage).Equals(baseline["config_hash"]!.GetValue<string>(), StringComparison.OrdinalIgnoreCase)) throw new IOException("武器配置与线上版本不一致，请先更新服务器允许的配置。");
            if (FileHash(sourcePackage) != FileHash(targetPackage)) File.Copy(sourcePackage, targetPackage, true);
        }
        int portWindow = SharedClient ? 1 : number;
        ReplacePort(Path.Combine(directory, "server.ini"), @"(?m)^port=\d+", "port=" + LoginPort(portWindow));
        ReplacePort(Path.Combine(directory, "Data", "config.xml"), "Port=\"[0-9]+\"", "Port=\"" + SDKPort(portWindow) + "\"");
        Directory.CreateDirectory(InstanceDirectory(number));
        var config = (JsonObject)baseline.DeepClone();
        config["client_directory"] = directory;
        config["client_sha256"] = Hash(imageBytes);
        config["login_port"] = LoginPort(portWindow); config["sdk_port"] = SDKPort(portWindow); config["game_port"] = GamePort(portWindow);
        if (SharedClient) { Directory.CreateDirectory(SharedDirectory); config["control_directory"] = SharedDirectory; }
        foreach (string key in new[] { "server_certificate", "login_certificate", "login_key" }) config[key] = Resolve(baseline[key]!.GetValue<string>());
        string path = Path.Combine(InstanceDirectory(number), "bridge.json");
        File.WriteAllText(path, config.ToJsonString(new() { WriteIndented = true }));
        using var resource = Assembly.GetExecutingAssembly().GetManifestResourceStream("OnlineBridge.exe") ?? throw new IOException("缺少网络组件。");
        using var buffer = new MemoryStream(); resource.CopyTo(buffer);
        string helper = Path.Combine(SharedClient ? SharedDirectory : InstanceDirectory(number), "OnlineBridge.exe");
        byte[] helperBytes = buffer.ToArray();
        if (!File.Exists(helper) || FileHash(helper) != Hash(helperBytes)) File.WriteAllBytes(helper, helperBytes);
        return path;
    }

    private static void ReplacePort(string path, string pattern, string value)
    {
        string content = Encoding.Latin1.GetString(File.ReadAllBytes(path));
        if (!System.Text.RegularExpressions.Regex.IsMatch(content, pattern)) throw new IOException("缺少客户端端口配置：" + path);
        string updated = System.Text.RegularExpressions.Regex.Replace(content, pattern, value);
        if (updated != content) File.WriteAllBytes(path, Encoding.Latin1.GetBytes(updated));
    }
    internal static string Hash(byte[] bytes) => Convert.ToHexString(SHA256.HashData(bytes)).ToLowerInvariant();
    internal static string FileHash(string path) { using var stream = File.OpenRead(path); return Convert.ToHexString(SHA256.HashData(stream)).ToLowerInvariant(); }
    private static void CheckAvailablePorts(int number)
    {
        var listeners = new List<TcpListener>();
        try
        {
            foreach (int port in new[] { LoginPort(number), SDKPort(number), GamePort(number) })
            {
                var listener = new TcpListener(IPAddress.Loopback, port); listener.Server.ExclusiveAddressUse = true; listener.Start(); listeners.Add(listener);
            }
            using var udp = new UdpClient(AddressFamily.InterNetwork);
            udp.ExclusiveAddressUse = true; udp.Client.Bind(new IPEndPoint(IPAddress.Loopback, GamePort(number)));
        }
        catch (SocketException) { throw new IOException("这个窗口的连接端口正在使用，请稍后重试或选择另一个窗口。"); }
        finally { foreach (var listener in listeners) listener.Stop(); }
    }
    [DllImport("user32.dll")] private static extern bool ShowWindow(IntPtr window, int command);
    [DllImport("user32.dll")] private static extern bool SetForegroundWindow(IntPtr window);
}
