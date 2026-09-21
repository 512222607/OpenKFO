using System.Net;
using System.Net.Sockets;
using System.Text.Json.Nodes;

namespace KfoLogin;

/// <summary>
/// 本机端口 ↔ 隧道 channel 双向转发（对照 kfo_launcher.py 的 Bridge / bridge_windows.go）。
/// SDK 登录通道监听 127.0.0.1:8000，游戏 TCP+UDP 监听 127.0.0.1:8001，
/// 每个原生连接映射为一个递增 channel，数据经隧道 op=data 转发。
/// </summary>
internal sealed class Bridge
{
    private readonly Tunnel _tunnel;
    private readonly Action<string, bool> _log;
    private readonly int _sdkPort;
    private readonly int _gamePort;

    private readonly List<TcpListener> _listeners = new();
    private Socket? _udp;
    private readonly Dictionary<int, TcpClient> _channels = new();
    private readonly HashSet<int> _udpPorts = new();
    private readonly object _lock = new();
    private int _nextChannel;
    private volatile bool _running;

    public Bridge(Tunnel tunnel, Action<string, bool> log, int sdkPort = 8000, int gamePort = 8001)
    {
        _tunnel = tunnel;
        _log = log;
        _sdkPort = sdkPort;
        _gamePort = gamePort;
    }

    public void Start()
    {
        _running = true;

        foreach ((int port, string kind) in new[] { (_sdkPort, "sdk"), (_gamePort, "game") })
        {
            var listener = new TcpListener(IPAddress.Loopback, port);
            listener.Start(16);
            _listeners.Add(listener);
            var t = new Thread(() => AcceptLoop(listener, kind)) { IsBackground = true };
            t.Start();
            _log($"桥监听 TCP 127.0.0.1:{port} ({kind})", false);
        }

        try
        {
            _udp = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
            _udp.Bind(new IPEndPoint(IPAddress.Loopback, _gamePort));
            new Thread(UdpInLoop) { IsBackground = true }.Start();
            _log($"桥监听 UDP 127.0.0.1:{_gamePort} (game)", false);
        }
        catch (SocketException ex)
        {
            _log($"UDP {_gamePort} 绑定失败：{ex.Message}", true);
        }

        new Thread(ReceiveLoop) { IsBackground = true }.Start();
        new Thread(KeepaliveLoop) { IsBackground = true }.Start();
    }

    public void Stop()
    {
        _running = false;
        foreach (TcpListener l in _listeners)
        {
            try { l.Stop(); } catch { /* ignore */ }
        }
        _listeners.Clear();

        try { _udp?.Close(); } catch { /* ignore */ }

        lock (_lock)
        {
            foreach (TcpClient c in _channels.Values)
            {
                try { c.Close(); } catch { /* ignore */ }
            }
            _channels.Clear();
        }
    }

    private void AcceptLoop(TcpListener listener, string kind)
    {
        while (_running)
        {
            TcpClient conn;
            try { conn = listener.AcceptTcpClient(); }
            catch (SocketException) { return; }
            catch (ObjectDisposedException) { return; }

            conn.NoDelay = true;
            int channel;
            lock (_lock)
            {
                if (_channels.Count >= 8) { conn.Close(); continue; }
                channel = ++_nextChannel;
                _channels[channel] = conn;
            }

            try
            {
                _tunnel.Send(new JsonObject { ["op"] = "open", ["channel"] = channel, ["kind"] = kind });
            }
            catch (Exception)
            {
                conn.Close();
                lock (_lock) _channels.Remove(channel);
                continue;
            }

            _log($"原生连接 {kind} -> channel {channel}", false);
            int ch = channel;
            TcpClient c = conn;
            new Thread(() => ForwardLoop(ch, c)) { IsBackground = true }.Start();
        }
    }

    private void ForwardLoop(int channel, TcpClient conn)
    {
        try
        {
            NetworkStream ns = conn.GetStream();
            var buf = new byte[32768];
            while (_running)
            {
                int n = ns.Read(buf, 0, buf.Length);
                if (n <= 0) break;
                _tunnel.Send(new JsonObject
                {
                    ["op"] = "data",
                    ["channel"] = channel,
                    ["data"] = Convert.ToBase64String(buf, 0, n),
                });
            }
        }
        catch (Exception) { /* 连接断开 */ }
        finally
        {
            lock (_lock) _channels.Remove(channel);
            try { conn.Close(); } catch { /* ignore */ }
            try { _tunnel.Send(new JsonObject { ["op"] = "close", ["channel"] = channel }); }
            catch (Exception) { /* ignore */ }
        }
    }

    private void ReceiveLoop()
    {
        while (_running)
        {
            JsonObject frame;
            try
            {
                frame = _tunnel.Read();
            }
            catch (Exception ex)
            {
                if (_running) _log($"隧道读取结束：{ex.Message}", true);
                _running = false;
                return;
            }

            switch (frame["op"]?.GetValue<string>())
            {
                case "data":
                {
                    int ch = (int)(frame["channel"]?.GetValue<double>() ?? 0);
                    TcpClient? conn;
                    lock (_lock) _channels.TryGetValue(ch, out conn);
                    if (conn is not null)
                    {
                        try
                        {
                            byte[] payload = Convert.FromBase64String(frame["data"]?.GetValue<string>() ?? "");
                            conn.GetStream().Write(payload, 0, payload.Length);
                        }
                        catch (Exception) { /* ignore */ }
                    }
                    break;
                }
                case "close":
                {
                    int ch = (int)(frame["channel"]?.GetValue<double>() ?? 0);
                    TcpClient? conn;
                    lock (_lock)
                    {
                        _channels.TryGetValue(ch, out conn);
                        _channels.Remove(ch);
                    }
                    try { conn?.Close(); } catch { /* ignore */ }
                    break;
                }
                case "udp":
                {
                    int port = (int)(frame["port"]?.GetValue<double>() ?? 0);
                    lock (_lock)
                    {
                        if (_udpPorts.Contains(port) && _udp is not null)
                        {
                            try
                            {
                                byte[] payload = Convert.FromBase64String(frame["data"]?.GetValue<string>() ?? "");
                                _udp.SendTo(payload, new IPEndPoint(IPAddress.Loopback, port));
                            }
                            catch (Exception) { /* ignore */ }
                        }
                    }
                    break;
                }
                case "ping":
                    try { _tunnel.Send(new JsonObject { ["op"] = "pong" }); } catch { /* ignore */ }
                    break;
                case "logged_out":
                    _log("服务端释放了本会话（logged_out）", false);
                    break;
                case "relogin":
                    _log("服务端要求重登（relogin）：请关闭客户端后重新登录", false);
                    break;
                case "pong":
                    break;
                default:
                    _log($"未知隧道指令 {frame["op"]}", true);
                    break;
            }
        }
    }

    private void UdpInLoop()
    {
        var buf = new byte[32768];
        while (_running)
        {
            try
            {
                EndPoint remote = new IPEndPoint(IPAddress.Any, 0);
                int n = _udp!.ReceiveFrom(buf, ref remote);
                int port = ((IPEndPoint)remote).Port;
                lock (_lock) _udpPorts.Add(port);
                _tunnel.Send(new JsonObject
                {
                    ["op"] = "udp",
                    ["port"] = port,
                    ["data"] = Convert.ToBase64String(buf, 0, n),
                });
            }
            catch (Exception) { return; }
        }
    }

    private void KeepaliveLoop()
    {
        while (_running)
        {
            Thread.Sleep(15000);
            if (!_running) return;
            try { _tunnel.Send(new JsonObject { ["op"] = "ping" }); }
            catch (Exception) { return; }
        }
    }
}
