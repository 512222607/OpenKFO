using System.Text;

namespace KfoLogin;

/// <summary>
/// 无界面自检：认证 → 应用 GPK 补丁 → 注入 session（默认不起桥、不拉客户端）。
/// 用于在未打开 GUI 时验证登录模块的整条链路，输出写入 --log 指定的文件（默认 selftest.log）。
/// </summary>
internal static class SelfTest
{
    public static int Run(string[] args)
    {
        var options = Parse(args);
        string logPath = options.LogPath ?? Path.Combine(AppContext.BaseDirectory, "selftest.log");

        using var writer = new StreamWriter(logPath, append: false, new UTF8Encoding(false)) { AutoFlush = true };
        void Log(string message, bool isError) => writer.WriteLine((isError ? "!! " : "· ") + message);

        string clientDir = options.ClientDir ?? Locate.Find("client", "gfxz.dat") ?? "";
        string serverDir = options.ServerDir ?? "";
        if (serverDir.Length == 0)
        {
            string? config = Locate.Find("dist", "local-server", "config.json");
            if (config is not null) serverDir = Path.GetDirectoryName(config)!;
        }

        string[] hostPort = (options.Endpoint ?? "127.0.0.1:19091").Split(':', 2);
        string host = hostPort[0];
        int port = hostPort.Length > 1 && int.TryParse(hostPort[1], out int p) ? p : 19091;

        Log($"客户端目录 {clientDir}", false);
        Log($"服务端目录 {serverDir}", false);
        Log($"服务端地址 {host}:{port}", false);

        if (clientDir.Length == 0 || !ClientPatcher.HasClient(clientDir))
        {
            Log("找不到客户端目录（--client 指定）", true);
            return 2;
        }
        if (serverDir.Length == 0)
        {
            Log("找不到服务端目录（--server 指定）", true);
            return 2;
        }

        var launcher = new Launcher(clientDir, serverDir, host, port, 8000, 8001, Log);
        try
        {
            launcher.Start(options.Account, options.Password, options.Launch, startBridge: options.Launch);
            Log($"自检通过：uid={launcher.Uid} session={launcher.Session}", false);

            if (options.Launch)
            {
                Log("客户端运行中，等待其退出（最长 120 秒）…", false);
                var deadline = DateTime.UtcNow.AddSeconds(120);
                while (launcher.ClientAlive && DateTime.UtcNow < deadline)
                    Thread.Sleep(2000);
                Log(launcher.ClientAlive ? "等待超时，准备停止" : "客户端已退出", false);
            }
            else
            {
                Log($"日志文件 {logPath}", false);
            }
            return 0;
        }
        catch (Exception ex)
        {
            Log("自检失败：" + ex.Message, true);
            return 1;
        }
        finally
        {
            launcher.Stop();
        }
    }

    private sealed class Options
    {
        public string Account = "";
        public string Password = "";
        public string? ClientDir;
        public string? ServerDir;
        public string? Endpoint;
        public string? LogPath;
        public bool Launch;
    }

    private static Options Parse(string[] args)
    {
        var o = new Options();
        var positional = new List<string>();
        for (int i = 1; i < args.Length; i++)
        {
            switch (args[i])
            {
                case "--client": o.ClientDir = Next(args, ref i); break;
                case "--server": o.ServerDir = Next(args, ref i); break;
                case "--endpoint": o.Endpoint = Next(args, ref i); break;
                case "--log": o.LogPath = Next(args, ref i); break;
                case "--launch": o.Launch = true; break;
                default: positional.Add(args[i]); break;
            }
        }
        if (positional.Count >= 2)
        {
            o.Account = positional[0];
            o.Password = positional[1];
        }
        return o;
    }

    private static string Next(string[] args, ref int i) => i + 1 < args.Length ? args[++i] : "";
}

internal static class Locate
{
    /// <summary>从执行文件目录向上查找 <paramref name="relative"/> 指向的文件，返回其绝对路径。</summary>
    public static string? Find(params string[] relative)
    {
        var dir = new DirectoryInfo(AppContext.BaseDirectory);
        while (dir is not null)
        {
            string candidate = Path.Combine(dir.FullName, Path.Combine(relative));
            if (File.Exists(candidate)) return candidate;
            dir = dir.Parent;
        }
        return null;
    }
}
