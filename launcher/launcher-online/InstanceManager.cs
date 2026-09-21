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
    private static readonly HashSet<string> SupportedImageHashes = new(StringComparer.OrdinalIgnoreCase)
    {
        "98c43be72ac7600b368d4e185d75205376f79e938ea42e4b16ce8f8c4bae827b"
    };
    internal static string ImageName(string directory) => "gfld.dat";
    private static bool HasImage(string directory) => File.Exists(Path.Combine(directory, ImageName(directory)));
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
    internal string EnvironmentDescription => $"{EnvironmentName} · {(WindowCount == 1 ? "单客户端" : "多窗口登录")}";

    internal InstanceManager(string rootDirectory)
    {
        root = Path.GetFullPath(rootDirectory);
        string exeName = Path.GetFileName(Environment.ProcessPath ?? "");
        string localConfig = Path.Combine(root, "bridge.local.json");
        string config = (exeName.Contains("本地") || exeName.Contains("线下")) && File.Exists(localConfig)
            ? localConfig : Path.Combine(root, "bridge.json");
        if (!File.Exists(config)) throw new IOException($"登录器所在目录不正确，或游戏包没有完整解压。\n\n缺少：{config}\n\n请先解压整个游戏文件夹，再双击其中的登录器。不要把 EXE 单独移到桌面；可创建桌面快捷方式。网络组件自动准备，无需手动复制 DLL。");
        try
        {
            baseline = JsonNode.Parse(File.ReadAllText(config))!.AsObject();
            SourceDirectory = Resolve(baseline["client_directory"]!.GetValue<string>());
            if (!HasImage(SourceDirectory))
            {
                var candidates = new[] { root, Path.Combine(root, "功夫小子"), Path.Combine(root, "client") }
                    .Where(path => HasImage(path) || Directory.Exists(Path.Combine(path, "Data"))).Distinct(StringComparer.OrdinalIgnoreCase).ToArray();
                if (candidates.Length > 1) throw new IOException("找到多个游戏目录，请只保留一个与登录器配套的游戏目录，或在配置中明确指定。");
                if (candidates.Length == 1) SourceDirectory = candidates[0];
            }
            Endpoint = new Uri(baseline["url"]!.GetValue<string>());
        }
        catch (Exception error) when (error is JsonException or InvalidOperationException or NullReferenceException or ArgumentException or UriFormatException)
        {
            throw new IOException("登录配置 bridge.json 格式不正确。请重新解压完整游戏包，或联系提供者更新登录器配置；无需自行编辑。", error);
        }
        var endpoint = Endpoint;
        if (endpoint.Scheme != "wss" && endpoint.Scheme != "tls") throw new InvalidOperationException("服务器地址必须使用安全的 TLS 或 WSS 连接。");
        if (endpoint.Scheme == "tls" && endpoint.Port < 1) throw new InvalidOperationException("缺少游戏连接端口。");
        Endpoint = endpoint;
        HealthUri = endpoint.Scheme == "tls" ? endpoint : new UriBuilder(endpoint) { Scheme = "https", Path = "/health", Query = "", Port = endpoint.IsDefaultPort ? -1 : endpoint.Port }.Uri;
    }

    internal async Task<(long? RoundTripMs, long? ConnectionMs, long TotalMs)> CheckHealthAsync(HttpClient http)
    {
        var elapsed = Stopwatch.StartNew();
        if (Endpoint.Scheme == "wss")
        {
            using var response = await http.GetAsync(HealthUri);
            response.EnsureSuccessStatusCode();
            using var document = JsonDocument.Parse(await response.Content.ReadAsStringAsync());
            if (document.RootElement.GetProperty("service").GetString() != "kungfu-go" || document.RootElement.GetProperty("status").GetString() != "ok") throw new IOException("服务返回异常状态");
            ReadCredentialsKey(document.RootElement);
            return (null, null, elapsed.ElapsedMilliseconds);
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
        long connectionMs = elapsed.ElapsedMilliseconds;
        elapsed.Restart();
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
        long roundTripMs = elapsed.ElapsedMilliseconds;
        using var status = JsonDocument.Parse(output.ToArray());
        if (status.RootElement.GetProperty("op").GetString() != "health" || status.RootElement.GetProperty("value").GetInt32() != 1) throw new IOException("服务暂不可用");
        ReadCredentialsKey(status.RootElement);
        return (roundTripMs, connectionMs, connectionMs + roundTripMs);
    }

    private string Resolve(string path) => Path.GetFullPath(path, root);

    internal Uri UpdateManifest(string kind)
    {
        if (baseline["update_base_url"] is JsonValue value && value.TryGetValue<string>(out var configured))
        {
            var address = OpenKFO.Updater.UpdateEngine.SecureUri(configured);
            if (!address.AbsolutePath.EndsWith('/') || address.Query != "" || address.Fragment != "") throw new IOException("更新目录必须以 / 结尾，且不能包含查询参数。");
            return new Uri(address, kind + ".json");
        }
        return new UriBuilder(Endpoint) { Scheme = "https", Path = "/updates/" + kind + ".json", Query = "", Port = Endpoint.Scheme == "tls" || Endpoint.IsDefaultPort ? -1 : Endpoint.Port }.Uri;
    }

    internal bool CheckLauncherUpdate()
    {
        if (Endpoint.IsLoopback || Endpoint.Scheme != "wss" && baseline["update_base_url"] == null) return true;
        using var resource = Assembly.GetExecutingAssembly().GetManifestResourceStream("OpenKFO.Updater.exe") ?? throw new IOException("登录器更新助手缺失，请重新下载登录器。");
        using var buffer = new MemoryStream(); resource.CopyTo(buffer); byte[] bytes = buffer.ToArray();
        string folder = Path.Combine(root, "launcher-components", "updater", Hash(bytes)[..16]);
        Directory.CreateDirectory(folder);
        string helper = Path.Combine(folder, "OpenKFO.Updater.exe");
        if (!File.Exists(helper) || FileHash(helper) != Hash(bytes)) File.WriteAllBytes(helper, bytes);
        string executable = Environment.ProcessPath!;
        var uri = UpdateManifest("launcher");
        var start = new ProcessStartInfo(helper) { WorkingDirectory = folder, UseShellExecute = false };
        foreach (var arg in new[] { "--kind", "launcher", "--target", Path.GetDirectoryName(executable)!, "--launcher", executable, "--restart-root", root, "--manifest", uri.AbsoluteUri }) start.ArgumentList.Add(arg);
        using var process = Process.Start(start) ?? throw new IOException("无法启动登录器更新助手。");
        process.WaitForExit();
        return process.ExitCode == 0;
    }

    internal string UsageInstructions => $"1. 将启动器.exe 放进完整游戏目录，与 Data 文件夹同级（自动释放老登客户端 gfld.dat）。\n2. 双击启动器，连接配置、证书和所需组件会自动准备，无需手动复制 DLL。\n3. 选择窗口、填写账号密码，点击“启动游戏”。可创建桌面快捷方式。\n\n不要在压缩包内直接运行。游戏启动前会检查客户端更新；已有自定义连接配置会保留。\n\n游戏目录：{SourceDirectory}\n启动器配置目录：{root}";

    internal void PrepareClientImage()
    {
        if (!Directory.Exists(Path.Combine(SourceDirectory, "Data")))
            throw new IOException("请将启动器放到完整游戏目录，与 Data 文件夹同级。启动器内置 gfld.dat，但不包含完整游戏资源。");
        string target = Path.Combine(SourceDirectory, "gfld.dat");
        if (File.Exists(target))
        {
            if (!SupportedImageHashes.Contains(FileHash(target)))
                throw new IOException("现有 gfld.dat 不是受支持的老登客户端，未覆盖原文件。请备份并移走该文件后重试。");
            return;
        }
        byte[] bytes = ReadResource("gfld.dat");
        if (!SupportedImageHashes.Contains(Hash(bytes))) throw new IOException("内置 gfld.dat 校验失败，请重新下载启动器。");
        string temporary = target + "." + Guid.NewGuid().ToString("N") + ".tmp";
        try
        {
            File.WriteAllBytes(temporary, bytes);
            try { File.Move(temporary, target); }
            catch (IOException) when (File.Exists(target) && SupportedImageHashes.Contains(FileHash(target))) { }
        }
        finally { if (File.Exists(temporary)) File.Delete(temporary); }
    }

    internal void ValidateInstallation()
    {
        var missing = new List<string>();
        foreach (string name in new[] { ImageName(SourceDirectory), "server.ini", "Data/config.xml", "Data/config.spf2" })
            if (!File.Exists(Path.Combine(SourceDirectory, name))) missing.Add(name);
        if (missing.Count != 0)
            throw new IOException($"游戏文件不完整，或登录器配置的游戏目录不正确。\n\n游戏目录：{SourceDirectory}\n缺少：{string.Join("、", missing)}\n\n请重新完整解压游戏包。登录器应和 gfld.dat（老登客户端）、Data 文件夹放在一起；本地调试版请联系管理员检查游戏目录配置。无需手动复制 DLL。");
        foreach (string key in new[] { "server_certificate", "login_certificate", "login_key" })
        {
            string? path = baseline[key] is JsonValue value && value.TryGetValue<string>(out var text) ? text : null;
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(Resolve(path)))
                throw new IOException("游戏包缺少连接证书或证书配置不正确。请重新解压完整游戏包，或联系提供者补发；无需玩家自行生成证书。\n\n缺失配置项：" + key);
        }
    }
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
    internal string CredentialsKey { get; private set; } = WindowCredentials.DefaultKey;
    internal string CredentialsDirectory(int number) => Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "OpenKFO", "Launcher", Hash(Encoding.UTF8.GetBytes(baseline["credentials_scope"]?.GetValue<string>() ?? Endpoint.AbsoluteUri))[..16], "window-" + number);
    internal WindowCredentials LoadCredentials(int number)
    {
        string legacy = InstanceDirectory(number);
        if (!File.Exists(Path.Combine(legacy, "credentials.bin"))) legacy = Path.Combine(SourceDirectory, "launcher-components", "window-" + number);
        return WindowCredentials.LoadMigrating(CredentialsDirectory(number), legacy, CredentialsKey);
    }
    internal void SaveCredentials(int number, WindowCredentials saved) => saved.Save(CredentialsDirectory(number), CredentialsKey);
    private void ReadCredentialsKey(JsonElement response)
    {
        if (!response.TryGetProperty("launcher_credentials_key", out var value)) { CredentialsKey = WindowCredentials.DefaultKey; return; }
        string? key = value.GetString();
        if (!WindowCredentials.ValidKey(key)) throw new IOException("服务器账号保存密钥配置无效。");
        CredentialsKey = key!;
    }
    internal const string GameWindowTitle = "KK - 神兵天下 [1.13.0.594]";
    internal void UpdateGameTitle(int number)
    {
        using var game = FindGame(number);
        if (game is null) return;
        game.Refresh();
        var window = game.MainWindowHandle;
        if (window == IntPtr.Zero) return;
        // Native login locates its parent by the original caption. Wait until
        // its child exists before changing the displayed title.
        bool loginExists = false;
        EnumChildWindows(window, (child, _) => {
            var name = new StringBuilder(64); GetClassNameW(child, name, name.Capacity);
            if (name.ToString() == "LoginChildWndClass") loginExists = true;
            return true;
        }, IntPtr.Zero);
        if (!loginExists) return;
        var current = new StringBuilder(256); GetWindowTextW(window, current, current.Capacity);
        if (current.ToString() != GameWindowTitle) SetWindowTextW(window, GameWindowTitle);
    }
    private delegate bool ChildWindowCallback(IntPtr window, IntPtr parameter);
    [DllImport("user32.dll")] private static extern bool EnumChildWindows(IntPtr window, ChildWindowCallback callback, IntPtr parameter);
    [DllImport("user32.dll")] private static extern bool IsWindowVisible(IntPtr window);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] private static extern int GetClassNameW(IntPtr window, StringBuilder name, int length);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] private static extern int GetWindowTextW(IntPtr window, StringBuilder text, int length);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] private static extern bool SetWindowTextW(IntPtr window, string title);

    internal string InstanceDirectory(int number) => Path.Combine(root, "launcher-components", "window-" + number);
    internal string LogPath(int number) => Path.Combine(SharedClient ? SharedDirectory : InstanceDirectory(number), "online-client.log");

    internal Process? FindGame(int number)
    {
        string expected = Path.Combine(ClientDirectory(number), ImageName(ClientDirectory(number)));
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
                if (!process.ProcessName.Equals("gfld.dat", StringComparison.OrdinalIgnoreCase)) continue;
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
        if (SharedClient) CheckSharedBridgeDirectory();
        await RestoreLoginCertificateAsync(progress);
        PrepareClientImage();
        PrepareConnectionFiles(SourceDirectory, SharedClient ? 1 : number);
        ValidateInstallation();
        // Serialize update and preparation across launcher windows.
        string stateDirectory = Path.Combine(root, "launcher-components");
        Directory.CreateDirectory(stateDirectory);
        using var preparationLock = new FileStream(Path.Combine(stateDirectory, SharedClient ? "shared.lock" : $"window-{number}.lock"), FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.None);
        await UpdateClientAsync(progress);
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

    private void CheckSharedBridgeDirectory()
    {
        string expected = Path.Combine(SharedDirectory, "OnlineBridge.exe");
        foreach (var process in Process.GetProcessesByName("OnlineBridge"))
        {
            using (process)
            {
                string? actual;
                try { actual = process.MainModule?.FileName; }
                catch (InvalidOperationException) { continue; } // Exited during enumeration.
                catch (System.ComponentModel.Win32Exception) { continue; } // Port checks remain authoritative.
                if (actual != null) ValidateSharedBridgeDirectory(expected, actual);
            }
        }
    }

    internal static void ValidateSharedBridgeDirectory(string expected, string actual)
    {
        if (string.Equals(Path.GetFullPath(expected), Path.GetFullPath(actual), StringComparison.OrdinalIgnoreCase)) return;
        throw new IOException($"另一个游戏目录的网络组件正在运行，无法共用启动请求。\n\n正在运行：{actual}\n\n请在原来的登录器中选择未启动的窗口，再点击“启动选中窗口”。若要切换游戏目录，请先退出原目录的游戏和登录器，等待网络组件退出后再启动。");
    }

    private async Task RestoreLoginCertificateAsync(IProgress<string> progress)
    {
        string certificatePath = Resolve(baseline["login_certificate"]!.GetValue<string>());
        if (File.Exists(certificatePath)) return;
        // Local test certificates belong to that local server; never replace
        // them with the online certificate.
        if (Endpoint.Scheme != "wss" || Endpoint.IsLoopback) return;
        progress.Report("正在补齐登录连接证书…");
        var uri = new UriBuilder(Endpoint) { Scheme = "https", Path = "/updates/login.crt", Query = "", Port = Endpoint.IsDefaultPort ? -1 : Endpoint.Port }.Uri;
        using var http = new HttpClient { Timeout = TimeSpan.FromSeconds(15), MaxResponseContentBufferSize = 65536 };
        string pem = await http.GetStringAsync(uri);
        // Check against this package's local bridge key before caching.
        using var certificate = X509Certificate2.CreateFromPem(pem, File.ReadAllText(Resolve(baseline["login_key"]!.GetValue<string>())));
        Directory.CreateDirectory(Path.GetDirectoryName(certificatePath)!);
        File.WriteAllText(certificatePath, pem);
    }

    private Task UpdateClientAsync(IProgress<string> progress)
    {
        if (Endpoint.IsLoopback || Endpoint.Scheme != "wss" && baseline["update_base_url"] == null) return Task.CompletedTask;
        progress.Report("正在检查客户端更新…");
        var manifest = UpdateManifest("client");
        using var update = new OpenKFO.Updater.UpdateForm("client", SourceDirectory, manifest, Path.Combine(root, "bridge.json"));
        update.ShowDialog(Form.ActiveForm);
        if (!update.Completed) throw new IOException("客户端更新未完成，已取消启动游戏。请完成更新后重试。");
        var current = JsonNode.Parse(File.ReadAllText(Path.Combine(root, "bridge.json")))!.AsObject();
        baseline["config_hash"] = current["config_hash"]!.GetValue<string>();
        return Task.CompletedTask;
    }

    private async Task PrepareLoginAsync(int number, Process game, IProgress<string> progress)
    {
        StartLoginSkin(number, game);
        var saved = LoadCredentials(number);
        if (saved.Account.Length == 0 && saved.Password.Length == 0)
        {
            progress.Report($"窗口 {number} 已启动，请在游戏里输入账号密码。");
            return;
        }
        progress.Report($"窗口 {number} 正在等待登录界面并填写账号密码…");
        bool filled = await saved.FillAsync(game);
        progress.Report(filled ? $"窗口 {number} 已填写保存的账号密码，请在游戏里点击登录。" : $"窗口 {number} 未找到可填写的登录界面；若已登录，无需重复操作。");
    }

    private static byte[] ReadResource(string name)
    {
        using var resource = Assembly.GetExecutingAssembly().GetManifestResourceStream(name) ?? throw new IOException("缺少登录组件：" + name);
        using var buffer = new MemoryStream(); resource.CopyTo(buffer); return buffer.ToArray();
    }

    private void StartLoginSkin(int number, Process game)
    {
        byte[] skin = ReadResource("LoginSkin.dll"), host = ReadResource("LoginSkinHost.exe");
        // Versioned files let existing native windows keep their loaded DLL
        // while a new launcher ships an updated design.
        // The launcher release is authoritative; repair missing/stale sidecar files.
        foreach (var component in new[] { (Name: "LoginSkin.dll", Data: skin), (Name: "LoginSkinHost.exe", Data: host) })
        {
            string sidecar = Path.Combine(root, component.Name);
            if (!File.Exists(sidecar) || FileHash(sidecar) != Hash(component.Data)) File.WriteAllBytes(sidecar, component.Data);
        }
        string directory = Path.Combine(ClientDirectory(number), "launcher-components", "login-skin", Hash(skin)[..12] + Hash(host)[..12]);
        Directory.CreateDirectory(directory);
        using var extractionLock = new FileStream(Path.Combine(directory, "extract.lock"), FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.None);
        string skinPath = Path.Combine(directory, "LoginSkin.dll"), hostPath = Path.Combine(directory, "LoginSkinHost.exe");
        if (!File.Exists(skinPath) || FileHash(skinPath) != Hash(skin)) File.WriteAllBytes(skinPath, skin);
        if (!File.Exists(hostPath) || FileHash(hostPath) != Hash(host)) File.WriteAllBytes(hostPath, host);
        var start = new ProcessStartInfo(hostPath) { WorkingDirectory = directory, UseShellExecute = false, CreateNoWindow = true };
        start.ArgumentList.Add(game.Id.ToString());
        start.ArgumentList.Add(Path.Combine(ClientDirectory(number), ImageName(ClientDirectory(number))));
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
        string image = Path.Combine(directory, ImageName(directory));
        byte[] imageBytes = File.ReadAllBytes(image);
        if (imageBytes.Length < MutexOffset + 10) throw new IOException("游戏文件不完整。");
        // Restore the known mutex bytes for whole-file verification before changing this instance's name.
        string currentMutex = Encoding.ASCII.GetString(imageBytes, MutexOffset, 9);
        if (currentMutex != "KungfuKid" && currentMutex != "KungfuKi2" && currentMutex != $"Kungfu{number:000}") throw new IOException("不支持的游戏版本，未修改客户端。");
        Encoding.ASCII.GetBytes("KungfuKid\0").CopyTo(imageBytes, MutexOffset);
        if (!SupportedImageHashes.Contains(Hash(imageBytes))) throw new IOException("游戏文件校验不一致，未修改客户端。");
        PrepareNativeLogin(directory);
        if (number > 1 && !SharedClient)
        {
            Encoding.ASCII.GetBytes(number == 2 ? "KungfuKi2\0" : $"Kungfu{number:000}\0").CopyTo(imageBytes, MutexOffset);
            if (!File.ReadAllBytes(image).AsSpan().SequenceEqual(imageBytes)) File.WriteAllBytes(image, imageBytes);
            string sourcePackage = Path.Combine(SourceDirectory, "Data", "config.spf2");
            string targetPackage = Path.Combine(directory, "Data", "config.spf2");
            if (!FileHash(sourcePackage).Equals(baseline["config_hash"]!.GetValue<string>(), StringComparison.OrdinalIgnoreCase)) throw new IOException("客户端配置与线上版本不一致，请先更新服务器允许的配置。");
            if (FileHash(sourcePackage) != FileHash(targetPackage)) File.Copy(sourcePackage, targetPackage, true);
        }
        int portWindow = SharedClient ? 1 : number;
        // Native login reads zz.crt from the game directory, independently of
        // the bridge's configured certificate path. Restore it on every launch.
        byte[] loginCertificate = File.ReadAllBytes(Resolve(baseline["login_certificate"]!.GetValue<string>()));
        string nativeCertificate = Path.Combine(directory, "zz.crt");
        if (!File.Exists(nativeCertificate) || !File.ReadAllBytes(nativeCertificate).AsSpan().SequenceEqual(loginCertificate))
            File.WriteAllBytes(nativeCertificate, loginCertificate);
        PrepareConnectionFiles(directory, portWindow);
        Directory.CreateDirectory(InstanceDirectory(number));
        var config = (JsonObject)baseline.DeepClone();
        config["client_directory"] = directory;
        config["client_executable"] = Path.GetFileName(image);
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
        InstallBridge(helper, helperBytes);
        return path;
    }

    internal static void InstallBridge(string helper, byte[] bytes)
    {
        if (File.Exists(helper) && FileHash(helper) == Hash(bytes)) return;
        foreach (var process in Process.GetProcessesByName("OnlineBridge"))
        {
            using (process)
            {
                string? running;
                try { running = process.MainModule?.FileName; }
                catch (InvalidOperationException) { continue; }
                catch (System.ComponentModel.Win32Exception error) { throw new IOException("无法检查网络组件状态，请关闭游戏和旧启动器后重试。", error); }
                if (string.Equals(running, helper, StringComparison.OrdinalIgnoreCase))
                    throw new IOException("网络组件有新版本，但旧版本仍在运行。请退出所有游戏窗口，等待约 30 秒后重试。当前游戏连接不会被强制断开。");
            }
        }
        string temporary = helper + "." + Guid.NewGuid().ToString("N") + ".tmp";
        try
        {
            File.WriteAllBytes(temporary, bytes);
            File.Move(temporary, helper, true);
        }
        catch (IOException error) { throw new IOException("网络组件正在退出或被占用，请稍后重试。原组件未被截断。", error); }
        finally { if (File.Exists(temporary)) File.Delete(temporary); }
    }

    internal static void PrepareNativeLogin(string directory)
    {
        foreach (string name in new[] { "libcrypto-1_1.dll", "libssl-1_1.dll", "SDError.dll" })
        {
            byte[] bytes = ReadResource(name);
            string target = Path.Combine(directory, name);
            if (File.Exists(target) && FileHash(target) == Hash(bytes)) continue;
            if (File.Exists(target))
            {
                string backup = Path.Combine(directory, "launcher-components", "native-login-backups", FileHash(target), name);
                Directory.CreateDirectory(Path.GetDirectoryName(backup)!);
                if (!File.Exists(backup)) File.Copy(target, backup);
            }
            string temporary = target + "." + Guid.NewGuid().ToString("N") + ".tmp";
            try
            {
                File.WriteAllBytes(temporary, bytes);
                File.Move(temporary, target, true);
            }
            catch (IOException error)
            {
                throw new IOException($"无法更新登录组件 {name}。请退出该目录的所有游戏窗口后重试。原文件已保留或备份。", error);
            }
            finally { if (File.Exists(temporary)) File.Delete(temporary); }
        }
    }

    internal static void PrepareConnectionFiles(string directory, int window)
    {
        string xml = Encoding.Latin1.GetString(ReadResource("client-config.xml"));
        xml = System.Text.RegularExpressions.Regex.Replace(xml, "Port=\"[0-9]+\"", "Port=\"" + SDKPort(window) + "\"");
        var files = new Dictionary<string, byte[]>
        {
            ["Data/config.xml"] = Encoding.Latin1.GetBytes(xml),
            ["server.ini"] = Encoding.ASCII.GetBytes("[server]\r\nip=127.0.0.1\r\nport=" + LoginPort(window) + "\r\n")
        };
        // The embedded server list contains one entry. Original clients may
        // retain Index=2, which resolves to an empty IP and port zero.
        string settings = Path.Combine(directory, "Settings.xml");
        if (File.Exists(settings))
        {
            string original = File.ReadAllText(settings, Encoding.Latin1);
            var selection = new System.Text.RegularExpressions.Regex(@"(<LoginServer\b[^>]*\bIndex\s*=\s*"")[^""]*("")");
            if (!selection.IsMatch(original)) throw new IOException("Settings.xml 缺少选区设置，未修改其他玩家设置。");
            string updated = selection.Replace(original, match => match.Groups[1].Value + "0" + match.Groups[2].Value);
            files["Settings.xml"] = Encoding.Latin1.GetBytes(updated);
        }
        foreach (var file in files)
        {
            string target = Path.Combine(directory, file.Key);
            if (File.Exists(target) && FileHash(target) == Hash(file.Value)) continue;
            if (File.Exists(target))
            {
                string backup = Path.Combine(directory, "launcher-components", "connection-backups", FileHash(target), file.Key);
                Directory.CreateDirectory(Path.GetDirectoryName(backup)!);
                if (!File.Exists(backup)) File.Copy(target, backup);
            }
            Directory.CreateDirectory(Path.GetDirectoryName(target)!);
            string temporary = target + "." + Guid.NewGuid().ToString("N") + ".tmp";
            try { File.WriteAllBytes(temporary, file.Value); File.Move(temporary, target, true); }
            finally { if (File.Exists(temporary)) File.Delete(temporary); }
        }
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
