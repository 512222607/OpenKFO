using System.Diagnostics;
using System.Text.Json.Nodes;

namespace KfoLogin;

/// <summary>
/// 登录编排：校验客户端目录 → 应用 GPK/更新绕过补丁 → 隧道认证 → 注入 sessionId →
/// 起桥（8000/8001）+ 本地假更新 → 拉起 gfxz.dat 并保活。GUI 与自检共用。
/// </summary>
internal sealed class Launcher : IDisposable
{
    private readonly Action<string, bool> _log;

    public string ClientDir { get; }
    public string ServerDir { get; }
    public string Host { get; }
    public int TunnelPort { get; }
    public int SdkPort { get; }
    public int GamePort { get; }

    public long Uid { get; private set; }
    public string Session { get; private set; } = "";

    private Tunnel? _tunnel;
    private Bridge? _bridge;
    private UpdateResponder? _updater;
    private Process? _client;

    public Launcher(string clientDir, string serverDir, string host, int tunnelPort,
        int sdkPort, int gamePort, Action<string, bool> log)
    {
        ClientDir = clientDir;
        ServerDir = serverDir;
        Host = host;
        TunnelPort = tunnelPort;
        SdkPort = sdkPort;
        GamePort = gamePort;
        _log = log;
    }

    public bool ClientAlive => _client is { HasExited: false };

    private string CertPath => Path.Combine(ServerDir, "certificates", "origin.crt");
    private string ConfigPath => Path.Combine(ServerDir, "config.json");

    private string LoadConfigHash()
    {
        if (!File.Exists(ConfigPath))
            throw new FileNotFoundException("服务端 config.json 不存在", ConfigPath);
        var node = JsonNode.Parse(File.ReadAllText(ConfigPath));
        string? value = node?["config_hash"]?.GetValue<string>();
        if (value is null || value.Length != 64)
            throw new InvalidDataException("config.json 缺少合法 config_hash");
        return value;
    }

    /// <summary>跑完整链路。任一阶段失败抛异常，调用方负责 Stop()。</summary>
    public void Start(string account, string password, bool launchClient, bool startBridge = true)
    {
        if (!ClientPatcher.HasClient(ClientDir))
            throw new FileNotFoundException("所选目录下没有 gfxz.dat", ClientPatcher.GfxzPath(ClientDir));
        if (!File.Exists(CertPath))
            throw new FileNotFoundException("服务端证书不存在", CertPath);

        // 1) GPK / 更新绕过补丁（幂等）
        (int changed, List<string> missing) = ClientPatcher.Apply(ClientDir, _log);
        if (missing.Count > 0)
            throw new InvalidOperationException("客户端补丁不完整：" + string.Join("；", missing));
        _log($"GPK/更新绕过补丁就位（本次改动 {changed} 处）", false);

        // 2) 隧道认证
        string configHash = LoadConfigHash();
        _tunnel = new Tunnel(Host, TunnelPort, CertPath);
        _tunnel.Connect();
        _log($"隧道已连接 {Host}:{TunnelPort}", false);
        Uid = _tunnel.Authenticate(account, password, configHash, GamePort);
        _log($"认证通过 uid={Uid}（摘要 {Legacy.Digest(password)[..16]}…）", false);

        // 3) 注入 session
        Session = Legacy.BuildSession(account, Uid);
        ClientPatcher.InjectSession(ClientDir, Session);
        _log($"注入 sessionId {Session}", false);

        if (!startBridge)
        {
            _log("自检模式：跳过起桥与客户端拉起", false);
            return;
        }

        // 4) 起桥 + 假更新
        _bridge = new Bridge(_tunnel, _log, SdkPort, GamePort);
        _bridge.Start();
        _updater = new UpdateResponder(_log);
        _updater.Start();

        // 5) 拉起客户端
        if (!launchClient)
        {
            _log("已按设置跳过客户端拉起", false);
            return;
        }
        LaunchClient();
    }

    public void LaunchClient()
    {
        var psi = new ProcessStartInfo
        {
            FileName = ClientPatcher.GfxzPath(ClientDir),
            WorkingDirectory = ClientDir,
            UseShellExecute = false,
        };
        _client = Process.Start(psi) ?? throw new InvalidOperationException("客户端进程启动失败");
        _log($"已拉起客户端 PID={_client.Id}", false);
    }

    public void Stop()
    {
        try
        {
            if (_client is { HasExited: false })
            {
                int pid = _client.Id;
                _client.Kill(entireProcessTree: true);
                _log($"已结束客户端 PID={pid}", false);
            }
        }
        catch (Exception) { /* ignore */ }
        _client = null;

        _bridge?.Stop();
        _bridge = null;
        _updater?.Stop();
        _updater = null;
        _tunnel?.Dispose();
        _tunnel = null;
    }

    public void Dispose() => Stop();
}
