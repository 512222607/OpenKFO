using System.Net;
using System.Net.Sockets;
using System.Text;

namespace KfoLogin;

/// <summary>
/// AutoPatch.ini / check.ini / gpkupdate.ini 指向的 127.0.0.1:8088 最小应答。
/// 直接拉起 gfxz.dat 时更新链路本就不执行；这里把原版会打到 sdo / igalive 的地址
/// 全部落到回环，保证任何残留调用都不出网。
/// </summary>
internal sealed class UpdateResponder
{
    private readonly Action<string, bool> _log;
    private readonly int _port;
    private TcpListener? _listener;
    private volatile bool _running;

    public UpdateResponder(Action<string, bool> log, int port = 8088)
    {
        _log = log;
        _port = port;
    }

    public void Start()
    {
        try
        {
            _listener = new TcpListener(IPAddress.Loopback, _port);
            _listener.Start(16);
        }
        catch (SocketException ex)
        {
            _log($"更新回环端口 {_port} 未启用：{ex.Message}", false);
            return;
        }

        _running = true;
        _log($"更新回环 HTTP 127.0.0.1:{_port}", false);
        new Thread(AcceptLoop) { IsBackground = true }.Start();
    }

    public void Stop()
    {
        _running = false;
        try { _listener?.Stop(); } catch { /* ignore */ }
    }

    private void AcceptLoop()
    {
        while (_running)
        {
            TcpClient conn;
            try { conn = _listener!.AcceptTcpClient(); }
            catch (SocketException) { return; }
            catch (ObjectDisposedException) { return; }
            new Thread(() => Serve(conn)) { IsBackground = true }.Start();
        }
    }

    private static void Serve(TcpClient conn)
    {
        try
        {
            using (conn)
            {
                conn.ReceiveTimeout = 3000;
                NetworkStream ns = conn.GetStream();
                var buf = new byte[4096];
                int n = ns.Read(buf, 0, buf.Length);
                string request = Encoding.Latin1.GetString(buf, 0, n);
                string path = request.Split(' ') is { Length: > 1 } parts ? parts[1] : "/";

                (byte[] body, string mime) = path switch
                {
                    _ when path.EndsWith("config.xml") => ("<GameClient><Updater/></GameClient>"u8.ToArray(), "text/xml"),
                    _ when path.EndsWith("chkVer.dat") => ("0006"u8.ToArray(), "application/octet-stream"),
                    _ => (Array.Empty<byte>(), "text/html"),
                };

                string head = $"HTTP/1.1 200 OK\r\nContent-Type: {mime}\r\nContent-Length: {body.Length}\r\nConnection: close\r\n\r\n";
                byte[] headBytes = Encoding.ASCII.GetBytes(head);
                ns.Write(headBytes, 0, headBytes.Length);
                ns.Write(body, 0, body.Length);
            }
        }
        catch (Exception) { /* ignore */ }
    }
}
